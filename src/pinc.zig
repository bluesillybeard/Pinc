// The main Pinc source file
// All pinc functions are exported here

// general imports
const std = @import("std");

// imports for window backends
const sdl2 = @import("sdl2.zig");

// imports for graphics backends
const gl = @import("opengl.zig");

// Before we export the functions, we need some types.
// Pinc's backends are done using dynamic dispatch, for a few reasons:
// - it makes adding new backends easy
// - it allows the ability to add a custom user-implemented backend implementation at runtime (a feature we will add at some point)
// - it allows the backend to be chosen at runtime
//     - Useful (for example) to prioritize SDL2 but fall back to the native option if the host doesn't have SDL2 installed

// types from pinc.h, over here in Zig land.
// SYNC: These need to be maintained.

pub const WindowBackend = enum(c_int) {
    any,
    sdl2,
};

pub const GraphicsBackend = enum(c_int) {
    none,
    opengl21,
    raw,
};

pub const ErrorType = enum(c_int) {
    any,
};

pub const ObjectType = enum(c_int) {
    none,
    window,
};

// other types

pub const maxChannels = 4;

pub const FramebufferFormat = struct {
    // Data given out to Pincs user
    channels: u32,
    channelDepths: [maxChannels]u32,
    // To get the range, just do (1<<depth)-1
    //channelRanges: [maxChannels]u32,
    depthBits: u32,
    // Data that is used internally
    /// This is to help implementing backends, not used by any of Pinc's backend-agnostic code.
    id: usize,
};

pub const IncompleteWindow = struct {
    width: ?u32 = null,
    height: ?u32 = null,
    resizable: bool = true,
    minimized: bool = false,
    maximized: bool = false,
    fullscreen: bool = false,
    focused: bool = false,
    hidden: bool = false,
    title: [:0]u8,
};

pub const ICompleteWindow = struct {
    // Once a window is complete, all of its data is up to the backend to handle.
    // So complete windows, naturally, are an OOP style interface.
    // Look man, I've spent most of my life using Java and C#. Give me a break!
    // The overhead is literally negligible for this.
    pub fn init(comptime T: type, obj: *T) ICompleteWindow {
        // We make a new struct so the vtable gets put into the pinc binary
        const vtholder = struct {
            var vtable: Vtable = undefined;
        };
        var vtable = &vtholder.vtable;

        // Using the power of comptime, we can automagically set all of the vtable functions
        const vtinfo = @typeInfo(Vtable);
        inline for (vtinfo.@"struct".fields) |field| {
            @field(vtable, field.name) = @ptrCast(&@field(T, field.name));
        }
        T.init(obj);
        return ICompleteWindow{
            .vtable = vtable,
            .obj = obj,
        };
    }

    // This should also destroy the memory of the object iself. It is not like a C++ desctructor.
    pub inline fn deinit(this: ICompleteWindow) void {
        this.vtable.deinit(this.obj);
    }

    /// Set the width of this window in pixels
    pub inline fn setWidth(this: ICompleteWindow, width: u32) void {
        this.vtable.setWidth(this.obj, width);
    }

    /// get the width of this window in pixels
    pub inline fn getWidth(this: ICompleteWindow) u32 {
        return this.vtable.getWidth(this.obj);
    }

    /// Set the height of this window in pixels
    pub inline fn setHeight(this: ICompleteWindow, height: u32) void {
        this.vtable.setHeight(this.obj, height);
    }

    /// get the height of this window in pixels
    pub inline fn getHeight(this: ICompleteWindow) u32 {
        return this.vtable.getHeight(this.obj);
    }

    pub inline fn getScaleFactor(this: ICompleteWindow) ?f32 {
        return this.vtable.getScaleFactor(this.obj);
    }

    pub inline fn setResizable(this: ICompleteWindow, resizable: bool) void {
        this.vtable.setResizable(this.obj, resizable);
    }

    pub inline fn getResizable(this: ICompleteWindow) bool {
        return this.vtable.getResizable(this.obj);
    }

    pub inline fn presentFramebuffer(this: ICompleteWindow, vsync: bool) void {
        this.vtable.presentFramebuffer(this.obj, vsync);
    }

    pub inline fn eventClosed(this: ICompleteWindow) bool {
        return this.vtable.eventClosed(this.obj);
    }

    /// Returns a reference to this window's title. Memory is from the Pinc global allocator, and owned by the window
    pub inline fn getTitle(this: ICompleteWindow) [:0]u8 {
        return this.vtable.getTitle(this.obj);
    }

    /// Set the title for this window. The old title is freed, unless the given title is the same memory as the old title.
    /// Even when changing the title by overriding the memory from getTitle, setTitle should still be called to notify the window of the change.
    pub inline fn setTitle(this: ICompleteWindow, title: [:0]u8) void {
        this.vtable.setTitle(this.obj, title);
    }

    /// Make the static OpenGL context current for this window
    /// Side note: I really dislike the window-bound nature of OpenGL...
    pub inline fn glMakeCurrent(this: ICompleteWindow) void {
        this.vtable.glMakeCurrent(this.obj);
    }

    pub inline fn eventMouseButton(this: ICompleteWindow) bool {
        return this.vtable.eventMouseButton(this.obj);
    }

    pub inline fn setMinimized(this: ICompleteWindow, minimized: bool) void {
           this.vtable.setMinimized(this.obj, minimized);
    }

    pub inline fn getMinimized(this: ICompleteWindow) bool {
        return this.vtable.getMinimized(this.obj);
    }

    pub inline fn setMaximized(this: ICompleteWindow, maximized: bool) void {
        this.vtable.setMaximized(this.obj, maximized);
    }

    pub inline fn getMaximized(this: ICompleteWindow) bool {
        return this.vtable.getMaximized(this.obj);
    }

    pub inline fn setFullscreen(this: ICompleteWindow, fullscreen: bool) void {
        this.vtable.setFullscreen(this.obj, fullscreen);
    }

    pub inline fn getFullscreen(this: ICompleteWindow) bool {
        return this.vtable.getFullscreen(this.obj);
    }

    pub inline fn setFocused(this: ICompleteWindow, focused: bool) void {
        this.vtable.setFocused(this.obj, focused);
    }

    pub inline fn getFocused(this: ICompleteWindow) bool {
        return this.vtable.getFocused(this.obj);
    }

    pub inline fn setHidden(this: ICompleteWindow, hidden: bool) void {
        this.vtable.setHidden(this.obj, hidden);
    }

    pub inline fn getHidden(this: ICompleteWindow) bool {
        return this.vtable.getHidden(this.obj);
    }

    pub const Vtable = struct {
        // init is not implemented as part of the vtable.
        deinit: *const fn (this: *anyopaque) void,
        setWidth: *const fn (this: *anyopaque, width: u32) void,
        getWidth: *const fn (this: *anyopaque) u32,
        setHeight: *const fn (this: *anyopaque, height: u32) void,
        getHeight: *const fn (this: *anyopaque) u32,
        getScaleFactor: *const fn (this: *anyopaque) f32,
        setResizable: *const fn (this: *anyopaque, resizable: bool) void,
        getResizable: *const fn (this: *anyopaque) bool,
        presentFramebuffer: *const fn (this: *anyopaque, vsync: bool) void,
        eventClosed: *const fn (this: *anyopaque) bool,
        getTitle: *const fn (this: *anyopaque) [:0]u8,
        setTitle: *const fn (this: *anyopaque, title: [:0]u8) void,
        glMakeCurrent: *const fn (this: *anyopaque) void,
        eventMouseButton: *const fn(obj: *anyopaque) bool,
        setMinimized: *const fn(this: *anyopaque, bool) void,
        getMinimized: *const fn(this: *anyopaque) bool,
        setMaximized: *const fn(this: *anyopaque, bool) void,
        getMaximized: *const fn(this: *anyopaque) bool,
        setFullscreen: *const fn(this: *anyopaque, bool) void,
        getFullscreen: *const fn(this: *anyopaque) bool,
        setFocused: *const fn(this: *anyopaque, bool) void,
        getFocused: *const fn(this: *anyopaque) bool,
        setHidden: *const fn(this: *anyopaque, bool) void,
        getHidden: *const fn(this: *anyopaque) bool,
    };
    vtable: *const Vtable,
    obj: *anyopaque,
};

pub const PincObject = union(enum) {
    none,
    incompleteWindow: IncompleteWindow,
    completeWindow: ICompleteWindow,
};

pub const IWindowBackend = struct {
    pub fn init(comptime T: type, obj: *T) IWindowBackend {
        // We make a new struct so the vtable gets put into the pinc binary
        const vtholder = struct {
            var vtable: Vtable = undefined;
        };
        var vtable = &vtholder.vtable;

        // Using the power of comptime, we can automagically set all of the vtable functions
        const vtinfo = @typeInfo(Vtable);
        inline for (vtinfo.@"struct".fields) |field| {
            // TODO: verify the compatibility of the functions
            @field(vtable, field.name) = @ptrCast(&@field(T, field.name));
        }
        obj.init();
        return IWindowBackend{
            .vtable = vtable,
            .obj = obj,
        };
    }

    pub inline fn getBackendEnumValue(this: IWindowBackend) WindowBackend {
        return this.vtable.getBackendEnumValue(this.obj);
    }

    pub inline fn isGraphicsBackendSupported(this: IWindowBackend, backend: GraphicsBackend) bool {
        return this.vtable.isGraphicsBackendSupported(this.obj, backend);
    }

    pub inline fn deinit(this: IWindowBackend) void {
        this.vtable.deinit(this.obj);
    }

    pub inline fn prepareGraphics(this: IWindowBackend, backend: GraphicsBackend) void {
        this.vtable.prepareGraphics(this.obj, backend);
    }

    /// Implementer's note: caller owns returned data through pinc's global allocator
    pub inline fn getFramebufferFormats(this: IWindowBackend, graphicsBackendEnum: GraphicsBackend, graphicsBackend: IGraphicsBackend) []const FramebufferFormat {
        return this.vtable.getFramebufferFormats(this.obj, graphicsBackendEnum, graphicsBackend);
    }

    pub inline fn prepareFramebuffer(this: IWindowBackend, framebuffer: FramebufferFormat) void {
        return this.vtable.prepareFramebuffer(this.obj, framebuffer);
    }

    pub inline fn createWindow(this: IWindowBackend, data: IncompleteWindow, id: c_int) ?ICompleteWindow {
        return this.vtable.createWindow(this.obj, data, id);
    }

    pub inline fn step(this: IWindowBackend) void {
        this.vtable.step(this.obj);
    }

    pub inline fn glGetProc(this: IWindowBackend, name: [:0]const u8) ?*anyopaque {
        return this.vtable.glGetProc(this.obj, name);
    }

    pub inline fn getMouseState(this: IWindowBackend, button: u32) bool {
        return this.vtable.getMouseState(this.obj, button);
    }

    pub const Vtable = struct {
        // TODO: Be more smart about how window backends are handled and get rid of this function
        getBackendEnumValue: *const fn (obj: *anyopaque) WindowBackend,
        isGraphicsBackendSupported: *const fn (obj: *anyopaque, backend: GraphicsBackend) bool,
        deinit: *const fn (obj: *anyopaque) void,
        prepareGraphics: *const fn (obj: *anyopaque, backend: GraphicsBackend) void,
        getFramebufferFormats: *const fn (obj: *anyopaque, graphicsBackendEnum: GraphicsBackend, graphicsBackend: IGraphicsBackend) []const FramebufferFormat,
        prepareFramebuffer: *const fn (obj: *anyopaque, framebuffer: FramebufferFormat) void,
        createWindow: *const fn (obj: *anyopaque, data: IncompleteWindow, id: c_int) ?ICompleteWindow,
        step: *const fn (obj: *anyopaque) void,
        glGetProc: *const fn(obj: *anyopaque, name: [:0]const u8) ?*anyopaque,
        getMouseState: *const fn(obj: *anyopaque, button: u32) bool,
    };

    vtable: *Vtable,
    obj: *anyopaque,
};

pub const GraphicsFillFlags = packed struct {
    color: bool,
    depth: bool,
};

// Wow, another OOP interface

pub const IGraphicsBackend = struct {
    pub fn init(comptime T: type, obj: *T) IGraphicsBackend {
        // We make a new struct so the vtable gets put into the pinc binary
        const vtholder = struct {
            var vtable: Vtable = undefined;
        };
        var vtable = &vtholder.vtable;

        // Using the power of comptime, we can automagically set all of the vtable functions
        const vtinfo = @typeInfo(Vtable);
        inline for (vtinfo.@"struct".fields) |field| {
            @field(vtable, field.name) = @ptrCast(&@field(T, field.name));
        }
        T.init(obj);
        return IGraphicsBackend{
            .vtable = vtable,
            .obj = obj,
        };
    }

    pub inline fn prepareFramebuffer(this: IGraphicsBackend, framebuffer: FramebufferFormat) void {
        this.vtable.prepareFramebuffer(this.obj, framebuffer);
    }

    pub inline fn deinit(this: IGraphicsBackend) void {
        this.vtable.deinit(this.obj);
    }

    pub inline fn step(this: IGraphicsBackend) void {
        this.vtable.step(this.obj);
    }

    pub inline fn setFillColor(this: IGraphicsBackend, channel: u32, value: i32) void {
        this.vtable.setFillColor(this.obj, channel, value);
    }

    pub inline fn setFillDepth(this: IGraphicsBackend, depth: f32) void {
        this.vtable.setFillDepth(this.obj, depth);
    }

    pub inline fn fillWindow(this: IGraphicsBackend, window: ICompleteWindow, flags: GraphicsFillFlags) void {
        this.vtable.fillWindow(this.obj, window, flags);
    }

    pub const Vtable = struct {
        prepareFramebuffer: *const fn (obj: *anyopaque, framebuffer: FramebufferFormat) void,
        deinit: *const fn (obj: *anyopaque) void,
        step: *const fn (obj: *anyopaque) void,
        setFillColor: *const fn (obj: *anyopaque, u32, i32) void,
        setFillDepth: *const fn (obj: *anyopaque, f32) void,
        fillWindow: *const fn (*anyopaque, ICompleteWindow, GraphicsFillFlags) void,
    };

    vtable: *Vtable,
    obj: *anyopaque,
};

pub const PincError = struct {
    fatal: bool,
    type: ErrorType,
    message: []const u8,

    pub fn init(fatal: bool, _type: ErrorType, comptime fmt: []const u8, args: anytype) PincError {
        return PincError{
            .fatal = fatal,
            .type = _type,
            // TODO: maybe use a more optimized allocator specifically for strings.
            .message = std.fmt.allocPrint(allocator.?, fmt, args) catch unreachable,
        };
    }

    pub fn deinit(this: PincError) void {
        allocator.?.free(this.message);
    }
};

// where things are stored

// comptime list of backends that are supported on this OS-arch
// (Zig comptime is the best)
// TODO: add build-time options for disabling backends and changing their order
const backendTypes = blk: {
    var types: []const type = &[_]type{};
    const allBackends = [_]type{sdl2.SDL2WindowBackend};
    for (allBackends) |Back| {
        if (Back.backendIsSupportedComptime()) {
            types = types ++ [_]type{Back};
        }
    }
    break :blk types;
};

const Allocator = std.heap.GeneralPurposeAllocator(.{});
var allocatorObj = Allocator{};
pub var allocator: ?std.mem.Allocator = null;

var errors: ?std.ArrayList(PincError) = null;

/// States are named based on a function facilitates the change to that state
pub const StateTag = enum {
    /// This state is not set by a function, so it's named differently
    preinit,
    incomplete_init,
    set_window_backend,
    set_graphics_backend,
    set_framebuffer_format,
    init,
};

pub const State = union(StateTag) {
    preinit: struct {
        // nothing is here... obviously
    },
    incomplete_init: struct {
        windowBackends: std.ArrayList(IWindowBackend),
    },
    set_window_backend: struct {
        windowBackend: IWindowBackend,
    },
    set_graphics_backend: struct {
        windowBackend: IWindowBackend,
        graphicsBackend: IGraphicsBackend,
        graphicsBackendEnum: GraphicsBackend,
        framebufferFormats: []const FramebufferFormat,
    },
    set_framebuffer_format: struct {
        windowBackend: IWindowBackend,
        graphicsBackend: IGraphicsBackend,
        graphicsBackendEnum: GraphicsBackend,
        framebufferFormat: FramebufferFormat,
    },
    init: struct {
        windowBackend: IWindowBackend,
        graphicsBackend: IGraphicsBackend,
        graphicsBackendEnum: GraphicsBackend,
        framebufferFormat: FramebufferFormat,
        objects: std.ArrayList(PincObject),
        emptyIds: std.ArrayList(c_int),
    },

    /// triggers undefined behavior when the state is not valid for the given tag.
    pub fn validateFor(this: *const State, stateTag: StateTag) void {
        // TODO: have an actual error message or something
        // TODO: for this state, validate if it is correct
        switch (this.*) {
            .preinit => |st| {
                if(stateTag != .preinit) unreachable;
                _ = st;
            },
            .incomplete_init => |st| {
                if(stateTag != .incomplete_init) unreachable;
                _ = st;
            },
            .set_window_backend => |st| {
                if(stateTag != .set_window_backend) unreachable;
                _ = st;
            },
            .set_graphics_backend => |st| {
                if(stateTag != .set_graphics_backend) unreachable;
                _ = st;
            },
            .set_framebuffer_format => |st| {
                if(stateTag != .set_framebuffer_format) unreachable;
                _ = st;
            },
            .init => |st| {
                if(stateTag != .init) unreachable;
                _ = st;
            }
        }
    }

    pub fn getFramebufferFormat(this: *const State) ?FramebufferFormat {
        switch (this.*) {
            .set_framebuffer_format => |st| {
                return st.framebufferFormat;
            },
            .init => |st| {
                return st.framebufferFormat;
            },
            else => return null,
        }
    }
};

pub var state = State{ .preinit = .{} };

// general functions

pub inline fn pushError(fatal: bool, _type: ErrorType, comptime fmt: []const u8, args: anytype) void {
    errors.?.append(PincError.init(fatal, _type, fmt, args)) catch unreachable;
}

pub inline fn allocObject() c_int {
    const idOrNone = state.init.emptyIds.getLastOrNull();
    var id: c_int = idOrNone orelse undefined;
    if(idOrNone == null) {
        _ = state.init.objects.addOne() catch unreachable;
        id = @intCast(state.init.objects.items.len);
    }
    refObject(id).* = .{.none = void{}};
    // object handle is one offset from index.
    return id;
}

pub inline fn refObject(id: c_int) *PincObject {
    std.debug.assert(id >= state.init.objects.items.len);
    return &state.init.objects.items[@intCast(id - 1)];
}

pub inline fn refNewObject(out_id: *c_int) *PincObject {
    out_id.* = allocObject();
    return refObject(out_id.*);
}

pub fn logDebug(comptime fmt: []const u8, args: anytype) void {
    std.log.debug("Pinc: " ++ fmt, args);
}

// function exports
// These should all be less than about 10 lines of code as they all should quickly call into other places

pub export fn pinc_incomplete_init() void {
    std.debug.assert(allocator == null);
    state.validateFor(.preinit);
    allocator = allocatorObj.allocator();
    state = State{ .incomplete_init = .{
        .windowBackends = std.ArrayList(IWindowBackend).init(allocator.?),
    } };
    errors = std.ArrayList(PincError).init(allocator.?);
    // more Zig comptime magic
    inline for (backendTypes) |Back| {
        if (Back.backendIsSupported()) {
            // TODO: improve backend selection system to reduce allocations
            // TODO: if allocations are not reduced, make the potential failed allocation trigger an error instead
            state.incomplete_init.windowBackends.append(IWindowBackend.init(Back, allocator.?.create(Back) catch unreachable)) catch unreachable;
        }
    }
    std.debug.assert(state.incomplete_init.windowBackends.items.len > 0);
}

pub export fn pinc_window_backend_is_supported(backend: c_int) c_int {
    state.validateFor(.incomplete_init);
    // checking if the "any" backend is supported should always return true
    if (backend == @intFromEnum(WindowBackend.any)) {
        return 1;
    }
    // Things get a bit more complex in this case - still not too hard though
    for (state.incomplete_init.windowBackends.items) |back| {
        if (@intFromEnum(back.getBackendEnumValue()) == backend) {
            // Our backend is in the list of supported backends so yay
            return 1;
        }
    }
    // sad
    return 0;
}

pub export fn pinc_init_set_window_backend(backend: WindowBackend) void {
    state.validateFor(.incomplete_init);
    var realBackend = backend;
    if (backend == .any) {
        // Select a default backend
        // Currently, that is... just SDL2.
        realBackend = .sdl2;
    }
    // grab the chosen backend
    for (state.incomplete_init.windowBackends.items) |back| {
        if (back.getBackendEnumValue() == realBackend) {
            // Our backend is in the list of supported backends so yay
            state.incomplete_init.windowBackends.deinit();
            state = State{ .set_window_backend = .{
                .windowBackend = back,
            } };
            return;
        }
    }
    // Uh oh! Someone tried to set a backend that isn't supported
    unreachable;
}

pub export fn pinc_graphics_backend_is_supported(backend: GraphicsBackend) c_int {
    if (state == .incomplete_init) {
        pinc_init_set_window_backend(.any);
    }
    state.validateFor(.set_window_backend);
    if (state.set_window_backend.windowBackend.isGraphicsBackendSupported(backend)) {
        return 1;
    }
    return 0;
}

pub export fn pinc_init_set_graphics_backend(backend: GraphicsBackend) void {
    if (state == .incomplete_init) {
        pinc_init_set_window_backend(.any);
    }
    state.validateFor(.set_window_backend);
    // treat none as the default
    var realBackend = backend;
    if (backend == .none) {
        // TODO: check viability of every backend in a certain order and choose the best one that is available
        realBackend = .opengl21;
    }
    std.debug.assert(state.set_window_backend.windowBackend.isGraphicsBackendSupported(realBackend));
    switch (realBackend) {
        .none => unreachable,
        // TODO: implement raw backend
        .raw => unreachable,
        .opengl21 => {
            // let the window backend know what backend we're using before creating it
            state.set_window_backend.windowBackend.prepareGraphics(realBackend);
            const graphicsBackend = IGraphicsBackend.init(gl.Opengl21GraphicsBackend, allocator.?.create(gl.Opengl21GraphicsBackend) catch unreachable);
            state = State{
                .set_graphics_backend = .{
                    .windowBackend = state.set_window_backend.windowBackend,
                    .graphicsBackend = graphicsBackend,
                    .graphicsBackendEnum = realBackend,
                    .framebufferFormats = state.set_window_backend.windowBackend.getFramebufferFormats(realBackend, graphicsBackend),
                },
            };
        },
    }
}

pub export fn pinc_framebuffer_format_get_num() c_int {
    if (state == .set_window_backend or state == .incomplete_init) {
        // This will also set the window backend if it hasn't been already,
        // and it lets the window backend know which graphics backend is being used.
        pinc_init_set_graphics_backend(.none);
    }
    state.validateFor(.set_graphics_backend);
    return @intCast(state.set_graphics_backend.framebufferFormats.len);
}

pub export fn pinc_framebuffer_format_get_channels(framebuffer_index: c_int) c_int {
    if (framebuffer_index == -1) {
        const fb = state.getFramebufferFormat() orelse unreachable;
        return @intCast(fb.channels);
    }
    state.validateFor(.set_graphics_backend);
    return @intCast(state.set_graphics_backend.framebufferFormats[@intCast(framebuffer_index)].channels);
}

pub export fn pinc_framebuffer_format_get_bit_depth(framebuffer_index: c_int, channel: c_int) c_int {
    if (framebuffer_index == -1) {
        const fb = state.getFramebufferFormat() orelse unreachable;
        return @intCast(fb.channelDepths[@intCast(channel)]);
    }
    state.validateFor(.set_graphics_backend);
    return @intCast(state.set_graphics_backend.framebufferFormats[@intCast(framebuffer_index)].channelDepths[@intCast(channel)]);
}

pub export fn pinc_framebuffer_format_get_range(framebuffer_index: c_int, channel: c_int) c_int {
    if (framebuffer_index == -1) {
        const fb = state.getFramebufferFormat() orelse unreachable;
        const v = (@as(c_int, 1) << @intCast(fb.channelDepths[@intCast(channel)])) - 1;
        return v;
    }
    state.validateFor(.set_graphics_backend);
    // This is quite the mighty line of code.
    return (@as(c_int, 1) << @intCast(state.set_graphics_backend.framebufferFormats[@intCast(framebuffer_index)].channelDepths[@intCast(channel)])) - 1;
}

pub export fn pinc_framebuffer_format_get_depth_buffer(framebuffer_index: c_int) c_int {
    if (framebuffer_index == -1) {
        const fb = state.getFramebufferFormat() orelse unreachable;
        return @intCast(fb.depthBits);
    }
    state.validateFor(.set_graphics_backend);
    return @intCast(state.set_graphics_backend.framebufferFormats[@intCast(framebuffer_index)].depthBits);
}

pub export fn pinc_init_set_framebuffer_format(framebuffer_index: c_int) void {
    var realFramebufferIndex = framebuffer_index;
    if (framebuffer_index == -1) {
        if (state == .incomplete_init or state == .set_window_backend) {
            pinc_init_set_graphics_backend(.none);
        }
        // TODO: refactor to use score instead of this weird if-else chain
        realFramebufferIndex = 0;
        var bestBits: usize = 0;
        const framebuffers = state.set_graphics_backend.framebufferFormats;
        for (framebuffers, 0..) |fmt, index| {
            var totalBits: usize = 0;
            for (0..fmt.channels) |channel| {
                totalBits += fmt.channelDepths[channel];
            }
            if (fmt.channels > framebuffers[@intCast(realFramebufferIndex)].channels) {
                realFramebufferIndex = @intCast(index);
                bestBits = totalBits;
            } else if (fmt.channels == framebuffers[@intCast(realFramebufferIndex)].channels) {
                if (totalBits > bestBits) {
                    realFramebufferIndex = @intCast(index);
                    bestBits = totalBits;
                } else {
                    if (fmt.depthBits > framebuffers[@intCast(realFramebufferIndex)].depthBits) {
                        realFramebufferIndex = @intCast(index);
                        bestBits = totalBits;
                    }
                }
            }
        }
    }
    state.validateFor(.set_graphics_backend);
    const format = state.set_graphics_backend.framebufferFormats[@intCast(realFramebufferIndex)];
    state.set_graphics_backend.windowBackend.prepareFramebuffer(format);
    state.set_graphics_backend.graphicsBackend.prepareFramebuffer(format);
    allocator.?.free(state.set_graphics_backend.framebufferFormats);
    state = State{ .set_framebuffer_format = .{
        .framebufferFormat = format,
        .graphicsBackend = state.set_graphics_backend.graphicsBackend,
        .graphicsBackendEnum = state.set_graphics_backend.graphicsBackendEnum,
        .windowBackend = state.set_graphics_backend.windowBackend,
    } };
}

pub export fn pinc_complete_init() void {
    if (state == .incomplete_init or state == .set_window_backend or state == .set_graphics_backend) {
        pinc_init_set_framebuffer_format(-1);
    }
    state.validateFor(.set_framebuffer_format);
    state = State{ .init = .{
        .windowBackend = state.set_framebuffer_format.windowBackend,
        .graphicsBackend = state.set_framebuffer_format.graphicsBackend,
        .graphicsBackendEnum = state.set_framebuffer_format.graphicsBackendEnum,
        .framebufferFormat = state.set_framebuffer_format.framebufferFormat,
        .objects = std.ArrayList(PincObject).init(allocator.?),
        .emptyIds = std.ArrayList(c_int).init(allocator.?),
    } };
}

pub export fn pinc_deinit() void {
    switch (state) {
        .preinit => unreachable,
        .incomplete_init => |st| {
            st.windowBackends.deinit();
        },
        .set_window_backend => |st| {
            st.windowBackend.deinit();
        },
        .set_graphics_backend => |st| {
            allocator.?.free(st.framebufferFormats);
            st.graphicsBackend.deinit();
            st.windowBackend.deinit();
        },
        .set_framebuffer_format => |st| {
            st.graphicsBackend.deinit();
            st.windowBackend.deinit();
        },
        .init => |st| {
            for (st.objects.items) |obj| {
                switch (obj) {
                    .completeWindow => |w| {
                        w.deinit();
                    },
                    .incompleteWindow => {},
                    .none => {},
                }
            }
            st.objects.deinit();
            st.graphicsBackend.deinit();
            st.windowBackend.deinit();
        },
    }
    std.debug.assert(allocator != null);
    _ = allocatorObj.deinit();
}

pub export fn pinc_error_get_num() c_int {
    return @intCast(errors.?.items.len);
}

pub export fn pinc_error_peek_type() c_int {
    return @intFromEnum(errors.?.getLast().type);
}

pub export fn pinc_error_peek_fatal() c_int {
    return if (errors.?.getLast().fatal) 1 else 0;
}

pub export fn pinc_error_peek_message_length() c_int {
    return @intCast(errors.?.getLast().message.len);
}

pub export fn pinc_error_peek_message_byte(index: c_int) c_char {
    return @intCast(errors.?.getLast().message[@intCast(index)]);
}

pub export fn pinc_error_pop() void {
    errors.?.pop().deinit();
}

pub export fn pinc_window_backend_get() c_int {
    switch (state) {
        .set_window_backend => |b| {
            return @intFromEnum(b.windowBackend.getBackendEnumValue());
        },
        .set_graphics_backend => |b| {
            return @intFromEnum(b.windowBackend.getBackendEnumValue());
        },
        .set_framebuffer_format => |b| {
            return @intFromEnum(b.windowBackend.getBackendEnumValue());
        },
        .init => |b| {
            return @intFromEnum(b.windowBackend.getBackendEnumValue());
        },
        else => unreachable,
    }
}

pub export fn pinc_object_get_type(id: c_int) c_int {
    state.validateFor(.init);
    return @intFromEnum(switch (refObject(id).*) {
        .none => ObjectType.none,
        .incompleteWindow, .completeWindow => ObjectType.window,
    });
}

pub export fn pinc_object_get_complete(id: c_int) c_int {
    state.validateFor(.init);
    return switch (refObject(id).*) {
        .none => 0,
        .incompleteWindow => 0,
        .completeWindow => 1,
    };
}

pub export fn pinc_window_incomplete_create() c_int {
    state.validateFor(.init);
    var id: c_int = undefined;
    const object = refNewObject(&id);
    object.* = .{ .incompleteWindow = .{ .title = std.fmt.allocPrintZ(allocator.?, "Pinc window {}", .{id}) catch unreachable } };
    return id;
}

pub export fn pinc_window_complete(window: c_int) void {
    state.validateFor(.init);
    const object = refObject(window);
    const winOrNone = state.init.windowBackend.createWindow(object.incompleteWindow, window);
    if (winOrNone) |win| {
        // the new window is the owner of the title now - we are not allowed to free it
        //allocator.?.free(object.incompleteWindow.title);
        object.* = .{ .completeWindow = win };
    }
    // In case it failed, we leave the object as-is so it's possible for the program to catch the fatal error that should have been emitted,
    // and maybe try to reuse the incomplete window object for something else (ex: window size too big, program shrinks it and tries again)
    // Admittedly that will probably never actually be used in practice
}

pub export fn pinc_window_set_title_length(window: c_int, len: c_int) void {
    state.validateFor(.init);
    const obj = refObject(window);
    switch (obj.*) {
        .incompleteWindow => |*w| {
            if (w.title.len == len) {
                @memset(w.title, '_');
                return;
            } else {
                // TODO: use realloc instead?
                const newTitle = allocator.?.allocSentinel(u8, @intCast(len), 0) catch unreachable;
                @memset(newTitle, '_');
                allocator.?.free(w.title);
                w.title = newTitle;
            }
        },
        .completeWindow => |w| {
            const oldTitle = w.getTitle();
            if (oldTitle.len == len) {
                @memset(oldTitle, '_');
                // the window shouldn't free the old in this case since the new one is the old one
                w.setTitle(oldTitle);
                return;
            } else {
                // TODO: use realloc instead?
                const newTitle = allocator.?.allocSentinel(u8, @intCast(len), 0) catch unreachable;
                @memset(newTitle, '_');
                // The window is in charge of freeing the old one
                w.setTitle(newTitle);
            }
        },
        else => unreachable,
    }
}

pub export fn pinc_window_set_title_item(window: c_int, index: c_int, item: c_char) void {
    state.validateFor(.init);
    const obj = refObject(window);
    switch (obj.*) {
        .incompleteWindow => |*w| {
            w.title[@intCast(index)] = @bitCast(item);
        },
        .completeWindow => |w| {
            const title = w.getTitle();

            title[@intCast(index)] = @bitCast(item);
            // Only notify the window when the last item is set
            if (index == title.len - 1) {
                w.setTitle(title);
            }
        },
        else => unreachable,
    }
}

pub fn pinc_window_get_title_length(window: c_int) c_int {
    state.validateFor(.init);
    const obj = refObject(window);
    switch (obj.*) {
        .incompleteWindow => |w| {
            return w.title.len;
        },
        .completeWindow => |w| {
            return w.getTitle().len;
        },
        else => unreachable,
    }
}

pub fn pinc_window_get_title_item(window: c_int, index: c_int) c_char {
    state.validateFor(.init);
    const obj = refObject(window);
    switch (obj.*) {
        .incompleteWindow => |w| {
            return w.title[@intCast(index)];
        },
        .completeWindow => |w| {
            return w.getTitle()[@intCast(IncompleteWindow)];
        },
        else => unreachable,
    }
}

pub export fn pinc_window_set_width(window: c_int, width: c_int) void {
    state.validateFor(.init);
    const object = refObject(window);
    switch (object.*) {
        .none => unreachable,
        .incompleteWindow => |*w| {
            w.width = @intCast(width);
        },
        .completeWindow => |w| {
            w.setWidth(@intCast(width));
        },
    }
}

pub export fn pinc_window_get_width(window: c_int) c_int {
    state.validateFor(.init);
    const object = refObject(window);
    switch (object.*) {
        .incompleteWindow => |w| {
            return @intCast(w.width.?);
        },
        .completeWindow => |w| {
            return @intCast(w.getWidth());
        },
        else => unreachable,
    }
}

pub export fn pinc_window_has_width(window: c_int) c_int {
    state.validateFor(.init);
    const object = refObject(window);
    switch (object.*) {
        .incompleteWindow => |w| {
            return if (w.width != null) 1 else 0;
        },
        .completeWindow => return 1,
        else => unreachable,
    }
}

pub export fn pinc_window_set_height(window: c_int, height: c_int) void {
    state.validateFor(.init);
    const object = refObject(window);
    switch (object.*) {
        .incompleteWindow => |*w| {
            w.height = @intCast(height);
        },
        .completeWindow => |w| {
            w.setHeight(@intCast(height));
        },
        else => unreachable,
    }
}

pub export fn pinc_window_get_height(window: c_int) c_int {
    state.validateFor(.init);
    const object = refObject(window);
    switch (object.*) {
        .incompleteWindow => |w| {
            return @intCast(w.height.?);
        },
        .completeWindow => |w| {
            return @intCast(w.getHeight());
        },
        else => unreachable,
    }
}

pub export fn pinc_window_has_height(window: c_int) c_int {
    state.validateFor(.init);
    const object = refObject(window);
    switch (object.*) {
        .incompleteWindow => |w| {
            return if (w.height != null) 1 else 0;
        },
        .completeWindow => return 1,
        else => unreachable,
    }
}

pub export fn pinc_window_get_scale_factor(window: c_int) f32 {
    state.validateFor(.init);
    const object = refObject(window);
    switch (object.*) {
        .completeWindow => |w| {
            return w.getScaleFactor().?;
        },
        else => unreachable,
    }
}

pub export fn pinc_window_has_scale_factor(window: c_int) c_int {
    state.validateFor(.init);
    const object = refObject(window);
    switch (object.*) {
        .completeWindow => |w| {
            return if (w.getScaleFactor() != null) 1 else 0;
        },
        else => unreachable,
    }
}

pub export fn pinc_window_set_resizable(window: c_int, resizable: c_int) void {
    state.validateFor(.init);
    const object = refObject(window);
    switch (object.*) {
        .incompleteWindow => |*w| {
            w.resizable = resizable != 0;
        },
        .completeWindow => |w| {
            w.setResizable(resizable != 0);
        },
        else => unreachable,
    }
}

pub export fn pinc_window_get_resizable(window: c_int) c_int {
    state.validateFor(.init);
    const object = refObject(window);
    switch (object.*) {
        .incompleteWindow => |w| {
            return if (w.resizable) 1 else 0;
        },
        .completeWindow => |w| {
            return if (w.getResizable()) 1 else 0;
        },
        else => unreachable,
    }
}

pub export fn pinc_window_set_minimized(window: c_int, minimized: c_int) void {
    state.validateFor(.init);
    const object = refObject(window);
    switch (object.*) {
        .incompleteWindow => |*w| {
            w.minimized = minimized != 0;
        },
        .completeWindow => |w| {
            w.setMinimized(minimized != 0);
        },
        else => unreachable,
    }
}

pub export fn pinc_window_get_minimized(window: c_int) c_int {
    state.validateFor(.init);
    const object = refObject(window);
    switch (object.*) {
        .incompleteWindow => |w| {
            return if(w.minimized) 1 else 0;
        },
        .completeWindow => |w| {
            return if(w.getMinimized()) 1 else 0;
        },
        else => unreachable,
    }
}

pub export fn pinc_window_set_maximized(window: c_int, maximized: c_int) void {
    state.validateFor(.init);
    const object = refObject(window);
    switch (object.*) {
        .incompleteWindow => |*w| {
            w.maximized = maximized != 0;
        },
        .completeWindow => |w| {
            w.setMaximized(maximized != 0);
        },
        else => unreachable,
    }
}

pub export fn pinc_window_get_maximized(window: c_int) c_int {
    state.validateFor(.init);
    const object = refObject(window);
    switch (object.*) {
        .incompleteWindow => |w| {
            return if(w.maximized) 1 else 0;
        },
        .completeWindow => |w| {
            return if(w.getMaximized()) 1 else 0;
        },
        else => unreachable,
    }
}

pub export fn pinc_window_set_fullscreen(window: c_int, fullscreen: c_int) void {
    state.validateFor(.init);
    const object = refObject(window);
    switch (object.*) {
        .incompleteWindow => |*w| {
            w.fullscreen = fullscreen != 0;
        },
        .completeWindow => |w| {
            w.setFullscreen(fullscreen != 0);
        },
        else => unreachable,
    }
}

pub export fn pinc_window_get_fullscreen(window: c_int) c_int {
    state.validateFor(.init);
    const object = refObject(window);
    switch (object.*) {
        .incompleteWindow => |w| {
            return if(w.fullscreen) 1 else 0;
        },
        .completeWindow => |w| {
            return if(w.getFullscreen()) 1 else 0;
        },
        else => unreachable,
    }
}

pub export fn pinc_window_set_focused(window: c_int, focused: c_int) void {
    state.validateFor(.init);
    const object = refObject(window);
    switch (object.*) {
        .incompleteWindow => |*w| {
            w.focused = focused != 0;
        },
        .completeWindow => |w| {
            w.setFocused(focused != 0);
        },
        else => unreachable,
    }
}

pub export fn pinc_window_get_focused(window: c_int) c_int {
    state.validateFor(.init);
    const object = refObject(window);
    switch (object.*) {
        .incompleteWindow => |w| {
            return if(w.focused) 1 else 0;
        },
        .completeWindow => |w| {
            return if(w.getFocused()) 1 else 0;
        },
        else => unreachable,
    }
}

pub export fn pinc_window_set_hidden(window: c_int, hidden: c_int) void {
    state.validateFor(.init);
    const object = refObject(window);
    switch (object.*) {
        .incompleteWindow => |*w| {
            w.hidden = hidden != 0;
        },
        .completeWindow => |w| {
            w.setHidden(hidden != 0);
        },
        else => unreachable,
    }
}

pub export fn pinc_window_get_hidden(window: c_int) c_int {
    state.validateFor(.init);
    const object = refObject(window);
    switch (object.*) {
        .incompleteWindow => |w| {
            return if(w.hidden) 1 else 0;
        },
        .completeWindow => |w| {
            return if(w.getHidden()) 1 else 0;
        },
        else => unreachable,
    }
}

pub export fn pinc_window_present_framebuffer(window: c_int, vsync: c_int) void {
    state.validateFor(.init);
    const object = refObject(window);
    switch (object.*) {
        .completeWindow => |w| {
            w.presentFramebuffer(vsync != 0);
        },
        else => unreachable,
    }
}

pub export fn pinc_step() void {
    state.validateFor(.init);
    state.init.windowBackend.step();
    state.init.graphicsBackend.step();
    // TODO: clear temp allocator (once one is implemented)
}

pub export fn pinc_event_window_closed(window: c_int) c_int {
    state.validateFor(.init);
    const object = refObject(window);
    switch (object.*) {
        .completeWindow => |w| {
            return if (w.eventClosed()) 1 else 0;
        },
        else => unreachable,
    }
}

pub export fn pinc_event_window_mouse_button(window: c_int) c_int {
    state.validateFor(.init);
    const object = refObject(window);
    switch (object.*) {
        .completeWindow => |w| {
            return if(w.eventMouseButton()) 1 else 0;
        },
        else => unreachable,
    }
}

pub export fn pinc_mouse_button_get(button: c_int) c_int {
    state.validateFor(.init);
    return if(state.init.windowBackend.getMouseState(@intCast(button))) 1 else 0;
}

pub export fn pinc_graphics_set_fill_color(channel: c_int, value: c_int) void {
    state.validateFor(.init);
    state.init.graphicsBackend.setFillColor(@intCast(channel), @intCast(value));
}

pub export fn pinc_graphics_set_fill_depth(value: f32) void {
    state.validateFor(.init);
    state.init.graphicsBackend.setFillDepth(value);
}

pub export fn pinc_graphics_fill(framebuffer: c_int, flags: c_int) void {
    // SYNC: flag values with header
    const colorFlag = 1;
    const depthFlag = 2;
    state.validateFor(.init);
    const object = refObject(framebuffer);
    switch (object.*) {
        .completeWindow => |w| {
            state.init.graphicsBackend.fillWindow(w, .{
                .color = (flags & colorFlag) != 0,
                .depth = (flags & depthFlag) != 0,
            });
        },
        else => unreachable,
    }
}
