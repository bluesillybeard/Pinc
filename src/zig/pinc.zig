// This _IS NOT_ meant to be included by Zig directly. For now, @cImport the header. Sorry, Pinc may be written *in* Zig, but it is *not* written *for* Zig.

const c = @import("c.zig");
const std = @import("std");
const gl21bind = @import("ext/gl21load.zig");
const builtin = @import("builtin");

// API functions are exported by this native struct.
// We do it like this so that functions that aren't implemented for a specific backend cause link errors.
// The alternative is getting some kind of crash when an unimplemented function is called at runtime, which is definitely not ideal.
// This does mean more boilerplate code, but I think that's OK.
const native = switch (builtin.os.tag) {
    .linux => @import("x11.zig"),
    .windows => @import("win32.zig"),
    else => @compileError("Unsupported OS"),
};
// This is to make sure the compiler actually includes all of our exported functions
usingnamespace native;

const graphics = @import("graphics.zig");
usingnamespace graphics;

const internal = @import("internal.zig");
usingnamespace internal;

const NativeWindow = switch(builtin.os.tag) {
    .linux => c.x11_window,
    // .windows => c.win32_window,
    else => @compileError("Unsupported OS"),
};

// the C api cannot use Zig errors,
// and returning a result type on every single function is just really annoying.
// So, functions that may result in an error return a boolean, and if the return value is false the program can then get more detail
pub var latestError: c.pinc_error_enum = c.pinc_error_none;
pub var latestErrorString: [*:0]const u8 = "";

pub const Window = struct {
    native: NativeWindow,
    // per-window event buffers
    eventWindowResize: ?c.pinc_event_window_resize_t = null,
    eventWindowFocus: ?c.pinc_event_window_focus_t = null,
    eventWindowUnfocus: ?c.pinc_event_window_unfocus_t = null,
    eventWindowDamaged: ?c.pinc_event_window_damaged_t = null,
    eventWindowCursorMove: ?c.pinc_event_window_cursor_move_t = null,
    eventWindowScroll: ?c.pinc_event_window_scroll_t = null,
    eventWindowClose: ?c.pinc_event_window_close_t = null,
};

// this is a sparse list where the index is equal to the window handle-1 (so handle 0 is a 'null' handle)
pub var windows: std.ArrayList(?Window) = undefined;

// TODO: refactor to an events struct? Honestly the entire event system needs to be refactored...
// global events buffers
pub var eventsWindowKeyDown: std.ArrayList(c.pinc_event_window_key_down_t) = undefined;
pub var eventsWindowKeyUp: std.ArrayList(c.pinc_event_window_key_up_t) = undefined;
pub var eventsWindowKeyRepeat: std.ArrayList(c.pinc_event_window_key_repeat_t) = undefined;
pub var eventsWindowText: std.ArrayList(c.pinc_event_window_text_t) = undefined;
pub var eventsWindowCursorEnter: std.ArrayList(c.pinc_event_window_cursor_enter_t) = undefined;
pub var eventsWindowCursorExit: std.ArrayList(c.pinc_event_window_cursor_exit_t) = undefined;
pub var eventsWindowCursorButtonDown: std.ArrayList(c.pinc_event_window_cursor_button_down_t) = undefined;
pub var eventsWindowCursorButtonUp: std.ArrayList(c.pinc_event_window_cursor_button_up_t) = undefined;

const AllocatorType = std.heap.GeneralPurposeAllocator(.{});
var allocatorObj: AllocatorType = undefined;
pub var allocator: std.mem.Allocator = undefined;

pub fn init(graphics_api: c.pinc_graphics_api_enum, nativeInit: fn(c.pinc_graphics_api_enum) callconv(.C) bool) bool {
    allocatorObj = .{};
    allocator = allocatorObj.allocator();
    // Initialize data structures and stuff
    windows = std.ArrayList(?Window).init(allocator);
    eventsWindowKeyDown = std.ArrayList(c.pinc_event_window_key_down_t).init(allocator);
    eventsWindowKeyUp = std.ArrayList(c.pinc_event_window_key_up_t).init(allocator);
    eventsWindowKeyRepeat = std.ArrayList(c.pinc_event_window_key_repeat_t).init(allocator);
    eventsWindowText = std.ArrayList(c.pinc_event_window_text_t).init(allocator);
    eventsWindowCursorEnter = std.ArrayList(c.pinc_event_window_cursor_enter_t).init(allocator);
    eventsWindowCursorExit = std.ArrayList(c.pinc_event_window_cursor_exit_t).init(allocator);
    eventsWindowCursorButtonDown = std.ArrayList(c.pinc_event_window_cursor_button_down_t).init(allocator);
    eventsWindowCursorButtonUp = std.ArrayList(c.pinc_event_window_cursor_button_up_t).init(allocator);
    if(!nativeInit(graphics_api)) {
        return false;
    }
    std.log.info("Loading OpenGL 2.1 functions", .{});
    gl21bind.load(void{}, getOpenglProc) catch {
        _ = c.pinci_make_error(c.pinc_error_init, "Failed to load OpenGL functions");
    };
    return true;
}

fn getOpenglProc(context: void, name: [:0]const u8) ?gl21bind.FunctionPointer {
    _ = context;
    return @ptrCast(c.pinc_graphics_opengl_get_proc(name.ptr));
}

pub fn sendEvent(event: c.pinc_event_union_t) callconv(.C) void {
    switch (event.type) {
        c.pinc_event_none => {},
        c.pinc_event_window_resize => {
            const evdat = event.data.window_resize;
            if (evdat.window == 0) return;
            if (windows.items[evdat.window - 1] == null) return;
            const window = &windows.items[evdat.window - 1].?;
            // override previous size
            window.eventWindowResize = evdat;
        },
        c.pinc_event_window_focus => {
            const evdat = event.data.window_focus;
            if (evdat.window == 0) return;
            if (windows.items[evdat.window - 1] == null) return;
            const window = &windows.items[evdat.window - 1].?;
            // override previous size
            window.eventWindowFocus = evdat;
        },
        c.pinc_event_window_unfocus => {
            const evdat = event.data.window_unfocus;
            if (evdat.window == 0) return;
            if (windows.items[evdat.window - 1] == null) return;
            const window = &windows.items[evdat.window - 1].?;
            // override previous size
            window.eventWindowUnfocus = evdat;
        },
        c.pinc_event_window_damaged => {
            const evdat = event.data.window_damaged;
            if (evdat.window == 0) return;
            if (windows.items[evdat.window - 1] == null) return;
            const window = &windows.items[evdat.window - 1].?;
            // override previous event
            window.eventWindowDamaged = evdat;
        },
        c.pinc_event_window_key_down => {
            const evdat = event.data.window_key_down;
            if (evdat.window == 0) return;
            if (windows.items[evdat.window - 1] == null) return;
            eventsWindowKeyDown.append(evdat) catch std.debug.panic("Out of memory", .{});
        },
        c.pinc_event_window_key_up => {
            const evdat = event.data.window_key_up;
            if (evdat.window == 0) return;
            if (windows.items[evdat.window - 1] == null) return;
            eventsWindowKeyUp.append(evdat) catch std.debug.panic("Out of memory", .{});
        },
        c.pinc_event_window_key_repeat => {
            const evdat = event.data.window_key_repeat;
            if (evdat.window == 0) return;
            if (windows.items[evdat.window - 1] == null) return;
            eventsWindowKeyRepeat.append(evdat) catch std.debug.panic("Out of memory", .{});
        },
        c.pinc_event_window_text => {
            const evdat = event.data.window_text;
            if (evdat.window == 0) return;
            if (windows.items[evdat.window - 1] == null) return;
            eventsWindowText.append(evdat) catch std.debug.panic("Out of memory", .{});
        },
        c.pinc_event_window_cursor_move => {
            // Remember: the X backend only sets the pixel coords, not delta or screen coords.
            const evdat = event.data.window_cursor_move;
            if (evdat.window == 0) return;
            if (windows.items[evdat.window - 1] == null) return;
            const window = &windows.items[evdat.window - 1].?;
            // TODO: update current pos, calculate delta and screen coords
            if (window.eventWindowCursorMove == null) {
                window.eventWindowCursorMove = evdat;
            } else {
                window.eventWindowCursorMove.?.x_pixels = evdat.x_pixels;
                window.eventWindowCursorMove.?.y_pixels = evdat.y_pixels;
            }
        },
        c.pinc_event_window_cursor_enter => {
            const evdat = event.data.window_cursor_enter;
            if (evdat.window == 0) return;
            if (windows.items[evdat.window - 1] == null) return;
            eventsWindowCursorEnter.append(evdat) catch std.debug.panic("Out of memory", .{});
        },
        c.pinc_event_window_cursor_exit => {
            const evdat = event.data.window_cursor_exit;
            if (evdat.window == 0) return;
            if (windows.items[evdat.window - 1] == null) return;
            eventsWindowCursorExit.append(evdat) catch std.debug.panic("Out of memory", .{});
        },
        c.pinc_event_window_cursor_button_down => {
            const evdat = event.data.window_cursor_button_down;
            if (evdat.window == 0) return;
            if (windows.items[evdat.window - 1] == null) return;
            eventsWindowCursorButtonDown.append(evdat) catch std.debug.panic("Out of memory", .{});
        },
        c.pinc_event_window_cursor_button_up => {
            const evdat = event.data.window_cursor_button_up;
            if (evdat.window == 0) return;
            if (windows.items[evdat.window - 1] == null) return;
            eventsWindowCursorButtonUp.append(evdat) catch std.debug.panic("Out of memory", .{});
        },
        c.pinc_event_window_scroll => {
            const evdat = event.data.window_scroll;
            if (evdat.window == 0) return;
            if (windows.items[evdat.window - 1] == null) return;
            const window = &windows.items[evdat.window - 1].?;
            // override previous event
            window.eventWindowScroll = evdat;
        },
        c.pinc_event_window_close => {
            const evdat = event.data.window_close;
            if (evdat.window == 0) return;
            if (windows.items[evdat.window - 1] == null) return;
            const window = &windows.items[evdat.window - 1].?;
            window.eventWindowClose = evdat;
        },
        // TODO: handle this case maybe?
        else => {},
    }
}
// Gets the current event
// TODO: this entire thing is in severe need of a refactoring. Perhaps the entire way the event system is implemented needs some reworking.
pub fn getEvent(clear: bool) c.pinc_event_union_t {
    // This comes pretty close to the worst code I have ever emitted from my dumb brain.
    // Section for top priority
    for (windows.items) |*windowOrNone| {
        if (windowOrNone.* == null) continue;
        const window = &windowOrNone.*.?;
        if (window.eventWindowResize) |resize| {
            const eventUnion = c.pinc_event_union_t{
                .type = c.pinc_event_window_resize,
                .data = .{ .window_resize = resize },
            };
            if (clear) window.eventWindowResize = null;
            return eventUnion;
        }
        if (window.eventWindowFocus) |focus| {
            const eventUnion = c.pinc_event_union_t{
                .type = c.pinc_event_window_focus,
                .data = .{ .window_focus = focus },
            };
            if (clear) window.eventWindowFocus = null;
            return eventUnion;
        }
        if (window.eventWindowUnfocus) |unfocus| {
            const eventUnion = c.pinc_event_union_t{
                .type = c.pinc_event_window_unfocus,
                .data = .{ .window_unfocus = unfocus },
            };
            if (clear) window.eventWindowUnfocus = null;
            return eventUnion;
        }
    }
    // section for second priority
    for (windows.items) |*windowOrNone| {
        if (windowOrNone.* == null) continue;
        const window = &windowOrNone.*.?;
        if (window.eventWindowDamaged) |damaged| {
            const eventUnion = c.pinc_event_union_t{
                .type = c.pinc_event_window_damaged,
                .data = .{ .window_damaged = damaged },
            };
            if (clear) window.eventWindowDamaged = null;
            return eventUnion;
        }
    }
    // section for tertiary priority
    if (eventsWindowKeyDown.items.len > 0) {
        return c.pinc_event_union_t{
            .type = c.pinc_event_window_key_down,
            .data = .{ .window_key_down = if (clear) eventsWindowKeyDown.pop() else eventsWindowKeyDown.getLast() },
        };
    }
    // pinc_event_window_key_up,
    if (eventsWindowKeyUp.items.len > 0) {
        return c.pinc_event_union_t{
            .type = c.pinc_event_window_key_up,
            .data = .{ .window_key_up = if (clear) eventsWindowKeyUp.pop() else eventsWindowKeyUp.getLast() },
        };
    }
    if (eventsWindowKeyRepeat.items.len > 0) {
        return c.pinc_event_union_t{
            .type = c.pinc_event_window_key_repeat,
            .data = .{ .window_key_repeat = if (clear) eventsWindowKeyRepeat.pop() else eventsWindowKeyRepeat.getLast() },
        };
    }
    // pinc_event_window_text,
    if (eventsWindowText.items.len > 0) {
        return c.pinc_event_union_t{
            .type = c.pinc_event_window_text,
            .data = .{ .window_text = if (clear) eventsWindowText.pop() else eventsWindowText.getLast() },
        };
    }
    // section for 4th priority
    for (windows.items) |*windowOrNone| {
        if (windowOrNone.* == null) continue;
        const window = &windowOrNone.*.?;
        if (window.eventWindowCursorMove) |move| {
            const eventUnion = c.pinc_event_union_t{
                .type = c.pinc_event_window_cursor_move,
                .data = .{ .window_cursor_move = move },
            };
            if (clear) window.eventWindowCursorMove = null;
            return eventUnion;
        }
        if (window.eventWindowScroll) |scroll| {
            const eventUnion = c.pinc_event_union_t{
                .type = c.pinc_event_window_scroll,
                .data = .{ .window_scroll = scroll },
            };
            if (clear) window.eventWindowScroll = null;
            return eventUnion;
        }
    }
    if (eventsWindowCursorEnter.items.len > 0) {
        return c.pinc_event_union_t{
            .type = c.pinc_event_window_cursor_enter,
            .data = .{ .window_cursor_enter = if (clear) eventsWindowCursorEnter.pop() else eventsWindowCursorEnter.getLast() },
        };
    }
    if (eventsWindowCursorExit.items.len > 0) {
        return c.pinc_event_union_t{
            .type = c.pinc_event_window_cursor_exit,
            .data = .{ .window_cursor_exit = if (clear) eventsWindowCursorExit.pop() else eventsWindowCursorExit.getLast() },
        };
    }
    if (eventsWindowCursorButtonDown.items.len > 0) {
        return c.pinc_event_union_t{
            .type = c.pinc_event_window_cursor_button_down,
            .data = .{ .window_cursor_button_down = if (clear) eventsWindowCursorButtonDown.pop() else eventsWindowCursorButtonDown.getLast() },
        };
    }
    if (eventsWindowCursorButtonUp.items.len > 0) {
        return c.pinc_event_union_t{
            .type = c.pinc_event_window_cursor_button_up,
            .data = .{ .window_cursor_button_up = if (clear) eventsWindowCursorButtonUp.pop() else eventsWindowCursorButtonUp.getLast() },
        };
    }
    // section for lowest priority.

    for (windows.items) |*windowOrNone| {
        if (windowOrNone.* == null) continue;
        const window = &windowOrNone.*.?;
        if (window.eventWindowClose) |close| {
            const eventUnion = c.pinc_event_union_t{
                .type = c.pinc_event_window_close,
                .data = .{ .window_close = close },
            };
            if (clear) window.eventWindowClose = null;
            return eventUnion;
        }
    }
    return c.pinc_event_union_t{
        .type = c.pinc_event_none,
        .data = undefined,
    };
}