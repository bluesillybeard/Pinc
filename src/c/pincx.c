// This C file contains ALL of the code that directly interacts with X and glX.
// GLFW's equivalent to this file is ~8000 lines of code, so it's not bad at all.

// Refactoring functionality out of this file would require modifying the loader headers
// to support separating the file that holds the function pointers and files that access them.

// Includes of C standard library (Linux stuff)
#include <stddef.h>
#include <stdbool.h>
#include <dlfcn.h>
#include <stdio.h>
#include <locale.h>
#include <string.h>
#include <math.h>
#include <time.h>
#include <unistd.h>
#include <stdlib.h>
// Includes of X and X extensions
#include <X11/Xlib.h>
#include "load/XlibLoad.h"

// Apparently X util functions are in a different header
#include <X11/Xutil.h>
#include "load/XutilLoad.h"

#include <X11/keysym.h>
#include <X11/Xatom.h>
#include <X11/Xresource.h>

#include <X11/Xcursor/Xcursor.h>
#include "load/XCursorLoad.h"

#include <X11/XKBlib.h>
#include "load/xkbLoad.h"

#include <X11/extensions/XInput2.h>
#include "load/XInput2Load.h"

#include <GL/glx.h>
#include "load/glXLoad.h"

#define PINC_X_INCLUDED
#include "pincx.h"

// General TODOs for X11 go here
// TODO: system content scale (example at GLFW x11_init.c line 1530)
// TODO: add the XRender extension for seeing if a Visual supports transparency
// TODO: atoms and window manager stuff
// TODO: only integer step scroll events work at the moment

// Resources used: public HTML version of libX11 documentation: https://x.org/releases/current/doc/libX11/libX11/libX11.html
// Kinc source code, here is their website: https://kinc.tech/
// - Kinc is full of confusing macros and other insanity so that was probably a waste of time
// GLFW source code
// - This is what "inspired" 90% of the code in pincx.c (I basically went line by line and duplicated GLFW's X11 backend)

// -> Library handles

void* libX11; // This also contains Xkb and Xutil.
void* libXi;
void* libXcursor;
void* libGL; // This contains glX as well

// -> Xlib static vars

Display* xDisplay;
// TODO: X error handler instead of letting Xlib crash the program
// The previous X error handler to be restored later
XErrorHandler previousXErrorHandler;
// Most recent error code from the X error handler
int xErrorCode;
char* primarySelectionString;
char* clipboardString;

Atom WM_PROTOCOLS;

Atom WM_DELETE_WINDOW;

// -> glX static vars

GLXContext glxContext;

GLXFBConfig glxFbConfig;

int glxErrorBase;

int glxEventBase;

// -> Xkb static vars - many of these are used even ifthe xkb extension is not available.

// Lookup table from X11 keycode to pinc keycode.
// This is in the XKB vars but is still properly initialized when XKB is not available.
int16_t xkbToPinc[256];
int16_t pincToXkb[pinc_key_code_count + 1];
// This is for detecting key repeat events. input -> xkb code, output -> if that key is currently being pressed
bool keystates[256] = {0};
// Whether the XKB extension is available
bool xkbAvailable = false;
// Whether XKB key repeat events can be detected
bool xkbDetectable;
// the first XKB event code
int xkbEventBase;
unsigned char xkbGroup;
// -> XInput static vars

// Whether Xi / XInput is available
bool xiAvailable = false;
// TODO: what is this
int xiEventBase;
// TODO: what is this
int xiErrorBase;
// Xi major opcode, whatever the heck that is
int xiMajorOpcode;
// XIM input method
XIM xim;

// declarations of private functions that are implemented later

bool x11_load_libraries(void);

void* x11_load_Xlib_symbol(const char* name);

void* x11_load_library(const char* name);

bool x11_init_extensions(void);

void x11_create_key_tables(void);

pinc_key_code_enum x11_translate_keysyms(const KeySym* keysyms, int width);

void x11_input_instantiate_callback(Display* display, XPointer clientData, XPointer callData);

bool x11_framebuffer_is_better(int colorBits, int depthBits, int stencilBits, int newColorBits, int newDepthBits, int newStencilBits);

uint32_t x11_sym_to_unicode(KeySym sym);

// Super simple private functions are just implemented here rather than declared here and implemented later

// Translates and X11 key code to a pinc key code.
pinc_key_code_enum x11_translate_keycode(int keycode) {
    if(keycode < 0 || keycode > 255) return pinc_key_code_unknown;
    return xkbToPinc[keycode];
}

// translates X11 modifiers into Pinc modifiers
pinc_key_modifiers_t x11_translate_modifiers(int mods) {
    pinc_key_modifiers_t m;
    if(mods & ShiftMask) m |= pinc_modifier_shift_bit;
    if(mods & LockMask) m |= pinc_modifier_caps_lock_bit;
    if(mods & ControlMask) m |= pinc_modifier_control_bit;
    if(mods & Mod1Mask) m |= pinc_modifier_alt_bit;
    if(mods & Mod2Mask) m |= pinc_modifier_num_lock_bit;
    if(mods & Mod4Mask) m |= pinc_modifier_super_bit;
    return m;
}

// Decode a Unicode code point from a UTF-8 stream
// Based on cutef8 by Jeff Bezanson (Public Domain)
//
static uint32_t decodeUTF8(const char** s)
{
    uint32_t codepoint = 0, count = 0;
    static const uint32_t offsets[] =
    {
        0x00000000u, 0x00003080u, 0x000e2080u,
        0x03c82080u, 0xfa082080u, 0x82082080u
    };

    do
    {
        codepoint = (codepoint << 6) + (unsigned char) **s;
        (*s)++;
        count++;
    } while ((**s & 0xc0) == 0x80);

    // assert(count <= 6);
    return codepoint - offsets[count - 1];
}

// implementations of functions in pincx.h

bool x11_init(void) {
    // HACK: (stolen from GLFW) If the application has left the locale as "C" then both wide
    //       character text input and explicit UTF-8 input via XIM will break
    //       This sets the CTYPE part of the current locale from the environment
    //       in the hope that it is set to something more sane than "C"
    if (strcmp(setlocale(LC_CTYPE, NULL), "C") == 0) setlocale(LC_CTYPE, "");

    bool result = x11_load_libraries();
    // Errors are always set at the "leaf node" - the deepest point where the error occurs
    if(!result) return false;
    xDisplay = XOpenDisplay(NULL);
    if(xDisplay == NULL) {
        pinci_make_error(pinc_error_init, "Failed to connect to X server");
        return false;
    }
    result = x11_init_extensions();
    if(!result) return false;

    WM_PROTOCOLS = XInternAtom(xDisplay, "WM_PROTOCOLS", False);

    WM_DELETE_WINDOW = XInternAtom(xDisplay, "WM_DELETE_WINDOW", False);

    if(Xutf8LookupString && Xutf8SetWMProperties) {
        if(XSupportsLocale()) {
            XSetLocaleModifiers("");
            // TODO: what the heck is an input method?
            // XRegisterIMInstantiateCallback(xDisplay, NULL, NULL, NULL, &x11_input_instantiate_callback, NULL);
        }
    }
    return true;
}

void x11_deinit(void) {
    if(clipboardString) pinci_free_string(clipboardString);
    if(primarySelectionString) pinci_free_string(primarySelectionString);

    glXDestroyContext(xDisplay, glxContext);

    if(xim) {
        XCloseIM(xim);
        xim = NULL;
    }
    if(xDisplay) {
        XCloseDisplay(xDisplay);
        xDisplay = NULL;
    }

    if(libGL) {
        dlclose(libGL);
        libGL = NULL;
    }

    if(libXi) {
        dlclose(libXi);
        libXi = NULL;
    }

    if(libXcursor) {
        dlclose(libXcursor);
        libXcursor = NULL;
    }

    if(libX11) {
        dlclose(libX11);
        libX11 = NULL;
    }
}

x11_window x11_window_incomplete_create(const char* title) {
    x11_window w;
    w.title = pinci_dupe_string(title);
    w.xWindow = 0;
    w.cursorX = 0;
    w.cursorY = 0;
    w.width = 800;
    w.height = 600;
    w.inputContext = None;
    w.lastCursorX = 0;
    w.lastCursorY = 0;
    // TODO: actually detect if the chosen FBConfigs from init supports transparency, and use that to initialize this
    w.transparency = false;
    // This being set to null is how incomplete windows are detected
    w.xWindow = None;
    return w;
}

bool x11_window_complete(x11_window* window) {
    XVisualInfo* xVisual = glXGetVisualFromFBConfig(xDisplay, glxFbConfig);
    Window rootWindow = DefaultRootWindow(xDisplay);
    Colormap cmap = XCreateColormap(xDisplay, rootWindow, xVisual->visual, AllocNone);

    XSetWindowAttributes windowAttributes = {};
    windowAttributes.colormap = cmap;
    windowAttributes.event_mask = StructureNotifyMask | KeyPressMask | KeyReleaseMask
        | PointerMotionMask | ButtonPressMask | ButtonReleaseMask | ExposureMask
        | FocusChangeMask | VisibilityChangeMask | EnterWindowMask | LeaveWindowMask | PropertyChangeMask;

    window->xWindow = XCreateWindow(xDisplay, rootWindow, 0, 0, window->width, window->height, 0, xVisual->depth,
        InputOutput, xVisual->visual, CWBorderPixel | CWColormap | CWEventMask, &windowAttributes);
    if(window->xWindow == None) {
        pinci_make_error(pinc_error_init, "Failed to create X window");
        return false;
    }
    XFree(xVisual);
    XStoreName(xDisplay, window->xWindow, window->title);
    XMapWindow(xDisplay, window->xWindow);

    {
        XWMHints* hints = XAllocWMHints();
        hints->flags = StateHint;
        hints->initial_state = NormalState;
        XSetWMHints(xDisplay, window->xWindow, hints);
        XFree(hints);
    }

    {
        XClassHint* hint = XAllocClassHint();
        const char* envResourceName = getenv("RESOURCE_NAME");
        if(envResourceName && strlen(envResourceName)) {
            hint->res_name = envResourceName;
        } else if(strlen(window->title)) {
            hint->res_name = window->title;
        } else {
            hint->res_name = "untitled-pinc";
        }

        if(strlen(window->title)) {
            hint->res_class = window->title;
        } else {
            hint->res_class = "untitled-pinc";
        }
        XSetClassHint(xDisplay, window->xWindow, hint);
        XFree(hint);
    }
    {
        Atom protocols[] = {
            WM_DELETE_WINDOW,
        };
        XSetWMProtocols(xDisplay, window->xWindow, protocols, 1);
    }
    // This is so the window shows up immediately upon completing it.
    XFlush(xDisplay);
    // Flush a second time because that somehow fixes a crash. I genuinely don't know why or how.
    XFlush(xDisplay);
    return true;
}

void x11_window_destroy(pinc_window_incomplete_handle_t window) {
    x11_window* xWindow = x11_get_x_window(window);
    if(!xWindow) return;
    if(xWindow->xWindow) {
        if(xWindow->inputContext) {
            XDestroyIC(xWindow->inputContext);
            xWindow->inputContext = NULL;
        }
        XUnmapWindow(xDisplay, xWindow->xWindow);
        XDestroyWindow(xDisplay, xWindow->xWindow);
        xWindow->xWindow = 0;
        XFlush(xDisplay);
    }
}

void x11_poll_events(void) {
    // It is common to have nested stuff which makes breaking back to this loop non-trivial. This is what goto is meant for.
    CONTINUE_LOOP:
    while(XPending(xDisplay)) {
        XEvent event;
        XNextEvent(xDisplay, &event);

        int keycode = 0;
        Bool filtered = false;

        // HACK: Save scancode as some IMs clear the field in XFilterEvent
        if (event.type == KeyPress || event.type == KeyRelease)
            keycode = event.xkey.keycode;

        filtered = XFilterEvent(&event, None);

        if(xkbAvailable) {
            if(event.type == xkbEventBase + XkbEventCode) {
                XkbEvent* xkbEvent = (XkbEvent*) &event;
                if(xkbEvent->any.xkb_type == XkbStateNotify && xkbEvent->state.changed & XkbGroupStateMask) {
                    xkbGroup = xkbEvent->state.group;
                }
                goto CONTINUE_LOOP;
            }
        }
        if(event.type == GenericEvent) {
            if(xiAvailable) {
                // TODO: apparently mouse motion? GLFW's strange design and lack of comments is making figuring this out hard
                // glfw line 1186 or so
            }
            goto CONTINUE_LOOP;
        }
        if(event.type == SelectionRequest) {
            // TODO: after Atoms are implemented. glfw line 1222 or so
            goto CONTINUE_LOOP;
        }
        // get the pinc ID of the window and a pointer to the X11 specific data of the window
        pinc_window_handle_t window = x11_get_window_handle(event.xany.window);
        x11_window* windowData = x11_get_x_window(window);
        switch(event.type) {
            case ReparentNotify: {
                // TODO: should Pinc care what the parent window is?
                goto CONTINUE_LOOP;
            }

            case KeyPress: {
                // Unlike in GLFW, the key repeat action is detected here instead of in the event handling code down the chain.
                const pinc_key_code_enum key = x11_translate_keycode(keycode);
                const pinc_key_modifiers_t modifiers = x11_translate_modifiers(event.xkey.state);

                if(windowData->inputContext) {
                    // XIM tends to duplicate key presses (pain) but thankfully the duplicated events have the same timestamp so they can be filtered out.
                    Time diff = event.xkey.time - windowData->keyPressTime[keycode];
                    // This comparison is weird in order to handle wrap around
                    if( diff == event.xkey.time || (diff > 0 && diff < ((Time)(1 << 31)))) {
                        windowData->keyPressTime[keycode] = event.xkey.time;
                        if(keystates[keycode] == true) {
                            // this is a repeat event
                            pinc_event_union_t krevt = {};
                            krevt.type = pinc_event_window_key_repeat;
                            krevt.data.window_key_repeat.key = key; 
                            krevt.data.window_key_repeat.modifiers = modifiers;
                            krevt.data.window_key_repeat.token = keycode;
                            krevt.data.window_key_repeat.window = window;
                            pinci_send_event(krevt);
                        } else {
                            // This is not a repeat event
                            keystates[keycode] = true;
                            pinc_event_union_t kpevt = {};
                            kpevt.type = pinc_event_window_key_down;
                            kpevt.data.window_key_down.key = key; 
                            kpevt.data.window_key_down.modifiers = modifiers;
                            kpevt.data.window_key_down.token = keycode;
                            kpevt.data.window_key_down.window = window;
                            pinci_send_event(kpevt);
                        }
                    }

                    if(!filtered) {
                        int count;
                        Status status;
                        char buffer[128];
                        char* chars = buffer;

                        count = Xutf8LookupString(windowData->inputContext, &event.xkey, chars, sizeof(buffer)-1, NULL, &status);
                        if(status == XBufferOverflow) {
                            chars = pinci_alloc_string(count);
                            // memset(chars, 1, count+1);
                            count = Xutf8LookupString(windowData->inputContext, &event.xkey, chars, count, NULL, &status);
                        }
                        if(status == XLookupChars || status == XLookupChars) {
                            const char* c = chars;
                            chars[count] = 0;
                            while(c - chars < count) {
                                uint32_t codepoint = decodeUTF8(&c);
                                // If the codepoint is too big, it's not a valid one and should not be sent
                                if(codepoint <= 0x110000) {
                                    pinc_event_union_t ktevt = {};
                                    ktevt.type = pinc_event_window_text;
                                    ktevt.data.window_text.window = window;
                                    ktevt.data.window_text.codepoint = codepoint;
                                    pinci_send_event(ktevt);
                                }
                            }
                        }
                        if(chars != buffer) pinci_free_string(chars);
                    }
                } else {
                    // the input method is not set, so we use the 'regular' way
                    KeySym sym;
                    XLookupString(&event.xkey, NULL, 0, &sym, NULL);
                    if(keystates[keycode] == true) {
                        // this is a repeat event
                        pinc_event_union_t krevt = {};
                        krevt.type = pinc_event_window_key_repeat;
                        krevt.data.window_key_repeat.key = key; 
                        krevt.data.window_key_repeat.modifiers = modifiers;
                        krevt.data.window_key_repeat.token = keycode;
                        krevt.data.window_key_repeat.window = window;
                        pinci_send_event(krevt);
                    } else {
                        // this is not a repeat event
                        keystates[keycode] = true;
                        pinc_event_union_t kpevt = {};
                        kpevt.type = pinc_event_window_key_down;
                        kpevt.data.window_key_down.key = key; 
                        kpevt.data.window_key_down.modifiers = modifiers;
                        kpevt.data.window_key_down.token = keycode;
                        kpevt.data.window_key_down.window = window;
                        pinci_send_event(kpevt);
                    }
                    const uint32_t codepoint = x11_sym_to_unicode(sym);
                    // If the codepoint is too big, it's not a valid one and should not be sent
                    if(codepoint <= 0x110000) {
                        pinc_event_union_t ktevt = {};
                        ktevt.type = pinc_event_window_text;
                        ktevt.data.window_text.window = window;
                        ktevt.data.window_text.codepoint = codepoint;
                        pinci_send_event(ktevt);
                    }
                }
                goto CONTINUE_LOOP;
            }
            case KeyRelease: {
                const int key = x11_translate_keycode(keycode);
                const int modifiers = x11_translate_modifiers(event.xkey.state);

                if(!xkbDetectable) {
                    // X is a wild beast that sends *undetectable repeat release events* for some asinine reason
                    // Thankfully, these events happen very close together, so they can be filtered.
                    if(XEventsQueued(xDisplay, QueuedAfterReading)) {
                        XEvent next;
                        XPeekEvent(xDisplay, &next);
                        if(next.type == KeyPress && next.xkey.window == event.xkey.window && next.xkey.keycode == keycode) {
                            // Place a margin on the time since it won't match exactl.
                            // I will be darn impressed if someone can break this limit and accidentally trigger this deduplication
                            // more impressed if they notice, and absolutely mindblown if they figure out it's Pinc that was causing it
                            // Also consider this code only runs if xkb repeat detection is not available, which is itself already quite rare
                            if((next.xkey.time - event.xkey.time) < 20 /*milliseconds*/) {
                                goto CONTINUE_LOOP;
                            }
                        }
                    }
                }
                keystates[keycode] = false;
                pinc_event_union_t krevt = {};
                krevt.type = pinc_event_window_key_up;
                krevt.data.window_key_up.window = window;
                krevt.data.window_key_up.token = keycode;
                krevt.data.window_key_up.key = key;
                krevt.data.window_key_up.modifiers = modifiers;
                pinci_send_event(krevt);
                goto CONTINUE_LOOP;
            }
            case ButtonPress: {
                if(event.xbutton.button < 0) goto CONTINUE_LOOP;
                if(event.xbutton.button <= 3) {
                    pinc_event_union_t mbevt = {};
                    mbevt.type = pinc_event_window_cursor_button_down;
                    mbevt.data.window_cursor_button_down.window = window;
                    switch(event.xbutton.button) {
                        case 1:
                            mbevt.data.window_cursor_button_down.button = 1; break;
                        case 2:
                            mbevt.data.window_cursor_button_down.button = 2; break;
                        case 3:
                            mbevt.data.window_cursor_button_down.button = 3; break;
                    }
                    pinci_send_event(mbevt);
                    goto CONTINUE_LOOP;
                }
                // Apparently the scroll wheel is made of 4 buttons.
                if(event.xbutton.button <= 7) {
                    pinc_event_union_t srevt = {};
                    srevt.type = pinc_event_window_scroll;
                    srevt.data.window_scroll.window = window;
                    switch (event.xbutton.button)
                    {
                        case 4:
                            // V
                            srevt.data.window_scroll.delta_x = 0;
                            srevt.data.window_scroll.delta_y = -1;
                            break;
                        case 5:
                            // ^
                            srevt.data.window_scroll.delta_x = 0;
                            srevt.data.window_scroll.delta_y = 1;
                            break;
                        case 6:
                            // <
                            srevt.data.window_scroll.delta_x = -1;
                            srevt.data.window_scroll.delta_y = 0;
                            break;
                        case 7:
                            // >
                            srevt.data.window_scroll.delta_x = 1;
                            srevt.data.window_scroll.delta_y = 0;
                            break;
                    }
                    pinci_send_event(srevt);
                    goto CONTINUE_LOOP;
                } else {
                    pinc_event_union_t mbevt = {};
                    mbevt.type = pinc_event_window_cursor_button_down;
                    mbevt.data.window_cursor_button_down.window = window;
                    // subtract for to make up for the goned events from scroll
                    mbevt.data.window_cursor_button_down.button = event.xbutton.button - 4;
                    pinci_send_event(mbevt);
                    goto CONTINUE_LOOP;
                }
            }
            case ButtonRelease: {
                if(event.xbutton.button < 0) goto CONTINUE_LOOP;
                if(event.xbutton.button <= 3) {
                    pinc_event_union_t mbevt = {};
                    mbevt.type = pinc_event_window_cursor_button_up;
                    mbevt.data.window_cursor_button_up.window = window;
                    switch(event.xbutton.button) {
                        case 1:
                            mbevt.data.window_cursor_button_up.button = 1; break;
                        case 2:
                            mbevt.data.window_cursor_button_up.button = 2; break;
                        case 3:
                            mbevt.data.window_cursor_button_up.button = 3; break;
                    }
                    pinci_send_event(mbevt);
                    goto CONTINUE_LOOP;
                }
                // Apparently the scroll wheel is made of 4 buttons.
                // I don't know how the 'release' of the scroll makes any sense so it's ignored
                if(event.xbutton.button <= 7) {
                    goto CONTINUE_LOOP;
                } else {
                    pinc_event_union_t mbevt = {};
                    mbevt.type = pinc_event_window_cursor_button_up;
                    mbevt.data.window_cursor_button_up.window = window;
                    // subtract for to make up for the goned events from scroll
                    mbevt.data.window_cursor_button_up.button = event.xbutton.button - 4;
                    pinci_send_event(mbevt);
                    goto CONTINUE_LOOP;
                }
            }
            case EnterNotify: {
                // TODO: Apparently it's the WM's responsibility to manage cursor image transitions between windows,
                // So once cursor images / states are added, that needs to be handled.
                // (GLFW's source code x11_window.c line ~1430 ish is a good starting point)
                pinc_event_union_t etevt = {};
                etevt.type = pinc_event_window_cursor_enter;
                etevt.data.window_cursor_enter.window = window;
                pinci_send_event(etevt);
                goto CONTINUE_LOOP;
            }
            case LeaveNotify: {
                pinc_event_union_t lvevt = {};
                lvevt.type = pinc_event_window_cursor_exit;
                lvevt.data.window_cursor_exit.window = window;
                pinci_send_event(lvevt);
                goto CONTINUE_LOOP;
            }
            case MotionNotify: {
                // The Zig portion of Pinc will take care of screen coordinates and deltas.
                pinc_event_union_t cmevt = {};
                cmevt.type = pinc_event_window_cursor_move;
                cmevt.data.window_cursor_move.window = window;
                // conveniently X uses coordinates starting on the top left just like Pinc
                cmevt.data.window_cursor_move.x_pixels = event.xmotion.x;
                cmevt.data.window_cursor_move.y_pixels = event.xmotion.y;
                pinci_send_event(cmevt);
                goto CONTINUE_LOOP;
            }
            case ConfigureNotify: {
                if(event.xconfigure.width != windowData->width || event.xconfigure.height != windowData->height) {
                    windowData->width = event.xconfigure.width;
                    windowData->height = event.xconfigure.height;
                    pinc_event_union_t szevt = {};
                    szevt.type = pinc_event_window_resize;
                    szevt.data.window_resize.window = window;
                    szevt.data.window_resize.width = event.xconfigure.width;
                    szevt.data.window_resize.height = event.xconfigure.height;
                    pinci_send_event(szevt);
                }
                // Pinc has no care for the Window's position (yet)
                goto CONTINUE_LOOP;
            }
            case ClientMessage: {
                // We got mail! Probably from the window manager.
                if(filtered) goto CONTINUE_LOOP;
                if(event.xclient.message_type == None) goto CONTINUE_LOOP;
                // TODO: drag/drop operations, which are apparently quite complex actually (GLFW x11_window.c line 1547 is a good reference)
                if(event.xclient.message_type == WM_PROTOCOLS) {
                    Atom protocol = event.xclient.data.l[0];
                    if(protocol == WM_DELETE_WINDOW) {
                        // Someone is telling this window to exit
                        // The user application is in charge of destroying this window.
                        pinc_event_union_t clevt;
                        clevt.type = pinc_event_window_close;
                        clevt.data.window_close.window = window;
                        pinci_send_event(clevt);
                        printf("Recieved exit event\n");
                    }
                }
                goto CONTINUE_LOOP;
            }
            case SelectionNotify: {
                // TODO: more drag&drop is suppossed to happen here
                goto CONTINUE_LOOP;
            }
            case FocusIn: {
                // We don't care about these
                if(event.xfocus.mode == NotifyGrab || event.xfocus.mode == NotifyUngrab) {
                    goto CONTINUE_LOOP;
                }
                // TODO: cursor capture stuff needs to happen
                if(windowData->inputContext) {
                    XSetICFocus(windowData->inputContext);
                }
                pinc_event_union_t fcevt = {};
                fcevt.type = pinc_event_window_focus;
                fcevt.data.window_focus.window = window;
                pinci_send_event(fcevt);
                goto CONTINUE_LOOP;
            }
            case FocusOut: {
                // We don't care about these
                if(event.xfocus.mode == NotifyGrab || event.xfocus.mode == NotifyUngrab) {
                    goto CONTINUE_LOOP;
                }
                // TODO: cursor capture stuff needs to happen
                if(windowData->inputContext) {
                    XUnsetICFocus(windowData->inputContext);
                }
                pinc_event_union_t fcevt = {};
                fcevt.type = pinc_event_window_unfocus;
                fcevt.data.window_unfocus.window = window;
                pinci_send_event(fcevt);
                goto CONTINUE_LOOP;
            }
            case Expose: {
                pinc_event_union_t dmgevt = {};
                dmgevt.type = pinc_event_window_damaged;
                dmgevt.data.window_damaged.window = window;
                pinci_send_event(dmgevt);
                goto CONTINUE_LOOP;
            }
            case PropertyNotify: {
                // TODO: this event apparently requires atoms to work correctly.
                // That is because it's for minimized/maximized/fullscreen stuff that is handled by the WM, and in order to do WM stuff atoms are required
                goto CONTINUE_LOOP;
            }
            case DestroyNotify: {
                goto CONTINUE_LOOP;
            }
        }
    }
}

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

void* x11_load_glX_symbol(void* context, const char* name) {
    // The only function that libGL is required to expose is glXGetProcAddressARB
    // Every other function needs to be retrieved using said function
    return glXGetProcAddressARB((const GLubyte*)name);
}
void x11_make_context_current(pinc_window_handle_t window) {
    x11_window* w = x11_get_x_window(window);
    glXMakeCurrent(xDisplay, w->xWindow, glxContext);
}

void x11_present_framebuffer(pinc_window_handle_t window, bool vsync) {
    // TODO: vsync
    x11_window* w = x11_get_x_window(window);
    glXSwapBuffers(xDisplay, w->xWindow);
}

void x11_set_window_size(pinc_window_handle_t window, uint16_t width, uint16_t height) {
    // TODO: update WM hints once those are implemented
    // TODO: if 0 is entered, figure out some kind of default size or something
    x11_window* xWindow = x11_get_x_window(window);
    XResizeWindow(xDisplay, xWindow->xWindow, width, height);
    // Update the width and height of the window
    xWindow->width = width;
    xWindow->height = height;
}

// implementation of private functions

bool x11_load_libraries(void) {
    libX11 = x11_load_library("X11");
    if(libX11 == NULL) {
        pinci_make_error(pinc_error_init, "Failed to load libx11.so");
        return false;
    }
    loadXlib(libX11, &dlsym);
    loadXutil(libX11, &dlsym);
    if(XOpenDisplay == NULL) {
        pinci_make_error(pinc_error_init, "Loaded libX11.so but it's missing functions");
        return false;
    }
    // Xkb is not strictly required - it will be detected later
    loadXkb(libX11, &dlsym);
    libXi = x11_load_library("Xi");
    // Xi is not strictly required - it will be detected later
    loadXInput2(libXi, &dlsym);
    libXcursor = x11_load_library("Xcursor");
    if(libXcursor == NULL) {
        pinci_make_error(pinc_error_init, "Failed to load libXcursor.so");
        return false;
    }
    loadXcursor(libXcursor, &dlsym);
    if(XcursorAnimateCreate == NULL) {
        pinci_make_error(pinc_error_init, "Loaded libXcursor.so but it's missing functions");
        return false;
    }

    // libGL is where we are going to get glX from.
    // glX implemented within libGL for some reason
    libGL = x11_load_library("GL");
    if(libGL == NULL) {
        pinci_make_error(pinc_error_init, "Failed to load libGL.so");
        return false;
    }
    // load glXGetProcAddressARB first as it is the function used to load all of the other functions.
    // Technically all of the core GLX functions *should* be exposed,
    // however for the sake of conforming with the original ABI from 2000, do it the safe way.
    // (https://registry.khronos.org/OpenGL/ABI/)
    // this ABI is outdated by a long while, however due to backwards compabilility,
    // any OpenGL system *WILL* support it faithfully.
    glXGetProcAddressARB = dlsym(libGL, "glXGetProcAddressARB");
    if(glXGetProcAddressARB == NULL) {
        pinci_make_error(pinc_error_init, "glXGetProcAddressARB is missing from libGL.so");
        return false;
    }
    loadGlX(NULL, &x11_load_glX_symbol);
    if(glXChooseVisual == NULL) {
        pinci_make_error(pinc_error_init, "glX functions are missing");
        return false;
    }
    return true;
}

// Initializes X extensions. Assumes the functions are already loaded,
// does not rely on functions being available (except for required extensions)
bool x11_init_extensions(void) {
    // TODO: for each extension, forcibly disable it and see if everything still works as intended.
    // TODO: before doing that, it may be worth adding the ability to enable / disable X extension from the user level
    // However, that relies on adding the platform-specific options struct to pinc_init.
    if(libXi != NULL && XIQueryVersion != NULL && XQueryExtension(xDisplay, "XInputExtension",
                                                                &xiMajorOpcode, &xiEventBase, &xiErrorBase)) {
        int major = 2;
        int minor = 0;
        xiAvailable = (XIQueryVersion(xDisplay, &major, &minor) == Success);
    }
    // Xcursor does not need initialization, if GLFW's source code is correct.
    if(XkbQueryExtension != NULL) {
        int majorOpcode;
        int errorBase;
        int major;
        int minor;
        xkbAvailable = XkbQueryExtension(xDisplay, &majorOpcode, &xkbEventBase, &errorBase, &major, &minor);
    }
    if(xkbAvailable) {
        Bool detectable;
        // It is not immediately clear what this means, but essentially it tells the X server that we don't want release events for repeat events.
        // This makes detecting repeat events much easier and more reliable.
        // We still have a fallback for when enabling this fails.
        if(XkbSetDetectableAutoRepeat(xDisplay, True, &detectable)) {
            if(detectable) {
                xkbDetectable = true;
            }
        }
        XkbStateRec stateRec;
        if(XkbGetState(xDisplay, XkbUseCoreKbd, &stateRec) == Success) {
            xkbGroup = stateRec.group;
        }
        XkbSelectEventDetails(xDisplay, XkbUseCoreKbd, XkbStateNotify, XkbGroupStateMask, XkbGroupStateMask);
        
        x11_create_key_tables();
    }
    if(libGL) {
        if(!glXQueryExtension(xDisplay, &glxErrorBase, &glxEventBase)) {
            pinci_make_error(pinc_error_init, "Failed to initialise glX");
            return false;
        }
        // Make sure at least glX version 1.3 is available
        int major;
        int minor;
        if(!glXQueryVersion(xDisplay, &major, &minor)) {
            pinci_make_error(pinc_error_init, "Failed to initialize glX");
            return false;
        }

        if(major < 1 || (major == 1 && minor < 3)) {
            pinci_make_error(pinc_error_init, "Pinc requires glX 1.3 or later");
            return false;
        }

        // create a glX context (one for the entire application)

        // The fact that glX lets the program make a windowless context is a bit of a cheat - it still has to know the framebuffer format ahead of time.
        // Pincs API is not designed with this limitation in mind, however it still is flexible enough to force every window to have the same format.
        // So, when choosing a framebuffer config, choose the "best" one with the most bit depth, and one with transparency if available.
        // TODO: add user options to the pinc api to help guide FB selection
        int numFbConfigs;
        GLXFBConfig* fbConfigs = glXGetFBConfigs(xDisplay, DefaultScreen(xDisplay), &numFbConfigs);
        if(fbConfigs == NULL || numFbConfigs == 0) {
            pinci_make_error(pinc_error_init, "No framebuffer configs available");
            return false;
        }
        int bestFbIndex = -1;
        // bool bestFbSupportsTransparency = false;
        // Total number of color bits (red + green + blue + alpha)
        int bestFbBitDepth = 0;
        int bestFbDepthBits = 0;
        int bestFbStencilBits = 0;
        // We don't care about the accumulation buffer - It's only useful in niche circumstances that are entirely useless for the functionality pinc provides.
        for(int i=0; i<numFbConfigs; ++i) {
            int value;
            GLXFBConfig fb = fbConfigs[i];
            // only RGBA framebuffers are allowed here
            glXGetFBConfigAttrib(xDisplay, fb, GLX_RENDER_TYPE, &value);
            if((value & GLX_RGBA_BIT) == 0) continue;
            glXGetFBConfigAttrib(xDisplay, fb, GLX_DRAWABLE_TYPE, &value);
            if((value & GLX_WINDOW_BIT) == 0) continue;
            glXGetFBConfigAttrib(xDisplay, fb, GLX_DOUBLEBUFFER, &value);
            if(value == 0) continue;
            // Get the properties of this config
            int fbBitDepth;
            int fbDepthBits;
            int fbStencilBits;
            glXGetFBConfigAttrib(xDisplay, fb, GLX_RED_SIZE, &value);
            fbBitDepth += value;
            glXGetFBConfigAttrib(xDisplay, fb, GLX_GREEN_SIZE, &value);
            fbBitDepth += value;
            glXGetFBConfigAttrib(xDisplay, fb, GLX_BLUE_SIZE, &value);
            fbBitDepth += value;
            //TODO: only include alpha bits if the framebuffer actually supports transparency
            glXGetFBConfigAttrib(xDisplay, fb, GLX_ALPHA_SIZE, &value);
            fbBitDepth += value;
            glXGetFBConfigAttrib(xDisplay, fb, GLX_DEPTH_SIZE, &fbDepthBits);
            glXGetFBConfigAttrib(xDisplay, fb, GLX_STENCIL_SIZE, &fbStencilBits);

            if(x11_framebuffer_is_better(bestFbBitDepth, bestFbDepthBits, bestFbStencilBits, fbBitDepth, fbDepthBits, fbStencilBits)) {
                bestFbBitDepth = fbBitDepth;
                bestFbDepthBits = fbDepthBits;
                bestFbStencilBits = fbStencilBits;
                bestFbIndex = i;
            }
        }

        if(bestFbIndex == -1) {
            pinci_make_error(pinc_error_init, "No usable glX framebuffer found");
            return false;
        }
        // Keep hold of the fbconfig we chose
        glxFbConfig = fbConfigs[bestFbIndex];
        XFree(fbConfigs);

        // At the moment, Pinc only supports OpenGL 2.1
        // So, use the legacy context creation mechanism
        glxContext = glXCreateNewContext(xDisplay, glxFbConfig, GLX_RGBA_TYPE, NULL, True);

        if(glxContext == NULL) {
            pinci_make_error(pinc_error_init, "failed to create glX context");
            return false;
        }

    }
    return true;
}

bool x11_framebuffer_is_better(int colorBits, int depthBits, int stencilBits, int newColorBits, int newDepthBits, int newStencilBits) {
    int totalBits = colorBits + depthBits + stencilBits;
    int newTotalBits = newColorBits + newDepthBits + newStencilBits;
    if(newTotalBits < totalBits) return false;
    if(newTotalBits > totalBits) return true;
    // If the number of bits is the same, then go through each value as a tiebreaker
    if(newColorBits > colorBits) return true;
    if(newDepthBits > depthBits) return true;
    if(newStencilBits > stencilBits) return true;

    return false;
}

void x11_create_key_tables(void) {
    int scancodeMin;
    int scancodeMax;
    memset(xkbToPinc, -1, sizeof(xkbToPinc));
    memset(pincToXkb, -1, sizeof(pincToXkb));
    if(xkbAvailable) {
        // use XKB to determine physical key locations

        XkbDescPtr desc = XkbGetMap(xDisplay, 0, XkbUseCoreKbd);
        XkbGetNames(xDisplay, XkbKeyNamesMask | XkbKeyAliasesMask, desc);
        scancodeMin = desc->min_key_code;
        scancodeMax = desc->max_key_code;

        // maps from Pinc codes to XKB code strings
        const struct {int key; char* name;} keymap [] = {
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
            { pinc_key_code_t, "AD05" },
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
            { pinc_key_code_x, "AB02" },
            { pinc_key_code_c, "AB03" },
            { pinc_key_code_v, "AB04" },
            { pinc_key_code_b, "AB05" },
            { pinc_key_code_n, "AB06" },
            { pinc_key_code_m, "AB07" },
            { pinc_key_code_comma, "AB08" },
            { pinc_key_code_dot, "AB09" },
            { pinc_key_code_slash, "AB10" },
            { pinc_key_code_backslash, "BKSL" },
            // { pinc_key_code_WORLD_1, "LSGT" }, Still don't know what the heck this is
            // Based on minimal research, it seems to be an additional modifier key (like shift, crtl, and alt)
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
            // TODO: see if XKB keys go to F30 like Pinc does
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

        // Get key code mappings
        for(int scancode = scancodeMin; scancode <= scancodeMax; ++scancode) {
            int key = pinc_key_code_unknown;

            for(int i = 0; i < sizeof(keymap) / sizeof(keymap[0]); ++i) {
                if(strncmp(desc->names->keys[scancode].name, keymap[i].name, 4) == 0) {
                    key = keymap[i].key;
                    break;
                }
            }
            // fallback to key aliases if no name matched
            for(int i = 0; key == pinc_key_code_unknown && i < desc->names->num_key_aliases; ++i) {
                if(strncmp(desc->names->key_aliases[i].real, desc->names->keys[scancode].name, 4) != 0) {
                    continue;
                }
                for(int j = 0; j < sizeof(keymap) / sizeof(keymap[0]); ++j) {
                    if(strncmp(desc->names->key_aliases[i].alias, keymap[j].name, 4) == 0) {
                        key = keymap[j].key;
                        break;
                    }
                }
            }

            xkbToPinc[scancode] = key;
        }

        XkbFreeNames(desc, XkbKeyNamesMask, True);
        XkbFreeKeyboard(desc, 0, True);
    } else {
        // Xkb is not available, so use the "old" (as if xkb isn't also old) way of doing things
        XDisplayKeycodes(xDisplay, &scancodeMin, &scancodeMax);

        int width;
        KeySym* keysyms = XGetKeyboardMapping(xDisplay, scancodeMin, scancodeMax - scancodeMin + 1, &width);

        for(int scancode = scancodeMin; scancode <= scancodeMax; ++scancode) {
            if(xkbToPinc[scancode] < 0) {
                const size_t base = (scancode - scancodeMin) * width;
                xkbToPinc[scancode] = x11_translate_keysyms(&keysyms[base], width);
            }

            if(xkbToPinc[scancode] > 0) {
                pincToXkb[xkbToPinc[scancode]] = scancode;
            }
        }
        XFree(keysyms);
    }
}

pinc_key_code_enum x11_translate_keysyms(const KeySym* keysyms, int width) {
    if(width > 1) {
        switch(keysyms[1]) {
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

    switch (keysyms[0]) {
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
        case XK_t:              return pinc_key_code_t;
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
        // TODO: add international modifier keys to pinc
        //case XK_less:           return pinc_key_code_WORLD_1; // At least in some layouts...
        default:                break;
    }

    // No matching translation was found
    return pinc_key_code_unknown;
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

// Stole this giant array & associated function from GLFW. See xkb_unicode.c in GLFW's source code for more detail.
// (Honestly like 80% of Pincs X implementation is basically taken from GLFW)
static const struct codepair {
  unsigned short keysym;
  unsigned short ucs;
} keysymtab[] = {
  { 0x01a1, 0x0104 },
  { 0x01a2, 0x02d8 },
  { 0x01a3, 0x0141 },
  { 0x01a5, 0x013d },
  { 0x01a6, 0x015a },
  { 0x01a9, 0x0160 },
  { 0x01aa, 0x015e },
  { 0x01ab, 0x0164 },
  { 0x01ac, 0x0179 },
  { 0x01ae, 0x017d },
  { 0x01af, 0x017b },
  { 0x01b1, 0x0105 },
  { 0x01b2, 0x02db },
  { 0x01b3, 0x0142 },
  { 0x01b5, 0x013e },
  { 0x01b6, 0x015b },
  { 0x01b7, 0x02c7 },
  { 0x01b9, 0x0161 },
  { 0x01ba, 0x015f },
  { 0x01bb, 0x0165 },
  { 0x01bc, 0x017a },
  { 0x01bd, 0x02dd },
  { 0x01be, 0x017e },
  { 0x01bf, 0x017c },
  { 0x01c0, 0x0154 },
  { 0x01c3, 0x0102 },
  { 0x01c5, 0x0139 },
  { 0x01c6, 0x0106 },
  { 0x01c8, 0x010c },
  { 0x01ca, 0x0118 },
  { 0x01cc, 0x011a },
  { 0x01cf, 0x010e },
  { 0x01d0, 0x0110 },
  { 0x01d1, 0x0143 },
  { 0x01d2, 0x0147 },
  { 0x01d5, 0x0150 },
  { 0x01d8, 0x0158 },
  { 0x01d9, 0x016e },
  { 0x01db, 0x0170 },
  { 0x01de, 0x0162 },
  { 0x01e0, 0x0155 },
  { 0x01e3, 0x0103 },
  { 0x01e5, 0x013a },
  { 0x01e6, 0x0107 },
  { 0x01e8, 0x010d },
  { 0x01ea, 0x0119 },
  { 0x01ec, 0x011b },
  { 0x01ef, 0x010f },
  { 0x01f0, 0x0111 },
  { 0x01f1, 0x0144 },
  { 0x01f2, 0x0148 },
  { 0x01f5, 0x0151 },
  { 0x01f8, 0x0159 },
  { 0x01f9, 0x016f },
  { 0x01fb, 0x0171 },
  { 0x01fe, 0x0163 },
  { 0x01ff, 0x02d9 },
  { 0x02a1, 0x0126 },
  { 0x02a6, 0x0124 },
  { 0x02a9, 0x0130 },
  { 0x02ab, 0x011e },
  { 0x02ac, 0x0134 },
  { 0x02b1, 0x0127 },
  { 0x02b6, 0x0125 },
  { 0x02b9, 0x0131 },
  { 0x02bb, 0x011f },
  { 0x02bc, 0x0135 },
  { 0x02c5, 0x010a },
  { 0x02c6, 0x0108 },
  { 0x02d5, 0x0120 },
  { 0x02d8, 0x011c },
  { 0x02dd, 0x016c },
  { 0x02de, 0x015c },
  { 0x02e5, 0x010b },
  { 0x02e6, 0x0109 },
  { 0x02f5, 0x0121 },
  { 0x02f8, 0x011d },
  { 0x02fd, 0x016d },
  { 0x02fe, 0x015d },
  { 0x03a2, 0x0138 },
  { 0x03a3, 0x0156 },
  { 0x03a5, 0x0128 },
  { 0x03a6, 0x013b },
  { 0x03aa, 0x0112 },
  { 0x03ab, 0x0122 },
  { 0x03ac, 0x0166 },
  { 0x03b3, 0x0157 },
  { 0x03b5, 0x0129 },
  { 0x03b6, 0x013c },
  { 0x03ba, 0x0113 },
  { 0x03bb, 0x0123 },
  { 0x03bc, 0x0167 },
  { 0x03bd, 0x014a },
  { 0x03bf, 0x014b },
  { 0x03c0, 0x0100 },
  { 0x03c7, 0x012e },
  { 0x03cc, 0x0116 },
  { 0x03cf, 0x012a },
  { 0x03d1, 0x0145 },
  { 0x03d2, 0x014c },
  { 0x03d3, 0x0136 },
  { 0x03d9, 0x0172 },
  { 0x03dd, 0x0168 },
  { 0x03de, 0x016a },
  { 0x03e0, 0x0101 },
  { 0x03e7, 0x012f },
  { 0x03ec, 0x0117 },
  { 0x03ef, 0x012b },
  { 0x03f1, 0x0146 },
  { 0x03f2, 0x014d },
  { 0x03f3, 0x0137 },
  { 0x03f9, 0x0173 },
  { 0x03fd, 0x0169 },
  { 0x03fe, 0x016b },
  { 0x047e, 0x203e },
  { 0x04a1, 0x3002 },
  { 0x04a2, 0x300c },
  { 0x04a3, 0x300d },
  { 0x04a4, 0x3001 },
  { 0x04a5, 0x30fb },
  { 0x04a6, 0x30f2 },
  { 0x04a7, 0x30a1 },
  { 0x04a8, 0x30a3 },
  { 0x04a9, 0x30a5 },
  { 0x04aa, 0x30a7 },
  { 0x04ab, 0x30a9 },
  { 0x04ac, 0x30e3 },
  { 0x04ad, 0x30e5 },
  { 0x04ae, 0x30e7 },
  { 0x04af, 0x30c3 },
  { 0x04b0, 0x30fc },
  { 0x04b1, 0x30a2 },
  { 0x04b2, 0x30a4 },
  { 0x04b3, 0x30a6 },
  { 0x04b4, 0x30a8 },
  { 0x04b5, 0x30aa },
  { 0x04b6, 0x30ab },
  { 0x04b7, 0x30ad },
  { 0x04b8, 0x30af },
  { 0x04b9, 0x30b1 },
  { 0x04ba, 0x30b3 },
  { 0x04bb, 0x30b5 },
  { 0x04bc, 0x30b7 },
  { 0x04bd, 0x30b9 },
  { 0x04be, 0x30bb },
  { 0x04bf, 0x30bd },
  { 0x04c0, 0x30bf },
  { 0x04c1, 0x30c1 },
  { 0x04c2, 0x30c4 },
  { 0x04c3, 0x30c6 },
  { 0x04c4, 0x30c8 },
  { 0x04c5, 0x30ca },
  { 0x04c6, 0x30cb },
  { 0x04c7, 0x30cc },
  { 0x04c8, 0x30cd },
  { 0x04c9, 0x30ce },
  { 0x04ca, 0x30cf },
  { 0x04cb, 0x30d2 },
  { 0x04cc, 0x30d5 },
  { 0x04cd, 0x30d8 },
  { 0x04ce, 0x30db },
  { 0x04cf, 0x30de },
  { 0x04d0, 0x30df },
  { 0x04d1, 0x30e0 },
  { 0x04d2, 0x30e1 },
  { 0x04d3, 0x30e2 },
  { 0x04d4, 0x30e4 },
  { 0x04d5, 0x30e6 },
  { 0x04d6, 0x30e8 },
  { 0x04d7, 0x30e9 },
  { 0x04d8, 0x30ea },
  { 0x04d9, 0x30eb },
  { 0x04da, 0x30ec },
  { 0x04db, 0x30ed },
  { 0x04dc, 0x30ef },
  { 0x04dd, 0x30f3 },
  { 0x04de, 0x309b },
  { 0x04df, 0x309c },
  { 0x05ac, 0x060c },
  { 0x05bb, 0x061b },
  { 0x05bf, 0x061f },
  { 0x05c1, 0x0621 },
  { 0x05c2, 0x0622 },
  { 0x05c3, 0x0623 },
  { 0x05c4, 0x0624 },
  { 0x05c5, 0x0625 },
  { 0x05c6, 0x0626 },
  { 0x05c7, 0x0627 },
  { 0x05c8, 0x0628 },
  { 0x05c9, 0x0629 },
  { 0x05ca, 0x062a },
  { 0x05cb, 0x062b },
  { 0x05cc, 0x062c },
  { 0x05cd, 0x062d },
  { 0x05ce, 0x062e },
  { 0x05cf, 0x062f },
  { 0x05d0, 0x0630 },
  { 0x05d1, 0x0631 },
  { 0x05d2, 0x0632 },
  { 0x05d3, 0x0633 },
  { 0x05d4, 0x0634 },
  { 0x05d5, 0x0635 },
  { 0x05d6, 0x0636 },
  { 0x05d7, 0x0637 },
  { 0x05d8, 0x0638 },
  { 0x05d9, 0x0639 },
  { 0x05da, 0x063a },
  { 0x05e0, 0x0640 },
  { 0x05e1, 0x0641 },
  { 0x05e2, 0x0642 },
  { 0x05e3, 0x0643 },
  { 0x05e4, 0x0644 },
  { 0x05e5, 0x0645 },
  { 0x05e6, 0x0646 },
  { 0x05e7, 0x0647 },
  { 0x05e8, 0x0648 },
  { 0x05e9, 0x0649 },
  { 0x05ea, 0x064a },
  { 0x05eb, 0x064b },
  { 0x05ec, 0x064c },
  { 0x05ed, 0x064d },
  { 0x05ee, 0x064e },
  { 0x05ef, 0x064f },
  { 0x05f0, 0x0650 },
  { 0x05f1, 0x0651 },
  { 0x05f2, 0x0652 },
  { 0x06a1, 0x0452 },
  { 0x06a2, 0x0453 },
  { 0x06a3, 0x0451 },
  { 0x06a4, 0x0454 },
  { 0x06a5, 0x0455 },
  { 0x06a6, 0x0456 },
  { 0x06a7, 0x0457 },
  { 0x06a8, 0x0458 },
  { 0x06a9, 0x0459 },
  { 0x06aa, 0x045a },
  { 0x06ab, 0x045b },
  { 0x06ac, 0x045c },
  { 0x06ae, 0x045e },
  { 0x06af, 0x045f },
  { 0x06b0, 0x2116 },
  { 0x06b1, 0x0402 },
  { 0x06b2, 0x0403 },
  { 0x06b3, 0x0401 },
  { 0x06b4, 0x0404 },
  { 0x06b5, 0x0405 },
  { 0x06b6, 0x0406 },
  { 0x06b7, 0x0407 },
  { 0x06b8, 0x0408 },
  { 0x06b9, 0x0409 },
  { 0x06ba, 0x040a },
  { 0x06bb, 0x040b },
  { 0x06bc, 0x040c },
  { 0x06be, 0x040e },
  { 0x06bf, 0x040f },
  { 0x06c0, 0x044e },
  { 0x06c1, 0x0430 },
  { 0x06c2, 0x0431 },
  { 0x06c3, 0x0446 },
  { 0x06c4, 0x0434 },
  { 0x06c5, 0x0435 },
  { 0x06c6, 0x0444 },
  { 0x06c7, 0x0433 },
  { 0x06c8, 0x0445 },
  { 0x06c9, 0x0438 },
  { 0x06ca, 0x0439 },
  { 0x06cb, 0x043a },
  { 0x06cc, 0x043b },
  { 0x06cd, 0x043c },
  { 0x06ce, 0x043d },
  { 0x06cf, 0x043e },
  { 0x06d0, 0x043f },
  { 0x06d1, 0x044f },
  { 0x06d2, 0x0440 },
  { 0x06d3, 0x0441 },
  { 0x06d4, 0x0442 },
  { 0x06d5, 0x0443 },
  { 0x06d6, 0x0436 },
  { 0x06d7, 0x0432 },
  { 0x06d8, 0x044c },
  { 0x06d9, 0x044b },
  { 0x06da, 0x0437 },
  { 0x06db, 0x0448 },
  { 0x06dc, 0x044d },
  { 0x06dd, 0x0449 },
  { 0x06de, 0x0447 },
  { 0x06df, 0x044a },
  { 0x06e0, 0x042e },
  { 0x06e1, 0x0410 },
  { 0x06e2, 0x0411 },
  { 0x06e3, 0x0426 },
  { 0x06e4, 0x0414 },
  { 0x06e5, 0x0415 },
  { 0x06e6, 0x0424 },
  { 0x06e7, 0x0413 },
  { 0x06e8, 0x0425 },
  { 0x06e9, 0x0418 },
  { 0x06ea, 0x0419 },
  { 0x06eb, 0x041a },
  { 0x06ec, 0x041b },
  { 0x06ed, 0x041c },
  { 0x06ee, 0x041d },
  { 0x06ef, 0x041e },
  { 0x06f0, 0x041f },
  { 0x06f1, 0x042f },
  { 0x06f2, 0x0420 },
  { 0x06f3, 0x0421 },
  { 0x06f4, 0x0422 },
  { 0x06f5, 0x0423 },
  { 0x06f6, 0x0416 },
  { 0x06f7, 0x0412 },
  { 0x06f8, 0x042c },
  { 0x06f9, 0x042b },
  { 0x06fa, 0x0417 },
  { 0x06fb, 0x0428 },
  { 0x06fc, 0x042d },
  { 0x06fd, 0x0429 },
  { 0x06fe, 0x0427 },
  { 0x06ff, 0x042a },
  { 0x07a1, 0x0386 },
  { 0x07a2, 0x0388 },
  { 0x07a3, 0x0389 },
  { 0x07a4, 0x038a },
  { 0x07a5, 0x03aa },
  { 0x07a7, 0x038c },
  { 0x07a8, 0x038e },
  { 0x07a9, 0x03ab },
  { 0x07ab, 0x038f },
  { 0x07ae, 0x0385 },
  { 0x07af, 0x2015 },
  { 0x07b1, 0x03ac },
  { 0x07b2, 0x03ad },
  { 0x07b3, 0x03ae },
  { 0x07b4, 0x03af },
  { 0x07b5, 0x03ca },
  { 0x07b6, 0x0390 },
  { 0x07b7, 0x03cc },
  { 0x07b8, 0x03cd },
  { 0x07b9, 0x03cb },
  { 0x07ba, 0x03b0 },
  { 0x07bb, 0x03ce },
  { 0x07c1, 0x0391 },
  { 0x07c2, 0x0392 },
  { 0x07c3, 0x0393 },
  { 0x07c4, 0x0394 },
  { 0x07c5, 0x0395 },
  { 0x07c6, 0x0396 },
  { 0x07c7, 0x0397 },
  { 0x07c8, 0x0398 },
  { 0x07c9, 0x0399 },
  { 0x07ca, 0x039a },
  { 0x07cb, 0x039b },
  { 0x07cc, 0x039c },
  { 0x07cd, 0x039d },
  { 0x07ce, 0x039e },
  { 0x07cf, 0x039f },
  { 0x07d0, 0x03a0 },
  { 0x07d1, 0x03a1 },
  { 0x07d2, 0x03a3 },
  { 0x07d4, 0x03a4 },
  { 0x07d5, 0x03a5 },
  { 0x07d6, 0x03a6 },
  { 0x07d7, 0x03a7 },
  { 0x07d8, 0x03a8 },
  { 0x07d9, 0x03a9 },
  { 0x07e1, 0x03b1 },
  { 0x07e2, 0x03b2 },
  { 0x07e3, 0x03b3 },
  { 0x07e4, 0x03b4 },
  { 0x07e5, 0x03b5 },
  { 0x07e6, 0x03b6 },
  { 0x07e7, 0x03b7 },
  { 0x07e8, 0x03b8 },
  { 0x07e9, 0x03b9 },
  { 0x07ea, 0x03ba },
  { 0x07eb, 0x03bb },
  { 0x07ec, 0x03bc },
  { 0x07ed, 0x03bd },
  { 0x07ee, 0x03be },
  { 0x07ef, 0x03bf },
  { 0x07f0, 0x03c0 },
  { 0x07f1, 0x03c1 },
  { 0x07f2, 0x03c3 },
  { 0x07f3, 0x03c2 },
  { 0x07f4, 0x03c4 },
  { 0x07f5, 0x03c5 },
  { 0x07f6, 0x03c6 },
  { 0x07f7, 0x03c7 },
  { 0x07f8, 0x03c8 },
  { 0x07f9, 0x03c9 },
  { 0x08a1, 0x23b7 },
  { 0x08a2, 0x250c },
  { 0x08a3, 0x2500 },
  { 0x08a4, 0x2320 },
  { 0x08a5, 0x2321 },
  { 0x08a6, 0x2502 },
  { 0x08a7, 0x23a1 },
  { 0x08a8, 0x23a3 },
  { 0x08a9, 0x23a4 },
  { 0x08aa, 0x23a6 },
  { 0x08ab, 0x239b },
  { 0x08ac, 0x239d },
  { 0x08ad, 0x239e },
  { 0x08ae, 0x23a0 },
  { 0x08af, 0x23a8 },
  { 0x08b0, 0x23ac },
  { 0x08bc, 0x2264 },
  { 0x08bd, 0x2260 },
  { 0x08be, 0x2265 },
  { 0x08bf, 0x222b },
  { 0x08c0, 0x2234 },
  { 0x08c1, 0x221d },
  { 0x08c2, 0x221e },
  { 0x08c5, 0x2207 },
  { 0x08c8, 0x223c },
  { 0x08c9, 0x2243 },
  { 0x08cd, 0x21d4 },
  { 0x08ce, 0x21d2 },
  { 0x08cf, 0x2261 },
  { 0x08d6, 0x221a },
  { 0x08da, 0x2282 },
  { 0x08db, 0x2283 },
  { 0x08dc, 0x2229 },
  { 0x08dd, 0x222a },
  { 0x08de, 0x2227 },
  { 0x08df, 0x2228 },
  { 0x08ef, 0x2202 },
  { 0x08f6, 0x0192 },
  { 0x08fb, 0x2190 },
  { 0x08fc, 0x2191 },
  { 0x08fd, 0x2192 },
  { 0x08fe, 0x2193 },
  { 0x09e0, 0x25c6 },
  { 0x09e1, 0x2592 },
  { 0x09e2, 0x2409 },
  { 0x09e3, 0x240c },
  { 0x09e4, 0x240d },
  { 0x09e5, 0x240a },
  { 0x09e8, 0x2424 },
  { 0x09e9, 0x240b },
  { 0x09ea, 0x2518 },
  { 0x09eb, 0x2510 },
  { 0x09ec, 0x250c },
  { 0x09ed, 0x2514 },
  { 0x09ee, 0x253c },
  { 0x09ef, 0x23ba },
  { 0x09f0, 0x23bb },
  { 0x09f1, 0x2500 },
  { 0x09f2, 0x23bc },
  { 0x09f3, 0x23bd },
  { 0x09f4, 0x251c },
  { 0x09f5, 0x2524 },
  { 0x09f6, 0x2534 },
  { 0x09f7, 0x252c },
  { 0x09f8, 0x2502 },
  { 0x0aa1, 0x2003 },
  { 0x0aa2, 0x2002 },
  { 0x0aa3, 0x2004 },
  { 0x0aa4, 0x2005 },
  { 0x0aa5, 0x2007 },
  { 0x0aa6, 0x2008 },
  { 0x0aa7, 0x2009 },
  { 0x0aa8, 0x200a },
  { 0x0aa9, 0x2014 },
  { 0x0aaa, 0x2013 },
  { 0x0aae, 0x2026 },
  { 0x0aaf, 0x2025 },
  { 0x0ab0, 0x2153 },
  { 0x0ab1, 0x2154 },
  { 0x0ab2, 0x2155 },
  { 0x0ab3, 0x2156 },
  { 0x0ab4, 0x2157 },
  { 0x0ab5, 0x2158 },
  { 0x0ab6, 0x2159 },
  { 0x0ab7, 0x215a },
  { 0x0ab8, 0x2105 },
  { 0x0abb, 0x2012 },
  { 0x0abc, 0x2329 },
  { 0x0abe, 0x232a },
  { 0x0ac3, 0x215b },
  { 0x0ac4, 0x215c },
  { 0x0ac5, 0x215d },
  { 0x0ac6, 0x215e },
  { 0x0ac9, 0x2122 },
  { 0x0aca, 0x2613 },
  { 0x0acc, 0x25c1 },
  { 0x0acd, 0x25b7 },
  { 0x0ace, 0x25cb },
  { 0x0acf, 0x25af },
  { 0x0ad0, 0x2018 },
  { 0x0ad1, 0x2019 },
  { 0x0ad2, 0x201c },
  { 0x0ad3, 0x201d },
  { 0x0ad4, 0x211e },
  { 0x0ad6, 0x2032 },
  { 0x0ad7, 0x2033 },
  { 0x0ad9, 0x271d },
  { 0x0adb, 0x25ac },
  { 0x0adc, 0x25c0 },
  { 0x0add, 0x25b6 },
  { 0x0ade, 0x25cf },
  { 0x0adf, 0x25ae },
  { 0x0ae0, 0x25e6 },
  { 0x0ae1, 0x25ab },
  { 0x0ae2, 0x25ad },
  { 0x0ae3, 0x25b3 },
  { 0x0ae4, 0x25bd },
  { 0x0ae5, 0x2606 },
  { 0x0ae6, 0x2022 },
  { 0x0ae7, 0x25aa },
  { 0x0ae8, 0x25b2 },
  { 0x0ae9, 0x25bc },
  { 0x0aea, 0x261c },
  { 0x0aeb, 0x261e },
  { 0x0aec, 0x2663 },
  { 0x0aed, 0x2666 },
  { 0x0aee, 0x2665 },
  { 0x0af0, 0x2720 },
  { 0x0af1, 0x2020 },
  { 0x0af2, 0x2021 },
  { 0x0af3, 0x2713 },
  { 0x0af4, 0x2717 },
  { 0x0af5, 0x266f },
  { 0x0af6, 0x266d },
  { 0x0af7, 0x2642 },
  { 0x0af8, 0x2640 },
  { 0x0af9, 0x260e },
  { 0x0afa, 0x2315 },
  { 0x0afb, 0x2117 },
  { 0x0afc, 0x2038 },
  { 0x0afd, 0x201a },
  { 0x0afe, 0x201e },
  { 0x0ba3, 0x003c },
  { 0x0ba6, 0x003e },
  { 0x0ba8, 0x2228 },
  { 0x0ba9, 0x2227 },
  { 0x0bc0, 0x00af },
  { 0x0bc2, 0x22a5 },
  { 0x0bc3, 0x2229 },
  { 0x0bc4, 0x230a },
  { 0x0bc6, 0x005f },
  { 0x0bca, 0x2218 },
  { 0x0bcc, 0x2395 },
  { 0x0bce, 0x22a4 },
  { 0x0bcf, 0x25cb },
  { 0x0bd3, 0x2308 },
  { 0x0bd6, 0x222a },
  { 0x0bd8, 0x2283 },
  { 0x0bda, 0x2282 },
  { 0x0bdc, 0x22a2 },
  { 0x0bfc, 0x22a3 },
  { 0x0cdf, 0x2017 },
  { 0x0ce0, 0x05d0 },
  { 0x0ce1, 0x05d1 },
  { 0x0ce2, 0x05d2 },
  { 0x0ce3, 0x05d3 },
  { 0x0ce4, 0x05d4 },
  { 0x0ce5, 0x05d5 },
  { 0x0ce6, 0x05d6 },
  { 0x0ce7, 0x05d7 },
  { 0x0ce8, 0x05d8 },
  { 0x0ce9, 0x05d9 },
  { 0x0cea, 0x05da },
  { 0x0ceb, 0x05db },
  { 0x0cec, 0x05dc },
  { 0x0ced, 0x05dd },
  { 0x0cee, 0x05de },
  { 0x0cef, 0x05df },
  { 0x0cf0, 0x05e0 },
  { 0x0cf1, 0x05e1 },
  { 0x0cf2, 0x05e2 },
  { 0x0cf3, 0x05e3 },
  { 0x0cf4, 0x05e4 },
  { 0x0cf5, 0x05e5 },
  { 0x0cf6, 0x05e6 },
  { 0x0cf7, 0x05e7 },
  { 0x0cf8, 0x05e8 },
  { 0x0cf9, 0x05e9 },
  { 0x0cfa, 0x05ea },
  { 0x0da1, 0x0e01 },
  { 0x0da2, 0x0e02 },
  { 0x0da3, 0x0e03 },
  { 0x0da4, 0x0e04 },
  { 0x0da5, 0x0e05 },
  { 0x0da6, 0x0e06 },
  { 0x0da7, 0x0e07 },
  { 0x0da8, 0x0e08 },
  { 0x0da9, 0x0e09 },
  { 0x0daa, 0x0e0a },
  { 0x0dab, 0x0e0b },
  { 0x0dac, 0x0e0c },
  { 0x0dad, 0x0e0d },
  { 0x0dae, 0x0e0e },
  { 0x0daf, 0x0e0f },
  { 0x0db0, 0x0e10 },
  { 0x0db1, 0x0e11 },
  { 0x0db2, 0x0e12 },
  { 0x0db3, 0x0e13 },
  { 0x0db4, 0x0e14 },
  { 0x0db5, 0x0e15 },
  { 0x0db6, 0x0e16 },
  { 0x0db7, 0x0e17 },
  { 0x0db8, 0x0e18 },
  { 0x0db9, 0x0e19 },
  { 0x0dba, 0x0e1a },
  { 0x0dbb, 0x0e1b },
  { 0x0dbc, 0x0e1c },
  { 0x0dbd, 0x0e1d },
  { 0x0dbe, 0x0e1e },
  { 0x0dbf, 0x0e1f },
  { 0x0dc0, 0x0e20 },
  { 0x0dc1, 0x0e21 },
  { 0x0dc2, 0x0e22 },
  { 0x0dc3, 0x0e23 },
  { 0x0dc4, 0x0e24 },
  { 0x0dc5, 0x0e25 },
  { 0x0dc6, 0x0e26 },
  { 0x0dc7, 0x0e27 },
  { 0x0dc8, 0x0e28 },
  { 0x0dc9, 0x0e29 },
  { 0x0dca, 0x0e2a },
  { 0x0dcb, 0x0e2b },
  { 0x0dcc, 0x0e2c },
  { 0x0dcd, 0x0e2d },
  { 0x0dce, 0x0e2e },
  { 0x0dcf, 0x0e2f },
  { 0x0dd0, 0x0e30 },
  { 0x0dd1, 0x0e31 },
  { 0x0dd2, 0x0e32 },
  { 0x0dd3, 0x0e33 },
  { 0x0dd4, 0x0e34 },
  { 0x0dd5, 0x0e35 },
  { 0x0dd6, 0x0e36 },
  { 0x0dd7, 0x0e37 },
  { 0x0dd8, 0x0e38 },
  { 0x0dd9, 0x0e39 },
  { 0x0dda, 0x0e3a },
  { 0x0ddf, 0x0e3f },
  { 0x0de0, 0x0e40 },
  { 0x0de1, 0x0e41 },
  { 0x0de2, 0x0e42 },
  { 0x0de3, 0x0e43 },
  { 0x0de4, 0x0e44 },
  { 0x0de5, 0x0e45 },
  { 0x0de6, 0x0e46 },
  { 0x0de7, 0x0e47 },
  { 0x0de8, 0x0e48 },
  { 0x0de9, 0x0e49 },
  { 0x0dea, 0x0e4a },
  { 0x0deb, 0x0e4b },
  { 0x0dec, 0x0e4c },
  { 0x0ded, 0x0e4d },
  { 0x0df0, 0x0e50 },
  { 0x0df1, 0x0e51 },
  { 0x0df2, 0x0e52 },
  { 0x0df3, 0x0e53 },
  { 0x0df4, 0x0e54 },
  { 0x0df5, 0x0e55 },
  { 0x0df6, 0x0e56 },
  { 0x0df7, 0x0e57 },
  { 0x0df8, 0x0e58 },
  { 0x0df9, 0x0e59 },
  { 0x0ea1, 0x3131 },
  { 0x0ea2, 0x3132 },
  { 0x0ea3, 0x3133 },
  { 0x0ea4, 0x3134 },
  { 0x0ea5, 0x3135 },
  { 0x0ea6, 0x3136 },
  { 0x0ea7, 0x3137 },
  { 0x0ea8, 0x3138 },
  { 0x0ea9, 0x3139 },
  { 0x0eaa, 0x313a },
  { 0x0eab, 0x313b },
  { 0x0eac, 0x313c },
  { 0x0ead, 0x313d },
  { 0x0eae, 0x313e },
  { 0x0eaf, 0x313f },
  { 0x0eb0, 0x3140 },
  { 0x0eb1, 0x3141 },
  { 0x0eb2, 0x3142 },
  { 0x0eb3, 0x3143 },
  { 0x0eb4, 0x3144 },
  { 0x0eb5, 0x3145 },
  { 0x0eb6, 0x3146 },
  { 0x0eb7, 0x3147 },
  { 0x0eb8, 0x3148 },
  { 0x0eb9, 0x3149 },
  { 0x0eba, 0x314a },
  { 0x0ebb, 0x314b },
  { 0x0ebc, 0x314c },
  { 0x0ebd, 0x314d },
  { 0x0ebe, 0x314e },
  { 0x0ebf, 0x314f },
  { 0x0ec0, 0x3150 },
  { 0x0ec1, 0x3151 },
  { 0x0ec2, 0x3152 },
  { 0x0ec3, 0x3153 },
  { 0x0ec4, 0x3154 },
  { 0x0ec5, 0x3155 },
  { 0x0ec6, 0x3156 },
  { 0x0ec7, 0x3157 },
  { 0x0ec8, 0x3158 },
  { 0x0ec9, 0x3159 },
  { 0x0eca, 0x315a },
  { 0x0ecb, 0x315b },
  { 0x0ecc, 0x315c },
  { 0x0ecd, 0x315d },
  { 0x0ece, 0x315e },
  { 0x0ecf, 0x315f },
  { 0x0ed0, 0x3160 },
  { 0x0ed1, 0x3161 },
  { 0x0ed2, 0x3162 },
  { 0x0ed3, 0x3163 },
  { 0x0ed4, 0x11a8 },
  { 0x0ed5, 0x11a9 },
  { 0x0ed6, 0x11aa },
  { 0x0ed7, 0x11ab },
  { 0x0ed8, 0x11ac },
  { 0x0ed9, 0x11ad },
  { 0x0eda, 0x11ae },
  { 0x0edb, 0x11af },
  { 0x0edc, 0x11b0 },
  { 0x0edd, 0x11b1 },
  { 0x0ede, 0x11b2 },
  { 0x0edf, 0x11b3 },
  { 0x0ee0, 0x11b4 },
  { 0x0ee1, 0x11b5 },
  { 0x0ee2, 0x11b6 },
  { 0x0ee3, 0x11b7 },
  { 0x0ee4, 0x11b8 },
  { 0x0ee5, 0x11b9 },
  { 0x0ee6, 0x11ba },
  { 0x0ee7, 0x11bb },
  { 0x0ee8, 0x11bc },
  { 0x0ee9, 0x11bd },
  { 0x0eea, 0x11be },
  { 0x0eeb, 0x11bf },
  { 0x0eec, 0x11c0 },
  { 0x0eed, 0x11c1 },
  { 0x0eee, 0x11c2 },
  { 0x0eef, 0x316d },
  { 0x0ef0, 0x3171 },
  { 0x0ef1, 0x3178 },
  { 0x0ef2, 0x317f },
  { 0x0ef3, 0x3181 },
  { 0x0ef4, 0x3184 },
  { 0x0ef5, 0x3186 },
  { 0x0ef6, 0x318d },
  { 0x0ef7, 0x318e },
  { 0x0ef8, 0x11eb },
  { 0x0ef9, 0x11f0 },
  { 0x0efa, 0x11f9 },
  { 0x0eff, 0x20a9 },
  { 0x13a4, 0x20ac },
  { 0x13bc, 0x0152 },
  { 0x13bd, 0x0153 },
  { 0x13be, 0x0178 },
  { 0x20ac, 0x20ac },
  { 0xfe50,    '`' },
  { 0xfe51, 0x00b4 },
  { 0xfe52,    '^' },
  { 0xfe53,    '~' },
  { 0xfe54, 0x00af },
  { 0xfe55, 0x02d8 },
  { 0xfe56, 0x02d9 },
  { 0xfe57, 0x00a8 },
  { 0xfe58, 0x02da },
  { 0xfe59, 0x02dd },
  { 0xfe5a, 0x02c7 },
  { 0xfe5b, 0x00b8 },
  { 0xfe5c, 0x02db },
  { 0xfe5d, 0x037a },
  { 0xfe5e, 0x309b },
  { 0xfe5f, 0x309c },
  { 0xfe63,    '/' },
  { 0xfe64, 0x02bc },
  { 0xfe65, 0x02bd },
  { 0xfe66, 0x02f5 },
  { 0xfe67, 0x02f3 },
  { 0xfe68, 0x02cd },
  { 0xfe69, 0xa788 },
  { 0xfe6a, 0x02f7 },
  { 0xfe6e,    ',' },
  { 0xfe6f, 0x00a4 },
  { 0xfe80,    'a' }, // XK_dead_a
  { 0xfe81,    'A' }, // XK_dead_A
  { 0xfe82,    'e' }, // XK_dead_e
  { 0xfe83,    'E' }, // XK_dead_E
  { 0xfe84,    'i' }, // XK_dead_i
  { 0xfe85,    'I' }, // XK_dead_I
  { 0xfe86,    'o' }, // XK_dead_o
  { 0xfe87,    'O' }, // XK_dead_O
  { 0xfe88,    'u' }, // XK_dead_u
  { 0xfe89,    'U' }, // XK_dead_U
  { 0xfe8a, 0x0259 },
  { 0xfe8b, 0x018f },
  { 0xfe8c, 0x00b5 },
  { 0xfe90,    '_' },
  { 0xfe91, 0x02c8 },
  { 0xfe92, 0x02cc },
  { 0xff80 /*XKB_KEY_KP_Space*/,     ' ' },
  { 0xff95 /*XKB_KEY_KP_7*/, 0x0037 },
  { 0xff96 /*XKB_KEY_KP_4*/, 0x0034 },
  { 0xff97 /*XKB_KEY_KP_8*/, 0x0038 },
  { 0xff98 /*XKB_KEY_KP_6*/, 0x0036 },
  { 0xff99 /*XKB_KEY_KP_2*/, 0x0032 },
  { 0xff9a /*XKB_KEY_KP_9*/, 0x0039 },
  { 0xff9b /*XKB_KEY_KP_3*/, 0x0033 },
  { 0xff9c /*XKB_KEY_KP_1*/, 0x0031 },
  { 0xff9d /*XKB_KEY_KP_5*/, 0x0035 },
  { 0xff9e /*XKB_KEY_KP_0*/, 0x0030 },
  { 0xffaa /*XKB_KEY_KP_Multiply*/,  '*' },
  { 0xffab /*XKB_KEY_KP_Add*/,       '+' },
  { 0xffac /*XKB_KEY_KP_Separator*/, ',' },
  { 0xffad /*XKB_KEY_KP_Subtract*/,  '-' },
  { 0xffae /*XKB_KEY_KP_Decimal*/,   '.' },
  { 0xffaf /*XKB_KEY_KP_Divide*/,    '/' },
  { 0xffb0 /*XKB_KEY_KP_0*/, 0x0030 },
  { 0xffb1 /*XKB_KEY_KP_1*/, 0x0031 },
  { 0xffb2 /*XKB_KEY_KP_2*/, 0x0032 },
  { 0xffb3 /*XKB_KEY_KP_3*/, 0x0033 },
  { 0xffb4 /*XKB_KEY_KP_4*/, 0x0034 },
  { 0xffb5 /*XKB_KEY_KP_5*/, 0x0035 },
  { 0xffb6 /*XKB_KEY_KP_6*/, 0x0036 },
  { 0xffb7 /*XKB_KEY_KP_7*/, 0x0037 },
  { 0xffb8 /*XKB_KEY_KP_8*/, 0x0038 },
  { 0xffb9 /*XKB_KEY_KP_9*/, 0x0039 },
  { 0xffbd /*XKB_KEY_KP_Equal*/,     '=' }
};

uint32_t x11_sym_to_unicode(KeySym keysym) {
    int min = 0;
    int max = sizeof(keysymtab) / sizeof(struct codepair) - 1;
    int mid;

    // First check for Latin-1 characters (1:1 mapping)
    if ((keysym >= 0x0020 && keysym <= 0x007e) ||
        (keysym >= 0x00a0 && keysym <= 0x00ff))
    {
        return keysym;
    }

    // Also check for directly encoded 24-bit UCS characters
    if ((keysym & 0xff000000) == 0x01000000)
        return keysym & 0x00ffffff;

    // Binary search in table
    while (max >= min)
    {
        mid = (min + max) / 2;
        if (keysymtab[mid].keysym < keysym)
            min = mid + 1;
        else if (keysymtab[mid].keysym > keysym)
            max = mid - 1;
        else
            return keysymtab[mid].ucs;
    }

    // No matching Unicode value found
    return 0xffffffffu;
}

