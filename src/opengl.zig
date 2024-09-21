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

    // TODO: this weird fill color conversion state crap will be removed soon enough... right?
    // More accurately, there will be a graphics context object that is entirely managed by pinc.zig,
    // and the graphics backends will just get all the data they need to draw all in one function
    // instead of having to deal with this state stuff
    pub fn setFillColor(this: *Opengl21GraphicsBackend, channel: u32, value: i32) void {
        // TODO: handle non-RGBA colors.
        // This only works because the only implemented window backend (SDL2) assumes an RGBA framebuffer
        // TODO: handle non-8bpc colors
        // this only works because the only implemented window backend (SDL2) assumes 8bpc
        this.fillColor[channel] = @as(f32, @floatFromInt(value)) / 255.0;
    }

    pub fn setFillDepth(this: *Opengl21GraphicsBackend, depth: f32) void {
        _ = this;
        _ = depth;
        // TODO
    }

    pub fn fillWindow(this: *Opengl21GraphicsBackend, window: pinc.ICompleteWindow, flags: pinc.GraphicsFillFlags) void {
        window.glMakeCurrent();
        var glFlags: gl.GLuint = 0;
        if (flags.color) {
            // TODO: handle non-RGBA colors? Or will we just always use RGBA internally?
            // Does OpenGL itself even support non-rgba framebuffers?
            gl.clearColor(this.fillColor[0], this.fillColor[1], this.fillColor[2], this.fillColor[3]);
            glFlags |= gl.COLOR_BUFFER_BIT;
        }
        // TODO: depth
        gl.clear(glFlags);
    }

    fillColor: [4]f32,
};
