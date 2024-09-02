const gl = @import("ext/gl21load.zig");
const pinc = @import("pinc.zig");

pub const Opengl21GraphicsBackend = struct {
    pub fn init(this: *Opengl21GraphicsBackend) void {
        _ = this;
    }
    pub fn prepareFramebuffer(this: *Opengl21GraphicsBackend, framebuffer: pinc.FramebufferFormat) void {
        _ = this;
        _ = framebuffer;
    }

    pub fn deinit(this: *Opengl21GraphicsBackend) void {
        _ = this;
    }

    pub fn step(this: *Opengl21GraphicsBackend) void {
        _ = this;
    }

    pub fn setFillColor(this: *Opengl21GraphicsBackend, channel: u32, value: i32) void {
        _ = this;
        _ = channel;
        _ = value;
    }

    pub fn setFillDepth(this: *Opengl21GraphicsBackend, depth: f32) void {
        _ = this;
        _ = depth;
    }

    pub fn fillWindow(this: *Opengl21GraphicsBackend, window: pinc.ICompleteWindow, flags: pinc.GraphicsFillFlags) void {
        _ = this;
        _ = window;
        _ = flags;
    }
};
