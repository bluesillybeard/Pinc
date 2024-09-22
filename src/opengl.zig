const gl = @import("ext/gl21load.zig");
const pinc = @import("pinc.zig");

pub const Opengl21GraphicsBackend = struct {
    pub fn init(this: *Opengl21GraphicsBackend) void {
        _ = this;
    }

    // This shouldn't be required, but for some reason Zig complains when we try to give gl.load the window backend glGetProc function directly
    pub fn loadProcFnGl(b: pinc.IWindowBackend, name: [:0]const u8) ?*anyopaque {
        return b.glGetProc(name);
    }

    pub fn prepareFramebuffer(this: *Opengl21GraphicsBackend, framebuffer: pinc.FramebufferFormat) void {
        _ = this;
        _ = framebuffer;
        // This seems like a decent function in which to load the OpenGL procs
        // TODO: error instead of unreachable on load error
        gl.load(pinc.state.set_graphics_backend.windowBackend, loadProcFnGl) catch unreachable;
    }

    pub fn deinit(this: *Opengl21GraphicsBackend) void {
        pinc.allocator.?.destroy(this);
    }

    pub fn step(this: *Opengl21GraphicsBackend) void {
        _ = this;
    }

    pub fn fillColor(this: *Opengl21GraphicsBackend, window: pinc.ICompleteWindow, c1: f32, c2: f32, c3: f32, c4: f32) void {
        _ = this;
        window.glMakeCurrent();
        const color = pinc.state.getFramebufferFormat().?.channelsToRgbaColor(c1, c2, c3, c4);
        gl.clearColor(color.r, color.g, color.b, color.a);
        gl.clear(gl.COLOR_BUFFER_BIT);
    }

    pub fn fillDepth(this: *Opengl21GraphicsBackend, window: pinc.ICompleteWindow, c1: f32) void {
        _ = this;
        window.glMakeCurrent();
        gl.clearDepth(c1);
        gl.clear(gl.DEPTH_BUFFER_BIT);
    }
};
