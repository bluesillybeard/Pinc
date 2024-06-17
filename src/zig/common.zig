// Common for all platforms.
// The individual platform file imports this file.

const c = @import("c.zig");

pub fn Common(NativeWindow: type) type {
    return struct {
        pub const PincWindow = struct {
            native: NativeWindow,
            // per-window event buffers
            eventWindowResize: ?c.pinc_event_window_resize_t = null,
            eventWindowFocus: ?c.pinc_event_window_focus_t = null,
            eventWindowUnfocus: ?c.pinc_event_window_unfocus_t = null,
            eventWindowDamaged: ?c.pinc_event_window_damaged_t = null,
            eventWindowCursorMove: ?c.pinc_event_window_cursor_move_t = null,
            eventWindowScroll: ?c.pinc_event_window_scroll_t = null,
            eventWindowClose: ?c.pinc_event_window_close_t = null,
        };
    };
}
