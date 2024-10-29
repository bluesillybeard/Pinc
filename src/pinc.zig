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
    vertex_attributes,
    uniforms,
    shaders,
    pipeline,
    vertex_array,
    texture,
};

pub const KeyboardKey = enum(c_int) {
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

// Types from pinc_graphics.h
// also needs to stay in sync for ABI compatibility
pub const AttribtueType = enum(c_int) {
    float,
    vec2,
    vec3,
    vec4,
    int,
    ivec2,
    ivec3,
    ivec4,
    short,
    svec2,
    svec3,
    svec4,
    byte,
    bvec2,
    bvec3,
    bvec4,
};

pub const UniformType = enum(c_int) {
    float,
    vec2,
    vec3,
    vec4,
    int,
    ivec2,
    ivec3,
    ivec4,
    mat2x2,
    mat3x3,
    mat4x4,
    texture,
};

pub const TextureWrap = enum(c_int) {
    clamp,
    clamp_to_edge,
    clamp_to_border,
    repeat,
    mirrored_repeat,
};

pub const Filter = enum(c_int) {
    nearest,
    linear,
    nearest_mipmap_nearest,
    nearest_mipmap_linear,
    linear_mipmap_nearest,
    linear_mipmap_linear,
};

pub const ShaderType = enum(c_int) {
    glsl,
};

pub const VertexAssembly = enum(c_int) {
    array_triangles,
    array_triangle_fan,
    array_triangle_strip,
    element_triangles,
    element_triangle_fan,
    element_triangle_strip,
};

// other types

pub const maxChannels = 4;

pub const FramebufferFormat = struct {
    // Data given out to Pincs user
    channels: u32,
    channelDepths: [maxChannels]u32,
    depthBits: u32,
    // Data that is used internally
    /// This is to help implementing backends, not used by any of Pinc's backend-agnostic code.
    id: usize,

    pub fn channelsToRgbaColor(this: FramebufferFormat, c1: f32, c2: f32, c3: f32, c4: f32) Color {
        return switch (this.channels) {
            1 => Color{
                .r = c1,
                .g = c1,
                .b = c1,
                .a = 1,
            },
            2 => Color{
                .r = c1,
                .g = c1,
                .b = c1,
                .a = c2,
            },
            3 => Color{
                .r = c1,
                .g = c2,
                .b = c3,
                .a = 1,
            },
            4 => Color{
                .r = c1,
                .g = c2,
                .b = c3,
                .a = c4,
            },
            else => unreachable,
        };
    }
};

pub const Color = struct {
    r: f32,
    g: f32,
    b: f32,
    a: f32,
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

pub const KeyboardButtonEvent = struct {
    key: KeyboardKey,
    repeated: bool,
};

pub const PixelPos = struct {
    x: i32,
    y: i32,
};

pub const Vec2 = struct {
    x: f32,
    y: f32,
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

    pub inline fn eventResized(this: ICompleteWindow) bool {
        return this.vtable.eventResized(this.obj);
    }

    pub inline fn eventWindowFocused(this: ICompleteWindow) bool {
        return this.vtable.eventWindowFocused(this.obj);
    }

    pub inline fn eventWindowUnfocused(this: ICompleteWindow) bool {
        return this.vtable.eventWindowUnfocused(this.obj);
    }

    pub inline fn eventWindowExposed(this: ICompleteWindow) bool {
        return this.vtable.eventWindowExposed(this.obj);
    }

    pub inline fn eventKeyboardButtons(this: ICompleteWindow) []const KeyboardButtonEvent {
        return this.vtable.eventKeyboardButtons(this.obj);
    }

    pub inline fn eventCursorMove(this: ICompleteWindow) bool {
        return this.vtable.eventCursorMove(this.obj);
    }

    pub inline fn eventCursorExit(this: ICompleteWindow) bool {
        return this.vtable.eventCursorExit(this.obj);
    }

    pub inline fn eventCursorEnter(this: ICompleteWindow) bool {
        return this.vtable.eventCursorEnter(this.obj);
    }

    pub inline fn eventText(this: ICompleteWindow) []const u8 {
        return this.vtable.eventText(this.obj);
    }

    pub inline fn eventScroll(this: ICompleteWindow) Vec2 {
        return this.vtable.eventScroll(this.obj);
    }

    pub const Vtable = struct {
        // init is not implemented as part of the vtable.
        deinit: *const fn (this: *anyopaque) void,
        setWidth: *const fn (this: *anyopaque, width: u32) void,
        getWidth: *const fn (this: *anyopaque) u32,
        setHeight: *const fn (this: *anyopaque, height: u32) void,
        getHeight: *const fn (this: *anyopaque) u32,
        getScaleFactor: *const fn (this: *anyopaque) ?f32,
        setResizable: *const fn (this: *anyopaque, resizable: bool) void,
        getResizable: *const fn (this: *anyopaque) bool,
        presentFramebuffer: *const fn (this: *anyopaque, vsync: bool) void,
        eventClosed: *const fn (this: *anyopaque) bool,
        getTitle: *const fn (this: *anyopaque) [:0]u8,
        setTitle: *const fn (this: *anyopaque, title: [:0]u8) void,
        glMakeCurrent: *const fn (this: *anyopaque) void,
        eventMouseButton: *const fn (this: *anyopaque) bool,
        setMinimized: *const fn (this: *anyopaque, bool) void,
        getMinimized: *const fn (this: *anyopaque) bool,
        setMaximized: *const fn (this: *anyopaque, bool) void,
        getMaximized: *const fn (this: *anyopaque) bool,
        setFullscreen: *const fn (this: *anyopaque, bool) void,
        getFullscreen: *const fn (this: *anyopaque) bool,
        setFocused: *const fn (this: *anyopaque, bool) void,
        getFocused: *const fn (this: *anyopaque) bool,
        setHidden: *const fn (this: *anyopaque, bool) void,
        getHidden: *const fn (this: *anyopaque) bool,
        eventResized: *const fn (this: *anyopaque) bool,
        eventWindowFocused: *const fn (this: *anyopaque) bool,
        eventWindowUnfocused: *const fn (this: *anyopaque) bool,
        eventWindowExposed: *const fn (this: *anyopaque) bool,
        eventKeyboardButtons: *const fn (this: *anyopaque) []const KeyboardButtonEvent,
        eventCursorMove: *const fn (this: *anyopaque) bool,
        eventCursorExit: *const fn (this: *anyopaque) bool,
        eventCursorEnter: *const fn (this: *anyopaque) bool,
        eventText: *const fn (this: *anyopaque) []const u8,
        eventScroll: *const fn (this: *anyopaque) Vec2,
    };
    vtable: *const Vtable,
    obj: *anyopaque,
};

pub const IElementArray = struct {};

// Vertex array interface for graphics backends to implement
pub const IVertexArray = struct {
    pub fn init(comptime T: type, obj: *T) IVertexArray {
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
        return IVertexArray{
            .vtable = vtable,
            .obj = obj,
        };
    }

    pub inline fn deinit(this: IVertexArray) void {
        this.vtable.deinit(this.obj);
    }

    pub inline fn lock(this: IVertexArray) void {
        this.vtable.lock(this.obj);
    }

    pub inline fn unlock(this: IVertexArray) void {
        this.vtable.unlock(this.obj);
    }

    pub inline fn setItemVec2(this: IVertexArray, vertex: usize, attribute: usize, v: [2]f32) void {
        this.vtable.setItemVec2(this.obj, vertex, attribute, v);
    }

    pub inline fn setItemVec4(this: IVertexArray, vertex: usize, attribute: usize, v: [4]f32) void {
        this.vtable.setItemVec4(this.obj, vertex, attribute, v);
    }

    pub const Vtable = struct {
        deinit: *const fn (this: *anyopaque) void,
        lock: *const fn (this: *anyopaque) void,
        unlock: *const fn (this: *anyopaque) void,
        setItemVec2: *const fn (this: *anyopaque, vertex: usize, attribute: usize, v: [2]f32) void,
        setItemVec4: *const fn (this: *anyopaque, vertex: usize, attribute: usize, v: [4]f32) void,
    };

    vtable: *Vtable,
    obj: *anyopaque,
};

// Texture interface for graphics backends to implement
pub const ITexture = struct {};

pub const VertexAttribute = struct {
    type: AttribtueType = .vec4,
    offset: usize = 0,
    normalize: bool = false,
};

pub const VertexAttributesObj = struct {
    // Note: OpenGL only guarantees a maximum of 16 4 component attributes.
    // TODO: find a better maximum for the memory storage
    pub const MaxNumAttributes = 16;
    numAttribs: usize = 0,
    stride: usize = 0,
    attribsBuffer: [MaxNumAttributes]VertexAttribute = undefined,

    pub fn setLength(this: *VertexAttributesObj, len: usize) void {
        if (len > this.numAttribs) {
            // make sure the new spots are undefined so if they are attempted to be used, they will cause a clear error.
            for (this.numAttribs..len) |index| {
                this.attribsBuffer[index] = undefined;
            }
        }
    }

    // C++ style copy constructor
    pub inline fn copy(this: *const VertexAttributesObj) VertexAttributesObj {
        // all memory is inline, no references to external references
        return this.*;
    }
};

pub const Uniform = union(UniformType) {
    float,
    vec2,
    vec3,
    vec4,
    int,
    ivec2,
    ivec3,
    ivec4,
    mat2x2,
    mat3x3,
    mat4x4,
    texture: struct {
        wrap: TextureWrap,
        minFilter: Filter,
        maxFilter: Filter,
        mipmap: bool,
    },
};

pub const UniformsObj = struct {
    pub const MAX_UNIFORMS = 16;
    uniformsBuffer: [MAX_UNIFORMS]Uniform = undefined,
    numUniforms: usize = 0,

    // C++ style copy constructor.
    // Yikes, I really am becoming a C++ developer, despite not even using C++...
    pub inline fn copy(this: *UniformsObj) UniformsObj {
        // For now, a uniforms object is fully inline - no references to external memory.
        // So just dereference this.
        return this.*;
    }
};

// This is a heavy struct. Copying this is expensive. Generally, try to pass references to it instead.
pub const ShadersObj = union(ShaderType) {
    glsl: GlslShadersObj,
};

pub const GlslShadersObj = struct {
    pub const maxAttributeMaps = 16;
    // these are on the heap
    vertexSource: [:0]u8,
    fragmentSource: [:0]u8,
    numAttributeMaps: usize = 0,
    // lol memory efficiency is for losers anyway
    // TODO: fix this memory use disaster (ok it's not THAT bad... only like 1 kb per instance or something like that)
    // The issue is when you realize that *all* pinc objects become at least 1kb per instance due the fact that all object types are in a union.
    attributeMaps: [maxAttributeMaps]AttributeMap = undefined,
    // Whoops, another kilobyte per object, my bad
    numUniformMaps: usize = 0,
    uniformMaps: [UniformsObj.MAX_UNIFORMS]UniformMap = undefined,
};

pub const AttributeMap = struct {
    pub const maxAttributeNameSize = 32;
    nameLen: usize,
    name: [maxAttributeNameSize]u8,
};

pub const UniformMap = struct {
    pub const maxUniformNameSize = 32;
    nameLen: usize,
    name: [maxUniformNameSize]u8,
};

pub const PipelineInitData = struct {
    vertexAttribsObj: c_int,
    uniformsObj: c_int,
    shadersObj: c_int,
    assembly: VertexAssembly,
};

// this is a heavy struct. Copying it is expensive. Generally, try to pass references of it instead.
pub const PincObject = union(enum) {
    none,
    incompleteWindow: IncompleteWindow,
    completeWindow: ICompleteWindow,
    vertexAttributes: VertexAttributesObj,
    uniforms: UniformsObj,
    shaders: ShadersObj,
    incompletePipeline: PipelineInitData,
    completePipeline: IPipeline,
    vertexArray: IVertexArray,
    texture: ITexture,
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

    pub inline fn getKeyboardState(this: IWindowBackend, button: KeyboardKey) bool {
        return this.vtable.getKeyboardState(this.obj, button);
    }

    pub inline fn getCursorPos(this: IWindowBackend) PixelPos {
        return this.vtable.getCursorPos(this.obj);
    }

    // For when we need an OpenGL context to be current, but we don't care which window.
    pub inline fn glMakeAnyCurrent(this: IWindowBackend) void {
        return this.vtable.glMakeAnyCurrent(this.obj);
    }

    pub const Vtable = struct {
        // TODO: Be more smart about how window backends are handled and get rid of this function
        getBackendEnumValue: *const fn (this: *anyopaque) WindowBackend,
        isGraphicsBackendSupported: *const fn (this: *anyopaque, backend: GraphicsBackend) bool,
        deinit: *const fn (this: *anyopaque) void,
        prepareGraphics: *const fn (this: *anyopaque, backend: GraphicsBackend) void,
        getFramebufferFormats: *const fn (this: *anyopaque, graphicsBackendEnum: GraphicsBackend, graphicsBackend: IGraphicsBackend) []const FramebufferFormat,
        prepareFramebuffer: *const fn (this: *anyopaque, framebuffer: FramebufferFormat) void,
        createWindow: *const fn (this: *anyopaque, data: IncompleteWindow, id: c_int) ?ICompleteWindow,
        step: *const fn (this: *anyopaque) void,
        glGetProc: *const fn (this: *anyopaque, name: [:0]const u8) ?*anyopaque,
        getMouseState: *const fn (this: *anyopaque, button: u32) bool,
        getKeyboardState: *const fn (this: *anyopaque, button: KeyboardKey) bool,
        getCursorPos: *const fn (this: *anyopaque) PixelPos,
        glMakeAnyCurrent: *const fn (this: *anyopaque) void,
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

    pub inline fn fillColor(this: IGraphicsBackend, window: ICompleteWindow, c1: f32, c2: f32, c3: f32, c4: f32) void {
        this.vtable.fillColor(this.obj, window, c1, c2, c3, c4);
    }

    pub inline fn fillDepth(this: IGraphicsBackend, window: ICompleteWindow, depth: f32) void {
        this.vtable.fillDepth(this.obj, window, depth);
    }

    pub inline fn createPipeline(this: IGraphicsBackend, initData: PipelineInitData) ?IPipeline {
        return this.vtable.createPipeline(this.obj, initData);
    }

    pub inline fn createVertexArray(this: IGraphicsBackend, attributes: *const VertexAttributesObj, num: usize) ?IVertexArray {
        return this.vtable.createVertexArray(this.obj, attributes, num);
    }

    pub inline fn draw(this: IGraphicsBackend, window: ICompleteWindow, pipeline: IPipeline, vertexArray: IVertexArray, elementArray: ?IElementArray) void {
        this.vtable.draw(this.obj, window, pipeline, vertexArray, elementArray);
    }

    pub inline fn done(this: IGraphicsBackend) void {
        this.vtable.done(this.obj);
    }

    pub inline fn vertexAttributeAlign(this: IGraphicsBackend, _type: AttribtueType) u32 {
        return this.vtable.vertexAttributeAlign(this.obj, _type);
    }

    pub inline fn glslVersionSupported(this: IGraphicsBackend, major: u32, minor: u32, patch: u32) bool {
        return this.vtable.glslVersionSupported(this.obj, major, minor, patch);
    }

    pub const Vtable = struct {
        prepareFramebuffer: *const fn (this: *anyopaque, framebuffer: FramebufferFormat) void,
        deinit: *const fn (this: *anyopaque) void,
        step: *const fn (this: *anyopaque) void,
        fillColor: *const fn (this: *anyopaque, window: ICompleteWindow, c1: f32, c2: f32, c3: f32, c4: f32) void,
        fillDepth: *const fn (this: *anyopaque, window: ICompleteWindow, depth: f32) void,
        createPipeline: *const fn (this: *anyopaque, initData: PipelineInitData) ?IPipeline,
        createVertexArray: *const fn (this: *anyopaque, attributes: *const VertexAttributesObj, num: usize) ?IVertexArray,
        draw: *const fn (this: *anyopaque, window: ICompleteWindow, pipeline: IPipeline, vertexArray: IVertexArray, elementArray: ?IElementArray) void,
        done: *const fn (this: *anyopaque) void,
        vertexAttributeAlign: *const fn (this: *anyopaque, _type: AttribtueType) u32,
        glslVersionSupported: *const fn (this: *anyopaque, major: u32, minor: u32, patch: u32) bool,
    };

    vtable: *Vtable,
    obj: *anyopaque,
};

pub const IPipeline = struct {
    pub fn init(comptime T: type, obj: *T) IPipeline {
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
        return IPipeline{
            .vtable = vtable,
            .obj = obj,
        };
    }

    pub inline fn deinit(this: IPipeline) void {
        this.vtable.deinit(this.obj);
    }

    pub inline fn setVec4(this: IPipeline, uniform: u32, v1: f32, v2: f32, v3: f32, v4: f32) void {
        this.vtable.setVec4(this.obj, uniform, v1, v2, v3, v4);
    }

    pub const Vtable = struct {
        deinit: *const fn (this: *anyopaque) void,
        setVec4: *const fn (this: *anyopaque, uniform: u32, v1: f32, v2: f32, v3: f32, v4: f32) void,
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
                if (stateTag != .preinit) unreachable;
                _ = st;
            },
            .incomplete_init => |st| {
                if (stateTag != .incomplete_init) unreachable;
                _ = st;
            },
            .set_window_backend => |st| {
                if (stateTag != .set_window_backend) unreachable;
                _ = st;
            },
            .set_graphics_backend => |st| {
                if (stateTag != .set_graphics_backend) unreachable;
                _ = st;
            },
            .set_framebuffer_format => |st| {
                if (stateTag != .set_framebuffer_format) unreachable;
                _ = st;
            },
            .init => |st| {
                if (stateTag != .init) unreachable;
                _ = st;
            },
        }
    }

    pub inline fn getFramebufferFormat(this: *const State) ?FramebufferFormat {
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

    pub inline fn getGraphicsBackendEnum(this: *const State) ?GraphicsBackend {
        return switch (this.*) {
            .set_graphics_backend => |st| st.graphicsBackendEnum,
            .set_framebuffer_format => |st| st.graphicsBackendEnum,
            .init => |st| st.graphicsBackendEnum,
            else => null,
        };
    }

    pub inline fn getGraphicsBackend(this: *const State) ?IGraphicsBackend {
        return switch (this.*) {
            .set_graphics_backend => |st| st.graphicsBackend,
            .set_framebuffer_format => |st| st.graphicsBackend,
            .init => |st| st.graphicsBackend,
            else => null,
        };
    }

    pub inline fn getWindowBackend(this: *const State) ?IWindowBackend {
        return switch (this.*) {
            .set_window_backend => |st| st.windowBackend,
            .set_graphics_backend => |st| st.windowBackend,
            .set_framebuffer_format => |st| st.windowBackend,
            .init => |st| st.windowBackend,
            else => null,
        };
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
    if (idOrNone == null) {
        _ = state.init.objects.addOne() catch unreachable;
        id = @intCast(state.init.objects.items.len);
    }
    refObject(id).* = .{ .none = void{} };
    // object handle is one offset from index.
    return id;
}

pub inline fn refObject(id: c_int) *PincObject {
    std.debug.assert(id <= state.init.objects.items.len);
    return &state.init.objects.items[@intCast(id - 1)];
}

pub inline fn refNewObject(out_id: *c_int) *PincObject {
    out_id.* = allocObject();
    return refObject(out_id.*);
}

pub inline fn deallocObject(id: c_int) void {
    std.debug.assert(id <= state.init.objects.items.len);
    state.init.objects.items[@intCast(id - 1)] = .none;
    var rid = id;
    while (rid == state.init.objects.items.len) {
        _ = state.init.objects.popOrNull();
        rid -= 1;
    }
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
                    .vertexAttributes => {},
                    .uniforms => {},
                    .shaders => |ob| {
                        if (ob.glsl.fragmentSource.len > 0) {
                            allocator.?.free(ob.glsl.fragmentSource);
                        }
                        if (ob.glsl.vertexSource.len > 0) {
                            allocator.?.free(ob.glsl.vertexSource);
                        }
                    },
                    .incompletePipeline => {},
                    // TODO:
                    .vertexArray => |ob| {
                        ob.deinit();
                    },
                    // TODO:
                    .texture => {},
                    .none => {},
                    // TODO
                    .completePipeline => |ob| {
                        ob.deinit();
                    },
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
        .incompletePipeline => ObjectType.pipeline,
        .shaders => ObjectType.shaders,
        .texture => ObjectType.texture,
        .uniforms => ObjectType.uniforms,
        .vertexArray => ObjectType.vertex_array,
        .vertexAttributes => ObjectType.vertex_attributes,
        .completePipeline => ObjectType.pipeline,
    });
}

pub export fn pinc_object_get_complete(id: c_int) c_int {
    state.validateFor(.init);
    return switch (refObject(id).*) {
        .none => 0,
        .incompleteWindow => 0,
        .completeWindow => 1,
        .incompletePipeline => 0,
        .shaders => 1,
        .texture => 1,
        .uniforms => 1,
        .vertexArray => 1,
        .vertexAttributes => 1,
        .completePipeline => 1,
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
        else => unreachable,
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
            return if (w.minimized) 1 else 0;
        },
        .completeWindow => |w| {
            return if (w.getMinimized()) 1 else 0;
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
            return if (w.maximized) 1 else 0;
        },
        .completeWindow => |w| {
            return if (w.getMaximized()) 1 else 0;
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
            return if (w.fullscreen) 1 else 0;
        },
        .completeWindow => |w| {
            return if (w.getFullscreen()) 1 else 0;
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
            return if (w.focused) 1 else 0;
        },
        .completeWindow => |w| {
            return if (w.getFocused()) 1 else 0;
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
            return if (w.hidden) 1 else 0;
        },
        .completeWindow => |w| {
            return if (w.getHidden()) 1 else 0;
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

pub export fn pinc_mouse_button_get(button: c_int) c_int {
    state.validateFor(.init);
    return if (state.init.windowBackend.getMouseState(@intCast(button))) 1 else 0;
}

pub export fn pinc_keyboard_key_get(button: c_int) c_int {
    state.validateFor(.init);
    return if (state.init.windowBackend.getKeyboardState(@enumFromInt(button))) 1 else 0;
}

pub export fn pinc_get_cursor_x() c_int {
    state.validateFor(.init);
    return @intCast(state.init.windowBackend.getCursorPos().x);
}

pub export fn pinc_get_cursor_y() c_int {
    state.validateFor(.init);
    return @intCast(state.init.windowBackend.getCursorPos().y);
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
            return if (w.eventMouseButton()) 1 else 0;
        },
        else => unreachable,
    }
}

pub export fn pinc_event_window_resized(window: c_int) c_int {
    state.validateFor(.init);
    const object = refObject(window);
    switch (object.*) {
        .completeWindow => |w| {
            return if (w.eventResized()) 1 else 0;
        },
        else => unreachable,
    }
}

pub export fn pinc_event_window_focused(window: c_int) c_int {
    state.validateFor(.init);
    const object = refObject(window);
    switch (object.*) {
        .completeWindow => |w| {
            return if (w.eventWindowFocused()) 1 else 0;
        },
        else => unreachable,
    }
}

pub export fn pinc_event_window_unfocused(window: c_int) c_int {
    state.validateFor(.init);
    const object = refObject(window);
    switch (object.*) {
        .completeWindow => |w| {
            return if (w.eventWindowUnfocused()) 1 else 0;
        },
        else => unreachable,
    }
}

pub export fn pinc_event_window_exposed(window: c_int) c_int {
    state.validateFor(.init);
    const object = refObject(window);
    switch (object.*) {
        .completeWindow => |w| {
            return if (w.eventWindowExposed()) 1 else 0;
        },
        else => unreachable,
    }
}

pub export fn pinc_event_window_keyboard_button_num(window: c_int) c_int {
    state.validateFor(.init);
    const object = refObject(window);
    switch (object.*) {
        .completeWindow => |w| {
            return @intCast(w.eventKeyboardButtons().len);
        },
        else => unreachable,
    }
}

pub export fn pinc_event_window_keyboard_button_get(window: c_int, index: c_int) c_int {
    state.validateFor(.init);
    const object = refObject(window);
    switch (object.*) {
        .completeWindow => |w| {
            return @intCast(@intFromEnum(w.eventKeyboardButtons()[@intCast(index)].key));
        },
        else => unreachable,
    }
}

pub export fn pinc_event_window_keyboard_button_get_repeat(window: c_int, index: c_int) c_int {
    state.validateFor(.init);
    const object = refObject(window);
    switch (object.*) {
        .completeWindow => |w| {
            return if (w.eventKeyboardButtons()[@intCast(index)].repeated) 1 else 0;
        },
        else => unreachable,
    }
}

pub export fn pinc_event_window_cursor_move(window: c_int) c_int {
    state.validateFor(.init);
    const object = refObject(window);
    switch (object.*) {
        .completeWindow => |w| {
            return if (w.eventCursorMove()) 1 else 0;
        },
        else => unreachable,
    }
}

pub export fn pinc_event_window_cursor_exit(window: c_int) c_int {
    state.validateFor(.init);
    const object = refObject(window);
    switch (object.*) {
        .completeWindow => |w| {
            return if (w.eventCursorExit()) 1 else 0;
        },
        else => unreachable,
    }
}

pub export fn pinc_event_window_cursor_enter(window: c_int) c_int {
    state.validateFor(.init);
    const object = refObject(window);
    switch (object.*) {
        .completeWindow => |w| {
            return if (w.eventCursorEnter()) 1 else 0;
        },
        else => unreachable,
    }
}

pub export fn pinc_event_window_text_len(window: c_int) c_int {
    state.validateFor(.init);
    const object = refObject(window);
    switch (object.*) {
        .completeWindow => |w| {
            return @intCast(w.eventText().len);
        },
        else => unreachable,
    }
}

pub export fn pinc_event_window_text_item(window: c_int, index: c_int) c_char {
    state.validateFor(.init);
    const object = refObject(window);
    switch (object.*) {
        .completeWindow => |w| {
            return @intCast(w.eventText()[@intCast(index)]);
        },
        else => unreachable,
    }
}

pub export fn pinc_event_window_scroll_vertical(window: c_int) f32 {
    state.validateFor(.init);
    const object = refObject(window);
    switch (object.*) {
        .completeWindow => |w| {
            return w.eventScroll().y;
        },
        else => unreachable,
    }
}

pub export fn pinc_event_window_scroll_horizontal(window: c_int) f32 {
    state.validateFor(.init);
    const object = refObject(window);
    switch (object.*) {
        .completeWindow => |w| {
            return w.eventScroll().x;
        },
        else => unreachable,
    }
}

// Graphics Functions (well, the ones that have been implemented at least)

pub export fn pinc_graphics_vertex_attributes_type_align(_type: AttribtueType) c_int {
    state.validateFor(.init);
    return @intCast(state.getGraphicsBackend().?.vertexAttributeAlign(_type));
}

pub export fn pinc_graphics_vertex_attributes_max_num() c_int {
    // TODO: for now this is hard-set at a static number
    // In the future it will be indeterminant and will depend on the graphics backend at runtime.
    return VertexAttributesObj.MaxNumAttributes;
}

pub export fn pinc_graphics_uniforms_max_num() c_int {
    // TODO: for now this is hard-set at a static number
    // In the future it will be indeterminant and will depend on the graphics backend at runtime.
    return UniformsObj.MAX_UNIFORMS;
}

pub export fn pinc_graphics_texture_max_size() c_int {
    // TODO: implement
    unreachable;
}

pub export fn pinc_graphics_shader_glsl_version_supported(major: c_int, minor: c_int, patch: c_int) c_int {
    state.validateFor(.init);
    return if (state.getGraphicsBackend().?.glslVersionSupported(@intCast(major), @intCast(minor), @intCast(patch))) 1 else 0;
}

pub export fn pinc_graphics_vertex_attributes_create(num: c_int) c_int {
    if (num > VertexAttributesObj.MaxNumAttributes) unreachable;
    state.validateFor(.init);
    var id: c_int = undefined;
    const object = refNewObject(&id);
    object.* = .{ .vertexAttributes = .{ .numAttribs = @intCast(num) } };
    return id;
}

pub export fn pinc_graphics_vertex_attributes_deinit(vertex_attributes_obj: c_int) void {
    state.validateFor(.init);
    deallocObject(vertex_attributes_obj);
}

pub export fn pinc_graphics_vertex_attributes_set_item(vertex_attributes_obj: c_int, index: c_int, attrib_type: c_int, offset: c_int, normalize: c_int) void {
    state.validateFor(.init);
    const vertexAttributes = &(refObject(vertex_attributes_obj).*.vertexAttributes);
    if (vertexAttributes.numAttribs <= index) unreachable;
    vertexAttributes.attribsBuffer[@intCast(index)] = .{
        .normalize = normalize != 0,
        .offset = @intCast(offset),
        .type = @enumFromInt(attrib_type),
    };
}

pub export fn pinc_graphics_vertex_attributes_set_stride(vertex_attributes_obj: c_int, stride: c_int) void {
    state.validateFor(.init);
    const vertexAttributes = &(refObject(vertex_attributes_obj).*.vertexAttributes);
    vertexAttributes.stride = @intCast(stride);
}

pub export fn pinc_graphics_uniforms_create(num: c_int) c_int {
    state.validateFor(.init);
    var id: c_int = undefined;
    const object = refNewObject(&id);
    if(num > pinc_graphics_uniforms_max_num()) unreachable;
    object.* = .{ .uniforms = .{
        .numUniforms = @intCast(num),
    } };
    return id;
}

pub export fn pinc_graphics_uniforms_deinit(uniforms_obj: c_int) void {
    state.validateFor(.init);
    deallocObject(uniforms_obj);
}

pub export fn pinc_graphics_uniforms_set_item(uniforms_obj: c_int, index: c_int, _type: UniformType) void {
    state.validateFor(.init);
    const uniforms = &refObject(uniforms_obj).*.uniforms;
    if(index >= uniforms.numUniforms) unreachable;
    // This is what I get for using a union to store the texture sampler data
    // TODO: Arguably that belongs in the pipeline anyway - I'll fix that later.
    // TODO: Do the above one first, but if that never happens then at least implement the rest of the types
    uniforms.uniformsBuffer[@intCast(index)] = switch (_type) {
        .vec4 => .{.vec4 = void{}},
        else => unreachable,
    };
}

pub export fn pinc_graphics_uniforms_set_item_texture_sampler_properties(uniforms_obj: c_int, index: c_int, wrap: TextureWrap, min_filter: Filter, mag_filter: Filter, mipmap: c_int) void {
    _ = uniforms_obj;
    _ = index;
    _ = wrap;
    _ = min_filter;
    _ = mag_filter;
    _ = mipmap;
    // TODO: implement
    unreachable;
}

pub export fn pinc_graphics_shaders_create(shaders_type: c_int) c_int {
    state.validateFor(.init);
    var id: c_int = undefined;
    const shaderType: ShaderType = @enumFromInt(shaders_type);
    const object = refNewObject(&id);
    object.* = .{
        .shaders = switch (shaderType) {
            // TODO: ok seriously what is the correct way to make a sentinel terminated string set to empty?
            // Also zig fmt is responsible for putting this mess into one line. If I had my way, this would spit across like 5 lines.
            ShaderType.glsl => .{ .glsl = .{ .fragmentSource = @constCast(&[0:0]u8{}), .vertexSource = @constCast(&[0:0]u8{}) } },
        },
    };
    return id;
}

pub export fn pinc_graphics_shaders_deinit(shaders_obj: c_int) void {
    state.validateFor(.init);
    // shader objects have some memory that needs to be freed first
    const obj = refObject(shaders_obj);
    const frag = obj.shaders.glsl.fragmentSource;
    if (frag.len > 0) {
        allocator.?.free(frag);
    }
    const vert = obj.shaders.glsl.vertexSource;
    if (vert.len > 0) {
        allocator.?.free(vert);
    }
    deallocObject(shaders_obj);
}

pub export fn pinc_graphics_shaders_glsl_vertex_set_len(shaders_obj: c_int, len: c_int) void {
    state.validateFor(.init);
    const glslShaders = &(refObject(shaders_obj).*.shaders.glsl);
    if (glslShaders.vertexSource.len > 0) {
        allocator.?.free(glslShaders.vertexSource);
    }
    if (len > 0) {
        glslShaders.vertexSource = allocator.?.allocSentinel(u8, @intCast(len), 0) catch unreachable;
    } else {
        glslShaders.vertexSource = @constCast(&[0:0]u8{});
    }
}

pub export fn pinc_graphics_shaders_glsl_vertex_set_item(shaders_obj: c_int, index: c_int, item: c_char) void {
    state.validateFor(.init);
    refObject(shaders_obj).shaders.glsl.vertexSource[@intCast(index)] = @intCast(item);
}

pub export fn pinc_graphics_shaders_glsl_fragment_set_len(shaders_obj: c_int, len: c_int) void {
    state.validateFor(.init);
    const glslShaders = &(refObject(shaders_obj).*.shaders.glsl);
    if (glslShaders.fragmentSource.len > 0) {
        allocator.?.free(glslShaders.fragmentSource);
    }
    if (len > 0) {
        glslShaders.fragmentSource = allocator.?.allocSentinel(u8, @intCast(len), 0) catch unreachable;
    } else {
        // length is zero, so a pointer to invalid memory is ok. There's almost certainly a correct way to do this that I have missed.
        glslShaders.fragmentSource = @constCast(&[0:0]u8{});
    }
}

pub export fn pinc_graphics_shaders_glsl_fragment_set_item(shaders_obj: c_int, index: c_int, item: c_char) void {
    state.validateFor(.init);
    refObject(shaders_obj).shaders.glsl.fragmentSource[@intCast(index)] = @intCast(item);
}

pub export fn pinc_graphics_shaders_glsl_attribute_mapping_set_num(shaders_obj: c_int, num: c_int) void {
    state.validateFor(.init);
    const object = &refObject(shaders_obj).shaders;
    object.glsl.numAttributeMaps = @intCast(num);
    object.glsl.attributeMaps = undefined;
    for (0..@intCast(num)) |index| {
        object.glsl.attributeMaps[index] = .{
            .name = undefined,
            .nameLen = 0,
        };
    }
}

pub export fn pinc_graphics_shaders_glsl_attribute_mapping_set_item_length(shaders_obj: c_int, attribute: c_int, len: c_int) void {
    state.validateFor(.init);
    const object = &refObject(shaders_obj).shaders;
    if (attribute > object.glsl.attributeMaps.len) unreachable;
    if (len > object.glsl.attributeMaps[0].name.len) unreachable;
    object.glsl.attributeMaps[@intCast(attribute)].nameLen = @intCast(len);
}

pub export fn pinc_graphics_shaders_glsl_attribute_mapping_set_item(shaders_obj: c_int, attribute: c_int, index: c_int, item: c_char) void {
    state.validateFor(.init);
    const object = &refObject(shaders_obj).shaders;
    if (attribute > object.glsl.attributeMaps.len) unreachable;
    if (index >= object.glsl.attributeMaps[@intCast(attribute)].nameLen) unreachable;
    object.glsl.attributeMaps[@intCast(attribute)].name[@intCast(index)] = @intCast(item);
}

pub export fn pinc_graphics_shaders_glsl_uniform_mapping_set_num(shaders_obj: c_int, num: c_int) void {
    state.validateFor(.init);
    const object = &refObject(shaders_obj).shaders;
    if(num > pinc_graphics_uniforms_max_num()) unreachable;
    object.glsl.numUniformMaps = @intCast(num);
    object.glsl.uniformMaps = undefined;
}

pub export fn pinc_graphics_shaders_glsl_uniform_mapping_set_item_length(shaders_obj: c_int, uniform: c_int, len: c_int) void {
    state.validateFor(.init);
    const object = &refObject(shaders_obj).shaders;
    if(uniform > object.glsl.numUniformMaps) unreachable;
    if(len > UniformMap.maxUniformNameSize) unreachable;
    object.glsl.uniformMaps[@intCast(uniform)].nameLen = @intCast(len);
}

pub export fn pinc_graphics_shaders_glsl_uniform_mapping_set_item(shaders_obj: c_int, uniform: c_int, index: c_int, value: c_char) void {
    state.validateFor(.init);
    const object = &refObject(shaders_obj).shaders;
    if(uniform > object.glsl.numUniformMaps) unreachable;
    if(index > object.glsl.uniformMaps[@intCast(uniform)].nameLen) unreachable;
    object.glsl.uniformMaps[@intCast(uniform)].name[@intCast(index)] = @intCast(value);
}

pub export fn pinc_graphics_pipeline_incomplete_create(vertex_attributes_obj: c_int, uniforms_obj: c_int, shaders_obj: c_int, assembly: c_int) c_int {
    state.validateFor(.init);
    var id: c_int = undefined;
    const object = refNewObject(&id);
    // TODO: verify these objects exist but only in 'unsafe' modes
    object.* = .{ .incompletePipeline = .{
        .vertexAttribsObj = vertex_attributes_obj,
        .uniformsObj = uniforms_obj,
        .shadersObj = shaders_obj,
        .assembly = @enumFromInt(assembly),
    } };
    return id;
}

pub export fn pinc_graphics_pipeline_complete(pipeline_obj: c_int) void {
    state.validateFor(.init);
    const initData = refObject(pipeline_obj).*.incompletePipeline;
    const pipeline = state.getGraphicsBackend().?.createPipeline(initData);
    if (pipeline == null) {
        // Something went wrong - the graphics backend should have created an error for this
        return;
    }
    refObject(pipeline_obj).* = .{ .completePipeline = pipeline.? };
}

pub export fn pinc_graphics_pipeline_deinit(pipeline_obj: c_int) void {
    state.validateFor(.init);
    const object = refObject(pipeline_obj).completePipeline;
    object.deinit();
}

pub export fn pinc_graphics_pipeline_set_uniform_float(pipeline_obj: c_int, uniform: c_int, v: f32) void {
    _ = pipeline_obj;
    _ = uniform;
    _ = v;
    // TODO: implement
    unreachable;
}

pub export fn pinc_graphics_pipeline_set_uniform_vec2(pipeline_obj: c_int, uniform: c_int, v1: f32, v2: f32) void {
    _ = pipeline_obj;
    _ = uniform;
    _ = v1;
    _ = v2;
    // TODO: implement
    unreachable;
}

pub export fn pinc_graphics_pipeline_set_uniform_vec3(pipeline_obj: c_int, uniform: c_int, v1: f32, v2: f32, v3: f32) void {
    _ = pipeline_obj;
    _ = uniform;
    _ = v1;
    _ = v2;
    _ = v3;
    // TODO: implement
    unreachable;
}

pub export fn pinc_graphics_pipeline_set_uniform_vec4(pipeline_obj: c_int, uniform: c_int, v1: f32, v2: f32, v3: f32, v4: f32) void {
    state.validateFor(.init);
    const object = &refObject(pipeline_obj).completePipeline;
    object.setVec4(@intCast(uniform), v1, v2, v3, v4);
}

pub export fn pinc_graphics_pipeline_set_uniform_int(pipeline_obj: c_int, uniform: c_int, v: c_int) void {
    _ = pipeline_obj;
    _ = uniform;
    _ = v;
    // TODO: implement
    unreachable;
}

pub export fn pinc_graphics_pipeline_set_uniform_ivec2(pipeline_obj: c_int, uniform: c_int, v1: c_int, v2: c_int) void {
    _ = pipeline_obj;
    _ = uniform;
    _ = v1;
    _ = v2;
    // TODO: implement
    unreachable;
}

pub export fn pinc_graphics_pipeline_set_uniform_ivec3(pipeline_obj: c_int, uniform: c_int, v1: c_int, v2: c_int, v3: c_int) void {
    _ = pipeline_obj;
    _ = uniform;
    _ = v1;
    _ = v2;
    _ = v3;
    // TODO: implement
    unreachable;
}

pub export fn pinc_graphics_pipeline_set_uniform_ivec4(pipeline_obj: c_int, uniform: c_int, v1: c_int, v2: c_int, v3: c_int, v4: c_int) void {
    _ = pipeline_obj;
    _ = uniform;
    _ = v1;
    _ = v2;
    _ = v3;
    _ = v4;
    // TODO: implement
    unreachable;
}

pub export fn pinc_graphics_vertex_array_create(vertex_attributes_obj: c_int, num: c_int) c_int {
    state.validateFor(.init);
    const vertexArray = state.getGraphicsBackend().?.createVertexArray(&refObject(vertex_attributes_obj).*.vertexAttributes, @intCast(num));
    if (vertexArray == null) {
        // backend should have created an error for this
        return 0;
    }
    var id: c_int = undefined;
    refNewObject(&id).* = .{ .vertexArray = vertexArray.? };
    return id;
}

pub export fn pinc_graphics_vertex_array_deinit(vertex_array_obj: c_int) void {
    state.validateFor(.init);
    const object = refObject(vertex_array_obj).vertexArray;
    object.deinit();
}

pub export fn pinc_graphics_vertex_array_lock(vertex_array_obj: c_int) void {
    state.validateFor(.init);
    const obj = refObject(vertex_array_obj).*.vertexArray;
    obj.lock();
}

pub export fn pinc_graphics_vertex_array_set_len(vertex_array_obj: c_int, num: c_int) void {
    _ = vertex_array_obj;
    _ = num;
    // TODO: implement
    unreachable;
}

pub export fn pinc_graphics_vertex_array_set_item_float(vertex_array_obj: c_int, vertex: c_int, attribute: c_int, v: f32) void {
    _ = vertex_array_obj;
    _ = vertex;
    _ = attribute;
    _ = v;
    // TODO: implement
    unreachable;
}

pub export fn pinc_graphics_vertex_array_set_item_vec2(vertex_array_obj: c_int, vertex: c_int, attribute: c_int, v1: f32, v2: f32) void {
    state.validateFor(.init);
    const obj = refObject(vertex_array_obj).*.vertexArray;
    obj.setItemVec2(@intCast(vertex), @intCast(attribute), [2]f32{ v1, v2 });
}

pub export fn pinc_graphics_vertex_array_set_item_vec3(vertex_array_obj: c_int, vertex: c_int, attribute: c_int, v1: f32, v2: f32, v3: f32) void {
    _ = vertex_array_obj;
    _ = vertex;
    _ = attribute;
    _ = v1;
    _ = v2;
    _ = v3;
    // TODO: implement
    unreachable;
}

pub export fn pinc_graphics_vertex_array_set_item_vec4(vertex_array_obj: c_int, vertex: c_int, attribute: c_int, v1: f32, v2: f32, v3: f32, v4: f32) void {
    state.validateFor(.init);
    const obj = refObject(vertex_array_obj).*.vertexArray;
    obj.setItemVec4(@intCast(vertex), @intCast(attribute), [4]f32{ v1, v2, v3, v4 });
}

pub export fn pinc_graphics_vertex_array_set_item_int(vertex_array_obj: c_int, vertex: c_int, attribute: c_int, v: c_int) void {
    _ = vertex_array_obj;
    _ = vertex;
    _ = attribute;
    _ = v;
    // TODO: implement
    unreachable;
}

pub export fn pinc_graphics_vertex_array_set_item_ivec2(vertex_array_obj: c_int, vertex: c_int, attribute: c_int, v1: c_int, v2: c_int) void {
    _ = vertex_array_obj;
    _ = vertex;
    _ = attribute;
    _ = v1;
    _ = v2;
    // TODO: implement
    unreachable;
}

pub export fn pinc_graphics_vertex_array_set_item_ivec3(vertex_array_obj: c_int, vertex: c_int, attribute: c_int, v1: c_int, v2: c_int, v3: c_int) void {
    _ = vertex_array_obj;
    _ = vertex;
    _ = attribute;
    _ = v1;
    _ = v2;
    _ = v3;
    // TODO: implement
    unreachable;
}

pub export fn pinc_graphics_vertex_array_set_item_ivec4(vertex_array_obj: c_int, vertex: c_int, attribute: c_int, v1: c_int, v2: c_int, v3: c_int, v4: c_int) void {
    _ = vertex_array_obj;
    _ = vertex;
    _ = attribute;
    _ = v1;
    _ = v2;
    _ = v3;
    _ = v4;
    // TODO: implement
    unreachable;
}

pub export fn pinc_graphics_vertex_array_set_item_short(vertex_array_obj: c_int, vertex: c_int, attribute: c_int, v: c_short) void {
    _ = vertex_array_obj;
    _ = vertex;
    _ = attribute;
    _ = v;
    // TODO: implement
    unreachable;
}

pub export fn pinc_graphics_vertex_array_set_item_svec2(vertex_array_obj: c_int, vertex: c_int, attribute: c_int, v1: c_short, v2: c_short) void {
    _ = vertex_array_obj;
    _ = vertex;
    _ = attribute;
    _ = v1;
    _ = v2;
    // TODO: implement
    unreachable;
}

pub export fn pinc_graphics_vertex_array_set_item_svec3(vertex_array_obj: c_int, vertex: c_int, attribute: c_int, v1: c_short, v2: c_short, v3: c_short) void {
    _ = vertex_array_obj;
    _ = vertex;
    _ = attribute;
    _ = v1;
    _ = v2;
    _ = v3;
    // TODO: implement
    unreachable;
}

pub export fn pinc_graphics_vertex_array_set_item_svec4(vertex_array_obj: c_int, vertex: c_int, attribute: c_int, v1: c_short, v2: c_short, v3: c_short, v4: c_short) void {
    _ = vertex_array_obj;
    _ = vertex;
    _ = attribute;
    _ = v1;
    _ = v2;
    _ = v3;
    _ = v4;
    // TODO: implement
    unreachable;
}

pub export fn pinc_graphics_vertex_array_set_item_byte(vertex_array_obj: c_int, vertex: c_int, attribute: c_int, v: c_char) void {
    _ = vertex_array_obj;
    _ = vertex;
    _ = attribute;
    _ = v;
    // TODO: implement
    unreachable;
}

pub export fn pinc_graphics_vertex_array_set_item_bvec2(vertex_array_obj: c_int, vertex: c_int, attribute: c_int, v1: c_char, v2: c_char) void {
    _ = vertex_array_obj;
    _ = vertex;
    _ = attribute;
    _ = v1;
    _ = v2;
    // TODO: implement
    unreachable;
}

pub export fn pinc_graphics_vertex_array_set_item_bvec3(vertex_array_obj: c_int, vertex: c_int, attribute: c_int, v1: c_char, v2: c_char, v3: c_char) void {
    _ = vertex_array_obj;
    _ = vertex;
    _ = attribute;
    _ = v1;
    _ = v2;
    _ = v3;
    // TODO: implement
    unreachable;
}

pub export fn pinc_graphics_vertex_array_set_item_bvec4(vertex_array_obj: c_int, vertex: c_int, attribute: c_int, v1: c_char, v2: c_char, v3: c_char, v4: c_char) void {
    _ = vertex_array_obj;
    _ = vertex;
    _ = attribute;
    _ = v1;
    _ = v2;
    _ = v3;
    _ = v4;
    // TODO: implement
    unreachable;
}

pub export fn pinc_graphics_vertex_array_set_byte(vertex_array_obj: c_int, index: c_int, byte: c_char) void {
    _ = vertex_array_obj;
    _ = index;
    _ = byte;
    // TODO: implement
    unreachable;
}

pub export fn pinc_graphics_vertex_array_unlock(vertex_array_obj: c_int) void {
    state.validateFor(.init);
    const obj = refObject(vertex_array_obj).*.vertexArray;
    obj.unlock();
}

// TODO: replace channels with type
pub export fn pinc_graphics_texture_create(channels: c_int, width: c_int, height: c_int, depth1: c_int, depth2: c_int, depth3: c_int, depth4: c_int) c_int {
    _ = channels;
    _ = width;
    _ = height;
    _ = depth1;
    _ = depth2;
    _ = depth3;
    _ = depth4;
    // TODO: implement
    unreachable;
}

pub export fn pinc_graphics_texture_deinit(texture_obj: c_int) void {
    _ = texture_obj;
    // TODO: implement
    unreachable;
}

pub export fn pinc_graphics_texture_lock(texture_obj: c_int) void {
    _ = texture_obj;
    // TODO: implement
    unreachable;
}

pub export fn pinc_graphics_texture_set_pixel(texture_obj: c_int, x: c_int, y: c_int, c1: f32, c2: f32, c3: f32, c4: f32) void {
    _ = texture_obj;
    _ = x;
    _ = y;
    _ = c1;
    _ = c2;
    _ = c3;
    _ = c4;
    // TODO: implement
    unreachable;
}

pub export fn pinc_graphics_texture_update_mipmaps(texture_obj: c_int, mipmap: c_int, levels: c_int, filter: Filter) void {
    _ = texture_obj;
    _ = mipmap;
    _ = levels;
    _ = filter;
    // TODO: implement
    unreachable;
}

pub export fn pinc_graphics_texture_unlock(texture_obj: c_int) void {
    _ = texture_obj;
    // TODO: implement
    unreachable;
}

pub export fn pinc_graphics_fill_color(window: c_int, c1: f32, c2: f32, c3: f32, c4: f32) void {
    state.validateFor(.init);
    const object = refObject(window);
    state.init.graphicsBackend.fillColor(object.completeWindow, c1, c2, c3, c4);
}

pub export fn pinc_graphics_fill_depth(window: c_int, depth: f32) void {
    state.validateFor(.init);
    const object = refObject(window);
    state.init.graphicsBackend.fillDepth(object.completeWindow, depth);
}

pub export fn pinc_graphics_draw(window: c_int, pipeline_obj: c_int, vertex_array_obj: c_int, element_array_obj: c_int) void {
    state.validateFor(.init);
    _ = element_array_obj;
    state.getGraphicsBackend().?.draw(refObject(window).*.completeWindow, refObject(pipeline_obj).*.completePipeline, refObject(vertex_array_obj).*.vertexArray, null);
}

pub export fn pinc_graphics_done() void {
    state.validateFor(.init);
    state.getGraphicsBackend().?.done();
}

// Raw OpenGL functions

pub export fn pinc_raw_opengl_make_current(window: c_int) void {
    state.validateFor(.init);
    const object = refObject(window);
    switch (state.init.graphicsBackendEnum) {
        .opengl21 => {
            object.completeWindow.glMakeCurrent();
        },
        else => unreachable,
    }
}

pub export fn pinc_raw_opengl_get_proc(procname: [*:0]const u8) ?*anyopaque {
    state.validateFor(.init);
    switch (state.init.graphicsBackendEnum) {
        .opengl21 => {
            return state.init.windowBackend.glGetProc(std.mem.sliceTo(procname, 0));
        },
        else => unreachable,
    }
}
