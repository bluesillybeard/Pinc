const std = @import("std");
const builtin = @import("builtin");
const pinc = @import("pinc.zig");
// SDL is very ergonomic even when translate-c'd without an actual binding
const sdl = @cImport({
    @cInclude("SDL2/SDL.h");
});

// SDL-specific TODOs
// - fix the bug in the SDL backend where unfocusing a window while buttons are being held down not causing window events
//    - Arguably this is not an issue, it's actually a bug in SDL2 (and I think GLFW) as well. The user can detect this in the unfocus event.
// - Check version of loaded SDL2 binary

// improvements of translated SDL types

// OG SDL uses a pointer here, but I prefer to declare things as pointers myself
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
    pub const _glGetDrawableSize = "SDL_GL_GetDrawableSize";
    pub var glGetDrawableSize: *@TypeOf(sdl.SDL_GL_GetDrawableSize) = undefined;
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
    pub const _setWindowResizable = "SDL_SetWindowResizable";
    pub var setWindowResizable: *@TypeOf(sdl.SDL_SetWindowResizable) = undefined;
    pub const _minimizeWindow = "SDL_MinimizeWindow";
    pub var minimizeWindow: *@TypeOf(sdl.SDL_MinimizeWindow) = undefined;
    pub const _restoreWindow = "SDL_RestoreWindow";
    pub var restoreWindow: *@TypeOf(sdl.SDL_RestoreWindow) = undefined;
    pub const _getWindowFlags = "SDL_GetWindowFlags";
    pub var getWindowFlags: *@TypeOf(sdl.SDL_GetWindowFlags) = undefined;
    pub const _maximizeWindow = "SDL_MaximizeWindow";
    pub var maximizeWindow: *@TypeOf(sdl.SDL_MaximizeWindow) = undefined;
    pub const _setWindowFullscreen = "SDL_SetWindowFullscreen";
    pub var setWindowFullscreen: *@TypeOf(sdl.SDL_SetWindowFullscreen) = undefined;
    pub const _raiseWindow = "SDL_RaiseWindow";
    pub var raiseWindow: *@TypeOf(sdl.SDL_RaiseWindow) = undefined;
    pub const _hideWindow = "SDL_HideWindow";
    pub var hideWindow: *@TypeOf(sdl.SDL_HideWindow) = undefined;
    pub const _showWindow = "SDL_ShowWindow";
    pub var showWindow: *@TypeOf(sdl.SDL_ShowWindow) = undefined;
    pub const _getKeyboardFocus = "SDL_GetKeyboardFocus";
    pub var getKeyboardFocus: *@TypeOf(sdl.SDL_GetKeyboardFocus) = undefined;
    pub const _getKeyboardState = "SDL_GetKeyboardState";
    pub var getKeyboardState: *@TypeOf(sdl.SDL_GetKeyboardState) = undefined;
    pub const _glGetCurrentWindow = "SDL_GL_GetCurrentWindow";
    pub var glGetCurrentWindow: *@TypeOf(sdl.SDL_GL_GetCurrentWindow) = undefined;
    pub var lib: ?std.DynLib = null;
    // returns false if loading failed for any reason
    pub fn load() bool {
        // TODO: enforce minimum SDL2 version
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
        if (this.dummyWindow) |w| {
            w.deinit();
        }
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
        this.framebufferFormat = framebuffer;
    }

    pub fn createWindow(this: *SDL2WindowBackend, data: pinc.IncompleteWindow, id: c_int) ?pinc.ICompleteWindow {
        return pinc.ICompleteWindow.init(SDL2CompleteWindow, this.createWindowDirect(data, id).?);
    }

    fn createWindowDirect(this: *SDL2WindowBackend, data: pinc.IncompleteWindow, id: ?c_int) ?*SDL2CompleteWindow {
        // Unfortunately SDL has no way to get a "default" window size... Which is perfectly fine, honestly doesn't even matter
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
        if (pinc.state.getGraphicsBackendEnum().? == .opengl21) {
            flags |= sdl.SDL_WINDOW_OPENGL;
            // On certain platforms (aka Windows), OpenGL is INSANELY particular about the framebuffer format not changing when switching to another window.
            // To be safe then, tell SDL2 what the framebuffer format should be before making a window.
            // This does mean that the OpenGL context can't be created until the framebuffer format is set.
            const framebufferFormat = this.framebufferFormat.?;
            _ = libsdl.glSetAttribute(sdl.SDL_GL_RED_SIZE, @intCast(framebufferFormat.channelDepths[0]));
            _ = libsdl.glSetAttribute(sdl.SDL_GL_GREEN_SIZE, @intCast(framebufferFormat.channelDepths[1]));
            _ = libsdl.glSetAttribute(sdl.SDL_GL_BLUE_SIZE, @intCast(framebufferFormat.channelDepths[2]));
            if (framebufferFormat.channels == 4) {
                _ = libsdl.glSetAttribute(sdl.SDL_GL_ALPHA_SIZE, @intCast(framebufferFormat.channelDepths[3]));
            }
        }
        const sdlwin = libsdl.createWindow(data.title.ptr, sdl.SDL_WINDOWPOS_UNDEFINED, sdl.SDL_WINDOWPOS_UNDEFINED, @intCast(width.?), @intCast(height.?), flags);
        if (sdlwin == null) {
            pinc.pushError(true, .any, "SDL2 backend: Failed to create window: {s}", .{libsdl.getError()});
            return null;
        }
        const dat = SDLWindowUserData{
            // id being nullable is really to indicate that it's optional.
            // Just to be safe, set the ID for this window to 0 to indicate that this is an "under the table" window.
            .pincWindowId = id orelse 0,
        };
        dat.toWindow(sdlwin.?);
        const win = pinc.allocator.?.create(SDL2CompleteWindow) catch unreachable;
        win.* = SDL2CompleteWindow{
            .window = sdlwin.?,
            // we own the title now
            .title = data.title,
            .evdat = .{},
            .resizable = data.resizable,
            .width = width.?,
            .height = height.?,
        };
        return win;
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
                        sdl.SDL_WINDOWEVENT_RESIZED => {
                            win.evdat.resized = true;
                            win.width = @intCast(ev.window.data1);
                            win.height = @intCast(ev.window.data2);
                        },
                        sdl.SDL_WINDOWEVENT_FOCUS_GAINED => {
                            win.evdat.focused = true;
                            // This is to make sure that application has no confusion of whether a window has focus -
                            // if we gained focus after being unfocused in the same step, then this window is focused
                            // and other windows are unfocused.
                            win.evdat.unfocused = false;
                        },
                        sdl.SDL_WINDOWEVENT_FOCUS_LOST => {
                            win.evdat.unfocused = true;
                            // TODO: is it worth setting the focused event to false here? Probably not.
                        },
                        sdl.SDL_WINDOWEVENT_EXPOSED => {
                            win.evdat.exposed = true;
                        },
                        sdl.SDL_WINDOWEVENT_ENTER => {
                            // TODO: disallow an exit and enter on the same window on the same step?
                            win.evdat.cursorEnter = true;
                        },
                        sdl.SDL_WINDOWEVENT_LEAVE => {
                            // TODO: disallow an exit and enter on the same window on the same step?
                            win.evdat.cursorExit = true;
                        },
                        else => {},
                    }
                },
                sdl.SDL_MOUSEBUTTONDOWN => {
                    const win = getWindowFromid(ev.button.windowID) orelse continue :LOOP;
                    win.evdat.mouseButton = true;
                },
                sdl.SDL_MOUSEBUTTONUP => {
                    const win = getWindowFromid(ev.button.windowID) orelse continue :LOOP;
                    win.evdat.mouseButton = true;
                },
                sdl.SDL_KEYDOWN => {
                    const win = getWindowFromid(ev.key.windowID) orelse continue :LOOP;
                    if (win.evdat.numKeyboardButtons >= @TypeOf(win.evdat).maxNumKeyboardButtons) {
                        pinc.logDebug("Maxed out at {} key events this frame", .{win.evdat.numKeyboardButtons});
                        win.evdat.numKeyboardButtons += 1;
                        continue :LOOP;
                    }
                    win.evdat.keyboardButtons[win.evdat.numKeyboardButtons] = .{
                        .key = translateSdlScancodeToPinc(ev.key.keysym.scancode),
                        .repeated = ev.key.repeat != 0,
                    };
                    win.evdat.numKeyboardButtons += 1;
                },
                sdl.SDL_KEYUP => {
                    const win = getWindowFromid(ev.key.windowID) orelse continue :LOOP;
                    if (win.evdat.numKeyboardButtons >= @TypeOf(win.evdat).maxNumKeyboardButtons) {
                        pinc.logDebug("Maxed out at {} key events this step", .{win.evdat.numKeyboardButtons});
                        win.evdat.numKeyboardButtons += 1;
                        continue :LOOP;
                    }
                    win.evdat.keyboardButtons[win.evdat.numKeyboardButtons] = .{
                        .key = translateSdlScancodeToPinc(ev.key.keysym.scancode),
                        .repeated = false,
                    };
                    win.evdat.numKeyboardButtons += 1;
                },
                sdl.SDL_MOUSEMOTION => {
                    const win = getWindowFromid(ev.motion.windowID) orelse continue :LOOP;
                    win.evdat.cursorMove = true;
                },
                sdl.SDL_TEXTINPUT => {
                    const win = getWindowFromid(ev.text.windowID) orelse continue :LOOP;
                    // I will say this EVERY time: Zig needs a way to make this variable not leak outside the scope of the wile loop!
                    var byteIndex: usize = 0;
                    while (byteIndex < ev.text.text.len and ev.text.text[byteIndex] != 0) : (byteIndex += 1) {
                        if (win.evdat.textLen >= @TypeOf(win.evdat).maxTextLen) {
                            pinc.logDebug("Maxed out at {} text input bytes this step", .{win.evdat.textLen});
                            win.evdat.textLen += 1;
                            continue;
                        }
                        win.evdat.textBuffer[win.evdat.textLen] = ev.text.text[byteIndex];
                        win.evdat.textLen += 1;
                    }
                },
                sdl.SDL_MOUSEWHEEL => {
                    const win = getWindowFromid(ev.wheel.windowID) orelse continue :LOOP;
                    win.evdat.scroll.x += ev.wheel.preciseX;
                    win.evdat.scroll.y += ev.wheel.preciseY;
                },
                else => {},
            }
        }
    }

    pub fn glGetProc(this: *SDL2WindowBackend, name: [:0]const u8) ?*anyopaque {
        // TODO: error on null dummy window?
        const dummy = this.getAnyWindow().?;
        dummy.glMakeCurrent();
        return libsdl.glGetProcAddress(name.ptr);
    }

    pub fn getMouseState(this: *SDL2WindowBackend, button: u32) bool {
        _ = this;
        // For some inexplicable reason, right click and middle click are swapped for sdl.
        // I was under the impression that everyone used 1 for right click and 2 for middle click,
        // But it seems that's just a GLFW thing.
        var realButton = button;
        if (realButton == 1) {
            realButton = 2;
        } else if (realButton == 2) {
            realButton = 1;
        }
        var state = libsdl.getMouseState(null, null);
        const mask = (@as(u32, 1) << @intCast(realButton));
        state &= mask;
        return state != 0;
    }

    pub fn getKeyboardState(this: *SDL2WindowBackend, button: pinc.KeyboardKey) bool {
        _ = this;
        const sdlScancode = translatePincToSdlScancode(button);
        if (sdlScancode == sdl.SDL_SCANCODE_UNKNOWN) {
            return false;
        }
        const state = libsdl.getKeyboardState(null);
        return state[sdlScancode] != 0;
    }

    pub fn getCursorPos(this: *SDL2WindowBackend) pinc.PixelPos {
        _ = this;
        var x: c_int = undefined;
        var y: c_int = undefined;
        _ = libsdl.getMouseState(&x, &y);
        return pinc.PixelPos{
            .x = @intCast(x),
            .y = @intCast(y),
        };
    }

    pub fn glMakeAnyCurrent(this: *SDL2WindowBackend) void {
        // If there is already a current context, return immediately
        if (libsdl.glGetCurrentWindow() != null) return;
        this.dummyWindow.?.glMakeCurrent();
    }

    fn getWindowFromid(id: u32) ?*SDL2CompleteWindow {
        const sdlWinOrNone = libsdl.getWindowFromID(id);
        if (sdlWinOrNone == null) return null;
        const sdlWin = sdlWinOrNone.?;

        // extract window object
        const dat = SDLWindowUserData.fromWindow(sdlWin);
        if (dat.pincWindowId == 0) return null;
        const object = pinc.refObject(dat.pincWindowId);
        if (object.* != .completeWindow) undefined;

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
            this.openglContext = @ptrCast(libsdl.glCreateContext(this.getAnyWindow().?.window));
            if (this.openglContext == null) {
                // We couldn't make the context... sad
                pinc.pushError(true, .any, "SDL2 backend: Failed to make OpenGL context! SDL2 error: {s}", .{libsdl.getError()});
            }
            return this.openglContext;
        }
    }

    fn getAnyWindow(this: *SDL2WindowBackend) ?*SDL2CompleteWindow {
        if (this.dummyWindow) |dw| {
            return dw;
        }
        switch (pinc.state) {
            .init => |st| {
                for (st.objects.items) |obj| {
                    switch (obj) {
                        .completeWindow => |w| {
                            return SDL2CompleteWindow.castFrom(w);
                        },
                        else => {},
                    }
                }
            },
            else => {},
        }
        // No existing window can be used, this means we have to make a new one
        this.dummyWindow = this.createWindowDirect(pinc.IncompleteWindow{
            .hidden = true,
            .title = pinc.allocator.?.dupeZ(u8, "Pinc dummy window (SDL2)") catch unreachable,
        }, null);
        if (this.dummyWindow == null) {
            // Couldn't create window! (sad)
            pinc.pushError(true, .any, "SDL2 backend: Failed to create dummy window: {s}", .{libsdl.getError()});
        }
        return this.dummyWindow;
    }

    // this window is "under the table" so to speak.
    // It is not registered as a Pinc object.
    dummyWindow: ?*SDL2CompleteWindow,
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
        const window: *SDL2CompleteWindow = @alignCast(@ptrCast(win.obj));
        return window;
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
        // TODO: handle scale factor
        this.width = width;
        libsdl.setWindowSize(this.window, @intCast(width), @intCast(this.getHeight()));
    }

    pub fn getWidth(this: *SDL2CompleteWindow) u32 {
        // TODO: handle scale factor
        return this.width;
    }

    pub fn setHeight(this: *SDL2CompleteWindow, height: u32) void {
        // TODO: handle scale factor
        this.height = height;
        libsdl.setWindowSize(this.window, @intCast(this.getWidth()), @intCast(height));
    }

    pub fn getHeight(this: *SDL2CompleteWindow) u32 {
        // TODO: handle scale factor
        return this.height;
    }

    pub fn getScaleFactor(this: *SDL2CompleteWindow) ?f32 {
        // Boy oh boy is SDL a nice and fun API with no strange graphics-backend specific code at all!
        // (SDL does have a function go get window size in pixels, HOWEVER it does not exist on many SDL verisons)
        // Really, I think it's windows fault for shoehorning scaling factor into an existing system
        // by literally lying to applications about the size of the window surface.
        // TODO: properly support scale factor - currently this should always result in 1.
        var width: c_int = undefined;
        var height: c_int = undefined;
        libsdl.getWindowSize(this.window, &width, &height);
        return @as(f32, @floatFromInt(width + height)) / @as(f32, @floatFromInt(this.width + this.height));
    }

    pub fn setResizable(this: *SDL2CompleteWindow, resizable: bool) void {
        this.resizable = resizable;
        libsdl.setWindowResizable(this.window, if (resizable) sdl.SDL_TRUE else sdl.SDL_FALSE);
    }

    pub fn getResizable(this: *SDL2CompleteWindow) bool {
        return this.resizable;
    }

    pub fn setMinimized(this: *SDL2CompleteWindow, minimized: bool) void {
        if (minimized) {
            libsdl.minimizeWindow(this.window);
        } else {
            libsdl.restoreWindow(this.window);
            // TODO: If a window was maximized and minimized at the same time, do we need to restore the maximized state?
        }
    }

    pub fn getMinimized(this: *SDL2CompleteWindow) bool {
        const flags = libsdl.getWindowFlags(this.window);
        return (flags & sdl.SDL_WINDOW_MINIMIZED) != 0;
    }

    pub fn setMaximized(this: *SDL2CompleteWindow, maximized: bool) void {
        if (maximized) {
            libsdl.maximizeWindow(this.window);
        } else {
            // TODO: if a window was minimized and maximized at the same time, do we need to restore the minimized state?
            libsdl.restoreWindow(this.window);
        }
    }

    pub fn getMaximized(this: *SDL2CompleteWindow) bool {
        const flags = libsdl.getWindowFlags(this.window);
        return (flags & sdl.SDL_WINDOW_MAXIMIZED) != 0;
    }

    pub fn setFullscreen(this: *SDL2CompleteWindow, fullscreen: bool) void {
        if (fullscreen) {
            // TODO: error check
            _ = libsdl.setWindowFullscreen(this.window, sdl.SDL_WINDOW_FULLSCREEN);
        } else {
            // TODO: error check
            _ = libsdl.setWindowFullscreen(this.window, 0);
        }
    }

    pub fn getFullscreen(this: *SDL2CompleteWindow) bool {
        const flags = libsdl.getWindowFlags(this.window);
        return (flags & sdl.SDL_WINDOW_FULLSCREEN) != 0;
    }

    pub fn setFocused(this: *SDL2CompleteWindow, focused: bool) void {
        if (focused) {
            libsdl.raiseWindow(this.window);
        } else {
            // Do nothing lol
            // What does unfocusing a window even look like?
        }
    }

    pub fn getFocused(this: *SDL2CompleteWindow) bool {
        const flags = libsdl.getWindowFlags(this.window);
        return (flags & sdl.SDL_WINDOW_INPUT_FOCUS) != 0;
    }

    pub fn setHidden(this: *SDL2CompleteWindow, hidden: bool) void {
        if (hidden) {
            libsdl.hideWindow(this.window);
        } else {
            libsdl.showWindow(this.window);
        }
    }

    pub fn getHidden(this: *SDL2CompleteWindow) bool {
        const flags = libsdl.getWindowFlags(this.window);
        return (flags & sdl.SDL_WINDOW_HIDDEN) != 0;
    }

    pub fn presentFramebuffer(this: *SDL2CompleteWindow, vsync: bool) void {
        // TODO: actually make sure we're on the OpenGL backend before swapping for OpenGL
        this.glMakeCurrent();
        if(libsdl.glSetSwapInterval(if (vsync) -1 else 0) == -1) {
            if(libsdl.glSetSwapInterval(if (vsync) 1 else 0) == -1) {
                pinc.pushError(false, .any, "SDL2 backend: Unable to set swap interval: {s}", .{libsdl.getError()});
            }
        }
        libsdl.glSwapWindow(this.window);
    }

    pub fn eventClosed(this: *SDL2CompleteWindow) bool {
        return this.evdat.closed;
    }

    pub fn getTitle(this: *SDL2CompleteWindow) [:0]const u8 {
        return this.title;
    }

    pub fn setTitle(this: *SDL2CompleteWindow, title: [:0]const u8) void {
        this.title = title;
    }

    pub fn glMakeCurrent(this: *SDL2CompleteWindow) void {
        // TODO: make a function for this
        const sdl2WindowBackend: *SDL2WindowBackend = @alignCast(@ptrCast(pinc.state.getWindowBackend().?.obj));
        if (libsdl.glMakeCurrent(this.window, sdl2WindowBackend.getContext()) != 0) {
            pinc.pushError(false, .any, "SDL2 backend: Could not make context current for window titled \"{s}\": {s}", .{ this.title, libsdl.getError() });
        }
    }

    pub fn eventMouseButton(this: *SDL2CompleteWindow) bool {
        return this.evdat.mouseButton;
    }

    pub fn eventResized(this: *SDL2CompleteWindow) bool {
        return this.evdat.resized;
    }

    pub fn eventWindowFocused(this: *SDL2CompleteWindow) bool {
        return this.evdat.focused;
    }

    pub fn eventWindowUnfocused(this: *SDL2CompleteWindow) bool {
        return this.evdat.unfocused;
    }

    pub fn eventWindowExposed(this: *SDL2CompleteWindow) bool {
        return this.evdat.exposed;
    }

    pub fn eventKeyboardButtons(this: *SDL2CompleteWindow) []const pinc.KeyboardButtonEvent {
        return this.evdat.keyboardButtons[0..@min(this.evdat.numKeyboardButtons, @TypeOf(this.evdat).maxNumKeyboardButtons)];
    }

    pub fn eventCursorMove(this: *SDL2CompleteWindow) bool {
        return this.evdat.cursorMove;
    }

    pub fn eventCursorExit(this: *SDL2CompleteWindow) bool {
        return this.evdat.cursorExit;
    }

    pub fn eventCursorEnter(this: *SDL2CompleteWindow) bool {
        return this.evdat.cursorEnter;
    }

    pub fn eventText(this: *SDL2CompleteWindow) []const u8 {
        return this.evdat.textBuffer[0..@min(this.evdat.textLen, @TypeOf(this.evdat).maxTextLen)];
    }

    pub fn eventScroll(this: *SDL2CompleteWindow) pinc.Vec2 {
        return this.evdat.scroll;
    }

    // privates
    fn getWindowSizePixels(this: *SDL2CompleteWindow, width: *u32, height: *u32) void {
        switch (pinc.state.init.graphicsBackendEnum) {
            .opengl21 => {
                var w: c_int = undefined;
                var h: c_int = undefined;
                libsdl.glGetDrawableSize(this.window, &w, &h);
                width.* = w;
                height.* = h;
            },
            // TODO: raw backend
            else => unreachable,
        }
    }

    window: *sdl.SDL_Window,
    // allocated on the pinc global allocator
    title: [:0]const u8,
    evdat: struct {
        const maxNumKeyboardButtons = 10;
        const maxTextLen = 128;
        closed: bool = false,
        mouseButton: bool = false,
        resized: bool = false,
        focused: bool = false,
        unfocused: bool = false,
        exposed: bool = false,
        numKeyboardButtons: usize = 0,
        keyboardButtons: [maxNumKeyboardButtons]pinc.KeyboardButtonEvent = undefined,
        cursorMove: bool = false,
        cursorExit: bool = false,
        cursorEnter: bool = false,
        textBuffer: [maxTextLen]u8 = undefined,
        textLen: usize = 0,
        scroll: pinc.Vec2 = .{ .x = 0, .y = 0 },
    },
    resizable: bool,
    width: u32,
    height: u32,
};

fn translateSdlScancodeToPinc(sdlScancode: c_uint) pinc.KeyboardKey {
    // TODO: menu
    return switch (sdlScancode) {
        sdl.SDL_SCANCODE_UNKNOWN => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_A => pinc.KeyboardKey.a,
        sdl.SDL_SCANCODE_B => pinc.KeyboardKey.b,
        sdl.SDL_SCANCODE_C => pinc.KeyboardKey.c,
        sdl.SDL_SCANCODE_D => pinc.KeyboardKey.d,
        sdl.SDL_SCANCODE_E => pinc.KeyboardKey.e,
        sdl.SDL_SCANCODE_F => pinc.KeyboardKey.f,
        sdl.SDL_SCANCODE_G => pinc.KeyboardKey.g,
        sdl.SDL_SCANCODE_H => pinc.KeyboardKey.h,
        sdl.SDL_SCANCODE_I => pinc.KeyboardKey.i,
        sdl.SDL_SCANCODE_J => pinc.KeyboardKey.j,
        sdl.SDL_SCANCODE_K => pinc.KeyboardKey.k,
        sdl.SDL_SCANCODE_L => pinc.KeyboardKey.l,
        sdl.SDL_SCANCODE_M => pinc.KeyboardKey.m,
        sdl.SDL_SCANCODE_N => pinc.KeyboardKey.n,
        sdl.SDL_SCANCODE_O => pinc.KeyboardKey.o,
        sdl.SDL_SCANCODE_P => pinc.KeyboardKey.p,
        sdl.SDL_SCANCODE_Q => pinc.KeyboardKey.q,
        sdl.SDL_SCANCODE_R => pinc.KeyboardKey.r,
        sdl.SDL_SCANCODE_S => pinc.KeyboardKey.s,
        sdl.SDL_SCANCODE_T => pinc.KeyboardKey.t,
        sdl.SDL_SCANCODE_U => pinc.KeyboardKey.u,
        sdl.SDL_SCANCODE_V => pinc.KeyboardKey.v,
        sdl.SDL_SCANCODE_W => pinc.KeyboardKey.w,
        sdl.SDL_SCANCODE_X => pinc.KeyboardKey.x,
        sdl.SDL_SCANCODE_Y => pinc.KeyboardKey.y,
        sdl.SDL_SCANCODE_Z => pinc.KeyboardKey.z,
        sdl.SDL_SCANCODE_1 => pinc.KeyboardKey.@"1",
        sdl.SDL_SCANCODE_2 => pinc.KeyboardKey.@"2",
        sdl.SDL_SCANCODE_3 => pinc.KeyboardKey.@"3",
        sdl.SDL_SCANCODE_4 => pinc.KeyboardKey.@"4",
        sdl.SDL_SCANCODE_5 => pinc.KeyboardKey.@"5",
        sdl.SDL_SCANCODE_6 => pinc.KeyboardKey.@"6",
        sdl.SDL_SCANCODE_7 => pinc.KeyboardKey.@"7",
        sdl.SDL_SCANCODE_8 => pinc.KeyboardKey.@"8",
        sdl.SDL_SCANCODE_9 => pinc.KeyboardKey.@"9",
        sdl.SDL_SCANCODE_0 => pinc.KeyboardKey.@"0",
        sdl.SDL_SCANCODE_RETURN => pinc.KeyboardKey.enter,
        sdl.SDL_SCANCODE_ESCAPE => pinc.KeyboardKey.escape,
        sdl.SDL_SCANCODE_BACKSPACE => pinc.KeyboardKey.backspace,
        sdl.SDL_SCANCODE_TAB => pinc.KeyboardKey.tab,
        sdl.SDL_SCANCODE_SPACE => pinc.KeyboardKey.space,
        sdl.SDL_SCANCODE_MINUS => pinc.KeyboardKey.dash,
        sdl.SDL_SCANCODE_EQUALS => pinc.KeyboardKey.equals,
        sdl.SDL_SCANCODE_LEFTBRACKET => pinc.KeyboardKey.left_bracket,
        sdl.SDL_SCANCODE_RIGHTBRACKET => pinc.KeyboardKey.right_bracket,
        sdl.SDL_SCANCODE_BACKSLASH => pinc.KeyboardKey.backslash,
        sdl.SDL_SCANCODE_NONUSHASH => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_SEMICOLON => pinc.KeyboardKey.semicolon,
        sdl.SDL_SCANCODE_APOSTROPHE => pinc.KeyboardKey.apostrophe,
        sdl.SDL_SCANCODE_GRAVE => pinc.KeyboardKey.backtick,
        sdl.SDL_SCANCODE_COMMA => pinc.KeyboardKey.comma,
        sdl.SDL_SCANCODE_PERIOD => pinc.KeyboardKey.dot,
        sdl.SDL_SCANCODE_SLASH => pinc.KeyboardKey.slash,
        sdl.SDL_SCANCODE_CAPSLOCK => pinc.KeyboardKey.caps_lock,
        sdl.SDL_SCANCODE_F1 => pinc.KeyboardKey.f1,
        sdl.SDL_SCANCODE_F2 => pinc.KeyboardKey.f2,
        sdl.SDL_SCANCODE_F3 => pinc.KeyboardKey.f3,
        sdl.SDL_SCANCODE_F4 => pinc.KeyboardKey.f4,
        sdl.SDL_SCANCODE_F5 => pinc.KeyboardKey.f5,
        sdl.SDL_SCANCODE_F6 => pinc.KeyboardKey.f6,
        sdl.SDL_SCANCODE_F7 => pinc.KeyboardKey.f7,
        sdl.SDL_SCANCODE_F8 => pinc.KeyboardKey.f8,
        sdl.SDL_SCANCODE_F9 => pinc.KeyboardKey.f9,
        sdl.SDL_SCANCODE_F10 => pinc.KeyboardKey.f10,
        sdl.SDL_SCANCODE_F11 => pinc.KeyboardKey.f11,
        sdl.SDL_SCANCODE_F12 => pinc.KeyboardKey.f12,
        sdl.SDL_SCANCODE_PRINTSCREEN => pinc.KeyboardKey.print_screen,
        sdl.SDL_SCANCODE_SCROLLLOCK => pinc.KeyboardKey.scroll_lock,
        sdl.SDL_SCANCODE_PAUSE => pinc.KeyboardKey.pause,
        sdl.SDL_SCANCODE_INSERT => pinc.KeyboardKey.insert,
        sdl.SDL_SCANCODE_HOME => pinc.KeyboardKey.home,
        sdl.SDL_SCANCODE_PAGEUP => pinc.KeyboardKey.page_up,
        sdl.SDL_SCANCODE_DELETE => pinc.KeyboardKey.delete,
        sdl.SDL_SCANCODE_END => pinc.KeyboardKey.end,
        sdl.SDL_SCANCODE_PAGEDOWN => pinc.KeyboardKey.page_down,
        sdl.SDL_SCANCODE_RIGHT => pinc.KeyboardKey.right,
        sdl.SDL_SCANCODE_LEFT => pinc.KeyboardKey.left,
        sdl.SDL_SCANCODE_DOWN => pinc.KeyboardKey.down,
        sdl.SDL_SCANCODE_UP => pinc.KeyboardKey.up,
        sdl.SDL_SCANCODE_NUMLOCKCLEAR => pinc.KeyboardKey.num_lock, //?
        sdl.SDL_SCANCODE_KP_DIVIDE => pinc.KeyboardKey.numpad_slash,
        sdl.SDL_SCANCODE_KP_MULTIPLY => pinc.KeyboardKey.numpad_asterisk,
        sdl.SDL_SCANCODE_KP_MINUS => pinc.KeyboardKey.numpad_dash,
        sdl.SDL_SCANCODE_KP_PLUS => pinc.KeyboardKey.numpad_plus,
        sdl.SDL_SCANCODE_KP_ENTER => pinc.KeyboardKey.numpad_enter,
        sdl.SDL_SCANCODE_KP_1 => pinc.KeyboardKey.numpad_1,
        sdl.SDL_SCANCODE_KP_2 => pinc.KeyboardKey.numpad_2,
        sdl.SDL_SCANCODE_KP_3 => pinc.KeyboardKey.numpad_3,
        sdl.SDL_SCANCODE_KP_4 => pinc.KeyboardKey.numpad_4,
        sdl.SDL_SCANCODE_KP_5 => pinc.KeyboardKey.numpad_5,
        sdl.SDL_SCANCODE_KP_6 => pinc.KeyboardKey.numpad_6,
        sdl.SDL_SCANCODE_KP_7 => pinc.KeyboardKey.numpad_7,
        sdl.SDL_SCANCODE_KP_8 => pinc.KeyboardKey.numpad_8,
        sdl.SDL_SCANCODE_KP_9 => pinc.KeyboardKey.numpad_9,
        sdl.SDL_SCANCODE_KP_0 => pinc.KeyboardKey.numpad_0,
        sdl.SDL_SCANCODE_KP_PERIOD => pinc.KeyboardKey.numpad_dot,
        sdl.SDL_SCANCODE_NONUSBACKSLASH => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_APPLICATION => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_POWER => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_KP_EQUALS => pinc.KeyboardKey.numpad_equal,
        sdl.SDL_SCANCODE_F13 => pinc.KeyboardKey.f13,
        sdl.SDL_SCANCODE_F14 => pinc.KeyboardKey.f14,
        sdl.SDL_SCANCODE_F15 => pinc.KeyboardKey.f15,
        sdl.SDL_SCANCODE_F16 => pinc.KeyboardKey.f16,
        sdl.SDL_SCANCODE_F17 => pinc.KeyboardKey.f17,
        sdl.SDL_SCANCODE_F18 => pinc.KeyboardKey.f18,
        sdl.SDL_SCANCODE_F19 => pinc.KeyboardKey.f19,
        sdl.SDL_SCANCODE_F20 => pinc.KeyboardKey.f20,
        sdl.SDL_SCANCODE_F21 => pinc.KeyboardKey.f21,
        sdl.SDL_SCANCODE_F22 => pinc.KeyboardKey.f22,
        sdl.SDL_SCANCODE_F23 => pinc.KeyboardKey.f23,
        sdl.SDL_SCANCODE_F24 => pinc.KeyboardKey.f24,
        sdl.SDL_SCANCODE_EXECUTE => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_HELP => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_MENU => pinc.KeyboardKey.menu,
        sdl.SDL_SCANCODE_SELECT => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_STOP => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_AGAIN => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_UNDO => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_CUT => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_COPY => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_PASTE => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_FIND => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_MUTE => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_VOLUMEUP => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_VOLUMEDOWN => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_KP_COMMA => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_KP_EQUALSAS400 => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_INTERNATIONAL1 => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_INTERNATIONAL2 => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_INTERNATIONAL3 => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_INTERNATIONAL4 => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_INTERNATIONAL5 => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_INTERNATIONAL6 => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_INTERNATIONAL7 => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_INTERNATIONAL8 => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_INTERNATIONAL9 => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_LANG1 => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_LANG2 => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_LANG3 => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_LANG4 => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_LANG5 => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_LANG6 => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_LANG7 => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_LANG8 => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_LANG9 => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_ALTERASE => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_SYSREQ => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_CANCEL => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_CLEAR => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_PRIOR => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_RETURN2 => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_SEPARATOR => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_OUT => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_OPER => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_CLEARAGAIN => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_CRSEL => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_EXSEL => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_KP_00 => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_KP_000 => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_THOUSANDSSEPARATOR => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_DECIMALSEPARATOR => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_CURRENCYUNIT => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_CURRENCYSUBUNIT => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_KP_LEFTPAREN => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_KP_RIGHTPAREN => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_KP_LEFTBRACE => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_KP_RIGHTBRACE => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_KP_TAB => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_KP_BACKSPACE => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_KP_A => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_KP_B => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_KP_C => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_KP_D => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_KP_E => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_KP_F => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_KP_XOR => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_KP_POWER => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_KP_PERCENT => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_KP_LESS => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_KP_GREATER => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_KP_AMPERSAND => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_KP_DBLAMPERSAND => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_KP_VERTICALBAR => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_KP_DBLVERTICALBAR => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_KP_COLON => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_KP_HASH => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_KP_SPACE => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_KP_AT => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_KP_EXCLAM => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_KP_MEMSTORE => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_KP_MEMRECALL => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_KP_MEMCLEAR => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_KP_MEMADD => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_KP_MEMSUBTRACT => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_KP_MEMMULTIPLY => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_KP_MEMDIVIDE => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_KP_PLUSMINUS => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_KP_CLEAR => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_KP_CLEARENTRY => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_KP_BINARY => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_KP_OCTAL => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_KP_DECIMAL => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_KP_HEXADECIMAL => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_LCTRL => pinc.KeyboardKey.left_control,
        sdl.SDL_SCANCODE_LSHIFT => pinc.KeyboardKey.left_shift,
        sdl.SDL_SCANCODE_LALT => pinc.KeyboardKey.left_alt,
        sdl.SDL_SCANCODE_LGUI => pinc.KeyboardKey.left_super,
        sdl.SDL_SCANCODE_RCTRL => pinc.KeyboardKey.right_control,
        sdl.SDL_SCANCODE_RSHIFT => pinc.KeyboardKey.right_shift,
        sdl.SDL_SCANCODE_RALT => pinc.KeyboardKey.right_alt,
        sdl.SDL_SCANCODE_RGUI => pinc.KeyboardKey.right_super,
        sdl.SDL_SCANCODE_MODE => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_AUDIONEXT => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_AUDIOPREV => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_AUDIOSTOP => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_AUDIOPLAY => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_AUDIOMUTE => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_MEDIASELECT => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_WWW => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_MAIL => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_CALCULATOR => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_COMPUTER => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_AC_SEARCH => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_AC_HOME => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_AC_BACK => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_AC_FORWARD => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_AC_STOP => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_AC_REFRESH => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_AC_BOOKMARKS => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_BRIGHTNESSDOWN => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_BRIGHTNESSUP => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_DISPLAYSWITCH => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_KBDILLUMTOGGLE => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_KBDILLUMDOWN => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_KBDILLUMUP => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_EJECT => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_SLEEP => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_APP1 => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_APP2 => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_AUDIOREWIND => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_AUDIOFASTFORWARD => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_SOFTLEFT => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_SOFTRIGHT => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_CALL => pinc.KeyboardKey.unknown,
        sdl.SDL_SCANCODE_ENDCALL => pinc.KeyboardKey.unknown,
        else => pinc.KeyboardKey.unknown,
    };
}

fn translatePincToSdlScancode(key: pinc.KeyboardKey) c_uint {
    return switch (key) {
        .unknown => sdl.SDL_SCANCODE_UNKNOWN,
        .space => sdl.SDL_SCANCODE_SPACE,
        .apostrophe => sdl.SDL_SCANCODE_APOSTROPHE,
        .comma => sdl.SDL_SCANCODE_COMMA,
        .dash => sdl.SDL_SCANCODE_MINUS,
        .dot => sdl.SDL_SCANCODE_PERIOD,
        .slash => sdl.SDL_SCANCODE_SLASH,
        .@"0" => sdl.SDL_SCANCODE_0,
        .@"1" => sdl.SDL_SCANCODE_1,
        .@"2" => sdl.SDL_SCANCODE_2,
        .@"3" => sdl.SDL_SCANCODE_3,
        .@"4" => sdl.SDL_SCANCODE_4,
        .@"5" => sdl.SDL_SCANCODE_5,
        .@"6" => sdl.SDL_SCANCODE_6,
        .@"7" => sdl.SDL_SCANCODE_7,
        .@"8" => sdl.SDL_SCANCODE_8,
        .@"9" => sdl.SDL_SCANCODE_9,
        .semicolon => sdl.SDL_SCANCODE_SEMICOLON,
        .equals => sdl.SDL_SCANCODE_EQUALS,
        .a => sdl.SDL_SCANCODE_A,
        .b => sdl.SDL_SCANCODE_B,
        .c => sdl.SDL_SCANCODE_C,
        .d => sdl.SDL_SCANCODE_D,
        .e => sdl.SDL_SCANCODE_E,
        .f => sdl.SDL_SCANCODE_F,
        .g => sdl.SDL_SCANCODE_G,
        .h => sdl.SDL_SCANCODE_H,
        .i => sdl.SDL_SCANCODE_I,
        .j => sdl.SDL_SCANCODE_J,
        .k => sdl.SDL_SCANCODE_K,
        .l => sdl.SDL_SCANCODE_L,
        .m => sdl.SDL_SCANCODE_M,
        .n => sdl.SDL_SCANCODE_N,
        .o => sdl.SDL_SCANCODE_O,
        .p => sdl.SDL_SCANCODE_P,
        .q => sdl.SDL_SCANCODE_Q,
        .r => sdl.SDL_SCANCODE_R,
        .s => sdl.SDL_SCANCODE_S,
        .t => sdl.SDL_SCANCODE_T,
        .u => sdl.SDL_SCANCODE_U,
        .v => sdl.SDL_SCANCODE_V,
        .w => sdl.SDL_SCANCODE_W,
        .x => sdl.SDL_SCANCODE_X,
        .y => sdl.SDL_SCANCODE_Y,
        .z => sdl.SDL_SCANCODE_Z,
        .left_bracket => sdl.SDL_SCANCODE_LEFTBRACKET,
        .backslash => sdl.SDL_SCANCODE_BACKSLASH,
        .right_bracket => sdl.SDL_SCANCODE_RIGHTBRACKET,
        .backtick => sdl.SDL_SCANCODE_GRAVE,
        .escape => sdl.SDL_SCANCODE_ESCAPE,
        .enter => sdl.SDL_SCANCODE_RETURN,
        .tab => sdl.SDL_SCANCODE_TAB,
        .backspace => sdl.SDL_SCANCODE_BACKSPACE,
        .insert => sdl.SDL_SCANCODE_INSERT,
        .delete => sdl.SDL_SCANCODE_DELETE,
        .right => sdl.SDL_SCANCODE_RIGHT,
        .left => sdl.SDL_SCANCODE_LEFT,
        .down => sdl.SDL_SCANCODE_DOWN,
        .up => sdl.SDL_SCANCODE_UP,
        .page_up => sdl.SDL_SCANCODE_PAGEUP,
        .page_down => sdl.SDL_SCANCODE_PAGEDOWN,
        .home => sdl.SDL_SCANCODE_HOME,
        .end => sdl.SDL_SCANCODE_END,
        .caps_lock => sdl.SDL_SCANCODE_CAPSLOCK,
        .scroll_lock => sdl.SDL_SCANCODE_SCROLLLOCK,
        .num_lock => sdl.SDL_SCANCODE_NUMLOCKCLEAR, // ?
        .print_screen => sdl.SDL_SCANCODE_PRINTSCREEN,
        .pause => sdl.SDL_SCANCODE_PAUSE,
        .f1 => sdl.SDL_SCANCODE_F1,
        .f2 => sdl.SDL_SCANCODE_F2,
        .f3 => sdl.SDL_SCANCODE_F3,
        .f4 => sdl.SDL_SCANCODE_F4,
        .f5 => sdl.SDL_SCANCODE_F5,
        .f6 => sdl.SDL_SCANCODE_F6,
        .f7 => sdl.SDL_SCANCODE_F7,
        .f8 => sdl.SDL_SCANCODE_F8,
        .f9 => sdl.SDL_SCANCODE_F9,
        .f10 => sdl.SDL_SCANCODE_F10,
        .f11 => sdl.SDL_SCANCODE_F11,
        .f12 => sdl.SDL_SCANCODE_F12,
        .f13 => sdl.SDL_SCANCODE_F13,
        .f14 => sdl.SDL_SCANCODE_F14,
        .f15 => sdl.SDL_SCANCODE_F15,
        .f16 => sdl.SDL_SCANCODE_F16,
        .f17 => sdl.SDL_SCANCODE_F17,
        .f18 => sdl.SDL_SCANCODE_F18,
        .f19 => sdl.SDL_SCANCODE_F19,
        .f20 => sdl.SDL_SCANCODE_F20,
        .f21 => sdl.SDL_SCANCODE_F21,
        .f22 => sdl.SDL_SCANCODE_F22,
        .f23 => sdl.SDL_SCANCODE_F23,
        .f24 => sdl.SDL_SCANCODE_F24,
        .f25 => sdl.SDL_SCANCODE_UNKNOWN,
        .f26 => sdl.SDL_SCANCODE_UNKNOWN,
        .f27 => sdl.SDL_SCANCODE_UNKNOWN,
        .f28 => sdl.SDL_SCANCODE_UNKNOWN,
        .f29 => sdl.SDL_SCANCODE_UNKNOWN,
        .f30 => sdl.SDL_SCANCODE_UNKNOWN,
        .numpad_0 => sdl.SDL_SCANCODE_KP_0,
        .numpad_1 => sdl.SDL_SCANCODE_KP_1,
        .numpad_2 => sdl.SDL_SCANCODE_KP_2,
        .numpad_3 => sdl.SDL_SCANCODE_KP_3,
        .numpad_4 => sdl.SDL_SCANCODE_KP_4,
        .numpad_5 => sdl.SDL_SCANCODE_KP_5,
        .numpad_6 => sdl.SDL_SCANCODE_KP_6,
        .numpad_7 => sdl.SDL_SCANCODE_KP_7,
        .numpad_8 => sdl.SDL_SCANCODE_KP_8,
        .numpad_9 => sdl.SDL_SCANCODE_KP_9,
        .numpad_dot => sdl.SDL_SCANCODE_KP_PERIOD,
        .numpad_slash => sdl.SDL_SCANCODE_KP_DIVIDE,
        .numpad_asterisk => sdl.SDL_SCANCODE_KP_MULTIPLY,
        .numpad_dash => sdl.SDL_SCANCODE_KP_MINUS,
        .numpad_plus => sdl.SDL_SCANCODE_KP_PLUS,
        .numpad_enter => sdl.SDL_SCANCODE_KP_ENTER,
        .numpad_equal => sdl.SDL_SCANCODE_KP_EQUALS,
        .left_shift => sdl.SDL_SCANCODE_LSHIFT,
        .left_control => sdl.SDL_SCANCODE_LCTRL,
        .left_alt => sdl.SDL_SCANCODE_LALT,
        .left_super => sdl.SDL_SCANCODE_LGUI,
        .right_shift => sdl.SDL_SCANCODE_RSHIFT,
        .right_control => sdl.SDL_SCANCODE_RCTRL,
        .right_alt => sdl.SDL_SCANCODE_RALT,
        .right_super => sdl.SDL_SCANCODE_RGUI,
        .menu => sdl.SDL_SCANCODE_MENU,
        .count => sdl.SDL_SCANCODE_UNKNOWN,
    };
}
