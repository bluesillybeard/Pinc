// Surface level binding Zig binding

pub const window_backend = enum(c_int) {
    any,
    sdl2,  
};

pub const graphics_backend = enum(c_int) {
    none,
    opengl_2_1,
    raw,
};

pub const error_type = enum(c_int) {
    any,
};

pub const object_type = enum(c_int) {
    none,
    window,
};

pub const keyboard_key = enum(c_int) {
    unknown = -1,
    space = 0,
    apostrophe,
    comma,
    dash,
    dot,
    slash,
    @"0",
    @"1",
    @"2",
    @"3",
    @"4",
    @"5",
    @"6",
    @"7",
    @"8",
    @"9",
    semicolon,
    equals,
    a,
    b,
    c,
    d,
    e,
    f,
    g,
    h,
    i,
    j,
    k,
    l,
    m,
    n,
    o,
    p,
    q,
    r,
    s,
    t,
    u,
    v,
    w,
    x,
    y,
    z,
    left_bracket,
    backslash,
    right_bracket,
    backtick,
    escape,
    enter,
    tab,
    backspace,
    insert,
    delete,
    right,
    left,
    down,
    up,
    page_up,
    page_down,
    home,
    end,
    caps_lock,
    scroll_lock,
    num_lock,
    print_screen,
    pause,
    f1,
    f2,
    f3,
    f4,
    f5,
    f6,
    f7,
    f8,
    f9,
    f10,
    f11,
    f12,
    f13,
    f14,
    f15,
    f16,
    f17,
    f18,
    f19,
    f20,
    f21,
    f22,
    f23,
    f24,
    f25,
    f26,
    f27,
    f28,
    f29,
    f30,
    numpad_0,
    numpad_1,
    numpad_2,
    numpad_3,
    numpad_4,
    numpad_5,
    numpad_6,
    numpad_7,
    numpad_8,
    numpad_9,
    numpad_dot,
    numpad_slash,
    numpad_asterisk,
    numpad_dash,
    numpad_plus,
    numpad_enter,
    numpad_equal,
    left_shift,
    left_control,
    left_alt,
    left_super,
    right_shift,
    right_control,
    right_alt,
    right_super,
    menu,
    count,
};


extern fn pinc_incomplete_init() void;
extern fn pinc_window_backend_is_supported(backend: window_backend) c_int;
extern fn pinc_init_set_window_backend(backend: window_backend) void;
extern fn pinc_graphics_backend_is_supported(backend: graphics_backend) c_int;
extern fn pinc_init_set_graphics_backend(backend: graphics_backend) void;
extern fn pinc_framebuffer_format_get_num() c_int;
extern fn pinc_framebuffer_format_get_channels(framebuffer_index: c_int) c_int;
extern fn pinc_framebuffer_format_get_bit_depth(framebuffer_index: c_int, channel: c_int) c_int;
extern fn pinc_framebuffer_format_get_depth_buffer(framebuffer_index: c_int) c_int;
extern fn pinc_init_set_framebuffer_format(framebuffer_index: c_int) void;
extern fn pinc_complete_init() void;
extern fn pinc_deinit() void;
extern fn pinc_error_get_num() c_int;
extern fn pinc_error_peek_type() error_type;
extern fn pinc_error_peek_fatal() c_int;
extern fn pinc_error_peek_message_length() c_int;
extern fn pinc_error_peek_message_byte(index: c_int) u8;
extern fn pinc_error_pop() void;
extern fn pinc_window_backend_get() window_backend;
extern fn pinc_object_get_type(id: c_int) object_type;
extern fn pinc_object_get_complete(id: c_int) c_int;
extern fn pinc_window_incomplete_create() c_int;
extern fn pinc_window_complete(window: c_int) void;
extern fn pinc_window_set_title_length(window: c_int, len: c_int) void;
extern fn pinc_window_set_title_item(window: c_int, index: c_int, item: u8) void;
extern fn pinc_window_get_title_length(window: c_int) c_int;
extern fn pinc_window_get_title_item(window: c_int, index: c_int) u8;
extern fn pinc_window_set_width(window: c_int, width: c_int) void;
extern fn pinc_window_get_width(window: c_int) c_int;
extern fn pinc_window_has_width(window: c_int) c_int;
extern fn pinc_window_set_height(window: c_int, height: c_int) void;
extern fn pinc_window_get_height(window: c_int) c_int;
extern fn pinc_window_has_height(window: c_int) c_int;
extern fn pinc_window_get_scale_factor(window: c_int) f32;
extern fn pinc_window_has_scale_factor(window: c_int) c_int;
extern fn pinc_window_set_resizable(window: c_int, resizable: c_int) void;
extern fn pinc_window_get_resizable(window: c_int) c_int;
extern fn pinc_window_set_minimized(window: c_int, minimized: c_int) void;
extern fn pinc_window_get_minimized(window: c_int) c_int;
extern fn pinc_window_set_maximized(window: c_int, maximized: c_int) void;
extern fn pinc_window_get_maximized(window: c_int) c_int;
extern fn pinc_window_set_fullscreen(window: c_int, fullscreen: c_int) void;
extern fn pinc_window_get_fullscreen(window: c_int) c_int;
extern fn pinc_window_set_focused(window: c_int, focused: c_int) void;
extern fn pinc_window_get_focused(window: c_int) c_int;
extern fn pinc_window_set_hidden(window: c_int, hidden: c_int) void;
extern fn pinc_window_get_hidden(window: c_int) c_int;
extern fn pinc_window_present_framebuffer(window: c_int, vsync: c_int) void;
extern fn pinc_mouse_button_get(button: c_int) c_int;
extern fn pinc_keyboard_key_get(button: keyboard_key) c_int;
extern fn pinc_get_cursor_x() c_int;
extern fn pinc_get_cursor_y() c_int;
extern fn pinc_step() void;
extern fn pinc_event_window_closed(window: c_int) c_int;
extern fn pinc_event_window_mouse_button(window: c_int) c_int;
extern fn pinc_event_window_resized(window: c_int) c_int;
extern fn pinc_event_window_focused(window: c_int) c_int;
extern fn pinc_event_window_unfocused(window: c_int) c_int;
extern fn pinc_event_window_exposed(window: c_int) c_int;
extern fn pinc_event_window_keyboard_button_num(window: c_int) c_int;
extern fn pinc_event_window_keyboard_button_get(window: c_int, index: c_int) c_int;
extern fn pinc_event_window_keyboard_button_get_repeat(window: c_int, index: c_int) c_int;
extern fn pinc_event_window_cursor_move(window: c_int) c_int;
extern fn pinc_event_window_cursor_exit(window: c_int) c_int;
extern fn pinc_event_window_cursor_enter(window: c_int) c_int;
extern fn pinc_event_window_text_len(window: c_int) c_int;
extern fn pinc_event_window_text_item(window: c_int, index: c_int) u8;
extern fn pinc_event_window_scroll_vertical(window: c_int) f32;
extern fn pinc_event_window_scroll_horizontal(window: c_int) f32;
extern fn pinc_graphics_fill_color(window: c_int, c1: f32, c2: f32, c3: f32, c4: f32) void;
extern fn pinc_graphics_fill_depth(window: c_int, depth: f32) void;


pub fn incomplete_init() void {
    pinc_incomplete_init();
}

pub fn window_backend_is_supported(backend: window_backend) c_int {
    return pinc_window_backend_is_supported(backend);
}

pub fn init_set_window_backend(backend: window_backend) void {
    pinc_init_set_window_backend(backend);
}

pub fn graphics_backend_is_supported(backend: graphics_backend) c_int {
    return pinc_graphics_backend_is_supported(backend);
}

pub fn init_set_graphics_backend(backend: graphics_backend) void {
    pinc_init_set_graphics_backend(backend);
}

pub fn framebuffer_format_get_num() c_int {
    return pinc_framebuffer_format_get_num();
}

pub fn framebuffer_format_get_channels(framebuffer_index: c_int) c_int {
    return pinc_framebuffer_format_get_channels(framebuffer_index);
}

pub fn framebuffer_format_get_bit_depth(framebuffer_index: c_int, channel: c_int) c_int {
    return pinc_framebuffer_format_get_bit_depth(framebuffer_index, channel);
}

pub fn framebuffer_format_get_depth_buffer(framebuffer_index: c_int) c_int {
    return pinc_framebuffer_format_get_depth_buffer(framebuffer_index);
}

pub fn init_set_framebuffer_format(framebuffer_index: c_int) void {
    pinc_init_set_framebuffer_format(framebuffer_index);
}

pub fn complete_init() void {
    pinc_complete_init();
}

pub fn deinit() void {
    pinc_deinit();
}

pub fn error_get_num() c_int {
    return pinc_error_get_num();
}

pub fn error_peek_type() error_type {
    return pinc_error_peek_type();
}

pub fn error_peek_fatal() c_int {
    return pinc_error_peek_fatal();
}

pub fn error_peek_message_length() c_int {
    return pinc_error_peek_message_length();
}

pub fn error_peek_message_byte(index: c_int) u8 {
    pinc_error_peek_message_byte(index);
}

pub fn error_pop() void {
    pinc_error_pop();
}

pub fn window_backend_get() window_backend {
    return pinc_window_backend_get();
}

pub fn object_get_type(id: c_int) object_type {
    return pinc_object_get_type(id);
}

pub fn object_get_complete(id: c_int) c_int {
    return pinc_object_get_complete(id);
}

pub fn window_incomplete_create() c_int {
    return pinc_window_incomplete_create();
}

pub fn window_complete(window: c_int) void {
    pinc_window_complete(window);
}

pub fn window_set_title_length(window: c_int, len: c_int) void {
    pinc_window_set_title_length(window, len);
}

pub fn window_set_title_item(window: c_int, index: c_int, item: u8) void {
    pinc_window_set_title_item(window, index, item);
}

pub fn window_get_title_length(window: c_int) c_int {
    return pinc_window_get_title_length(window);
}

pub fn window_get_title_item(window: c_int, index: c_int) u8 {
    pinc_window_get_title_item(window, index);
}

pub fn window_set_width(window: c_int, width: c_int) void {
    pinc_window_set_width(window, width);
}

pub fn window_get_width(window: c_int) c_int {
    return pinc_window_get_width(window);
}

pub fn window_has_width(window: c_int) c_int {
    return pinc_window_has_width(window);
}

pub fn window_set_height(window: c_int, height: c_int) void {
    pinc_window_set_height(window, height);
}

pub fn window_get_height(window: c_int) c_int {
    return pinc_window_get_height(window);
}

pub fn window_has_height(window: c_int) c_int {
    return pinc_window_has_height(window);
}

pub fn window_get_scale_factor(window: c_int) f32 {
    pinc_window_get_scale_factor(window);
}

pub fn window_has_scale_factor(window: c_int) c_int {
    return pinc_window_has_scale_factor(window);
}

pub fn window_set_resizable(window: c_int, resizable: c_int) void {
    pinc_window_set_resizable(window, resizable);
}

pub fn window_get_resizable(window: c_int) c_int {
    return pinc_window_get_resizable(window);
}

pub fn window_set_minimized(window: c_int, minimized: c_int) void {
    pinc_window_set_minimized(window, minimized);
}

pub fn window_get_minimized(window: c_int) c_int {
    return pinc_window_get_minimized(window);
}

pub fn window_set_maximized(window: c_int, maximized: c_int) void {
    pinc_window_set_maximized(window, maximized);
}

pub fn window_get_maximized(window: c_int) c_int {
    return pinc_window_get_maximized(window);
}

pub fn window_set_fullscreen(window: c_int, fullscreen: c_int) void {
    pinc_window_set_fullscreen(window, fullscreen);
}

pub fn window_get_fullscreen(window: c_int) c_int {
    return pinc_window_get_fullscreen(window);
}

pub fn window_set_focused(window: c_int, focused: c_int) void {
    pinc_window_set_focused(window, focused);
}

pub fn window_get_focused(window: c_int) c_int {
    return pinc_window_get_focused(window);
}

pub fn window_set_hidden(window: c_int, hidden: c_int) void {
    pinc_window_set_hidden(window, hidden);
}

pub fn window_get_hidden(window: c_int) c_int {
    return pinc_window_get_hidden(window);
}

pub fn window_present_framebuffer(window: c_int, vsync: c_int) void {
    pinc_window_present_framebuffer(window, vsync);
}

pub fn mouse_button_get(button: c_int) c_int {
    return pinc_mouse_button_get(button);
}

pub fn keyboard_key_get(button: keyboard_key) c_int {
    return pinc_keyboard_key_get(button);
}

pub fn get_cursor_x() c_int {
    return pinc_get_cursor_x();
}

pub fn get_cursor_y() c_int {
    return pinc_get_cursor_y();
}

pub fn step() void {
    pinc_step();
}

pub fn event_window_closed(window: c_int) c_int {
    return pinc_event_window_closed(window);
}

pub fn event_window_mouse_button(window: c_int) c_int {
    return pinc_event_window_mouse_button(window);
}

pub fn event_window_resized(window: c_int) c_int {
    return pinc_event_window_resized(window);
}

pub fn event_window_focused(window: c_int) c_int {
    return pinc_event_window_focused(window);
}

pub fn event_window_unfocused(window: c_int) c_int {
    return pinc_event_window_unfocused(window);
}

pub fn event_window_exposed(window: c_int) c_int {
    return pinc_event_window_exposed(window);
}

pub fn event_window_keyboard_button_num(window: c_int) c_int {
    return pinc_event_window_keyboard_button_num(window);
}

pub fn event_window_keyboard_button_get(window: c_int, index: c_int) c_int {
    return pinc_event_window_keyboard_button_get(window, index);
}

pub fn event_window_keyboard_button_get_repeat(window: c_int, index: c_int) c_int {
    return pinc_event_window_keyboard_button_get_repeat(window, index);
}

pub fn event_window_cursor_move(window: c_int) c_int {
    return pinc_event_window_cursor_move(window);
}

pub fn event_window_cursor_exit(window: c_int) c_int {
    return pinc_event_window_cursor_exit(window);
}

pub fn event_window_cursor_enter(window: c_int) c_int {
    return pinc_event_window_cursor_enter(window);
}

pub fn event_window_text_len(window: c_int) c_int {
    return pinc_event_window_text_len(window);
}

pub fn event_window_text_item(window: c_int, index: c_int) u8 {
    pinc_event_window_text_item(window, index);
}

pub fn event_window_scroll_vertical(window: c_int) f32 {
    pinc_event_window_scroll_vertical(window);
}

pub fn event_window_scroll_horizontal(window: c_int) f32 {
    pinc_event_window_scroll_horizontal(window);
}

pub fn graphics_fill_color(window: c_int, c1: f32, c2: f32, c3: f32, c4: f32) void {
    pinc_graphics_fill_color(window, c1, c2, c3, c4);
}

pub fn graphics_fill_depth(window: c_int, depth: f32) void {
    pinc_graphics_fill_depth(window, depth);
}

