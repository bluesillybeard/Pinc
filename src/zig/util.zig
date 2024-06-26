// pinc util functions are exported here
// Anything with the "pinc_util_" prefix

const std = @import("std");
const c = @import("c.zig");

// TODO: set pinc error
pub export fn pinc_util_unicode_to_uft8(unicode: u32, dest: ?[*:0]u8) bool {
    if (unicode > std.math.maxInt(u21)) return false;
    if (dest == null) return false;
    // Create a slice that points to the actual dest
    var destSlice: []u8 = undefined;
    destSlice.len = 5;
    destSlice.ptr = @ptrCast(dest.?);
    const count = std.unicode.utf8Encode(@intCast(unicode), destSlice) catch return false;
    destSlice[count] = 0;
    return true;
}

pub export fn pinc_util_key_name(code: c.pinc_key_code_enum) [*:0]const u8 {
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
        c.pinc_key_code_backtick => return "backtick",
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
