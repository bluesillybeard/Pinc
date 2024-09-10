const std = @import("std");
const builtin = @import("builtin");
const pinc = @import("pinc.zig");
// SDL is very ergonomic even when translate-c'd without an actual binding
const sdl = @cImport({
    @cInclude("SDL2/SDL.h");
});

// improvements of translated SDL types

const GLContext = opaque {};

// struct to assist with loading SDL at runtime
const libsdl = struct {
    // The names of these declarations are important!
    // For every SDL function:
    // `_[our function name] = "[sdl function name]";` - this is used to get the relation of our name to the SDL name
    // `[our function name]: *typeof(sdl.[sdl function name]) = undefined;` - this is to store the actual function pointer
    // This is to avoid boilerplate code, making use of Zig's comptime abilities
    pub const _init = "SDL_Init";
    pub var init: *@TypeOf(sdl.SDL_Init) = undefined;
    pub const _quit = "SDL_Quit";
    pub var quit: *@TypeOf(sdl.SDL_Quit) = undefined;
    pub const _getError = "SDL_GetError";
    pub var getError: *@TypeOf(sdl.SDL_GetError) = undefined;
    pub const _createWindow = "SDL_CreateWindow";
    pub var createWindow: *@TypeOf(sdl.SDL_CreateWindow) = undefined;
    pub const _destroyWindow = "SDL_DestroyWindow";
    pub var destroyWindow: *@TypeOf(sdl.SDL_DestroyWindow) = undefined;
    pub const _setWindowSize = "SDL_SetWindowSize";
    pub var setWindowSize: *@TypeOf(sdl.SDL_SetWindowSize) = undefined;
    pub const _getWindowSize = "SDL_GetWindowSize";
    pub var getWindowSize: *@TypeOf(sdl.SDL_GetWindowSize) = undefined;
    pub const _getWindowData = "SDL_GetWindowData";
    pub var getWindowData: *@TypeOf(sdl.SDL_GetWindowData) = undefined;
    pub const _setWindowData = "SDL_SetWindowData";
    pub var setWindowData: *@TypeOf(sdl.SDL_SetWindowData) = undefined;
    pub const _glCreateContext = "SDL_GL_CreateContext";
    pub var glCreateContext: *@TypeOf(sdl.SDL_GL_CreateContext) = undefined;
    pub const _glMakeCurrent = "SDL_GL_MakeCurrent";
    pub var glMakeCurrent: *@TypeOf(sdl.SDL_GL_MakeCurrent) = undefined;
    pub const _glGetProcAddress = "SDL_GL_GetProcAddress";
    pub var glGetProcAddress: *@TypeOf(sdl.SDL_GL_GetProcAddress) = undefined;
    pub const _glSetSwapInterval = "SDL_GL_SetSwapInterval";
    pub var glSetSwapInterval: *@TypeOf(sdl.SDL_GL_SetSwapInterval) = undefined;
    pub const _glSetAttribute = "SDL_GL_SetAttribute";
    pub var glSetAttribute: *@TypeOf(sdl.SDL_GL_SetAttribute) = undefined;
    pub const _glSwapWindow = "SDL_GL_SwapWindow";
    pub var glSwapWindow: *@TypeOf(sdl.SDL_GL_SwapWindow) = undefined;
    pub const _pollEvent = "SDL_PollEvent";
    pub var pollEvent: *@TypeOf(sdl.SDL_PollEvent) = undefined;
    pub const _getWindowFromID = "SDL_GetWindowFromID";
    pub var getWindowFromID: *@TypeOf(sdl.SDL_GetWindowFromID) = undefined;
    pub const _waitEvent = "SDL_WaitEvent";
    pub var waitEvent: *@TypeOf(sdl.SDL_WaitEvent) = undefined;
    pub const _waitEventTimeout = "SDL_WaitEventTimeout";
    pub var waitEventTimeout: *@TypeOf(sdl.SDL_WaitEventTimeout) = undefined;
    pub const _getMouseState = "SDL_GetMouseState";
    pub var getMouseState: *@TypeOf(sdl.SDL_GetMouseState) = undefined;
    pub var lib: ?std.DynLib = null;
    // returns false if loading failed for any reason
    pub fn load() bool {
        // protect from calling this function multiple times
        if (lib != null) {
            return true;
        }
        // list of SDL shared library files depending on the system
        const sdl2libnames = comptime switch (builtin.os.tag) {
            .linux, .freebsd, .netbsd, .openbsd, .dragonfly, .solaris, .illumos => [_][]const u8{
                // The basic
                "libSDL2.so",
                // when the version is part of the name - side note, why do distros do this? It makes linking with SDL2 SO MUCH HARDER than it needs to be
                // At least have a "libsdl2.so" file available for applications that expect it to exist
                "libSDL2-2.0.so.0",
                // TODO: what are all the versions to look for?
            },
            .windows => [_][]const u8{"SDL2.dll"},
            // TODO: figure out if this is the correct name for darwin systems
            .macos, .ios, .tvos, .watchos, .visionos => [_][]const u8{
                "libsdl2.dylib",
            },
            else => @compileError("Unsupported platform for loading SDL at runtime"),
        };
        var locallib = blk: {
            inline for (sdl2libnames) |libname| {
                const libOrNone: ?std.DynLib = std.DynLib.open(libname) catch null;
                if (libOrNone) |someLib| {
                    pinc.logDebug("SDL2 backend: Loaded " ++ libname, .{});
                    break :blk someLib;
                } else {
                    pinc.logDebug("SDL2 backend: Unable to load " ++ libname, .{});
                }
            }
            // Never found an SDL2 binary
            pinc.logDebug("SDL2 backend: No SDL2 binary found, disabling SDL2", .{});
            return false;
        };
        // comptime magic to load all of the functions automatically
        const decls = comptime std.meta.declarations(libsdl);
        inline for (decls) |decl| {
            if (comptime decl.name[0] == '_') {
                const ourName = comptime decl.name[1..];
                const fnName: [:0]const u8 = comptime @field(libsdl, decl.name);
                @field(libsdl, ourName) = @ptrCast(locallib.lookup(*anyopaque, fnName) orelse {
                    pinc.logDebug("SDL2 backend: unable to load proc " ++ fnName, .{});
                    break undefined;
                });
            }
        }
        // only set lib if we were actually successful
        lib = locallib;
        return true;
    }
};

pub const SDL2WindowBackend = struct {
    pub fn init(this: *SDL2WindowBackend) void {
        this.* = .{
            .dummyWindow = null,
            .openglContext = null,
            .framebufferFormat = null,
        };
    }

    pub fn backendIsSupportedComptime() bool {
        // TODO: actually check
        return true;
    }

    pub fn backendIsSupported() bool {
        // To see if this backend is available, try to load SDL2
        if (!libsdl.load()) return false;

        return true;
    }

    pub fn getBackendEnumValue(this: *SDL2WindowBackend) pinc.WindowBackend {
        _ = this;
        return pinc.WindowBackend.sdl2;
    }

    pub fn isGraphicsBackendSupported(this: *SDL2WindowBackend, backend: pinc.GraphicsBackend) bool {
        // TODO: actually check
        _ = this;
        _ = backend;
        return true;
    }

    pub fn deinit(this: *SDL2WindowBackend) void {
        libsdl.lib.?.close();
        libsdl.lib = null;
        pinc.allocator.?.destroy(this);
    }

    pub fn prepareGraphics(this: *SDL2WindowBackend, backend: pinc.GraphicsBackend) void {
        // This is called immediately before changing the pinc state to set_graphics_backend
        _ = this;
        switch (backend) {
            .opengl21 => {
                if (libsdl.init(sdl.SDL_INIT_VIDEO) != 0) {
                    pinc.pushError(true, pinc.ErrorType.any, "SDL2 Backend: Failed to initialize SDL2", .{});
                }
            },
            .raw => {
                // TODO: implement raw backend
                unreachable;
            },
            else => unreachable,
        }
    }

    pub fn getFramebufferFormats(this: *SDL2WindowBackend, graphicsBackendEnum: pinc.GraphicsBackend, graphicsBackend: pinc.IGraphicsBackend) []const pinc.FramebufferFormat {
        _ = this;
        _ = graphicsBackend;
        switch (graphicsBackendEnum) {
            .none => unreachable,
            .opengl21 => {
                // TODO: SDL makes it hard to get a solid list of supported framebuffer formats, assumed 8bpc for now.
                // I have thought of a few possible ways to properly do this:
                // - have a list of common framebuffer formats, try to make a window+context for each one, and keep track of which ones succeed
                // - figure out which library SDL2 is using under the hood, and use its functions to get the list
                //     - glX has this easy-peasy, Pinc's own framebuffer selection system was actually inspired by glX
                //     - I think wgl has this?
                //     - EGL probably has this
                //     - No idea how cocoa does opengl lol
                // - give up and just remove the SDL2 backend completely (not realistically an option for now)
                // note: SDL2 is finished, they are not adding any more functions
                const formats = pinc.allocator.?.alloc(pinc.FramebufferFormat, 1) catch unreachable;
                formats[0] = pinc.FramebufferFormat{
                    .id = 0,
                    .channels = 4,
                    .channelDepths = [4]u32{ 8, 8, 8, 8 },
                    // pretty much anything made in the last 15 years supports 24 bit depth buffers
                    .depthBits = 24,
                };
                return formats;
            },
            .raw => {
                // TODO: actually go through every supported SDL2 front-facing pixel format instead of assuming RGBA 8bpc
                const formats = pinc.allocator.?.alloc(pinc.FramebufferFormat, 1) catch unreachable;
                formats[0] = pinc.FramebufferFormat{
                    .id = 0,
                    .channels = 4,
                    .channelDepths = [4]u32{ 8, 8, 8, 8 },
                    // In the raw backend, depth is f32 (for now)
                    .depthBits = 32,
                };
                return formats;
            },
        }
    }

    pub fn prepareFramebuffer(this: *SDL2WindowBackend, framebuffer: pinc.FramebufferFormat) void {
        // TODO: might actually be a good idea to make the OpenGL context here instead of later
        this.framebufferFormat = framebuffer;
    }

    pub fn createWindow(this: *SDL2WindowBackend, data: pinc.IncompleteWindow, id: c_int) ?pinc.ICompleteWindow {
        _ = this;
        // Unfortunately SDL has no way to get a "default" window size... Which is perfectly fine, honestly doesn't even matter
        // TODO: move this into a generic "makeSdlWindow" function and replace the dummy window creation with it
        var width = data.width;
        var height = data.height;
        if (width == null) width = 400;
        if (height == null) height = 300;
        // Just to be safe, no zero-sized windows
        std.debug.assert(width.? > 0);
        std.debug.assert(height.? > 0);
        var flags: u32 = 0;
        if (data.resizable) flags |= sdl.SDL_WINDOW_RESIZABLE;
        if (data.minimized) flags |= sdl.SDL_WINDOW_MINIMIZED;
        if (data.maximized) flags |= sdl.SDL_WINDOW_MAXIMIZED;
        if (data.hidden) flags |= sdl.SDL_WINDOW_HIDDEN;
        // TODO: fullscreen_desktop is a thing? what is that?
        if (data.fullscreen) flags |= sdl.SDL_WINDOW_FULLSCREEN;
        if (data.focused) {
            flags |= sdl.SDL_WINDOW_INPUT_FOCUS;
            flags |= sdl.SDL_WINDOW_INPUT_FOCUS;
        }
        if (pinc.state.init.graphicsBackendEnum == .opengl21) {
            flags |= sdl.SDL_WINDOW_OPENGL;
        }
        // TODO: maybe reuse the dummy window if possible?
        const sdlwin = libsdl.createWindow(data.title.ptr, sdl.SDL_WINDOWPOS_UNDEFINED, sdl.SDL_WINDOWPOS_UNDEFINED, @intCast(width.?), @intCast(height.?), flags);
        if (sdlwin == null) {
            pinc.pushError(true, .any, "SDL2 backend: Failed to create window: {s}", .{libsdl.getError()});
            return null;
        }
        const dat = SDLWindowUserData{
            .pincWindowId = id,
        };
        dat.toWindow(sdlwin.?);
        const win = pinc.allocator.?.create(SDL2CompleteWindow) catch unreachable;
        win.* = SDL2CompleteWindow{
            .secret = 12345,
            .window = sdlwin.?,
            // we own the title now
            .title = data.title,
            .evdat = .{},
        };
        return pinc.ICompleteWindow.init(SDL2CompleteWindow, win);
    }

    pub fn step(this: *SDL2WindowBackend) void {
        _ = this;
        // reset the event data on all of the windows
        for (pinc.state.init.objects.items) |*obj| {
            switch (obj.*) {
                .completeWindow => |win| {
                    const winObj = SDL2CompleteWindow.castFrom(win).?;
                    winObj.evdat = .{};
                },
                else => {},
            }
        }
        // Collect events
        var ev: sdl.SDL_Event = undefined;
        LOOP: while (libsdl.pollEvent(&ev) != 0) {
            switch (ev.type) {
                sdl.SDL_WINDOWEVENT => {
                    const win = getWindowFromid(ev.window.windowID) orelse continue :LOOP;

                    // Finally switch on the window event type
                    switch (ev.window.event) {
                        sdl.SDL_WINDOWEVENT_CLOSE => {
                            win.evdat.closed = true;
                        },
                        else => {}
                    }
                },
                sdl.SDL_MOUSEBUTTONDOWN => {
                    const win = getWindowFromid(ev.button.windowID) orelse continue :LOOP;
                    win.evdat.mouseButton = true;
                },
                else => {}
            }
        }
    }

    pub fn glGetProc(this: *SDL2WindowBackend, name: [:0]const u8) ?*anyopaque {
        // TODO: error on null dummy window?
        const dummy = this.getAnyWindow().?;
        // TODO: checck for error
        // TODO: might it be worth making the dummy window a fully fledged SDL2CompleteWindow so we can just call dummy.glMakeCurrent()?
        _ = libsdl.glMakeCurrent(dummy, this.getContext().?);
        return libsdl.glGetProcAddress(name.ptr);
    }

    pub fn getMouseState(this: *SDL2WindowBackend, button: u32) bool {
        _ = this;
        var state = libsdl.getMouseState(null, null);
        state &= (@as(u32, 1) >> @intCast(button));
        return state != 0;
    }

    fn getWindowFromid(id: u32) ?*SDL2CompleteWindow {
        const sdlWinOrNone = libsdl.getWindowFromID(id);
        if (sdlWinOrNone == null) return null;
        const sdlWin = sdlWinOrNone.?;

        // extract window object
        const dat = SDLWindowUserData.fromWindow(sdlWin);
        const object = pinc.refObject(dat.pincWindowId);
        // TODO: this should really be undefined behavior... Wasn't sure when I wrote it though
        if (object.* != .completeWindow) return null;

        const winOrNone = SDL2CompleteWindow.castFrom(object.completeWindow);
        return winOrNone;
    }

    // privates

    fn getContext(this: *SDL2WindowBackend) ?*GLContext {
        if (this.openglContext) |c| {
            return c;
        } else {
            const framebufferFormat: pinc.FramebufferFormat = this.framebufferFormat.?;
            var backend: pinc.GraphicsBackend = undefined;
            switch (pinc.state) {
                .set_framebuffer_format => |f| {
                    backend = f.graphicsBackendEnum;
                },
                .init => |i| {
                    backend = i.graphicsBackendEnum;
                },
                .set_graphics_backend => |st| {
                    backend = st.graphicsBackendEnum;
                },
                else => unreachable,
            }
            switch (backend) {
                .opengl21 => {
                    _ = libsdl.glSetAttribute(sdl.SDL_GL_CONTEXT_MAJOR_VERSION, 2);
                    _ = libsdl.glSetAttribute(sdl.SDL_GL_CONTEXT_MINOR_VERSION, 1);
                },
                else => undefined,
            }
            std.debug.assert(framebufferFormat.channels == 4 or framebufferFormat.channels == 3);
            _ = libsdl.glSetAttribute(sdl.SDL_GL_RED_SIZE, @intCast(framebufferFormat.channelDepths[0]));
            _ = libsdl.glSetAttribute(sdl.SDL_GL_GREEN_SIZE, @intCast(framebufferFormat.channelDepths[1]));
            _ = libsdl.glSetAttribute(sdl.SDL_GL_BLUE_SIZE, @intCast(framebufferFormat.channelDepths[2]));
            if (framebufferFormat.channels == 4) {
                _ = libsdl.glSetAttribute(sdl.SDL_GL_ALPHA_SIZE, @intCast(framebufferFormat.channelDepths[3]));
            }
            this.openglContext = @ptrCast(libsdl.glCreateContext(this.getAnyWindow().?));
            if (this.openglContext == null) {
                // We couldn't make the context... sad
                pinc.pushError(true, .any, "SDL2 backend: Failed to make OpenGL context! SDL2 error: {s}", .{libsdl.getError()});
            }
            return this.openglContext;
        }
    }

    fn getAnyWindow(this: *SDL2WindowBackend) ?*sdl.SDL_Window {
        if (this.dummyWindow) |dw| {
            return dw;
        }
        switch (pinc.state) {
            .init => |st| {
                for (st.objects.items) |obj| {
                    switch (obj) {
                        .completeWindow => |w| {
                            return SDL2CompleteWindow.castFrom(w).?.window;
                        },
                        else => {},
                    }
                }
            },
            else => {},
        }
        // No existing window can be used, this means we have to make a new one
        this.dummyWindow = libsdl.createWindow("pinc dummy window", sdl.SDL_WINDOWPOS_UNDEFINED, sdl.SDL_WINDOWPOS_UNDEFINED, 32, 32, sdl.SDL_WINDOW_HIDDEN | sdl.SDL_WINDOW_OPENGL);
        if (this.dummyWindow == null) {
            // Couldn't create window! (sad)
            pinc.pushError(true, .any, "SDL2 backend: Failed to create dummy window: {s}", .{libsdl.getError()});
        }
        return this.dummyWindow;
    }

    dummyWindow: ?*sdl.SDL_Window,
    openglContext: ?*GLContext,
    framebufferFormat: ?pinc.FramebufferFormat,
};

pub const SDLWindowUserData = struct {
    pincWindowId: c_int,

    // gets the user data from the window
    pub fn fromWindow(win: *sdl.SDL_Window) SDLWindowUserData {
        const this = SDLWindowUserData{
            // get the user data pointer associated with this window ID,
            // ?*anyopaque -> usize -> c_uint -> c_int
            // reinterperet it as a usize, cast it to a uint, then reinterperet that as a regulat int.
            // The point of this type dance is to cut off the bits we need, safely checking that the extra bits are all zeros,
            // while still correctly recovering the sign bit.
            // Technically we really don't need the sign bit at all, however in the future negative pinc object IDs may be possible.
            .pincWindowId = @bitCast(@as(c_uint, @intCast(@as(usize, @intFromPtr(libsdl.getWindowData(win, "pincid")))))),
        };
        return this;
    }

    // sets the user data of a window
    pub fn toWindow(this: SDLWindowUserData, win: *sdl.SDL_Window) void {
        // Like with fromWindow, but backwards: c_int -> c_uint -> usize -> ?*anyopaque
        // The int cast is gone since we are casting a lower bit type to a higher bit type (or equal on 32 bit systems)
        _ = libsdl.setWindowData(win, "pincid", @ptrFromInt(@as(usize, @as(c_uint, @bitCast(this.pincWindowId)))));
    }
};

pub const SDL2CompleteWindow = struct {
    pub fn castFrom(win: pinc.ICompleteWindow) ?*SDL2CompleteWindow {
        // TODO: would it be worth adding a type flag to ICompleteWindow?
        // Probably not, as there is only ever one backend anyway.
        const windowMaybe: *SDL2CompleteWindow = @alignCast(@ptrCast(win.obj));
        if (windowMaybe.secret == 12345) {
            return windowMaybe;
        }
        return null;
    }

    pub fn init(this: *SDL2CompleteWindow) void {
        _ = this;
    }

    pub fn deinit(this: *SDL2CompleteWindow) void {
        libsdl.destroyWindow(this.window);
        pinc.allocator.?.free(this.title);
        pinc.allocator.?.destroy(this);
    }

    pub fn setWidth(this: *SDL2CompleteWindow, width: u32) void {
        _ = this;
        _ = width;
    }

    pub fn getWidth(this: *SDL2CompleteWindow) u32 {
        _ = this;
        unreachable;
    }

    pub fn setHeight(this: *SDL2CompleteWindow, height: u32) void {
        _ = this;
        _ = height;
        unreachable;
    }

    pub fn getHeight(this: *SDL2CompleteWindow) u32 {
        _ = this;
        unreachable;
    }

    pub fn getScaleFactor(this: *SDL2CompleteWindow) f32 {
        _ = this;
        unreachable;
    }

    pub fn setResizable(this: *SDL2CompleteWindow, resizable: bool) void {
        _ = this;
        _ = resizable;
        unreachable;
    }

    pub fn getResizable(this: *SDL2CompleteWindow) bool {
        _ = this;
        unreachable;
    }

    pub fn presentFramebuffer(this: *SDL2CompleteWindow, vsync: bool) void {
        // TODO: actually make sure we're on the OpenGL backend before swapping for OpenGL
        this.glMakeCurrent();
        // TODO: test for success
        _ = libsdl.glSetSwapInterval(if(vsync) -1 else 0);
        libsdl.glSwapWindow(this.window);
    }

    pub fn eventClosed(this: *SDL2CompleteWindow) bool {
        return this.evdat.closed;
    }

    pub fn getTitle(this: *SDL2CompleteWindow) [:0]const u8 {
        _ = this;
        unreachable;
    }

    pub fn setTitle(this: *SDL2CompleteWindow, title: [:0]const u8) void {
        _ = this;
        _ = title;
        unreachable;
    }

    pub fn glMakeCurrent(this: *SDL2CompleteWindow) void {
        // TODO: make a function for this
        const sdl2WindowBackend: *SDL2WindowBackend = @alignCast(@ptrCast(pinc.state.init.windowBackend.obj));
        // TODO: test for success
        _ = libsdl.glMakeCurrent(this.window, sdl2WindowBackend.getContext());
    }

    pub fn eventMouseButton(this: *SDL2CompleteWindow) bool {
        return this.evdat.mouseButton;
    }

    // This is so we can safely cast from ICompleteWindow to SDL2CompleteWindow.
    // TODO: this really should exist... Wasn't sure when I wrote it though.
    secret: u32 = 12345,
    window: *sdl.SDL_Window,
    // allocated on the pinc global allocator
    title: [:0]const u8,
    evdat: struct {
        closed: bool = false,
        mouseButton: bool = false,
    },
};
