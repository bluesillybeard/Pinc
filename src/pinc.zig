// The main Pinc source file
// All pinc functions are exported here

const std = @import("std");

// Before we export the functions, we need some types.
// Pinc's backends are done using dynamic dispatch, for a few reasons:
// - it makes adding new backends easy
// - it allows the ability to add a custom user-implemented backend implementation at runtime (a feature we will add at some point)
// - it allows the backend to be chosen at runtime
//     - for example, on Linux there will be X11, Wayland, and SDL2 backends. (sdl is the only one implemented atm though)
//     - Also, the raw / opengl graphics backends
// - 

pub export fn pinc_incomplete_init() void {
    std.debug.panic("Function not implemented", .{});
}

pub export fn pinc_window_backend_is_supported(backend: c_int) c_int {
    _ = backend; // autofix
    std.debug.panic("Function not implemented", .{});
}

pub export fn pinc_init_set_window_backend(backend: c_int) void {
    _ = backend; // autofix
    std.debug.panic("Function not implemented", .{});
}

pub export fn pinc_graphics_backend_is_supported(backend: c_int) c_int {
    _ = backend; // autofix
    std.debug.panic("Function not implemented", .{});
}

pub export fn pinc_init_set_graphics_backend(backend: c_int) void {
    _ = backend; // autofix
    std.debug.panic("Function not implemented", .{});
}

pub export fn pinc_framebuffer_format_get_num() c_int {
    std.debug.panic("Function not implemented", .{});
}

pub export fn pinc_framebuffer_format_get_channels(framebuffer_index: c_int) c_int {
    _ = framebuffer_index; // autofix
    std.debug.panic("Function not implemented", .{});
}

pub export fn pinc_framebuffer_format_get_bit_depth(framebuffer_index: c_int, channel: c_int) c_int {
    _ = framebuffer_index; // autofix
    _ = channel; // autofix
    std.debug.panic("Function not implemented", .{});
}

pub export fn pinc_framebuffer_format_get_range(framebuffer_index: c_int, channel: c_int) c_int {
    _ = framebuffer_index; // autofix
    _ = channel; // autofix
    std.debug.panic("Function not implemented", .{});
}

pub export fn pinc_framebuffer_format_get_depth_buffer(framebuffer_index: c_int) c_int {
    _ = framebuffer_index; // autofix
    std.debug.panic("Function not implemented", .{});
}

pub export fn pinc_init_set_framebuffer_format(framebuffer_index: c_int) void {
    _ = framebuffer_index; // autofix
    std.debug.panic("Function not implemented", .{});
}

pub export fn pinc_complete_init() void {
    std.debug.panic("Function not implemented", .{});
}

pub export fn pinc_deinit() void {
    std.debug.panic("Function not implemented", .{});
}

pub export fn pinc_error_get_num() c_int {
    std.debug.panic("Function not implemented", .{});
}

pub export fn pinc_error_peek_type() c_int {
    std.debug.panic("Function not implemented", .{});
}

pub export fn pinc_error_peek_fatal() c_int {
    std.debug.panic("Function not implemented", .{});
}

pub export fn pinc_error_peek_message_length() c_int {
    std.debug.panic("Function not implemented", .{});
}

pub export fn pinc_error_peek_message_byte(index: c_int) c_char {
    _ = index; // autofix
    std.debug.panic("Function not implemented", .{});
}

pub export fn pinc_error_pop() void {
    std.debug.panic("Function not implemented", .{});
}

pub export fn pinc_window_backend_get() c_int {
    std.debug.panic("Function not implemented", .{});
}

pub export fn pinc_object_get_type(id: c_int) c_int {
    _ = id; // autofix
    std.debug.panic("Function not implemented", .{});
}

pub export fn pinc_object_get_complete(id: c_int) c_int {
    _ = id; // autofix
    std.debug.panic("Function not implemented", .{});
}

pub export fn pinc_window_incomplete_create() c_int {
    std.debug.panic("Function not implemented", .{});
}

pub export fn pinc_window_complete(window: c_int) void {
    _ = window; // autofix
    std.debug.panic("Function not implemented", .{});
}

pub export fn pinc_window_set_width(window: c_int, width: c_int) void {
    _ = window; // autofix
    _ = width; // autofix
    std.debug.panic("Function not implemented", .{});
}

pub export fn pinc_window_get_width(window: c_int) c_int {
    _ = window; // autofix
    std.debug.panic("Function not implemented", .{});
}

pub export fn pinc_window_has_width(window: c_int) c_int {
    _ = window; // autofix
    std.debug.panic("Function not implemented", .{});
}

pub export fn pinc_window_set_height(window: c_int, height: c_int) void {
    _ = window; // autofix
    _ = height; // autofix
    std.debug.panic("Function not implemented", .{});
}

pub export fn pinc_window_get_height(window: c_int) c_int {
    _ = window; // autofix
    std.debug.panic("Function not implemented", .{});
}

pub export fn pinc_window_has_height(window: c_int) c_int {
    _ = window; // autofix
    std.debug.panic("Function not implemented", .{});
}

pub export fn pinc_window_has_scale_factor(window: c_int) c_int {
    _ = window; // autofix
    std.debug.panic("Function not implemented", .{});
}

pub export fn pinc_window_set_resizable(window: c_int, resizable: c_int) void {
    _ = window; // autofix
    _ = resizable; // autofix
    std.debug.panic("Function not implemented", .{});
}

pub export fn pinc_window_get_resizable(window: c_int) c_int {
    _ = window; // autofix
    std.debug.panic("Function not implemented", .{});
}

pub export fn pinc_window_set_minimized(window: c_int, minimized: c_int) void {
    _ = window; // autofix
    _ = minimized; // autofix
    std.debug.panic("Function not implemented", .{});
}

pub export fn pinc_window_get_minimized(window: c_int) c_int {
    _ = window; // autofix
    std.debug.panic("Function not implemented", .{});
}

pub export fn pinc_window_set_maximized(window: c_int, maximized: c_int) void {
    _ = window; // autofix
    _ = maximized; // autofix
    std.debug.panic("Function not implemented", .{});
}

pub export fn pinc_window_get_maximized(window: c_int) c_int {
    _ = window; // autofix
    std.debug.panic("Function not implemented", .{});
}

pub export fn pinc_window_set_fullscreen(window: c_int, fullscreen: c_int) void {
    _ = window; // autofix
    _ = fullscreen; // autofix
    std.debug.panic("Function not implemented", .{});
}

pub export fn pinc_window_get_fullscreen(window: c_int) c_int {
    _ = window; // autofix
    std.debug.panic("Function not implemented", .{});
}

pub export fn pinc_window_set_focused(window: c_int, focused: c_int) void {
    _ = window; // autofix
    _ = focused; // autofix
    std.debug.panic("Function not implemented", .{});
}

pub export fn pinc_window_get_focused(window: c_int) c_int {
    _ = window; // autofix
    std.debug.panic("Function not implemented", .{});
}

pub export fn pinc_window_set_hidden(window: c_int, hidden: c_int) void {
    _ = window; // autofix
    _ = hidden; // autofix
    std.debug.panic("Function not implemented", .{});
}

pub export fn pinc_window_get_hidden(window: c_int) c_int {
    _ = window; // autofix
    std.debug.panic("Function not implemented", .{});
}

pub export fn pinc_window_present_framebuffer(window: c_int, vsync: c_int) void {
    _ = window; // autofix
    _ = vsync; // autofix
    std.debug.panic("Function not implemented", .{});
}

pub export fn pinc_step() void {
    std.debug.panic("Function not implemented", .{});
}

pub export fn pinc_window_event_closed(window: c_int) c_int {
    _ = window; // autofix
    std.debug.panic("Function not implemented", .{});
}

pub export fn pinc_graphics_set_fill_color(channel: c_int, value: c_int) void {
    _ = channel; // autofix
    _ = value; // autofix
    std.debug.panic("Function not implemented", .{});
}

pub export fn pinc_graphics_set_fill_depth(value: c_int) void {
    _ = value; // autofix
    std.debug.panic("Function not implemented", .{});
}

pub export fn pinc_graphics_fill(framebuffer: c_int, flags: c_int) void {
    _ = framebuffer; // autofix
    _ = flags; // autofix
    std.debug.panic("Function not implemented", .{});
}