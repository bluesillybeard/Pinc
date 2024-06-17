#pragma once
#include <stddef.h>
#include <stdbool.h>
#include <stdint.h>
#include <pinc.h>
// Pincx - Xlib is a pain to work with in Zig, so the parts of pinc that call X functions are written in C.
// This header provides Xlib functionality that is used in Zig.

// Some X types are re-implemented to avoid publicly including xlib.h in this header.

// Define this macro if this header is included in the same file as an X header
#ifndef PINC_X_INCLUDED
typedef unsigned long XID;
typedef XID Window;
typedef unsigned long Time;
// an input context is a pointer to an opaque
typedef struct _XIC *XIC;
#endif

// Functions implemented in pinx.c
bool x11_init(pinc_graphics_api_enum);

void x11_deinit(void);

typedef struct {
    // Xlib window. A window in X11 is a 32 bit unsigned int.
    Window xWindow;
    // We have to keep track of the X and Y positions since Xlib doesn't give the cursor delta (which makes sense I guess)
    // there might be strange edge cases where the pos is different for each window
    // so that position is stored here. It is only used within Zig.
    int32_t lastCursorX;
    int32_t lastCursorY;
    int32_t cursorX;
    int32_t cursorY;
    // Whether framebuffer transparency is enabled on this window
    bool transparency;
    // Xlib has a tendency to send duplicate key press events (SUPER annoying)
    // So we have to keep track of what time each key was last pressed
    // so the duplicates can be removed.
    Time keyPressTime[256];
    // The memory of this string is owned by Pinc
    char* title;
    // Width and height of the window in pixels
    uint32_t width;
    uint32_t height;

    XIC inputContext;
} x11_window;

x11_window x11_window_incomplete_create(const char* title);

bool x11_window_complete(x11_window* window);

void x11_window_destroy(pinc_window_incomplete_handle_t window);

// Unlike the "public" pinc API functions, these don't have the same
// deduplication and order guarantees.
// they are reported directly in the order the come in from Xlib.

// Polls events by calling pinci_send_event
void x11_poll_events(void);

void x11_wait_events(float timeout);

// This is public since it's used in pinc_graphics_opengl_get_proc
void* x11_load_glX_symbol(void* context, const char* name);

void x11_make_context_current(pinc_window_handle_t window);

void x11_present_framebuffer(pinc_window_handle_t window, bool vsync);

void x11_set_window_size(pinc_window_handle_t window, uint16_t width, uint16_t height);

// Functions implemented somewhere in Zig

// This returns the pinc window handle of a an X window given the window's XID.
pinc_window_incomplete_handle_t x11_get_window_handle(uint32_t id);

// This does the opposite of the above function. The returned pointer is temporary.
x11_window* x11_get_x_window(pinc_window_incomplete_handle_t window);

