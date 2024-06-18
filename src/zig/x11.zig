// Pinc's X implementation. Well, most of the actual implementation is in pincx.c, this is just the Zig part.

const c = @import("c.zig");
const std = @import("std");
const pinc = @import("pinc.zig");

// Some functions used by pincx.c

export fn x11_get_window_handle(xid: u32) c.pinc_window_incomplete_handle_t {
    // xid is the Xlib ID of the window
    for (pinc.windows.items, 0..) |windowOrNone, i| {
        if (windowOrNone) |window| {
            if (window.native.xWindow == xid) return @intCast(i + 1);
        }
    }
    // No corresponding window was found, return 0.
    // Error is not set here since C will do that instead
    return 0;
}

export fn x11_get_x_window(window: c.pinc_window_incomplete_handle_t) callconv(.C) ?*c.x11_window {
    // TODO: on the C side, check for null
    if (window == 0) return null;
    if (window - 1 >= pinc.windows.items.len) return null;
    if (pinc.windows.items[window - 1] == null) return null;
    return &pinc.windows.items[window - 1].?.native;
}

// implementation of the public API

pub export fn pinc_init(window_api: c.pinc_window_api_enum, graphics_api: c.pinc_graphics_api_enum) bool {
    _ = window_api;
    return pinc.init(graphics_api, c.x11_init);
}

pub export fn pinc_destroy() void {
    c.x11_deinit();
}

pub export fn pinc_error_get() c.pinc_error_enum {
    return pinc.latestError;
}

pub export fn pinc_error_string() [*:0]const u8 {
    return pinc.latestErrorString;
}

pub export fn pinc_get_window_api() c.pinc_window_api_enum {
    return c.pinc_window_api_x;
}
pub export fn pinc_window_incomplete_create(title: [*:0]u8) c.pinc_window_incomplete_handle_t {
    const xWindow = c.x11_window_incomplete_create(title);
    const windowObj = pinc.Window{ .native = xWindow };
    // TODO: find an empty spot
    pinc.windows.append(windowObj) catch {
        _ = c.pinci_make_error(c.pinc_error_allocation, "Failed to create window: allocation failed");
        return 0;
    };
    // This is here because LLDB is freaking stupid and can't find any static Zig variables
    const wins = &pinc.windows;
    return @intCast(wins.items.len);
}
pub export fn pinc_window_set_size(window: c.pinc_window_incomplete_handle_t, width: u16, height: u16) bool {
    // If someone can get a window more than 32k pixels in size and still be practical, I'll be quite impressed
    // In fact, after 32767 or so, Mutter or X.org (not sure which one causes it) breaks down and stops rendering the window.
    if ((width > 32767) or (height > 32767) or (width == 0) or (height == 0)) {
        _ = c.pinci_make_error(c.pinc_error_some, "Could not set window size: Width or Height out of range");
        return false;
    } else {
        c.x11_set_window_size(window, width, height);
        return true;
    }
}
pub export fn pinc_window_get_width(window: c.pinc_window_incomplete_handle_t) u16 {
    if (window == 0) {
        _ = c.pinci_make_error(c.pinc_error_null_handle, "pinc_window_get_width was given a null window");
        return 0;
    }
    const xWindowOrNone = x11_get_x_window(window);
    if (xWindowOrNone) |xWindow| {
        return @intCast(xWindow.width);
    } else {
        _ =c.pinci_make_error(c.pinc_error_null_handle, "pinc_window_get_width was given an invalid window");
        return 0;
    }
}
pub export fn pinc_window_get_height(window: c.pinc_window_incomplete_handle_t) u16 {
    if (window == 0) {
        _ =c.pinci_make_error(c.pinc_error_null_handle, "pinc_window_get_height was given a null window");
        return 0;
    }
    const xWindowOrNone = x11_get_x_window(window);
    if (xWindowOrNone) |xWindow| {
        return @intCast(xWindow.height);
    } else {
        _ =c.pinci_make_error(c.pinc_error_null_handle, "pinc_window_get_height was given an invalid window");
        return 0;
    }
}
// TODO - these functions are not implemented. They are commented out entirely so attempts to use them are met with link errors.
// pub export fn pinc_window_get_scale(window: c.pinc_window_incomplete_handle_t) f32 {}
// pub export fn pinc_window_get_top_border(window: c.pinc_window_incomplete_handle_t) f32 {}
// pub export fn pinc_window_get_left_border(window: c.pinc_window_incomplete_handle_t) f32 {}
// pub export fn pinc_window_get_right_border(window: c.pinc_window_incomplete_handle_t) f32 {}
// pub export fn pinc_window_get_bottom_border(window: c.pinc_window_incomplete_handle_t) f32 {}
// pub export fn pinc_window_get_zoom(window: c.pinc_window_incomplete_handle_t) f32 {}
// pub export fn pinc_window_set_icon(window: c.pinc_window_incomplete_handle_t, data: [*]u8, size: u32) void {}
// pub export fn pinc_window_set_minimized(window: c.pinc_window_incomplete_handle_t, minimized: bool) void {}
// pub export fn pinc_window_get_minimized(window: c.pinc_window_incomplete_handle_t) bool {}
// pub export fn pinc_window_set_resizable(window: c.pinc_window_incomplete_handle_t, resizable: bool) void {}
// pub export fn pinc_window_get_resizable(window: c.pinc_window_incomplete_handle_t) bool {}
// pub export fn pinc_window_set_maximized(window: c.pinc_window_incomplete_handle_t, maximized: bool) void {}
// pub export fn pinc_window_get_maximized(window: c.pinc_window_incomplete_handle_t) bool {}
// pub export fn pinc_window_set_fullscreen(window: c.pinc_window_incomplete_handle_t, fullscreen: bool, resize: bool) void {}
// pub export fn pinc_window_get_fullscreen(window: c.pinc_window_incomplete_handle_t) bool {}
// pub export fn pinc_window_set_visible(window: c.pinc_window_incomplete_handle_t, visible: bool) void {}
// pub export fn pinc_window_get_visible(window: c.pinc_window_incomplete_handle_t) bool {}
// pub export fn pinc_window_set_transparency(window: c.pinc_window_incomplete_handle_t, blend: bool) void {}
// pub export fn pinc_window_get_transparency(window: c.pinc_window_incomplete_handle_t) bool {}
// pub export fn pinc_window_set_red_bits(window: c.pinc_window_incomplete_handle_t, red_bits: u16) bool {}
// pub export fn pinc_window_get_red_bits(window: c.pinc_window_incomplete_handle_t) u16 {}
// pub export fn pinc_window_set_green_bits(window: c.pinc_window_incomplete_handle_t, green_bits: u16) bool {}
// pub export fn pinc_window_get_green_bits(window: c.pinc_window_incomplete_handle_t) u16 {}
// pub export fn pinc_window_set_blue_bits(window: c.pinc_window_incomplete_handle_t, blue_bits: u16) bool {}
// pub export fn pinc_window_get_blue_bits(window: c.pinc_window_incomplete_handle_t) u16 {}
// pub export fn pinc_window_set_alpha_bits(window: c.pinc_window_incomplete_handle_t, alpha_bits: u16) bool {}
// pub export fn pinc_window_get_alpha_bits(window: c.pinc_window_incomplete_handle_t) u16 {}
// pub export fn pinc_window_set_depth_bits(window: c.pinc_window_incomplete_handle_t, depth_bits: u16) bool {}
// pub export fn pinc_window_get_depth_bits(window: c.pinc_window_incomplete_handle_t) u16 {}
// pub export fn pinc_window_set_stencil_bits(window: c.pinc_window_incomplete_handle_t, depth_bits: u16) bool {}
// pub export fn pinc_window_get_stencil_bits(window: c.pinc_window_incomplete_handle_t) u16 {}
pub export fn pinc_window_destroy(window: c.pinc_window_incomplete_handle_t) void {
    c.x11_window_destroy(window);
}
pub export fn pinc_window_complete(incomplete: c.pinc_window_incomplete_handle_t) c.pinc_window_handle_t {
    if (incomplete == 0) {
        _ = c.pinci_make_error(c.pinc_error_null_handle, "pinc_window_complete was given a null handle");
        return 0;
    }
    // Get a pointer to the internal window handle.
    // The list does not change within this function call so the memory will stay valid
    // the internal function does not keep a pointer to the window.
    const xWindow: *c.x11_window = &pinc.windows.items[incomplete - 1].?.native;
    if (!c.x11_window_complete(xWindow)) {
        // completing the window failed, return a null handle.
        // TODO: make error enum more specific
        _ = c.pinci_make_error(c.pinc_error_some, "Failed to complete X11 window");
        return 0;
    }
    return incomplete;
}
// pub export fn pinc_window_get_focused(window: c.pinc_window_handle_t) bool {}
// pub export fn pinc_window_request_attention(window: c.pinc_window_handle_t) void {}
// pub export fn pinc_window_close(window: c.pinc_window_handle_t) void {}
pub export fn pinc_poll_events() void {
    for (pinc.windows.items) |*window| {
        // TODO: error
        if(window.* == null) return;
        // Some things are backend specific
        const xWindow = &window.*.?.native;
        xWindow.lastCursorX = xWindow.cursorX;
        xWindow.lastCursorY = xWindow.cursorY;
    }
    // This function calls pinci_send_event, where the Zig portion can then load the event into the buffer
    c.x11_poll_events();
}

pub export fn pinc_advance_event() void {
    // I think this stupidity makes the need to refactor event management really obvious
    _ = pinc.getEvent(true);
}
pub export fn pinc_wait_events(timeout: f32) void {
    c.x11_wait_events(timeout);
    pinc_poll_events();
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
pub export fn pinc_key_name(code: c.pinc_key_code_enum) [*:0]const u8 {
    switch (code) {
        c.pinc_key_code_unknown => return "unknown",
        c.pinc_key_code_space => return "space",
        c.pinc_key_code_apostrophe => return "apostrophe",
        c.pinc_key_code_comma => return "comma",
        c.pinc_key_code_dash => return "dash",
        c.pinc_key_code_dot => return "dot",
        c.pinc_key_code_slash => return "slash",
        c.pinc_key_code_0 => return "0",
        c.pinc_key_code_1 => return "1",
        c.pinc_key_code_2 => return "2",
        c.pinc_key_code_3 => return "3",
        c.pinc_key_code_4 => return "4",
        c.pinc_key_code_5 => return "5",
        c.pinc_key_code_6 => return "6",
        c.pinc_key_code_7 => return "7",
        c.pinc_key_code_8 => return "8",
        c.pinc_key_code_9 => return "9",
        c.pinc_key_code_semicolon => return "semicolon",
        c.pinc_key_code_equals => return "equals",
        c.pinc_key_code_a => return "a",
        c.pinc_key_code_b => return "b",
        c.pinc_key_code_c => return "c",
        c.pinc_key_code_d => return "d",
        c.pinc_key_code_e => return "e",
        c.pinc_key_code_f => return "f",
        c.pinc_key_code_g => return "g",
        c.pinc_key_code_h => return "h",
        c.pinc_key_code_i => return "i",
        c.pinc_key_code_j => return "j",
        c.pinc_key_code_k => return "k",
        c.pinc_key_code_l => return "l",
        c.pinc_key_code_m => return "m",
        c.pinc_key_code_n => return "n",
        c.pinc_key_code_o => return "o",
        c.pinc_key_code_p => return "p",
        c.pinc_key_code_q => return "q",
        c.pinc_key_code_r => return "r",
        c.pinc_key_code_s => return "s",
        c.pinc_key_code_t => return "T",
        c.pinc_key_code_u => return "u",
        c.pinc_key_code_v => return "v",
        c.pinc_key_code_w => return "w",
        c.pinc_key_code_x => return "x",
        c.pinc_key_code_y => return "y",
        c.pinc_key_code_z => return "z",
        c.pinc_key_code_left_bracket => return "left_bracket",
        c.pinc_key_code_backslash => return "backslash",
        c.pinc_key_code_right_bracket => return "right_bracket",
        c.pinc_key_code_backtick,
        => return "backtick",
        c.pinc_key_code_escape => return "escape",
        c.pinc_key_code_enter => return "enter",
        c.pinc_key_code_tab => return "tab",
        c.pinc_key_code_backspace => return "backspace",
        c.pinc_key_code_insert => return "insert",
        c.pinc_key_code_delete => return "delete",
        c.pinc_key_code_right => return "right",
        c.pinc_key_code_left => return "left",
        c.pinc_key_code_down => return "down",
        c.pinc_key_code_up => return "up",
        c.pinc_key_code_page_up => return "page_up",
        c.pinc_key_code_page_down => return "page_down",
        c.pinc_key_code_home => return "home",
        c.pinc_key_code_end => return "end",
        c.pinc_key_code_caps_lock => return "caps_lock",
        c.pinc_key_code_scroll_lock => return "scroll_lock",
        c.pinc_key_code_num_lock => return "num_lock",
        c.pinc_key_code_print_screen => return "print_screen",
        c.pinc_key_code_pause => return "pause",
        c.pinc_key_code_f1 => return "f1",
        c.pinc_key_code_f2 => return "f2",
        c.pinc_key_code_f3 => return "f3",
        c.pinc_key_code_f4 => return "f4",
        c.pinc_key_code_f5 => return "f5",
        c.pinc_key_code_f6 => return "f6",
        c.pinc_key_code_f7 => return "f7",
        c.pinc_key_code_f8 => return "f8",
        c.pinc_key_code_f9 => return "f9",
        c.pinc_key_code_f10 => return "f10",
        c.pinc_key_code_f11 => return "f11",
        c.pinc_key_code_f12 => return "f12",
        c.pinc_key_code_f13 => return "f13",
        c.pinc_key_code_f14 => return "f14",
        c.pinc_key_code_f15 => return "f15",
        c.pinc_key_code_f16 => return "f16",
        c.pinc_key_code_f17 => return "f17",
        c.pinc_key_code_f18 => return "f18",
        c.pinc_key_code_f19 => return "f19",
        c.pinc_key_code_f20 => return "f20",
        c.pinc_key_code_f21 => return "f21",
        c.pinc_key_code_f22 => return "f22",
        c.pinc_key_code_f23 => return "f23",
        c.pinc_key_code_f24 => return "f24",
        c.pinc_key_code_f25 => return "f25",
        c.pinc_key_code_f26 => return "f26",
        c.pinc_key_code_f27 => return "f27",
        c.pinc_key_code_f28 => return "f28",
        c.pinc_key_code_f29 => return "f29",
        c.pinc_key_code_f30 => return "f30",
        c.pinc_key_code_numpad_0 => return "numpad_0",
        c.pinc_key_code_numpad_1 => return "numpad_1",
        c.pinc_key_code_numpad_2 => return "numpad_2",
        c.pinc_key_code_numpad_3 => return "numpad_3",
        c.pinc_key_code_numpad_4 => return "numpad_4",
        c.pinc_key_code_numpad_5 => return "numpad_5",
        c.pinc_key_code_numpad_6 => return "numpad_6",
        c.pinc_key_code_numpad_7 => return "numpad_7",
        c.pinc_key_code_numpad_8 => return "numpad_8",
        c.pinc_key_code_numpad_9 => return "numpad_9",
        c.pinc_key_code_numpad_dot => return "numpad_dot",
        c.pinc_key_code_numpad_slash => return "numpad_slash",
        c.pinc_key_code_numpad_asterisk => return "numpad_asterisk",
        c.pinc_key_code_numpad_dash => return "numpad_dash",
        c.pinc_key_code_numpad_plus => return "numpad_plus",
        c.pinc_key_code_numpad_enter => return "numpad_enter",
        c.pinc_key_code_numpad_equal => return "numpad_equal",
        c.pinc_key_code_left_shift => return "left_shift",
        c.pinc_key_code_left_control => return "left_control",
        c.pinc_key_code_left_alt => return "left_alt",
        c.pinc_key_code_left_super => return "left_super",
        c.pinc_key_code_right_shift => return "right_shift",
        c.pinc_key_code_right_control => return "right_control",
        c.pinc_key_code_right_alt => return "right_alt",
        c.pinc_key_code_right_super => return "right_super",
        c.pinc_key_code_menu => return "menu",
        else => return "unknown",
    }
}
// pub export fn pinc_key_token_name(token: u32) [*:0]u8 ;
// pub export fn pinc_set_cursor_mode(mode: c.pinc_cursor_mode_enum, window: c.pinc_window_handle_t) void ;
// pub export fn pinc_set_cursor_theme_image(image: c.pinc_cursor_theme_image_enum, window: c.pinc_window_handle_t) void ;
// pub export fn pinc_set_cursor_image(window: c.pinc_window_handle_t, data: [*]u8, size: u32) void ;
// pub export fn pinc_get_clipboard_string() [*:0]u8 ;

pub export fn pinc_graphics_opengl_set_framebuffer(framebuffer: c.pinc_framebuffer_handle_t) void {
    c.x11_make_context_current(framebuffer);
}

pub export fn pinc_graphics_opengl_get_proc(procname: [*:0]const u8) ?*anyopaque {
    return c.x11_load_glX_symbol(null, procname);
}

pub export fn pinc_graphics_present_window(window: c.pinc_window_handle_t, vsync: bool) void {
    c.x11_present_framebuffer(window, vsync);
}
