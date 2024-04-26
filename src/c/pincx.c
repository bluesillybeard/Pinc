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
#include "XlibLoad.h"
#include <GL/glx.h>
// same as Xlib, we load glX at runtime.
#include "glXLoad.h"

// This file does not interact with OpenGL itself - only Xlib and the GLX extension.
// This is also the ONLY file that calls any Xlib or glX functions, because of the loader headers.
#define PINCX_PRIVATE
#include "pincx.h"

// static variables
void* libX11;
void* libGL;

Display* xDisplay;

GLXContext glxContext;

XVisualInfo* xVisual;

// Things that are public
bool x11_init(void) {
    x11_load_libraries();
    // if XLib wasn't loaded, it's not going to work
    if(XOpenDisplay == NULL) {
        // TODO: replace printfs with a proper logging / error reporting system
        printf("Failed to load libX11.so\n");
        return false;
    }
    // if glX wasn't loaded, it's not going to work
    // TODO: this is not true for non-OpenGl rendering backends
    if(glXChooseVisual == NULL) {
        printf("Failed to load glX\n");
        return false;
    }
    xDisplay = XOpenDisplay(NULL);
    if(xDisplay == NULL){
        printf("Display is null\n");
        return false;
    }
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
    return window;
}

bool x11_window_complete(x11_window* window) {
    XMapWindow(xDisplay, window->xWindow);
    // This is so the window shows up immediately upon completing it.
    XFlush(xDisplay);
}

// Pops the next event off of the queue
// Important notes:
// - the cursor move event does not have deltas or the screen coordinates set - only pixel coords
pinc_event_union_t x11_pop_event() {
    pinc_event_union_t event;
    if(XPending(xDisplay) == 0){
        event.type = pinc_event_none;
        return event;
    }
    XEvent xev;
    XNextEvent(xDisplay, &xev);
    switch(xev.type) {
        case KeyPress:
            // TODO
            break;
        case KeyRelease:
            // TODO
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
            // TODO: is this right?
            if(xev.xcrossing.mode == NotifyNormal) {
                event.type = pinc_event_window_cursor_enter;
                event.data.window_cursor_enter.window = x11_get_window_handle(xev.xcrossing.window);
            }
            break;
        case LeaveNotify:
            // TODO: is this right?
            if(xev.xcrossing.mode == NotifyNormal) {
                event.type = pinc_event_window_cursor_exit;
                event.data.window_cursor_exit.window = x11_get_window_handle(xev.xcrossing.window);
            }
            break;
        default:
            // TODO:
            event.type = pinc_event_none;
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
}

void* x11_load_Xlib_symbol(const char* name) {
    return dlsym(libX11, name);
}

void* x11_load_glX_symbol(const char* name) {
    // The only function that libGL exposes is glXGetProcAddressARB
    // Every other function needs to be retrieved using said function
    return glXGetProcAddressARB(name);
}

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

