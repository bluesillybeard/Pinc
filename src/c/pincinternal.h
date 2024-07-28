#include <stddef.h>
#include <stdbool.h>
#include <pinc.h>
#include <stdint.h>

// Internal functions and types. These are implemented in Zig and used by C.

// Event union - this isn't in the main header because
// the main header is designed around the limitations of other languages
// TODO: determine the plausibility of incorperating this and related functions to the main header
typedef struct {
    // event type - this is the discriminator of the discriminated union.
    pinc_event_type_enum type;
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

bool pinci_make_error(pinc_error_enum er, const char* err);

char* pinci_alloc_string(size_t length);

char* pinci_dupe_string(const char* str);

void pinci_free_string(char* string);

void pinci_send_event(pinc_event_union_t event);