// All event functions are exported here.
// The actual event data is stored in pinc.zig because... reasons.

const pinc = @import("pinc.zig");
const c = @import("c.zig");

pub export fn pinc_event_poll() void {
    // This function calls pinci_send_event, where the Zig portion can then load the event into the buffer
    pinc.native.collectEvents();
}

pub export fn pinc_event_advance() void {
    // I think this stupidity makes the need to refactor event management really obvious
    _ = pinc.getEvent(true);
}
pub export fn pinc_event_wait(timeoutSeconds: f32) void {
    pinc.native.waitForEvent(timeoutSeconds);
    pinc_event_poll();
}
pub export fn pinc_event_type() c.pinc_event_type_enum {
    return pinc.getEvent(false).type;
}
pub export fn pinc_event_window_close_data() c.pinc_event_window_close_t {
    return pinc.getEvent(false).data.window_close;
}
pub export fn pinc_event_window_resize_data() c.pinc_event_window_resize_t {
    return pinc.getEvent(false).data.window_resize;
}
pub export fn pinc_event_window_focus_data() c.pinc_event_window_focus_t {
    return pinc.getEvent(false).data.window_focus;
}
pub export fn pinc_event_window_unfocus_data() c.pinc_event_window_unfocus_t {
    return pinc.getEvent(false).data.window_unfocus;
}
pub export fn pinc_event_window_damaged_data() c.pinc_event_window_damaged_t {
    return pinc.getEvent(false).data.window_damaged;
}
pub export fn pinc_event_window_key_down_data() c.pinc_event_window_key_down_t {
    return pinc.getEvent(false).data.window_key_down;
}
pub export fn pinc_event_window_key_up_data() c.pinc_event_window_key_up_t {
    return pinc.getEvent(false).data.window_key_up;
}
pub export fn pinc_event_window_key_repeat_data() c.pinc_event_window_key_repeat_t {
    return pinc.getEvent(false).data.window_key_repeat;
}
pub export fn pinc_event_window_text_data() c.pinc_event_window_text_t {
    return pinc.getEvent(false).data.window_text;
}
pub export fn pinc_event_window_cursor_move_data() c.pinc_event_window_cursor_move_t {
    return pinc.getEvent(false).data.window_cursor_move;
}
pub export fn pinc_event_window_cursor_enter_data() c.pinc_event_window_cursor_enter_t {
    return pinc.getEvent(false).data.window_cursor_enter;
}
pub export fn pinc_event_window_cursor_exit_data() c.pinc_event_window_cursor_exit_t {
    return pinc.getEvent(false).data.window_cursor_exit;
}
pub export fn pinc_event_window_cursor_button_down_data() c.pinc_event_window_cursor_button_down_t {
    return pinc.getEvent(false).data.window_cursor_button_down;
}
pub export fn pinc_event_window_cursor_button_up_data() c.pinc_event_window_cursor_button_up_t {
    return pinc.getEvent(false).data.window_cursor_button_up;
}
pub export fn pinc_event_window_scroll_data() c.pinc_event_window_scroll_t {
    return pinc.getEvent(false).data.window_scroll;
}