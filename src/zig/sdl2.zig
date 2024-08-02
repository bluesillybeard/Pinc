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
            sdl.SDL_SetWindowSize(complete.sdlWin, @intCast(width), @intCast(height));
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
            sdl.SDL_GetWindowSizeInPixels(complete.sdlWin, &width, &height);
            return @intCast(width);
        }
    }
    return false;
}

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

