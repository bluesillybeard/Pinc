#include <stddef.h>
#include <stdbool.h>
// This will only ever be used on posix, so it is safe to do this
#include <dlfcn.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <time.h>
// This will only ever be used on posix, so it is safe to do this
#include <unistd.h>
#include <X11/Xlib.h>
// We use a file to load Xlib at runtime
#include "load/XlibLoad.h"
#include <GL/glx.h>
// same as Xlib, we load glX at runtime.
#include "load/glXLoad.h"

// xkb for better keyboard stuff
#include <X11/XKBlib.h>
// XKB functions need to be loaded from Xlib
#include "load/xkbLoad.h"

// This file does not interact with OpenGL itself - only Xlib and the GLX extension.
// This is also the ONLY file that calls any Xlib or glX functions, because of the loader headers.
#define PINCX_PRIVATE
#include "pincx.h"

// Resources used: public HTML version of libX11 documentation: https://x.org/releases/current/doc/libX11/libX11/libX11.html
// Kinc's source code, here is their website: https://kinc.tech/
// - Kinc is full of confusing macros and other insanity so that may have been a waste of time
// GLFW's source code
// - GLFW is an absolutely massive library so finding everything was a bit of a pain

// static variables
void* libX11;
void* libGL;

Display* xDisplay;

GLXContext glxContext;

XVisualInfo* xVisual;

// Lookup table from X11 keycode to pinc keycode
int16_t x11_xkey_to_pinc[256];

// reverse version of the above
int16_t x11_pinc_to_xkey[pinc_key_code_count + 1];

bool xkbAvailable;

// Things that are public
bool x11_init(void) {
    x11_load_libraries();
    // if XLib wasn't loaded, it's not going to work
    if(XOpenDisplay == NULL) {
        // TODO: replace printfs with a proper logging / error reporting system
        printf("Failed to load libX11.so\n");
        return false;
    }
    xDisplay = XOpenDisplay(NULL);
    if(xDisplay == NULL){
        printf("Display is null\n");
        return false;
    }
    xkbAvailable = false;
    if(XkbQueryExtension != NULL){
        int majorOpcode;
        int eventBase;
        int errorBase;
        int major = 1;
        int minor = 0;
        xkbAvailable = XkbQueryExtension(xDisplay,
            &majorOpcode,
            &eventBase,
            &errorBase,
            &major,
            &minor);
    }

    x11_create_key_tables();

    // Check if our GL library supports glXGetProcAddress - it is a requirement for OpenGL to work.
    // Remember, we use a loader header - this is not the extern function,
    // it's actually a macro to a pointer that should have been loaded by x11_load_libraries.
    if(glXGetProcAddressARB == NULL) {
        printf("glXGetProcAddressARB is null\n");
        return false;
    }
    // We want one GLX context for all windows, so it's initialized here.
    // Unlike WGL, GLX has zero need to create a fake window to make a GL context.
    // The attributes we want our GLX context to have
    GLint glxAttributes[] = { GLX_RGBA, GLX_DOUBLEBUFFER, None };
    xVisual = glXChooseVisual(xDisplay, 0, glxAttributes);
    if(xVisual == NULL) {
        printf("Visual is null\n");
        return false;
    }
    // create a context. NOTE: This is for the old OpenGL 1.0 - 2.1 context.
    glxContext = glXCreateContext(xDisplay, xVisual, NULL, GL_TRUE);
    if(glxContext == NULL) {
        printf("GLX Context is null");
        return false;
    }
    return true;
}

void x11_deinit(void) {
    dlclose(libX11);
}

x11_window x11_window_incomplete_create(const char* title) {
    // TODO: redirect window close
    Window rootWindow = DefaultRootWindow(xDisplay);
    Colormap cmap = XCreateColormap(xDisplay, rootWindow, xVisual->visual, AllocNone);

    XSetWindowAttributes windowAttributes;
    windowAttributes.colormap = cmap;
    windowAttributes.event_mask = KeyPressMask | KeyReleaseMask | ButtonPressMask
    | ButtonReleaseMask | EnterWindowMask | LeaveWindowMask | PointerMotionMask | ButtonMotionMask
    | ExposureMask | VisibilityChangeMask | StructureNotifyMask | ResizeRedirectMask
    | FocusChangeMask | PropertyChangeMask;

    x11_window window;
    window.xWindow = XCreateWindow(xDisplay, rootWindow, 0, 0, 800, 600, 0, xVisual->depth,
        InputOutput, xVisual->visual, CWColormap | CWEventMask, &windowAttributes);
    XStoreName(xDisplay, window.xWindow, title);
    // TODO: Atoms and WM stuff
    return window;
}

bool x11_window_complete(x11_window* window) {
    XMapWindow(xDisplay, window->xWindow);
    // This is so the window shows up immediately upon completing it.
    XFlush(xDisplay);
    return true;
}

// Pops the next event off of the queue
// Important notes:
// - the cursor move event does not have deltas or the screen coordinates set - only pixel coords
pinc_event_union_t x11_pop_event() {
    pinc_event_union_t event;
    event.type = pinc_event_none;
    if(XPending(xDisplay) == 0){
        return event;
    }
    XEvent xev;
    XNextEvent(xDisplay, &xev);
    // TODO: xkb events. GLFW's x11_window.c around line 1170 ish is where you can find a reference implementation
    // TODO: Apparently Xlib will send events for destroyed windows. Verify that Pinc handles that gracefully
    switch(xev.type) {
        case KeyPress:
            // TODO: apparently with the XI extension (not used in Pinc but it might be later), duplicate key events may be sent. (pain)
            event.type = pinc_event_window_key_down;
            event.data.window_key_down.window = x11_get_window_handle(xev.xkey.window);
            event.data.window_key_down.token = xev.xkey.keycode;
            event.data.window_key_down.key = x11_translate_key(xev.xkey.keycode);
            event.data.window_key_down.modifiers = x11_translate_modifiers(xev.xkey.state);
            break;
        case KeyRelease:
            event.type = pinc_event_window_key_up;
            event.data.window_key_up.window = x11_get_window_handle(xev.xkey.window);
            event.data.window_key_up.token = xev.xkey.keycode;
            event.data.window_key_up.key = x11_translate_key(xev.xkey.keycode);
            event.data.window_key_up.modifiers = x11_translate_modifiers(xev.xkey.state);
            break;
        case ButtonPress:
            event.type = pinc_event_window_cursor_button_down;
            event.data.window_cursor_button_down.window = x11_get_window_handle(xev.xbutton.window);
            event.data.window_cursor_button_down.button = xev.xbutton.button;
            break;
        case ButtonRelease:
            event.type = pinc_event_window_cursor_button_up;
            event.data.window_cursor_button_up.window = x11_get_window_handle(xev.xbutton.window);
            event.data.window_cursor_button_up.button = xev.xbutton.button;
            break;
        case MotionNotify:
            event.type = pinc_event_window_cursor_move;
            event.data.window_cursor_move.window = x11_get_window_handle(xev.xbutton.window);
            // Conveniently, X uses the same coordinate system as Pinc
            event.data.window_cursor_move.x_pixels = xev.xmotion.x;
            event.data.window_cursor_move.y_pixels = xev.xmotion.y;
            break;
        // Note: X calls enter and leave events on windows where the cursor does not directly enter or leave the window,
        // However that only happens when dealing with hirarchical windows which pinc does not allow to exist.
        case EnterNotify:
            // TODO: figure out how to deal with non-normal crossing events
            if(xev.xcrossing.mode == NotifyNormal) {
                event.type = pinc_event_window_cursor_enter;
                event.data.window_cursor_enter.window = x11_get_window_handle(xev.xcrossing.window);
            }
            break;
        case LeaveNotify:
            // TODO: figure out how to deal with non-normal crossing events
            if(xev.xcrossing.mode == NotifyNormal) {
                event.type = pinc_event_window_cursor_exit;
                event.data.window_cursor_exit.window = x11_get_window_handle(xev.xcrossing.window);
            }
            break;
        case FocusIn:
            // TODO: figure out how to deal with non-normal focus events
            event.type = pinc_event_window_focus;
            event.data.window_focus.window = x11_get_window_handle(xev.xfocus.window);
            break;
        case FocusOut:
            // TODO: figure out how to deal with non-normal focus events
            event.type = pinc_event_window_unfocus;
            event.data.window_unfocus.window = x11_get_window_handle(xev.xfocus.window);
            break;
        case KeymapNotify:
            // TODO: is this an event worth caring about?
            break;
        case Expose:
            // TODO: is it worth reporting the region that was exposed?
            event.type = pinc_event_window_damaged;
            event.data.window_damaged.window = x11_get_window_handle(xev.xexpose.window);
            break;
        case GraphicsExpose:
            // This only applies for if we are using the X11 draw commands
            break;
        case NoExpose:
            // This only applies for if we are using the X11 draw commands
            break;
        case VisibilityNotify:
            // TODO - create a window damaged event? Or does the X server always do that?
            // Should a window that's not visible also be considered not focused? Should an unfocus event be sent in that case?
            // Maybe pinc should just have visibility notification events like this.
            break;
        case CreateNotify:
            // Not useful for pinc
            break;
        case DestroyNotify:
            // Not useful for pinc (I think)
            break;
        case UnmapNotify:
            // Not useful for pinc
            break;
        case MapNotify:
            // Not useful for pinc
            break;
        case MapRequest:
            // TODO
            break;
        case ReparentNotify:
            // Pinc does not care about this
            break;
        case ConfigureNotify:
            // This event is not important
            // TODO: does the X server send the other events when asking for window config changes?
            break;
        case ConfigureRequest:
            // TODO: does the X server send other events when configuration changes are made by other clients?
            break;
        case GravityNotify:
            // Not useful for pinc, pinc doesn't report window position (yet)
            break;
        case ResizeRequest:
            // TODO: does the X server also send a normal resize event?
            break;
        case CirculateNotify:
            // TODO
            break;
        case CirculateRequest:
            // Not useful for pinc
            break;
        case PropertyNotify:
            // TODO: I think this will only matter once Atoms are implemented into Pinc
            break;
        case SelectionClear:
            // TODO: what is a selection (in the context of X)?
            break;
        case SelectionRequest:
            // TODO: what is a selection (in the context of X)?
            break;
        case SelectionNotify:
            // TODO: what is a selection (in the context of X)?
            break;
        case ColormapNotify:
            // Pinc does not care about colormaps. This event does not apply to Visuals or color spaces
            // (Does X11 even have the concept of a color space, or is everything assumed to be sRGB?)
            break;
        case ClientMessage:
            // This is a form of inter-client communication. Pinc could not care less.
            break;
        case MappingNotify:
            // Pinc does not care about this
            break;
        case GenericEvent:
            // TODO
            break;
        default:
            // TODO: produce an error maybe?
            break;
    }
    return event;
}

// Waits until there are events in the queue to be popped
void x11_wait_events(float timeout) {
    // The queue is not empty, return immediately
    if(XPending(xDisplay) != 0) return;
    // No events are in the queue
    XEvent event;
    if(timeout <= 0 || !isfinite(timeout)) {
        // If the timeout is infinite, use XPeekEvent to block
        XPeekEvent(xDisplay, &event);
    } else {
        // If the timeout is finite, Xlib has no function for that so a spinloop is required

        // convert the timeout to millis as an integer
        clock_t timeoutClock = timeout * CLOCKS_PER_SEC;
        clock_t start = clock();
        while(1) {
            // Return to OS so we don't consume this entire thread
            sleep(0);
            // If we have passed the timeout, exit
            if(clock() - start > timeoutClock) break;
            // If there are new events pending, exit
            if(XEventsQueued(xDisplay, QueuedAfterFlush) != 0) break;
        }
    }
}

// Things that are private to this file

bool x11_load_libraries(void) {
    libX11 = x11_load_library("X11");
    if(libX11 == NULL) return false;
    loadXlib(&x11_load_Xlib_symbol);
    loadXkb(&x11_load_Xlib_symbol);
    // libGL is where we are going to get glX from.
    // glX implemented within libGL
    libGL = x11_load_library("GL");
    if(libGL == NULL) return false;
    // load glXGetProcAddressARB first as it is the function used to load all of the other functions.
    // Technically all of the core GLX functions *should* be exposed,
    // however for the sake of confirming with the original ABI from 2000, do it the safe way.
    // (https://registry.khronos.org/OpenGL/ABI/)
    // this ABI is outdated by a long while, however due to backwards compabilility,
    // any OpenGL system *WILL* support it faithfully.
    glXGetProcAddressARB = dlsym(libGL, "glXGetProcAddressARB");
    loadGlX(&x11_load_glX_symbol);
    return true;
}

void* x11_load_Xlib_symbol(const char* name) {
    return dlsym(libX11, name);
}

void* x11_load_glX_symbol(const char* name) {
    // The only function that libGL exposes is glXGetProcAddressARB
    // Every other function needs to be retrieved using said function
    return glXGetProcAddressARB((const GLubyte*)name);
}

// This is copied from Kinc
void* x11_load_library(const char* name) {
    char libname[32];
    sprintf(libname, "lib%s.so", name);
    void* lib = dlopen(libname, RTLD_LAZY);
    // Some Linux distros don't have the .so directly, but instead put a version tag on it.
    // TODO: actually test this on one of said distros
    for(int i=0; i < 10 && lib == NULL; ++i) {
        sprintf(libname, "lib%s.so.%i", name, i);
        lib = dlopen(libname,  RTLD_LAZY);
    }
    return lib;
}

pinc_key_code_t x11_translate_key(int code) {
    if(code < 0 || code > 255) return pinc_key_code_unknown;
    return x11_xkey_to_pinc[code];
}

pinc_key_modifiers_t x11_translate_modifiers(unsigned int xState) {
    // TODO
    return xState;
}

// This is copied and ported from GLFW
void x11_create_key_tables(void)
{
    int scancodeMin, scancodeMax;

    memset(x11_xkey_to_pinc, -1, sizeof(x11_xkey_to_pinc));
    memset(x11_pinc_to_xkey, -1, sizeof(x11_pinc_to_xkey));

    if (xkbAvailable)
    {
        // Use XKB to determine physical key locations independently of the
        // current keyboard layout

        XkbDescPtr desc = XkbGetMap(xDisplay, 0, XkbUseCoreKbd);
        XkbGetNames(xDisplay, XkbKeyNamesMask | XkbKeyAliasesMask, desc);

        scancodeMin = desc->min_key_code;
        scancodeMax = desc->max_key_code;

        const struct
        {
            int key;
            char* name;
        } keymap[] =
        {
            { pinc_key_code_backtick, "TLDE" },
            { pinc_key_code_1, "AE01" },
            { pinc_key_code_2, "AE02" },
            { pinc_key_code_3, "AE03" },
            { pinc_key_code_4, "AE04" },
            { pinc_key_code_5, "AE05" },
            { pinc_key_code_6, "AE06" },
            { pinc_key_code_7, "AE07" },
            { pinc_key_code_8, "AE08" },
            { pinc_key_code_9, "AE09" },
            { pinc_key_code_0, "AE10" },
            { pinc_key_code_dash, "AE11" },
            { pinc_key_code_equals, "AE12" },
            { pinc_key_code_q, "AD01" },
            { pinc_key_code_w, "AD02" },
            { pinc_key_code_e, "AD03" },
            { pinc_key_code_r, "AD04" },
            { pinc_key_code_T, "AD05" },
            { pinc_key_code_y, "AD06" },
            { pinc_key_code_u, "AD07" },
            { pinc_key_code_i, "AD08" },
            { pinc_key_code_o, "AD09" },
            { pinc_key_code_p, "AD10" },
            { pinc_key_code_left_bracket, "AD11" },
            { pinc_key_code_right_bracket, "AD12" },
            { pinc_key_code_a, "AC01" },
            { pinc_key_code_s, "AC02" },
            { pinc_key_code_d, "AC03" },
            { pinc_key_code_f, "AC04" },
            { pinc_key_code_g, "AC05" },
            { pinc_key_code_h, "AC06" },
            { pinc_key_code_j, "AC07" },
            { pinc_key_code_k, "AC08" },
            { pinc_key_code_l, "AC09" },
            { pinc_key_code_semicolon, "AC10" },
            { pinc_key_code_apostrophe, "AC11" },
            { pinc_key_code_z, "AB01" },
            { pinc_key_code_z, "AB02" },
            { pinc_key_code_c, "AB03" },
            { pinc_key_code_v, "AB04" },
            { pinc_key_code_b, "AB05" },
            { pinc_key_code_n, "AB06" },
            { pinc_key_code_m, "AB07" },
            { pinc_key_code_comma, "AB08" },
            { pinc_key_code_dot, "AB09" },
            { pinc_key_code_slash, "AB10" },
            { pinc_key_code_backslash, "BKSL" },
            // TODO: I still don't know what the flip a "world" button is
            // Apparently it's mapped to the xkb LSGT code
            { pinc_key_code_unknown, "LSGT" },
            { pinc_key_code_space, "SPCE" },
            { pinc_key_code_escape, "ESC" },
            { pinc_key_code_enter, "RTRN" },
            { pinc_key_code_tab, "TAB" },
            { pinc_key_code_backspace, "BKSP" },
            { pinc_key_code_insert, "INS" },
            { pinc_key_code_delete, "DELE" },
            { pinc_key_code_right, "RGHT" },
            { pinc_key_code_left, "LEFT" },
            { pinc_key_code_down, "DOWN" },
            { pinc_key_code_up, "UP" },
            { pinc_key_code_page_up, "PGUP" },
            { pinc_key_code_page_down, "PGDN" },
            { pinc_key_code_home, "HOME" },
            { pinc_key_code_end, "END" },
            { pinc_key_code_caps_lock, "CAPS" },
            { pinc_key_code_scroll_lock, "SCLK" },
            { pinc_key_code_num_lock, "NMLK" },
            { pinc_key_code_print_screen, "PRSC" },
            { pinc_key_code_pause, "PAUS" },
            { pinc_key_code_f1, "FK01" },
            { pinc_key_code_f2, "FK02" },
            { pinc_key_code_f3, "FK03" },
            { pinc_key_code_f4, "FK04" },
            { pinc_key_code_f5, "FK05" },
            { pinc_key_code_f6, "FK06" },
            { pinc_key_code_f7, "FK07" },
            { pinc_key_code_f8, "FK08" },
            { pinc_key_code_f9, "FK09" },
            { pinc_key_code_f10, "FK10" },
            { pinc_key_code_f11, "FK11" },
            { pinc_key_code_f12, "FK12" },
            { pinc_key_code_f13, "FK13" },
            { pinc_key_code_f14, "FK14" },
            { pinc_key_code_f15, "FK15" },
            { pinc_key_code_f16, "FK16" },
            { pinc_key_code_f17, "FK17" },
            { pinc_key_code_f18, "FK18" },
            { pinc_key_code_f19, "FK19" },
            { pinc_key_code_f20, "FK20" },
            { pinc_key_code_f21, "FK21" },
            { pinc_key_code_f22, "FK22" },
            { pinc_key_code_f23, "FK23" },
            { pinc_key_code_f24, "FK24" },
            { pinc_key_code_f25, "FK25" },
            // TODO: Do xkb codes go all the way to F30?
            { pinc_key_code_numpad_0, "KP0" },
            { pinc_key_code_numpad_1, "KP1" },
            { pinc_key_code_numpad_2, "KP2" },
            { pinc_key_code_numpad_3, "KP3" },
            { pinc_key_code_numpad_4, "KP4" },
            { pinc_key_code_numpad_5, "KP5" },
            { pinc_key_code_numpad_6, "KP6" },
            { pinc_key_code_numpad_7, "KP7" },
            { pinc_key_code_numpad_8, "KP8" },
            { pinc_key_code_numpad_9, "KP9" },
            { pinc_key_code_numpad_dot, "KPDL" },
            { pinc_key_code_numpad_slash, "KPDV" },
            { pinc_key_code_numpad_asterisk, "KPMU" },
            { pinc_key_code_numpad_dash, "KPSU" },
            { pinc_key_code_numpad_plus, "KPAD" },
            { pinc_key_code_numpad_enter, "KPEN" },
            { pinc_key_code_numpad_equal, "KPEQ" },
            { pinc_key_code_left_shift, "LFSH" },
            { pinc_key_code_left_control, "LCTL" },
            { pinc_key_code_left_alt, "LALT" },
            { pinc_key_code_left_super, "LWIN" },
            { pinc_key_code_right_shift, "RTSH" },
            { pinc_key_code_right_control, "RCTL" },
            { pinc_key_code_right_alt, "RALT" },
            { pinc_key_code_right_alt, "LVL3" },
            { pinc_key_code_right_alt, "MDSW" },
            { pinc_key_code_right_super, "RWIN" },
            { pinc_key_code_menu, "MENU" }
        };

        // Find the X11 key code -> Pinc key code mapping
        for (int scancode = scancodeMin;  scancode <= scancodeMax;  scancode++)
        {
            int key = pinc_key_code_unknown;

            // Map the key name to a Pinc key code. Note: We use the US
            // keyboard layout. Because function keys aren't mapped correctly
            // when using traditional KeySym translations, they are mapped
            // here instead.
            for (int i = 0;  i < sizeof(keymap) / sizeof(keymap[0]);  i++)
            {
                if (strncmp(desc->names->keys[scancode].name,
                            keymap[i].name,
                            XkbKeyNameLength) == 0)
                {
                    key = keymap[i].key;
                    break;
                }
            }

            // Fall back to key aliases in case the key name did not match
            for (int i = 0;  i < desc->names->num_key_aliases;  i++)
            {
                if (key != pinc_key_code_unknown)
                    break;

                if (strncmp(desc->names->key_aliases[i].real,
                            desc->names->keys[scancode].name,
                            XkbKeyNameLength) != 0)
                {
                    continue;
                }

                for (int j = 0;  j < sizeof(keymap) / sizeof(keymap[0]);  j++)
                {
                    if (strncmp(desc->names->key_aliases[i].alias,
                                keymap[j].name,
                                XkbKeyNameLength) == 0)
                    {
                        key = keymap[j].key;
                        break;
                    }
                }
            }

            x11_xkey_to_pinc[scancode] = key;
        }

        XkbFreeNames(desc, XkbKeyNamesMask, True);
        XkbFreeKeyboard(desc, 0, True);
    }
    else
        XDisplayKeycodes(xDisplay, &scancodeMin, &scancodeMax);

    int width;
    KeySym* keysyms = XGetKeyboardMapping(xDisplay,
                                          scancodeMin,
                                          scancodeMax - scancodeMin + 1,
                                          &width);

    for (int scancode = scancodeMin;  scancode <= scancodeMax;  scancode++)
    {
        // Translate the un-translated key codes using traditional X11 KeySym
        // lookups
        if (x11_xkey_to_pinc[scancode] < 0)
        {
            const size_t base = (scancode - scancodeMin) * width;
            x11_xkey_to_pinc[scancode] = x11_get_key_code(&keysyms[base], width);
        }

        // Store the reverse translation for faster key name lookup
        if (x11_xkey_to_pinc[scancode] > 0)
            x11_pinc_to_xkey[x11_xkey_to_pinc[scancode]] = scancode;
    }

    XFree(keysyms);
}

// Translate the X11 KeySyms for a key to a Pinc key code
// NOTE: This is only used as a fallback, in case the XKB method fails
//       It is layout-dependent and will fail partially on most non-US layouts
// This is copied from GLFW
pinc_key_code_t x11_get_key_code(const KeySym* keysyms, int width)
{
    if (width > 1)
    {
        switch (keysyms[1])
        {
            case XK_KP_0:           return pinc_key_code_numpad_0;
            case XK_KP_1:           return pinc_key_code_numpad_1;
            case XK_KP_2:           return pinc_key_code_numpad_2;
            case XK_KP_3:           return pinc_key_code_numpad_3;
            case XK_KP_4:           return pinc_key_code_numpad_4;
            case XK_KP_5:           return pinc_key_code_numpad_5;
            case XK_KP_6:           return pinc_key_code_numpad_6;
            case XK_KP_7:           return pinc_key_code_numpad_7;
            case XK_KP_8:           return pinc_key_code_numpad_8;
            case XK_KP_9:           return pinc_key_code_numpad_9;
            case XK_KP_Separator:
            case XK_KP_Decimal:     return pinc_key_code_numpad_dot;
            case XK_KP_Equal:       return pinc_key_code_numpad_equal;
            case XK_KP_Enter:       return pinc_key_code_numpad_enter;
            default:                break;
        }
    }

    switch (keysyms[0])
    {
        case XK_Escape:         return pinc_key_code_escape;
        case XK_Tab:            return pinc_key_code_tab;
        case XK_Shift_L:        return pinc_key_code_left_shift;
        case XK_Shift_R:        return pinc_key_code_right_shift;
        case XK_Control_L:      return pinc_key_code_left_control;
        case XK_Control_R:      return pinc_key_code_right_control;
        case XK_Meta_L:
        case XK_Alt_L:          return pinc_key_code_left_alt;
        case XK_Mode_switch: // Mapped to Alt_R on many keyboards
        case XK_ISO_Level3_Shift: // AltGr on at least some machines
        case XK_Meta_R:
        case XK_Alt_R:          return pinc_key_code_right_alt;
        case XK_Super_L:        return pinc_key_code_left_super;
        case XK_Super_R:        return pinc_key_code_right_super;
        case XK_Menu:           return pinc_key_code_menu;
        case XK_Num_Lock:       return pinc_key_code_num_lock;
        case XK_Caps_Lock:      return pinc_key_code_caps_lock;
        case XK_Print:          return pinc_key_code_print_screen;
        case XK_Scroll_Lock:    return pinc_key_code_scroll_lock;
        case XK_Pause:          return pinc_key_code_pause;
        case XK_Delete:         return pinc_key_code_delete;
        case XK_BackSpace:      return pinc_key_code_backspace;
        case XK_Return:         return pinc_key_code_enter;
        case XK_Home:           return pinc_key_code_home;
        case XK_End:            return pinc_key_code_end;
        case XK_Page_Up:        return pinc_key_code_page_up;
        case XK_Page_Down:      return pinc_key_code_page_down;
        case XK_Insert:         return pinc_key_code_insert;
        case XK_Left:           return pinc_key_code_left;
        case XK_Right:          return pinc_key_code_right;
        case XK_Down:           return pinc_key_code_down;
        case XK_Up:             return pinc_key_code_up;
        case XK_F1:             return pinc_key_code_f1;
        case XK_F2:             return pinc_key_code_f2;
        case XK_F3:             return pinc_key_code_f3;
        case XK_F4:             return pinc_key_code_f4;
        case XK_F5:             return pinc_key_code_f5;
        case XK_F6:             return pinc_key_code_f6;
        case XK_F7:             return pinc_key_code_f7;
        case XK_F8:             return pinc_key_code_f8;
        case XK_F9:             return pinc_key_code_f9;
        case XK_F10:            return pinc_key_code_f10;
        case XK_F11:            return pinc_key_code_f11;
        case XK_F12:            return pinc_key_code_f12;
        case XK_F13:            return pinc_key_code_f13;
        case XK_F14:            return pinc_key_code_f14;
        case XK_F15:            return pinc_key_code_f15;
        case XK_F16:            return pinc_key_code_f16;
        case XK_F17:            return pinc_key_code_f17;
        case XK_F18:            return pinc_key_code_f18;
        case XK_F19:            return pinc_key_code_f19;
        case XK_F20:            return pinc_key_code_f20;
        case XK_F21:            return pinc_key_code_f21;
        case XK_F22:            return pinc_key_code_f22;
        case XK_F23:            return pinc_key_code_f23;
        case XK_F24:            return pinc_key_code_f24;
        case XK_F25:            return pinc_key_code_f25;
        case XK_F26:            return pinc_key_code_f26;
        case XK_F27:            return pinc_key_code_f27;
        case XK_F28:            return pinc_key_code_f28;
        case XK_F29:            return pinc_key_code_f29;
        case XK_F30:            return pinc_key_code_f30;
        // Numeric keypad
        case XK_KP_Divide:      return pinc_key_code_numpad_slash;
        case XK_KP_Multiply:    return pinc_key_code_numpad_asterisk;
        case XK_KP_Subtract:    return pinc_key_code_numpad_dash;
        case XK_KP_Add:         return pinc_key_code_numpad_plus;

        // These should have been detected in secondary keysym test above!
        case XK_KP_Insert:      return pinc_key_code_numpad_0;
        case XK_KP_End:         return pinc_key_code_numpad_1;
        case XK_KP_Down:        return pinc_key_code_numpad_2;
        case XK_KP_Page_Down:   return pinc_key_code_numpad_3;
        case XK_KP_Left:        return pinc_key_code_numpad_4;
        case XK_KP_Right:       return pinc_key_code_numpad_6;
        case XK_KP_Home:        return pinc_key_code_numpad_7;
        case XK_KP_Up:          return pinc_key_code_numpad_8;
        case XK_KP_Page_Up:     return pinc_key_code_numpad_9;
        case XK_KP_Delete:      return pinc_key_code_numpad_dot;
        case XK_KP_Equal:       return pinc_key_code_numpad_equal;
        case XK_KP_Enter:       return pinc_key_code_numpad_enter;

        // Last resort: Check for printable keys (should not happen if the XKB
        // extension is available). This will give a layout dependent mapping
        // (which is wrong, and we may miss some keys, especially on non-US
        // keyboards), but it's better than nothing...
        case XK_a:              return pinc_key_code_a;
        case XK_b:              return pinc_key_code_b;
        case XK_c:              return pinc_key_code_c;
        case XK_d:              return pinc_key_code_d;
        case XK_e:              return pinc_key_code_e;
        case XK_f:              return pinc_key_code_f;
        case XK_g:              return pinc_key_code_g;
        case XK_h:              return pinc_key_code_h;
        case XK_i:              return pinc_key_code_i;
        case XK_j:              return pinc_key_code_j;
        case XK_k:              return pinc_key_code_k;
        case XK_l:              return pinc_key_code_l;
        case XK_m:              return pinc_key_code_m;
        case XK_n:              return pinc_key_code_n;
        case XK_o:              return pinc_key_code_o;
        case XK_p:              return pinc_key_code_p;
        case XK_q:              return pinc_key_code_q;
        case XK_r:              return pinc_key_code_r;
        case XK_s:              return pinc_key_code_s;
        case XK_t:              return pinc_key_code_T;
        case XK_u:              return pinc_key_code_u;
        case XK_v:              return pinc_key_code_v;
        case XK_w:              return pinc_key_code_w;
        case XK_x:              return pinc_key_code_x;
        case XK_y:              return pinc_key_code_y;
        case XK_z:              return pinc_key_code_z;
        case XK_1:              return pinc_key_code_1;
        case XK_2:              return pinc_key_code_2;
        case XK_3:              return pinc_key_code_3;
        case XK_4:              return pinc_key_code_4;
        case XK_5:              return pinc_key_code_5;
        case XK_6:              return pinc_key_code_6;
        case XK_7:              return pinc_key_code_7;
        case XK_8:              return pinc_key_code_8;
        case XK_9:              return pinc_key_code_9;
        case XK_0:              return pinc_key_code_0;
        case XK_space:          return pinc_key_code_space;
        case XK_minus:          return pinc_key_code_dash;
        case XK_equal:          return pinc_key_code_equals;
        case XK_bracketleft:    return pinc_key_code_left_bracket;
        case XK_bracketright:   return pinc_key_code_right_bracket;
        case XK_backslash:      return pinc_key_code_backslash;
        case XK_semicolon:      return pinc_key_code_semicolon;
        case XK_apostrophe:     return pinc_key_code_apostrophe;
        case XK_grave:          return pinc_key_code_backtick;
        case XK_comma:          return pinc_key_code_comma;
        case XK_period:         return pinc_key_code_dot;
        case XK_slash:          return pinc_key_code_slash;
        default:                break;
    }

    // No matching translation was found
    return pinc_key_code_unknown;
}
