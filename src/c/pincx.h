#pragma once
#include <stddef.h>
#include <stdbool.h>
#include <stdint.h>
#include <pinc.h>
// Pincx - Xlib is a pain to work with in Zig, so the parts of pinc that call X functions are written in C.
// This header provides Xlib functionality that is used in Zig.

// Functions implemented in pinx.c
bool x11_init(void);

void x11_deinit(void);

typedef struct {
    // Xlib window. A window in X11 is a 32 bit unsigned int.
    uint32_t xWindow;
    // We have to keep track of the X and Y positions since Xlib doesn't give the cursor delta (which makes sense I guess)
    // there might be strange edge cases where the pos is different for each window
    // so that position is stored here. It is only used within Zig.
    int32_t lastCursorX;
    int32_t lastCursorY;
    int32_t cursorX;
    int32_t cursorY;
} x11_window;

x11_window x11_window_incomplete_create(const char* title);

bool x11_window_complete(x11_window* window);

// Unlike the "public" pinc API functions, these don't have the same
// deduplication and order guarantees.
// they are reported directly in the order the come in from Xlib.

// Event union - this isn't in the main header because
// the main header is designed around the limitations of other languages
// TODO: determine the plausibility of incorperating this and related functions to the main header
typedef struct {
    // event type - this is the discriminator of the discriminated union.
    pinc_event_type_t type;
    union {
        pinc_event_window_resize_t window_resize;
        pinc_event_window_focus_t window_focus;
        pinc_event_window_unfocus_t window_unfocus;
        pinc_event_window_damaged_t window_damaged;
        pinc_event_window_key_down_t window_key_down;
        pinc_event_window_key_up_t window_key_up;
        pinc_event_window_key_repeat_t window_key_repeat;
        pinc_event_window_text_t window_text;
        pinc_event_window_cursor_move_t window_cursor_move;
        pinc_event_window_cursor_enter_t window_cursor_enter;
        pinc_event_window_cursor_exit_t window_cursor_exit;
        pinc_event_window_cursor_button_down_t window_cursor_button_down;
        pinc_event_window_cursor_button_up_t window_cursor_button_up;
        pinc_event_window_scroll_t window_scroll;
        pinc_event_window_close_t window_close;
    } data; // This union has to be named because Zig doesn't nicely support compounding structs and unions as is common in C.
} pinc_event_union_t;
// Pops the next event off of the queue
pinc_event_union_t x11_pop_event();

void x11_wait_events(float timeout);

#ifdef PINCX_PRIVATE

// Unfortunately some private declarations rely on Xlib.
// Thankfully, C is nice so the include can be in the private section of the header.
#include <X11/Xlib.h>

bool x11_load_libraries(void);

void* x11_load_library(const char* name);

void* x11_load_Xlib_symbol(const char* name);

void* x11_load_glX_symbol(const char* name);

pinc_key_code_t x11_get_key_code(const KeySym* keysyms, int width);

pinc_key_code_t x11_translate_key(int code);

pinc_key_modifiers_t x11_translate_modifiers(unsigned int xState);

void x11_create_key_tables(void);

#endif

// Functions implemented somewhere in Zig

// This returns the pinc window handle of a an X window given the window's XID.
pinc_window_incomplete_handle_t x11_get_window_handle(uint32_t id);
