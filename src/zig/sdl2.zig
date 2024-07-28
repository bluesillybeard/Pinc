const std = @import("std");
const builtin = @import("builtin");
const c = @import("c.zig");
const pinc = @import("pinc.zig");

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

    lib: std.DynLib,
    pub fn load() !sdlf {
        const sdl2libname = comptime switch (builtin.os.tag) {
            .linux, .freebsd, .netbsd, .openbsd, .dragonfly, .solaris, .illumos => ".so",
            .windows => ".dll",
            .macos, .ios, .tvos, .watchos, .visionos => ".dylib",
            else => @compileError("Unsupported platform for loading SDL at runtime")
        };
        var lib = try std.DynLib.open(sdl2libname);
        return sdlf {
            .lib = lib,
            .Init = @ptrCast(lib.lookup(*anyopaque, "SDL_Init")),
            .Quit = @ptrCast(lib.lookup(*anyopaque, "SDL_Quit")),
            .GetWindowWMInfo = @ptrCast(lib.lookup(*anyopaque, "SDL_GetWindowWMInfo")),
            .CreateWindow = @ptrCast(lib.lookup(*anyopaque, "SDL_CreateWindow")),
            .DestroyWindow = @ptrCast(lib.lookup(*anyopaque, "SDL_DestroyWindow")),
        };
    }
};

// static bits
var libsdl: sdlf = undefined;


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
        if(pinc.windows.items.len > 0) {
            // TODO: error check
            _ = libsdl.GetWindowWMInfo(pinc.windows.items[0].?.native.sdlWin, &info);
            break :blk info.subsystem;
        }
        // No windows to use, make a super quick microscopic temp window that has a lifetime of literal microseconds in order to determine the underlying API
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

// pub export fn pinc_window_incomplete_create(title: [*:0]u8) c.pinc_window_incomplete_handle_t {
//     _ = title; // autofix
//     return 0;
// }

// pub export fn pinc_window_set_size(window: c.pinc_window_incomplete_handle_t, width: u16, height: u16) bool {
//     _ = window; // autofix
//     _ = width; // autofix
//     _ = height; // autofix
//     return false;
// }

// pub export fn pinc_window_get_width(window: c.pinc_window_incomplete_handle_t) u16 {
//     _ = window; // autofix
// }

// pub export fn pinc_window_get_height(window: c.pinc_window_incomplete_handle_t) u16 {
//     _ = window; // autofix
// }

// pub export fn pinc_window_get_scale(window: c.pinc_window_incomplete_handle_t) f32 {
//     _ = window; // autofix
// }

// pub export fn pinc_window_get_zoom(window: c.pinc_window_incomplete_handle_t) f32 {
//     _ = window; // autofix
// }

// pub export fn pinc_window_destroy(window: c.pinc_window_incomplete_handle_t) void {
//     _ = window; // autofix
// }

// pub export fn pinc_window_complete(incomplete: c.pinc_window_incomplete_handle_t) c.pinc_window_handle_t {
//     _ = incomplete; // autofix
// }

pub inline fn setOpenGLFramebuffer(framebuffer: c.pinc_framebuffer_handle_t) void {
    _ = framebuffer; // autofix
}

pub inline fn getOpenglProc(procname: [*:0]const u8) ?*anyopaque {
    _ = procname; // autofix
    return null;
}

pub inline fn presentWindow(window: c.pinc_window_handle_t, vsync: bool) void {
    _ = window; // autofix
    _ = vsync; // autofix
}

pub inline fn waitForEvent(timeoutSeconds: f32) void {
    _ = timeoutSeconds; // autofix
}

pub inline fn collectEvents() void {
}

pub const NativeWindow = struct {
    sdlWin: *sdl.SDL_Window
};
