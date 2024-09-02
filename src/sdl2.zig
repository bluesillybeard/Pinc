const pinc = @import("pinc.zig");

pub const SDL2WindowBackend = struct {
    pub fn init(this: *SDL2WindowBackend) void {
        _ = this;
    }

    pub fn backendIsSupportedComptime() bool {
        // TODO: actually check
        return true;
    }

    pub fn backendIsSupported() bool {
        // TODO: actually check
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
        _ = this;
    }

    pub fn prepareGraphics(this: *SDL2WindowBackend, backend: pinc.GraphicsBackend) void {
        _ = this;
        _ = backend;
    }

    pub fn getFramebufferFormats(this: *SDL2WindowBackend) []const pinc.FramebufferFormat {
        // TODO:
        _ = this;
        unreachable;
    }

    pub fn prepareFramebuffer(this: *SDL2WindowBackend, framebuffer: pinc.FramebufferFormat) void {
        _ = this;
        _ = framebuffer;
    }

    pub fn createWindow(this: *SDL2WindowBackend, data: pinc.IncompleteWindow) pinc.ICompleteWindow {
        _ = this;
        _ = data;
        unreachable;
    }

    pub fn step(this: *SDL2WindowBackend) void {
        _ = this;
    }
};

pub const SDL2CompleteWindow = struct {
    pub fn init(this: *SDL2CompleteWindow) void {
        _ = this;
    }
};

// const std = @import("std");
// const builtin = @import("builtin");
// const c = @import("c.zig");
// const internal = @import("internal.zig");

// // SDL's API is very nice to use directly translate-c'd from the header,
// // So there is no sdlLoad.h, pincsdl.h, or pincsdl.c
// const sdl = @cImport({
//     @cInclude("SDL2/SDL.h");
//     @cInclude("SDL2/SDL_syswm.h");
// });

// // SDL function pointers (remember, we load things at runtime here)
// const sdlf = struct {
//     Init: *@TypeOf(sdl.SDL_Init),
//     Quit: *@TypeOf(sdl.SDL_Quit),
//     GetWindowWMInfo: *@TypeOf(sdl.SDL_GetWindowWMInfo),
//     CreateWindow: *@TypeOf(sdl.SDL_CreateWindow),
//     DestroyWindow: *@TypeOf(sdl.SDL_DestroyWindow),
//     SetWindowSize: *@TypeOf(sdl.SDL_SetWindowSize),
//     GetWindowSizeInPixels: *@TypeOf(sdl.SDL_GetWindowSizeInPixels),
//     GL_CreateContext: *@TypeOf(sdl.SDL_GL_CreateContext),
//     GL_MakeCurrent: *@TypeOf(sdl.SDL_GL_MakeCurrent),
//     GL_GetProcAddress: *@TypeOf(sdl.SDL_GL_GetProcAddress),
//     GL_SetSwapInterval: *@TypeOf(sdl.SDL_GL_SetSwapInterval),
//     GL_SwapWindow: *@TypeOf(sdl.SDL_GL_SwapWindow),
//     PollEvent: *@TypeOf(sdl.SDL_PollEvent),
//     GetWindowFromID: *@TypeOf(sdl.SDL_GetWindowFromID),
//     WaitEvent: *@TypeOf(sdl.SDL_WaitEvent),
//     WaitEventTimeout: *@TypeOf(sdl.SDL_WaitEventTimeout),
//     lib: std.DynLib,
//     pub fn load() !sdlf {
//         const sdl2libname = comptime switch (builtin.os.tag) {
//             .linux, .freebsd, .netbsd, .openbsd, .dragonfly, .solaris, .illumos => "libSDL2.so",
//             .windows => "SDL2.dll",
//             // TODO: figure out if this is the correct name for darwin systems
//             .macos, .ios, .tvos, .watchos, .visionos => "libSDL2.dylib",
//             else => @compileError("Unsupported platform for loading SDL at runtime")
//         };
//         var lib = try std.DynLib.open(sdl2libname);
//         return sdlf {
//             .lib = lib,
//             .Init = @ptrCast(lib.lookup(*anyopaque, "SDL_Init")),
//             .Quit = @ptrCast(lib.lookup(*anyopaque, "SDL_Quit")),
//             .GetWindowWMInfo = @ptrCast(lib.lookup(*anyopaque, "SDL_GetWindowWMInfo")),
//             .CreateWindow = @ptrCast(lib.lookup(*anyopaque, "SDL_CreateWindow")),
//             .DestroyWindow = @ptrCast(lib.lookup(*anyopaque, "SDL_DestroyWindow")),
//             .SetWindowSize = @ptrCast(lib.lookup(*anyopaque, "SDL_SetWindowSize")),
//             // Apparently GetWindowSizeInPixels is a newer function that is not in some builds of SDL.
//             // Thankfully, it is binary compatible with the regular GetWindowSize, so fallback to that.
//             .GetWindowSizeInPixels = @ptrCast(lib.lookup(*anyopaque, "SDL_GetWindowSizeInPixels") orelse lib.lookup(*anyopaque, "SDL_GetWindowSize")),
//             .GL_CreateContext = @ptrCast(lib.lookup(*anyopaque, "SDL_GL_CreateContext")),
//             .GL_MakeCurrent = @ptrCast(lib.lookup(*anyopaque, "SDL_GL_MakeCurrent")),
//             .GL_GetProcAddress = @ptrCast(lib.lookup(*anyopaque, "SDL_GL_GetProcAddress")),
//             .GL_SetSwapInterval = @ptrCast(lib.lookup(*anyopaque, "SDL_GL_SetSwapInterval")),
//             .GL_SwapWindow = @ptrCast(lib.lookup(*anyopaque, "SDL_GL_SwapWindow")),
//             .PollEvent = @ptrCast(lib.lookup(*anyopaque, "SDL_PollEvent")),
//             .GetWindowFromID = @ptrCast(lib.lookup(*anyopaque, "SDL_GetWindowFromID")),
//             .WaitEvent = @ptrCast(lib.lookup(*anyopaque, "SDL_WaitEvent")),
//             .WaitEventTimeout = @ptrCast(lib.lookup(*anyopaque, "SDL_WaitEventTimeout")),
//         };
//     }
// };

// // static bits
// var libsdl: sdlf = undefined;

// // the OpenGL context is lazy-initialized due to requiring a window (and I prefer to not keep a random temp window around if possible)
// // This variable is not nullable because the SDL_GLContext type is itself nullable due to the translate-c thing.
// var context: sdl.SDL_GLContext = null;

// var graphicsApi: c.pinc_graphics_api_enum = c.pinc_graphics_api_automatic;

// pub export fn pinc_init(window_api: c.pinc_window_api_enum, graphics_api: c.pinc_graphics_api_enum) bool {
//     if(!pinc.init()){
//         return false;
//     }
//     libsdl = sdlf.load() catch {
//         return c.pinci_make_error(c.pinc_error_init, "Failed to load SDL2");
//     };
//     graphicsApi = graphics_api;
//     _ = window_api;
//     // TODO: check error
//     _ = libsdl.Init(sdl.SDL_INIT_VIDEO | sdl.SDL_INIT_EVENTS);

//     // Don't load the OpenGL functions here, wait until the first window (and thus the OpenGL context) is created.
//     // if(!pinc.initGraphics(graphics_api)) {
//     //     return false;
//     // }
//     return true;
// }

// pub export fn pinc_destroy() void {
//     libsdl.Quit();
// }

// pub export fn pinc_error_get() c.pinc_error_enum {
//     return pinc.latestError;
// }

// pub export fn pinc_error_string() [*:0]const u8 {
//     return pinc.latestErrorString;
// }

// // cached value for pinc_get_window_api
// var underlyingApi: ?c.pinc_window_api_enum = null;

// pub export fn pinc_get_window_api() c.pinc_window_api_enum {
//     if(underlyingApi) |api| return api;
//     // My friend, SDL, my pal, why do I have to make a window in order to see what the backend API is?
//     const sdlSubsys = blk: {
//         var info = sdl.SDL_SysWMinfo{};
//         // if there is already an existing window, use that to get the WM info
//         for(pinc.windows.items) |windowOrIncompleteOrNone|{
//             if(windowOrIncompleteOrNone) |windowOrIncomplete| {
//                 switch (windowOrIncomplete.native.coi) {
//                     .complete => |completeWindow| {
//                         // There is an existing window, return its subsystem
//                         // TODO: error check
//                         _ = libsdl.GetWindowWMInfo(completeWindow.sdlWin, &info);
//                         break :blk info.subsystem;
//                     },
//                     else => {},
//                 }
//             }
//         }
//         // No existing windows to use, make a super quick microscopic temp window that has a lifetime of literal microseconds in order to determine the underlying API
//         const tempwindow = libsdl.CreateWindow("temp Pinc window", sdl.SDL_WINDOWPOS_UNDEFINED, sdl.SDL_WINDOWPOS_UNDEFINED, 10, 10, sdl.SDL_WINDOW_OPENGL);
//         if(tempwindow == null) {
//             _ = c.pinci_make_error(c.pinc_error_some, "Failed to make temporary window to determine underlying API");
//             return c.pinc_window_api_automatic;
//         }
//         defer libsdl.DestroyWindow(tempwindow);
//         // TODO: error check
//         _ = libsdl.GetWindowWMInfo(tempwindow, &info);
//         break :blk info.subsystem;
//     };
//     return switch (sdlSubsys) {
//         sdl.SDL_SYSWM_X11 => c.pinc_window_api_x,
//         sdl.SDL_SYSWM_WINDOWS => c.pinc_window_api_win32,
//         else => c.pinc_window_api_automatic,
//     };
// }

// pub export fn pinc_window_incomplete_create(title: ?[*:0]u8) c.pinc_window_incomplete_handle_t {
//     const windowObj = pinc.Window {
//         .native = .{
//             .title = internal.pinci_dupe_string(title.?),
//             .coi = .{
//                 .incomplete = .{
//                     .width = 800,
//                     .height = 600,
//                 }
//             }
//         },
//     };
//     // TODO: search for an empty slot instead of always making a new one
//     pinc.windows.append(windowObj) catch {
//         // TODO: a failed memory allocation probably warrants a full crash?
//         _ = internal.pinci_make_error(c.pinc_error_some, "Failed to allocate memory");
//         return 0;
//     };
//     // Remember, the handle to a window is its index + 1
//     return @intCast(pinc.windows.items.len);
// }

// pub export fn pinc_window_set_size(window: c.pinc_window_incomplete_handle_t, width: u16, height: u16) bool {
//     std.debug.assert(window > 0);
//     const windowObj = &pinc.windows.items[window-1].?;
//     switch(windowObj.native.coi) {
//         .incomplete => |*incomplete| {
//             incomplete.height = height;
//             incomplete.width = width;
//         },
//         .complete => |complete| {
//             // this SDL function, annoyingly, does not work in Pixels.
//             // However, Pincs window size is done in pixels, leaving it to the user to determine the window's size in screen units.
//             // TODO: anyway, just pretend that's not something that exist and just shove the pixel size into the function anyway
//             libsdl.SetWindowSize(complete.sdlWin, @intCast(width), @intCast(height));
//         }
//     }
//     return false;
// }

// pub export fn pinc_window_get_width(window: c.pinc_window_incomplete_handle_t) u16 {
//     std.debug.assert(window > 0);
//     const windowObj = pinc.windows.items[window-1].?;
//     switch(windowObj.native.coi) {
//         .incomplete => |incomplete| {
//             return @intCast(incomplete.width);
//         },
//         .complete => |complete| {
//             var width: c_int = 0;
//             var height: c_int = 0;
//             libsdl.GetWindowSizeInPixels(complete.sdlWin, &width, &height);
//             return @intCast(width);
//         }
//     }
//     return false;
// }

// pub export fn pinc_window_get_height(window: c.pinc_window_incomplete_handle_t) u16 {
//     std.debug.assert(window > 0);
//     const windowObj = pinc.windows.items[window-1].?;
//     switch(windowObj.native.coi) {
//         .incomplete => |incomplete| {
//             return @intCast(incomplete.height);
//         },
//         .complete => |complete| {
//             var width: c_int = 0;
//             var height: c_int = 0;
//             libsdl.GetWindowSizeInPixels(complete.sdlWin, &width, &height);
//             return @intCast(height);
//         }
//     }
//     return false;
// }

// // pub export fn pinc_window_get_scale(window: c.pinc_window_incomplete_handle_t) f32 {
// //     _ = window; // autofix
// // }

// // pub export fn pinc_window_get_zoom(window: c.pinc_window_incomplete_handle_t) f32 {
// //     _ = window; // autofix
// // }

// pub export fn pinc_window_destroy(window: c.pinc_window_incomplete_handle_t) void {
//     const windowObj = &pinc.windows.items[window-1].?;
//     switch (windowObj.native.coi) {
//         .incomplete => {},
//         .complete => |complete| {
//             libsdl.DestroyWindow(complete.sdlWin);
//         }
//     }
//     c.pinci_free_string(@constCast(windowObj.native.title));
//     pinc.windows.items[window-1] = null;
// }

// pub export fn pinc_window_complete(incomplete: c.pinc_window_incomplete_handle_t) c.pinc_window_handle_t {
//     const windowObj = &pinc.windows.items[incomplete-1].?;
//     // Don't want to complete a window that has already been completed
//     std.debug.assert(windowObj.native.coi == .incomplete);

//     windowObj.native.coi = .{.complete = .{
//         // TODO: handle case where returned window is null
//         .sdlWin = libsdl.CreateWindow(windowObj.native.title, sdl.SDL_WINDOWPOS_UNDEFINED, sdl.SDL_WINDOWPOS_UNDEFINED, @intCast(windowObj.native.coi.incomplete.width), @intCast(windowObj.native.coi.incomplete.height), sdl.SDL_WINDOW_RESIZABLE | sdl.SDL_WINDOW_OPENGL).?,
//     }};
//     return incomplete;
// }

// pub inline fn setOpenGLFramebuffer(framebuffer: c.pinc_framebuffer_handle_t) bool {
//     // TODO: don't assume the framebuffer is a window
//     const windowObj = &pinc.windows.items[framebuffer-1].?;
//     std.debug.assert(windowObj.native.coi == .complete);
//     if(context == null) {
//         context = libsdl.GL_CreateContext(windowObj.native.coi.complete.sdlWin);
//     }
//     // TODO: check error
//     _ = libsdl.GL_MakeCurrent(windowObj.native.coi.complete.sdlWin, context);
//     // Now that the opengl context is created, load the OpenGL functions from it
//     if(!pinc.initGraphics(graphicsApi)) {
//         return false;
//     }
//     return true;
// }

// pub inline fn getOpenglProc(procname: [*:0]const u8) ?*anyopaque {
//     return libsdl.GL_GetProcAddress(procname);
// }

// pub inline fn presentWindow(window: c.pinc_window_handle_t, vsync: bool) void {
//     const windowObj = pinc.windows.items[window-1].?;
//     std.debug.assert(windowObj.native.coi == .complete);
//     // Unfortunately for me, setting the swap interval is OpenGL specific for SDL, which means I also have to make the window current...
//     // TODO: error check
//     // TODO: some extra logic to avoid calling MakeCurrent and SetSwapInterval where possible
//     _ = libsdl.GL_MakeCurrent(windowObj.native.coi.complete.sdlWin, context);
//     // TODO: error check
//     _ = libsdl.GL_SetSwapInterval(if(vsync) -1 else 0);
//     libsdl.GL_SwapWindow(windowObj.native.coi.complete.sdlWin);

// }

// pub inline fn waitForEvent(timeoutSeconds: f32) void {

//     // SDL, annoyingly, will pop the event off the queue, so when we collect the events later it will be skipped...
//     // Thankfully, Pinc's event system is nice and we can just shove it into our queue (:
//     var ev: sdl.SDL_Event = undefined;
//     if(std.math.isFinite(timeoutSeconds) and timeoutSeconds > 0){
//         if(libsdl.WaitEventTimeout(&ev, @intFromFloat(timeoutSeconds * 1000)) == 0) {
//             // TODO: error check
//             return;
//         }
//     } else {
//         // TODO: error check
//         _ = libsdl.WaitEvent(&ev);
//     }
//     submitSdlEvent(&ev);
// }

// pub inline fn collectEvents() void {
//     var event: sdl.SDL_Event = undefined;
//     while(libsdl.PollEvent(&event) == sdl.SDL_TRUE) {
//         submitSdlEvent(&event);
//     }
// }

// fn submitSdlEvent(ev: *sdl.SDL_Event) void {
//     // TODO: implement the rest of the events
//     switch (ev.type) {
//         sdl.SDL_WINDOWEVENT => {
//             const sdlWinOrNone = libsdl.GetWindowFromID(ev.window.windowID);
//             if(sdlWinOrNone) |sdlWin|{
//                 const windowHandle = getWindowHandleFromSdlWindow(sdlWin);
//                 if(windowHandle != 0){
//                     switch (ev.window.event) {
//                         sdl.SDL_WINDOWEVENT_CLOSE => {
//                             c.pinci_send_event(.{
//                                 .type = c.pinc_event_window_close,
//                                 .data = .{.window_close = .{.window = windowHandle}}
//                             });
//                         },
//                         sdl.SDL_WINDOWEVENT_SIZE_CHANGED => {
//                             var width: c_int = 0;
//                             var height: c_int = 0;
//                             libsdl.GetWindowSizeInPixels(sdlWin, &width, &height);
//                             c.pinci_send_event(.{
//                                 .type = c.pinc_event_window_resize,
//                                 .data = .{.window_resize = .{.window = windowHandle, .width = @intCast(width), .height = @intCast(height)}}
//                             });
//                         },
//                         // Not sure what the difference between resized and size changed is.
//                         // The documentation is not clear either. SDL2 may be a great library, but it's positively confusing sometimes...
//                         sdl.SDL_WINDOWEVENT_RESIZED => {
//                             c.pinci_send_event(.{
//                                 .type = c.pinc_event_window_resize,
//                                 .data = .{.window_resize = .{.window = windowHandle, .width = @intCast(ev.window.data1), .height = @intCast(ev.window.data2)}}
//                             });
//                         },
//                         sdl.SDL_WINDOWEVENT_FOCUS_GAINED => {
//                             c.pinci_send_event(.{
//                                 .type = c.pinc_event_window_focus,
//                                 .data = .{.window_focus =  .{.window = windowHandle}}
//                             });
//                         },
//                         sdl.SDL_WINDOWEVENT_FOCUS_LOST => {
//                             c.pinci_send_event(.{
//                                 .type = c.pinc_event_window_unfocus,
//                                 .data = .{.window_unfocus = .{.window = windowHandle}}
//                             });
//                         },
//                         sdl.SDL_WINDOWEVENT_EXPOSED => {
//                             c.pinci_send_event(.{
//                                 .type = c.pinc_event_window_damaged,
//                                 .data = .{.window_damaged = .{.window = windowHandle}}
//                             });
//                         },
//                         else => {}
//                     }
//                 }
//             }
//         },
//         sdl.SDL_KEYDOWN => {
//             const sdlWinOrNone = libsdl.GetWindowFromID(ev.key.windowID);
//             if(sdlWinOrNone) |sdlWin|{
//                 const windowHandle = getWindowHandleFromSdlWindow(sdlWin);
//                 if(windowHandle != 0){
//                     if(ev.key.repeat == sdl.SDL_TRUE){
//                         c.pinci_send_event(.{
//                             .type = c.pinc_event_window_key_repeat,
//                             .data =.{.window_key_repeat = .{
//                                 .key = translateKeySym(ev.key.keysym.scancode),
//                                 .modifiers = translateModifiers(ev.key.keysym.mod),
//                                 .token = 0, // SDL does not give us the native API token (for example, the X keysym on the X11 backend), so just use zero.
//                                 .window = windowHandle
//                                 }
//                             }
//                         });
//                     } else {
//                         c.pinci_send_event(.{
//                             .type = c.pinc_event_window_key_down,
//                             .data =.{.window_key_down = .{
//                                 .key = translateKeySym(ev.key.keysym.scancode),
//                                 .modifiers = translateModifiers(ev.key.keysym.mod),
//                                 .token = 0, // SDL does not give us the native API token (for example, the X keysym on the X11 backend), so just use zero.
//                                 .window = windowHandle
//                                 }
//                             }
//                         });
//                     }
//                 }
//             }
//         },
//         sdl.SDL_KEYUP => {
//             const sdlWinOrNone = libsdl.GetWindowFromID(ev.key.windowID);
//             if(sdlWinOrNone) |sdlWin|{
//                 const windowHandle = getWindowHandleFromSdlWindow(sdlWin);
//                 if(windowHandle != 0){
//                     c.pinci_send_event(.{
//                         .type = c.pinc_event_window_key_up,
//                         .data =.{.window_key_up = .{
//                             .key = translateKeySym(ev.key.keysym.scancode),
//                             .modifiers = translateModifiers(ev.key.keysym.mod),
//                             .token = 0, // SDL does not give us the native API token (for example, the X keysym on the X11 backend), so just use zero.
//                             .window = windowHandle
//                             }
//                         }
//                     });
//                 }
//             }
//         },
//         sdl.SDL_TEXTINPUT => {
//             const sdlWinOrNone = libsdl.GetWindowFromID(ev.text.windowID);
//             if(sdlWinOrNone) |sdlWin|{
//                 const windowHandle = getWindowHandleFromSdlWindow(sdlWin);
//                 if(windowHandle != 0){
//                     // Pinc text events are done as an event per unicode point,
//                     // As such we need to iterate the UTF8 string that SDL provides
//                     var unicodeIter = std.unicode.Utf8Iterator{
//                         .bytes = std.mem.sliceTo(&ev.text.text, 0),
//                         .i = 0,
//                     };
//                     while(unicodeIter.nextCodepoint()) |codepoint|{
//                             c.pinci_send_event(.{
//                             .type = c.pinc_event_window_text,
//                             .data = .{
//                                 .window_text = .{
//                                     .codepoint = codepoint,
//                                     .window = windowHandle,
//                                 }
//                             }
//                         });
//                     }
//                 }
//             }
//         },
//         else => {},
//     }
// }

// fn translateModifiers(mods: u16) c.pinc_key_modifiers_t {
//     var pincMods: c.pinc_key_modifiers_t = 0;
//     if(mods & sdl.KMOD_SHIFT != 0) pincMods |= c.pinc_modifier_shift_bit;
//     if(mods & sdl.KMOD_CTRL != 0) pincMods |= c.pinc_modifier_control_bit;
//     if(mods & sdl.KMOD_ALT != 0) pincMods |= c.pinc_modifier_alt_bit;
//     // I can only assume the "gui" modifier corresponds with the super key
//     if(mods & sdl.KMOD_GUI != 0) pincMods |= c.pinc_modifier_super_bit;
//     if(mods & sdl.KMOD_CAPS != 0) pincMods |= c.pinc_modifier_caps_lock_bit;
//     if(mods & sdl.KMOD_NUM != 0) pincMods |= c.pinc_modifier_num_lock_bit;
//     return pincMods;
// }

// fn translateKeySym(sym: sdl.SDL_Scancode) c.pinc_key_code_enum {
//     return switch (sym) {
//         sdl.SDL_SCANCODE_UNKNOWN => c.pinc_key_code_unknown,
//         sdl.SDL_SCANCODE_A => c.pinc_key_code_a,
//         sdl.SDL_SCANCODE_B => c.pinc_key_code_b,
//         sdl.SDL_SCANCODE_C => c.pinc_key_code_c,
//         sdl.SDL_SCANCODE_D => c.pinc_key_code_d,
//         sdl.SDL_SCANCODE_E => c.pinc_key_code_e,
//         sdl.SDL_SCANCODE_F => c.pinc_key_code_f,
//         sdl.SDL_SCANCODE_G => c.pinc_key_code_g,
//         sdl.SDL_SCANCODE_H => c.pinc_key_code_h,
//         sdl.SDL_SCANCODE_I => c.pinc_key_code_i,
//         sdl.SDL_SCANCODE_J => c.pinc_key_code_j,
//         sdl.SDL_SCANCODE_K => c.pinc_key_code_k,
//         sdl.SDL_SCANCODE_L => c.pinc_key_code_l,
//         sdl.SDL_SCANCODE_M => c.pinc_key_code_m,
//         sdl.SDL_SCANCODE_N => c.pinc_key_code_n,
//         sdl.SDL_SCANCODE_O => c.pinc_key_code_o,
//         sdl.SDL_SCANCODE_P => c.pinc_key_code_p,
//         sdl.SDL_SCANCODE_Q => c.pinc_key_code_q,
//         sdl.SDL_SCANCODE_R => c.pinc_key_code_r,
//         sdl.SDL_SCANCODE_S => c.pinc_key_code_s,
//         sdl.SDL_SCANCODE_T => c.pinc_key_code_t,
//         sdl.SDL_SCANCODE_U => c.pinc_key_code_u,
//         sdl.SDL_SCANCODE_V => c.pinc_key_code_v,
//         sdl.SDL_SCANCODE_W => c.pinc_key_code_w,
//         sdl.SDL_SCANCODE_X => c.pinc_key_code_x,
//         sdl.SDL_SCANCODE_Y => c.pinc_key_code_y,
//         sdl.SDL_SCANCODE_Z => c.pinc_key_code_z,
//         sdl.SDL_SCANCODE_1 => c.pinc_key_code_1,
//         sdl.SDL_SCANCODE_2 => c.pinc_key_code_2,
//         sdl.SDL_SCANCODE_3 => c.pinc_key_code_3,
//         sdl.SDL_SCANCODE_4 => c.pinc_key_code_4,
//         sdl.SDL_SCANCODE_5 => c.pinc_key_code_5,
//         sdl.SDL_SCANCODE_6 => c.pinc_key_code_6,
//         sdl.SDL_SCANCODE_7 => c.pinc_key_code_7,
//         sdl.SDL_SCANCODE_8 => c.pinc_key_code_8,
//         sdl.SDL_SCANCODE_9 => c.pinc_key_code_9,
//         sdl.SDL_SCANCODE_0 => c.pinc_key_code_0,
//         sdl.SDL_SCANCODE_RETURN => c.pinc_key_code_enter,
//         sdl.SDL_SCANCODE_ESCAPE => c.pinc_key_code_escape,
//         sdl.SDL_SCANCODE_BACKSPACE => c.pinc_key_code_backspace,
//         sdl.SDL_SCANCODE_TAB => c.pinc_key_code_tab,
//         sdl.SDL_SCANCODE_SPACE => c.pinc_key_code_space,
//         sdl.SDL_SCANCODE_MINUS => c.pinc_key_code_dash,
//         sdl.SDL_SCANCODE_EQUALS => c.pinc_key_code_equals,
//         sdl.SDL_SCANCODE_LEFTBRACKET => c.pinc_key_code_left_bracket,
//         sdl.SDL_SCANCODE_RIGHTBRACKET => c.pinc_key_code_right_bracket,
//         sdl.SDL_SCANCODE_BACKSLASH => c.pinc_key_code_backslash,
//         //sdl.SDL_SCANCODE_NONUSHASH => c.pinc_key_code_, // what the heck is this
//         sdl.SDL_SCANCODE_SEMICOLON => c.pinc_key_code_semicolon,
//         sdl.SDL_SCANCODE_APOSTROPHE => c.pinc_key_code_apostrophe,
//         sdl.SDL_SCANCODE_GRAVE => c.pinc_key_code_backtick,
//         sdl.SDL_SCANCODE_COMMA => c.pinc_key_code_comma,
//         sdl.SDL_SCANCODE_PERIOD => c.pinc_key_code_dot,
//         sdl.SDL_SCANCODE_SLASH => c.pinc_key_code_slash,
//         sdl.SDL_SCANCODE_CAPSLOCK => c.pinc_key_code_caps_lock,
//         sdl.SDL_SCANCODE_F1 => c.pinc_key_code_f1,
//         sdl.SDL_SCANCODE_F2 => c.pinc_key_code_f2,
//         sdl.SDL_SCANCODE_F3 => c.pinc_key_code_f3,
//         sdl.SDL_SCANCODE_F4 => c.pinc_key_code_f4,
//         sdl.SDL_SCANCODE_F5 => c.pinc_key_code_f5,
//         sdl.SDL_SCANCODE_F6 => c.pinc_key_code_f6,
//         sdl.SDL_SCANCODE_F7 => c.pinc_key_code_f7,
//         sdl.SDL_SCANCODE_F8 => c.pinc_key_code_f8,
//         sdl.SDL_SCANCODE_F9 => c.pinc_key_code_f9,
//         sdl.SDL_SCANCODE_F10 => c.pinc_key_code_f10,
//         sdl.SDL_SCANCODE_F11 => c.pinc_key_code_f11,
//         sdl.SDL_SCANCODE_F12 => c.pinc_key_code_f12,
//         sdl.SDL_SCANCODE_PRINTSCREEN => c.pinc_key_code_print_screen,
//         sdl.SDL_SCANCODE_SCROLLLOCK => c.pinc_key_code_scroll_lock,
//         sdl.SDL_SCANCODE_PAUSE => c.pinc_key_code_pause,
//         sdl.SDL_SCANCODE_INSERT => c.pinc_key_code_insert,
//         sdl.SDL_SCANCODE_HOME => c.pinc_key_code_home,
//         sdl.SDL_SCANCODE_PAGEUP => c.pinc_key_code_page_up,
//         sdl.SDL_SCANCODE_DELETE => c.pinc_key_code_delete,
//         sdl.SDL_SCANCODE_END => c.pinc_key_code_end,
//         sdl.SDL_SCANCODE_PAGEDOWN => c.pinc_key_code_page_down,
//         sdl.SDL_SCANCODE_RIGHT => c.pinc_key_code_right,
//         sdl.SDL_SCANCODE_LEFT => c.pinc_key_code_left,
//         sdl.SDL_SCANCODE_DOWN => c.pinc_key_code_down,
//         sdl.SDL_SCANCODE_UP => c.pinc_key_code_up,
//         // sdl.SDL_SCANCODE_NUMLOCKCLEAR => c.pinc_key_code_,// what is this like what
//         sdl.SDL_SCANCODE_KP_DIVIDE => c.pinc_key_code_numpad_slash,
//         sdl.SDL_SCANCODE_KP_MULTIPLY => c.pinc_key_code_numpad_asterisk,
//         sdl.SDL_SCANCODE_KP_MINUS => c.pinc_key_code_numpad_dash,
//         sdl.SDL_SCANCODE_KP_PLUS => c.pinc_key_code_numpad_plus,
//         sdl.SDL_SCANCODE_KP_ENTER => c.pinc_key_code_numpad_enter,
//         sdl.SDL_SCANCODE_KP_1 => c.pinc_key_code_numpad_1,
//         sdl.SDL_SCANCODE_KP_2 => c.pinc_key_code_numpad_2,
//         sdl.SDL_SCANCODE_KP_3 => c.pinc_key_code_numpad_3,
//         sdl.SDL_SCANCODE_KP_4 => c.pinc_key_code_numpad_4,
//         sdl.SDL_SCANCODE_KP_5 => c.pinc_key_code_numpad_5,
//         sdl.SDL_SCANCODE_KP_6 => c.pinc_key_code_numpad_6,
//         sdl.SDL_SCANCODE_KP_7 => c.pinc_key_code_numpad_7,
//         sdl.SDL_SCANCODE_KP_8 => c.pinc_key_code_numpad_8,
//         sdl.SDL_SCANCODE_KP_9 => c.pinc_key_code_numpad_9,
//         sdl.SDL_SCANCODE_KP_0 => c.pinc_key_code_numpad_0,
//         sdl.SDL_SCANCODE_KP_PERIOD => c.pinc_key_code_numpad_dot,
//         // sdl.SDL_SCANCODE_NONUSBACKSLASH => c.pinc_key_code_a,// what is this
//         // sdl.SDL_SCANCODE_APPLICATION => c.pinc_key_code_a, // what the heck is the application button
//         // sdl.SDL_SCANCODE_POWER => c.pinc_key_code_a, //power button?
//         sdl.SDL_SCANCODE_KP_EQUALS => c.pinc_key_code_numpad_equal,
//         sdl.SDL_SCANCODE_F13 => c.pinc_key_code_f13,
//         sdl.SDL_SCANCODE_F14 => c.pinc_key_code_f14,
//         sdl.SDL_SCANCODE_F15 => c.pinc_key_code_f15,
//         sdl.SDL_SCANCODE_F16 => c.pinc_key_code_f16,
//         sdl.SDL_SCANCODE_F17 => c.pinc_key_code_f17,
//         sdl.SDL_SCANCODE_F18 => c.pinc_key_code_f18,
//         sdl.SDL_SCANCODE_F19 => c.pinc_key_code_f19,
//         sdl.SDL_SCANCODE_F20 => c.pinc_key_code_f20,
//         sdl.SDL_SCANCODE_F21 => c.pinc_key_code_f21,
//         sdl.SDL_SCANCODE_F22 => c.pinc_key_code_f22,
//         sdl.SDL_SCANCODE_F23 => c.pinc_key_code_f23,
//         sdl.SDL_SCANCODE_F24 => c.pinc_key_code_f24,
//         // sdl.SDL_SCANCODE_EXECUTE => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_HELP => c.pinc_key_code_a,
//         sdl.SDL_SCANCODE_MENU => c.pinc_key_code_menu,
//         // sdl.SDL_SCANCODE_SELECT => c.pinc_key_code_sele,
//         // sdl.SDL_SCANCODE_STOP => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_AGAIN => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_UNDO => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_CUT => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_COPY => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_PASTE => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_FIND => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_MUTE => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_VOLUMEUP => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_VOLUMEDOWN => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_KP_COMMA => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_KP_EQUALSAS400 => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_INTERNATIONAL1 => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_INTERNATIONAL2 => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_INTERNATIONAL3 => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_INTERNATIONAL4 => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_INTERNATIONAL5 => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_INTERNATIONAL6 => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_INTERNATIONAL7 => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_INTERNATIONAL8 => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_INTERNATIONAL9 => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_LANG1 => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_LANG2 => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_LANG3 => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_LANG4 => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_LANG5 => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_LANG6 => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_LANG7 => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_LANG8 => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_LANG9 => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_ALTERASE => c.pinc_key_code_a,
//         sdl.SDL_SCANCODE_SYSREQ => c.pinc_key_code_print_screen,
//         // I didn't even know half of these keys existed
//         // sdl.SDL_SCANCODE_CANCEL => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_CLEAR => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_PRIOR => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_RETURN2 => c.pinc_key_code_a, // A second return key?
//         // sdl.SDL_SCANCODE_SEPARATOR => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_OUT => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_OPER => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_CLEARAGAIN => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_CRSEL => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_EXSEL => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_KP_00 => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_KP_000 => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_THOUSANDSSEPARATOR => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_DECIMALSEPARATOR => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_CURRENCYUNIT => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_CURRENCYSUBUNIT => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_KP_LEFTPAREN => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_KP_RIGHTPAREN => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_KP_LEFTBRACE => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_KP_RIGHTBRACE => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_KP_TAB => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_KP_BACKSPACE => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_KP_A => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_KP_B => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_KP_C => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_KP_D => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_KP_E => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_KP_F => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_KP_XOR => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_KP_POWER => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_KP_PERCENT => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_KP_LESS => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_KP_GREATER => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_KP_AMPERSAND => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_KP_DBLAMPERSAND => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_KP_VERTICALBAR => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_KP_DBLVERTICALBAR => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_KP_COLON => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_KP_HASH => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_KP_SPACE => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_KP_AT => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_KP_EXCLAM => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_KP_MEMSTORE => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_KP_MEMRECALL => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_KP_MEMCLEAR => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_KP_MEMADD => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_KP_MEMSUBTRACT => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_KP_MEMMULTIPLY => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_KP_MEMDIVIDE => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_KP_PLUSMINUS => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_KP_CLEAR => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_KP_CLEARENTRY => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_KP_BINARY => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_KP_OCTAL => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_KP_DECIMAL => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_KP_HEXADECIMAL => c.pinc_key_code_a,
//         sdl.SDL_SCANCODE_LCTRL => c.pinc_key_code_left_control,
//         sdl.SDL_SCANCODE_LSHIFT => c.pinc_key_code_left_shift,
//         sdl.SDL_SCANCODE_LALT => c.pinc_key_code_left_alt,
//         // sdl.SDL_SCANCODE_LGUI => c.pinc_key_code_a, //what the heck is the gui function?
//         sdl.SDL_SCANCODE_RCTRL => c.pinc_key_code_right_control,
//         sdl.SDL_SCANCODE_RSHIFT => c.pinc_key_code_right_shift,
//         sdl.SDL_SCANCODE_RALT => c.pinc_key_code_right_alt,
//         //sdl.SDL_SCANCODE_RGUI => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_MODE => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_AUDIONEXT => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_AUDIOPREV => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_AUDIOSTOP => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_AUDIOPLAY => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_AUDIOMUTE => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_MEDIASELECT => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_WWW => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_MAIL => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_CALCULATOR => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_COMPUTER => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_AC_SEARCH => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_AC_HOME => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_AC_BACK => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_AC_FORWARD => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_AC_STOP => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_AC_REFRESH => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_AC_BOOKMARKS => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_BRIGHTNESSDOWN => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_BRIGHTNESSUP => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_DISPLAYSWITCH => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_KBDILLUMTOGGLE => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_KBDILLUMDOWN => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_KBDILLUMUP => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_EJECT => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_SLEEP => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_APP1 => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_APP2 => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_AUDIOREWIND => c.pinc_key_code_a,
//         // sdl.SDL_SCANCODE_AUDIOFASTFORWARD => c.pinc_key_code_a,
//         else => c.pinc_key_code_unknown,
//     };
// }

// fn getWindowHandleFromSdlWindow(sdlWin: *sdl.SDL_Window) c.pinc_window_incomplete_handle_t {
//     for(pinc.windows.items, 0..) |item, index| {
//         if(item) |window| {
//             switch (window.native.coi) {
//                 .complete => |complete| {
//                     if(complete.sdlWin == sdlWin) {
//                         return @intCast(index+1);
//                     }
//                 },
//                 else => {}
//             }
//         }
//     }
//     return 0;
// }

// const CompleteWindow = struct {
//     sdlWin: *sdl.SDL_Window,
// };

// const IncompleteWindow = struct {
//     width: u32,
//     height: u32,
// };

// // This may seem like a complex data structure,
// // But keep in mind that because the SDL backend is written entirely in Zig,
// // it's worth taking full advantage of Zig's superior type system.
// pub const NativeWindow = struct {
//     title: [*:0]const u8,
//     // Complete Or Incomplete
//     coi: union(enum) {
//         incomplete: IncompleteWindow,
//         complete: CompleteWindow,
//     },
// };
