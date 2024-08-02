const std = @import("std");
const builtin = @import("builtin");
const c = @import("c.zig");
const pinc = @import("pinc.zig");
const internal = @import("internal.zig");

// SDL's API is very nice to use directly translate-c'd from the header,
// So there is no sdlLoad.h, pincsdl.h, or pincsdl.c
const sdl = @cImport({
    @cInclude("SDL2/SDL.h");
    @cInclude("SDL2/SDL_syswm.h");
});

// SDL function pointers (remember, we load things at runtime here)
const sdlf = struct {
    Init: *@TypeOf(sdl.SDL_Init),
    Quit: *@TypeOf(sdl.SDL_Quit),
    GetWindowWMInfo: *@TypeOf(sdl.SDL_GetWindowWMInfo),
    CreateWindow: *@TypeOf(sdl.SDL_CreateWindow),
    DestroyWindow: *@TypeOf(sdl.SDL_DestroyWindow),
    SetWindowSize: *@TypeOf(sdl.SDL_SetWindowSize),
    GetWindowSizeInPixels: *@TypeOf(sdl.SDL_GetWindowSizeInPixels),
    GL_CreateContext: *@TypeOf(sdl.SDL_GL_CreateContext),
    GL_MakeCurrent: *@TypeOf(sdl.SDL_GL_MakeCurrent),
    GL_GetProcAddress: *@TypeOf(sdl.SDL_GL_GetProcAddress),
    GL_SetSwapInterval: *@TypeOf(sdl.SDL_GL_SetSwapInterval),
    GL_SwapWindow: *@TypeOf(sdl.SDL_GL_SwapWindow),
    PollEvent: *@TypeOf(sdl.SDL_PollEvent),
    GetWindowFromID: *@TypeOf(sdl.SDL_GetWindowFromID),
    WaitEvent: *@TypeOf(sdl.SDL_WaitEvent),
    WaitEventTimeout: *@TypeOf(sdl.SDL_WaitEventTimeout),
    lib: std.DynLib,
    pub fn load() !sdlf {
        const sdl2libname = comptime switch (builtin.os.tag) {
            .linux, .freebsd, .netbsd, .openbsd, .dragonfly, .solaris, .illumos => "libSDL2.so",
            .windows => "SDL2.dll",
            // TODO: figure out if this is the correct name for darwin systems
            .macos, .ios, .tvos, .watchos, .visionos => "libSDL2.dylib",
            else => @compileError("Unsupported platform for loading SDL at runtime")
        };
        var lib = try std.DynLib.open(sdl2libname);
        return sdlf {
            .lib = lib,
            // TODO: investigate why lib.lookup returns null.
            // From what I can gather, libSDL.so doesn't actually export any symbols according to objdump... Very confusing.
            .Init = @ptrCast(lib.lookup(*anyopaque, "SDL_Init")),
            .Quit = @ptrCast(lib.lookup(*anyopaque, "SDL_Quit")),
            .GetWindowWMInfo = @ptrCast(lib.lookup(*anyopaque, "SDL_GetWindowWMInfo")),
            .CreateWindow = @ptrCast(lib.lookup(*anyopaque, "SDL_CreateWindow")),
            .DestroyWindow = @ptrCast(lib.lookup(*anyopaque, "SDL_DestroyWindow")),
            .SetWindowSize = @ptrCast(lib.lookup(*anyopaque, "SDL_SetWindowSize")),
            .GetWindowSizeInPixels = @ptrCast(lib.lookup(*anyopaque, "SDL_GetWindowSizeInPixels")),
            .GL_CreateContext = @ptrCast(lib.lookup(*anyopaque, "SDL_GL_CreateContext")),
            .GL_MakeCurrent = @ptrCast(lib.lookup(*anyopaque, "SDL_GL_MakeCurrent")),
            .GL_GetProcAddress = @ptrCast(lib.lookup(*anyopaque, "SDL_GL_GetProcAddress")),
            .GL_SetSwapInterval = @ptrCast(lib.lookup(*anyopaque, "SDL_GL_SetSwapInterval")),
            .GL_SwapWindow = @ptrCast(lib.lookup(*anyopaque, "SDL_GL_SwapWindow")),
            .PollEvent = @ptrCast(lib.lookup(*anyopaque, "SDL_PollEvent")),
            .GetWindowFromID = @ptrCast(lib.lookup(*anyopaque, "SDL_GetWindowFromID")),
            .WaitEvent = @ptrCast(lib.lookup(*anyopaque, "SDL_WaitEvent")),
            .WaitEventTimeout = @ptrCast(lib.lookup(*anyopaque, "SDL_WaitEventTimeout")),
        };
    }
};

// static bits
var libsdl: sdlf = undefined;

// the OpenGL context is lazy-initialized due to requiring a window (and I prefer to not keep a random temp window around if possible)
// This variable is not nullable because the SDL_GLContext type is itself nullable due to the translate-c thing.
var context: sdl.SDL_GLContext = null;

pub export fn pinc_init(window_api: c.pinc_window_api_enum, graphics_api: c.pinc_graphics_api_enum) bool {
    if(!pinc.init()){
        return false;
    }
    libsdl = sdlf.load() catch {
        return c.pinci_make_error(c.pinc_error_init, "Failed to load SDL2");
    };
    _ = window_api;
    // TODO: check error
    _ = libsdl.Init(sdl.SDL_INIT_VIDEO | sdl.SDL_INIT_EVENTS);

    if(!pinc.initGraphics(graphics_api)) {
        return false;
    }
    return true;
}

pub export fn pinc_destroy() void {
    libsdl.Quit();
}

pub export fn pinc_error_get() c.pinc_error_enum {
    return pinc.latestError;
}

pub export fn pinc_error_string() [*:0]const u8 {
    return pinc.latestErrorString;
}

// Cahced value for pinc_get_window_api
var underlyingApi: ?c.pinc_window_api_enum = null;

pub export fn pinc_get_window_api() c.pinc_window_api_enum {
    if(underlyingApi) |api| return api;
    // My friend, SDL, my pal, why the heck do I have to make a window in order to see what the backend API is?
    const sdlSubsys = blk: {
        var info = sdl.SDL_SysWMinfo{};
        // if there is already an existing window, use that to get the WM info
        for(pinc.windows.items) |windowOrIncompleteOrNone|{
            if(windowOrIncompleteOrNone) |windowOrIncomplete| {
                switch (windowOrIncomplete.native.coi) {
                    .complete => |completeWindow| {
                        // There is an existing window, return its subsystem
                        // TODO: error check
                        _ = libsdl.GetWindowWMInfo(completeWindow.sdlWin, &info);
                        break :blk info.subsystem;
                    },
                    else => {},
                }
            }
        }
        // No existing windows to use, make a super quick microscopic temp window that has a lifetime of literal microseconds in order to determine the underlying API
        const tempwindow = libsdl.CreateWindow("temp Pinc window", sdl.SDL_WINDOWPOS_UNDEFINED, sdl.SDL_WINDOWPOS_UNDEFINED, 10, 10, sdl.SDL_WINDOW_OPENGL);
        if(tempwindow == null) {
            _ = c.pinci_make_error(c.pinc_error_some, "Failed to make temporary window to determine underlying API");
            return c.pinc_window_api_automatic;
        }
        defer libsdl.DestroyWindow(tempwindow);
        // TODO: error check
        _ = libsdl.GetWindowWMInfo(tempwindow, &info);
        break :blk info.subsystem;
    };
    return switch (sdlSubsys) {
        sdl.SDL_SYSWM_X11 => c.pinc_window_api_x,
        sdl.SDL_SYSWM_WINDOWS => c.pinc_window_api_win32,
        else => c.pinc_window_api_automatic,
    };
}

pub export fn pinc_window_incomplete_create(title: ?[*:0]u8) c.pinc_window_incomplete_handle_t {
    const windowObj = pinc.Window {
        .native = .{
            .title = internal.pinci_dupe_string(title.?),
            .coi = .{
                .incomplete = .{
                    .width = 800,
                    .height = 600,
                }
            }
        },
    };
    // TODO: search for an empty slot instead of always making a new one
    pinc.windows.append(windowObj) catch {
        // TODO: a failed memory allocation probably warrants a full crash?
        _ = internal.pinci_make_error(c.pinc_error_some, "Failed to allocate memory");
        return 0;
    };
    // Remember, the handle to a window is its index + 1
    return @intCast(pinc.windows.items.len);
}

pub export fn pinc_window_set_size(window: c.pinc_window_incomplete_handle_t, width: u16, height: u16) bool {
    std.debug.assert(window > 0);
    const windowObj = &pinc.windows.items[window-1].?;
    switch(windowObj.native.coi) {
        .incomplete => |*incomplete| {
            incomplete.height = height;
            incomplete.width = width;
        },
        .complete => |complete| {
            // this SDL function, annoyingly, does not work in Pixels.
            // However, Pincs window size is done in pixels, leaving it to the user to determine the window's size in screen units.
            // TODO: anyway, just pretend that's not something that exist and just shove the pixel size into the function anyway
            libsdl.SetWindowSize(complete.sdlWin, @intCast(width), @intCast(height));
        }
    }
    return false;
}

pub export fn pinc_window_get_width(window: c.pinc_window_incomplete_handle_t) u16 {
    std.debug.assert(window > 0);
    const windowObj = pinc.windows.items[window-1].?;
    switch(windowObj.native.coi) {
        .incomplete => |incomplete| {
            return @intCast(incomplete.width);
        },
        .complete => |complete| {
            var width: c_int = 0;
            var height: c_int = 0;
            libsdl.GetWindowSizeInPixels(complete.sdlWin, &width, &height);
            return @intCast(width);
        }
    }
    return false;
}

pub export fn pinc_window_get_height(window: c.pinc_window_incomplete_handle_t) u16 {
    std.debug.assert(window > 0);
    const windowObj = pinc.windows.items[window-1].?;
    switch(windowObj.native.coi) {
        .incomplete => |incomplete| {
            return @intCast(incomplete.height);
        },
        .complete => |complete| {
            var width: c_int = 0;
            var height: c_int = 0;
            libsdl.GetWindowSizeInPixels(complete.sdlWin, &width, &height);
            return @intCast(height);
        }
    }
    return false;
}

// pub export fn pinc_window_get_scale(window: c.pinc_window_incomplete_handle_t) f32 {
//     _ = window; // autofix
// }

// pub export fn pinc_window_get_zoom(window: c.pinc_window_incomplete_handle_t) f32 {
//     _ = window; // autofix
// }

pub export fn pinc_window_destroy(window: c.pinc_window_incomplete_handle_t) void {
    const windowObj = &pinc.windows.items[window-1].?;
    switch (windowObj.native.coi) {
        .incomplete => {},
        .complete => |complete| {
            libsdl.DestroyWindow(complete.sdlWin);
        }
    }
    c.pinci_free_string(@constCast(windowObj.native.title));
    pinc.windows.items[window-1] = null;
}

pub export fn pinc_window_complete(incomplete: c.pinc_window_incomplete_handle_t) c.pinc_window_handle_t {
    const windowObj = &pinc.windows.items[incomplete-1].?;
    // Don't want to complete a window that has already been completed
    std.debug.assert(windowObj.native.coi == .incomplete);

    windowObj.native.coi = .{.complete = .{
        // TODO: handle case where returned window is null
        .sdlWin = libsdl.CreateWindow(windowObj.native.title, sdl.SDL_WINDOWPOS_UNDEFINED, sdl.SDL_WINDOWPOS_UNDEFINED, @intCast(windowObj.native.coi.incomplete.width), @intCast(windowObj.native.coi.incomplete.height), sdl.SDL_WINDOW_RESIZABLE | sdl.SDL_WINDOW_OPENGL).?,
    }};
    return incomplete;
}

pub inline fn setOpenGLFramebuffer(framebuffer: c.pinc_framebuffer_handle_t) void {
    // TODO: don't assume the framebuffer is a window
    const windowObj = &pinc.windows.items[framebuffer-1].?;
    std.debug.assert(windowObj.native.coi == .complete);
    if(context == null) {
        context = libsdl.GL_CreateContext(windowObj.native.coi.complete.sdlWin);
    }
    // TODO: check error
    _ = libsdl.GL_MakeCurrent(windowObj.native.coi.complete.sdlWin, context);
}

pub inline fn getOpenglProc(procname: [*:0]const u8) ?*anyopaque {
    return libsdl.GL_GetProcAddress(procname);
}

pub inline fn presentWindow(window: c.pinc_window_handle_t, vsync: bool) void {
    const windowObj = pinc.windows.items[window-1].?;
    std.debug.assert(windowObj.native.coi == .complete);
    // Unfortunately for me, setting the swap interval is OpenGL specific for SDL, which means I also have to make the window current...
    // TODO: error check
    // TODO: some extra logic to avoid calling MakeCurrent and SetSwapInterval where possible
    _ = libsdl.GL_MakeCurrent(windowObj.native.coi.complete.sdlWin, context);
    // TODO: error check
    _ = libsdl.GL_SetSwapInterval(if(vsync) -1 else 0);
    libsdl.GL_SwapWindow(windowObj.native.coi.complete.sdlWin);

}

pub inline fn waitForEvent(timeoutSeconds: f32) void {

    // SDL, annoyingly, will pop the event off the queue, so when we collect the events later it will be skipped...
    // Thankfully, Pinc's event system is nice and we can just shove it into our queue (:
    var ev: sdl.SDL_Event = undefined;
    if(std.math.isFinite(timeoutSeconds) and timeoutSeconds > 0){
        if(libsdl.WaitEventTimeout(&ev, @intFromFloat(timeoutSeconds * 1000)) == 0) {
            // TODO: error check
            return;
        }
    } else {
        // TODO: error check
        _ = libsdl.WaitEvent(&ev);
    }
    submitSdlEvent(&ev);
}

pub inline fn collectEvents() void {
    var event: sdl.SDL_Event = undefined;
    while(libsdl.PollEvent(&event) == sdl.SDL_TRUE) {
        submitSdlEvent(&event);
    }
}

fn submitSdlEvent(ev: *sdl.SDL_Event) void {
    // TODO: implement the rest of the events
    switch (ev.type) {
        sdl.SDL_WINDOWEVENT => {
            switch (ev.window.event) {
                sdl.SDL_WINDOWEVENT_CLOSE => {
                    const sdlWinOrNone = libsdl.GetWindowFromID(ev.window.windowID);
                    if(sdlWinOrNone) |sdlWin| {
                        const windowHandle = getWindowHandleFromSdlWindow(sdlWin);
                        if(windowHandle != 0){
                            c.pinci_send_event(.{
                                .type = c.pinc_event_window_close,
                                .data = .{.window_close = .{.window = windowHandle}}
                            });
                        }
                    }
                },
                else => {}
            }
        },
        else => {},
    }
}

fn getWindowHandleFromSdlWindow(sdlWin: *sdl.SDL_Window) c.pinc_window_incomplete_handle_t {
    for(pinc.windows.items, 0..) |item, index| {
        if(item) |window| {
            switch (window.native.coi) {
                .complete => |complete| {
                    if(complete.sdlWin == sdlWin) {
                        return @intCast(index+1);
                    }
                },
                else => {}
            }
        }
    }
    return 0;
}

const CompleteWindow = struct {
    sdlWin: *sdl.SDL_Window,
};

const IncompleteWindow = struct {
    width: u32,
    height: u32,
};

// This may seem like a complex data structure,
// But keep in mind that because the SDL backend is written entirely in Zig,
// it's worth taking full advantage of Zig's superior type system.
pub const NativeWindow = struct {
    title: [*:0]const u8,
    // Complete Or Incomplete
    coi: union(enum) {
        incomplete: IncompleteWindow,
        complete: CompleteWindow,
    },
};

