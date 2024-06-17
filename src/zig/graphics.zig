// Pinc's non-API specific graphics functions
// Graphics functions that only touch OpenGL

// My dumb brain was thinking "If this file is included more than once, it will cause duplicates of the OpenGL function pointers!"
// Then I remembered I'm programming in Zig, not C. Here in Zig land, things actually make sense (most of the time) instead of C's annoying compiling and linking semantics.
const gl21bind = @import("ext/gl21load.zig");
const c = @import("c.zig");

pub export fn pinc_graphics_clear_color(framebuffer: c.pinc_framebuffer_handle_t, r: f32, g: f32, b: f32, a: f32) void {
    // TODO: account for non-window framebuffers
    c.x11_make_context_current(framebuffer);
    gl21bind.clearColor(r, g, b, a);
    gl21bind.clear(gl21bind.COLOR_BUFFER_BIT);
}
