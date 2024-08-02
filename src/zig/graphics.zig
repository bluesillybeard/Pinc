// Pinc's non-API specific graphics functions
// functions with the "pinc_graphics" prefix
// My dumb brain was thinking "If this file is included more than once, it will cause duplicates of the OpenGL function pointers!"
// Then I remembered I'm programming in Zig, not C. Here in Zig land, things actually make sense (most of the time) instead of C's annoying compiling and linking semantics.
const gl21bind = @import("ext/gl21load.zig");
const c = @import("c.zig");
const pinc = @import("pinc.zig");
const std = @import("std");

// TODO: when adding non-window framebuffers, completely refactor so the native backend doesn't have to worry about that

pub export fn pinc_graphics_clear_color(framebuffer: c.pinc_framebuffer_handle_t, r: f32, g: f32, b: f32, a: f32) void {
    if(!pinc.native.setOpenGLFramebuffer(framebuffer)) {
        std.debug.panic("Failed to set the OpenGL framebuffer!", .{});
    }
    gl21bind.clearColor(r, g, b, a);
    gl21bind.clear(gl21bind.COLOR_BUFFER_BIT);
}

// These would have been exported from native directly, however they have the "pinc_graphics" prefix
pub export fn pinc_graphics_opengl_set_framebuffer(framebuffer: c.pinc_framebuffer_handle_t) bool {
    return pinc.native.setOpenGLFramebuffer(framebuffer);
}
pub export fn  pinc_graphics_opengl_get_proc(procname: [*:0]const u8) ?*anyopaque {
    return pinc.native.getOpenglProc(procname);
}
pub export fn pinc_graphics_present_window(window: c.pinc_window_handle_t, vsync: bool) void {
    pinc.native.presentWindow(window, vsync);
}
