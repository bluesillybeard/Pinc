// All public types are defined here - no need to redefine them thanks to Zig's excellent C importer
// Also, this includes headers for internal components of Pinc that are written in C.
const c = @cImport({
    @cInclude("pinc.h");
    @cInclude("pincx.h");
});
const std = @import("std");
const NativeWindow = union(enum) {
    none,
    x: c.x11_window,
};

const PincWindow = struct {
    // Also holds whether this window is an empty slot or not
    native: NativeWindow = .none,
    // per-window event buffers
    eventWindowResize: ?c.pinc_event_window_resize_t = null,
    eventWindowFocus: ?c.pinc_event_window_focus_t = null,
    eventWindowUnfocus: ?c.pinc_event_window_unfocus_t = null,
    eventWindowDamaged: ?c.pinc_event_window_damaged_t = null,
    eventWindowCursorMove: ?c.pinc_event_window_cursor_move_t = null,
    eventWindowScroll: ?c.pinc_event_window_scroll_t = null,
    eventWindowClose: ?c.pinc_event_window_close_t = null,
};

// This code is called from C
fn x11_get_window_handle(xid: u32) callconv(.C) c.pinc_window_incomplete_handle_t {
    // xid is the Xlib ID of the window
    for (windows.items, 0..) |window, i| {
        switch (window.native) {
            .x => |xWindow| {
                if (xWindow.xWindow == xid) return @intCast(i + 1);
            },
            else => {},
        }
    }
    // No corresponding window was found, return 0.
    return 0;
}

comptime {
    @export(x11_get_window_handle, .{ .name = "x11_get_window_handle", .linkage = std.builtin.GlobalLinkage.link_once });
}

// Gets the current event
// TODO: this entire thing is in severe need of a refactoring. Perhaps the entire way the event system is implemented needs some reworking.
fn pinc_event_union(clear: bool) c.pinc_event_union_t {
    // This comes pretty close to the worst code I have ever emitted from my dumb brain.
    // Section for top priority
    for (windows.items) |*window| {
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
    for (windows.items) |*window| {
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
    for (windows.items) |*window| {
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

    for (windows.items) |*window| {
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

// this is a sparse list where the index is equal to the window handle-1 (so handle 0 is a 'null' handle)
var windows: std.ArrayList(PincWindow) = undefined;

// global events buffers
var eventsWindowKeyDown: std.ArrayList(c.pinc_event_window_key_down_t) = undefined;
var eventsWindowKeyUp: std.ArrayList(c.pinc_event_window_key_up_t) = undefined;
var eventsWindowKeyRepeat: std.ArrayList(c.pinc_event_window_key_repeat_t) = undefined;
var eventsWindowText: std.ArrayList(c.pinc_event_window_text_t) = undefined;
var eventsWindowCursorEnter: std.ArrayList(c.pinc_event_window_cursor_enter_t) = undefined;
var eventsWindowCursorExit: std.ArrayList(c.pinc_event_window_cursor_exit_t) = undefined;
var eventsWindowCursorButtonDown: std.ArrayList(c.pinc_event_window_cursor_button_down_t) = undefined;
var eventsWindowCursorButtonUp: std.ArrayList(c.pinc_event_window_cursor_button_up_t) = undefined;
const AllocatorType = std.heap.GeneralPurposeAllocator(.{});
var allocatorObj: AllocatorType = undefined;
var allocator: std.mem.Allocator = undefined;
// ALL public pinc functions are defined here. (and ONLY public functions)
// They may simply call into another function from another file, but they are all in this one place so it's easy to find them.

pub export fn pinc_init(window_api: c.pinc_window_api_t, graphics_api: c.pinc_graphics_api_t) bool {
    // Initialize data structures and stuff
    allocatorObj = .{};
    allocator = allocatorObj.allocator();
    windows = std.ArrayList(PincWindow).init(allocator);
    eventsWindowKeyDown = std.ArrayList(c.pinc_event_window_key_down_t).init(allocator);
    eventsWindowKeyUp = std.ArrayList(c.pinc_event_window_key_up_t).init(allocator);
    eventsWindowKeyRepeat = std.ArrayList(c.pinc_event_window_key_repeat_t).init(allocator);
    eventsWindowText = std.ArrayList(c.pinc_event_window_text_t).init(allocator);
    eventsWindowCursorEnter = std.ArrayList(c.pinc_event_window_cursor_enter_t).init(allocator);
    eventsWindowCursorExit = std.ArrayList(c.pinc_event_window_cursor_exit_t).init(allocator);
    eventsWindowCursorButtonDown = std.ArrayList(c.pinc_event_window_cursor_button_down_t).init(allocator);
    eventsWindowCursorButtonUp = std.ArrayList(c.pinc_event_window_cursor_button_up_t).init(allocator);
    // window API specific things
    var actualWindowAPI = window_api;
    if (window_api == c.pinc_window_api_automatic) {
        actualWindowAPI = c.pinc_window_api_x;
    }
    switch (actualWindowAPI) {
        c.pinc_window_api_x => {
            return c.x11_init();
        },
        else => {
            // TODO: figure out error reporting
            return false;
        },
    }
    _ = graphics_api;
}
pub export fn pinc_get_window_api() c.pinc_window_api_t {
    // X11 is the only supported API at the moment.
    // In the future, this will require more complex logic as
    // 1: the API depends on the system and
    // 2: on Posix systems, it may be determined at runtime to be either X11 or Wayland
    return c.pinc_window_api_x;
}
pub export fn pinc_window_incomplete_create(title: [*:0]u8) c.pinc_window_incomplete_handle_t {
    const xWindow = c.x11_window_incomplete_create(title);
    // TODO: find an empty spot
    windows.append(.{ .native = .{ .x = xWindow } }) catch return 0;
    return @intCast(windows.items.len);
}
pub export fn pinc_window_set_size(window: c.pinc_window_incomplete_handle_t, width: u16, height: u16) void {
    _ = window;
    _ = width;
    _ = height;
    std.debug.panic("pinc_window_set_size is not implemented\n", .{});
}
pub export fn pinc_window_get_width(window: c.pinc_window_incomplete_handle_t) u16 {
    _ = window;
    std.debug.panic("pinc_window_get_width is not implemented\n", .{});
}
pub export fn pinc_window_get_height(window: c.pinc_window_incomplete_handle_t) u16 {
    _ = window;
    std.debug.panic("pinc_window_get_height is not implemented\n", .{});
}
pub export fn pinc_window_get_scale(window: c.pinc_window_incomplete_handle_t) f32 {
    _ = window;
    return 1;
}
pub export fn pinc_window_get_top_border(window: c.pinc_window_incomplete_handle_t) f32 {
    _ = window;
    std.debug.panic("pinc_window_get_top_border is not implemented\n", .{});
}
pub export fn pinc_window_get_left_border(window: c.pinc_window_incomplete_handle_t) f32 {
    _ = window;
    std.debug.panic("pinc_window_get_left_border is not implemented\n", .{});
}
pub export fn pinc_window_get_right_border(window: c.pinc_window_incomplete_handle_t) f32 {
    _ = window;
    std.debug.panic("pinc_window_get_right_border is not implemented\n", .{});
}
pub export fn pinc_window_get_bottom_border(window: c.pinc_window_incomplete_handle_t) f32 {
    _ = window;
    std.debug.panic("pinc_window_get_bottom_border is not implemented\n", .{});
}
pub export fn pinc_window_get_zoom(window: c.pinc_window_incomplete_handle_t) f32 {
    _ = window;
    std.debug.panic("pinc_window_get_zoom is not implemented\n", .{});
}
pub export fn pinc_window_set_icon(window: c.pinc_window_incomplete_handle_t, data: [*]u8, size: u32) void {
    _ = window;
    _ = data;
    _ = size;
    std.debug.panic("pinc_window_set_icon is not implemented\n", .{});
}
pub export fn pinc_window_set_minimized(window: c.pinc_window_incomplete_handle_t, minimized: bool) void {
    _ = window;
    _ = minimized;
    std.debug.panic("pinc_window_set_minimized is not implemented\n", .{});
}
pub export fn pinc_window_get_minimized(window: c.pinc_window_incomplete_handle_t) bool {
    _ = window;
    std.debug.panic("pinc_window_get_minimized is not implemented\n", .{});
}
pub export fn pinc_window_set_resizable(window: c.pinc_window_incomplete_handle_t, resizable: bool) void {
    _ = window;
    _ = resizable;
    std.debug.panic("pinc_window_set_resizable is not implemented\n", .{});
}
pub export fn pinc_window_get_resizable(window: c.pinc_window_incomplete_handle_t) bool {
    _ = window;
    std.debug.panic("pinc_window_get_resizable is not implemented\n", .{});
}
pub export fn pinc_window_set_maximized(window: c.pinc_window_incomplete_handle_t, maximized: bool) void {
    _ = window;
    _ = maximized;
    std.debug.panic("pinc_window_set_maximized is not implemented\n", .{});
}
pub export fn pinc_window_get_maximized(window: c.pinc_window_incomplete_handle_t) bool {
    _ = window;
    std.debug.panic("pinc_window_get_maximized is not implemented\n", .{});
}
pub export fn pinc_window_set_fullscreen(window: c.pinc_window_incomplete_handle_t, fullscreen: bool, resize: bool) void {
    _ = window;
    _ = fullscreen;
    _ = resize;
    std.debug.panic("pinc_window_set_fullscreen is not implemented\n", .{});
}
pub export fn pinc_window_get_fullscreen(window: c.pinc_window_incomplete_handle_t) bool {
    _ = window;
    std.debug.panic("pinc_window_get_fullscreen is not implemented\n", .{});
}
pub export fn pinc_window_set_visible(window: c.pinc_window_incomplete_handle_t, visible: bool) void {
    _ = window;
    _ = visible;
    std.debug.panic("pinc_window_set_visible is not implemented\n", .{});
}
pub export fn pinc_window_get_visible(window: c.pinc_window_incomplete_handle_t) bool {
    _ = window;
    std.debug.panic("pinc_window_get_visible is not implemented\n", .{});
}
pub export fn pinc_window_set_transparency(window: c.pinc_window_incomplete_handle_t, blend: bool) void {
    _ = window;
    _ = blend;
    std.debug.panic("pinc_window_set_transparency is not implemented\n", .{});
}
pub export fn pinc_window_get_transparency(window: c.pinc_window_incomplete_handle_t) bool {
    _ = window;
    std.debug.panic("pinc_window_get_transparency is not implemented\n", .{});
}
pub export fn pinc_window_set_red_bits(window: c.pinc_window_incomplete_handle_t, red_bits: u16) bool {
    _ = window;
    _ = red_bits;
    std.debug.panic("pinc_window_set_red_bits is not implemented\n", .{});
}
pub export fn pinc_window_get_red_bits(window: c.pinc_window_incomplete_handle_t) u16 {
    _ = window;
    std.debug.panic("pinc_window_get_red_bits is not implemented\n", .{});
}
pub export fn pinc_window_set_green_bits(window: c.pinc_window_incomplete_handle_t, green_bits: u16) bool {
    _ = window;
    _ = green_bits;
    std.debug.panic("pinc_window_set_green_bits is not implemented\n", .{});
}
pub export fn pinc_window_get_green_bits(window: c.pinc_window_incomplete_handle_t) u16 {
    _ = window;
    std.debug.panic("pinc_window_get_green_bits is not implemented\n", .{});
}
pub export fn pinc_window_set_blue_bits(window: c.pinc_window_incomplete_handle_t, blue_bits: u16) bool {
    _ = window;
    _ = blue_bits;
    std.debug.panic("pinc_window_set_blue_bits is not implemented\n", .{});
}
pub export fn pinc_window_get_blue_bits(window: c.pinc_window_incomplete_handle_t) u16 {
    _ = window;
    std.debug.panic("pinc_window_get_blue_bits is not implemented\n", .{});
}
pub export fn pinc_window_set_alpha_bits(window: c.pinc_window_incomplete_handle_t, alpha_bits: u16) bool {
    _ = window;
    _ = alpha_bits;
    std.debug.panic("pinc_window_set_alpha_bits is not implemented\n", .{});
}
pub export fn pinc_window_get_alpha_bits(window: c.pinc_window_incomplete_handle_t) u16 {
    _ = window;
    std.debug.panic("pinc_window_get_alpha_bits is not implemented\n", .{});
}
pub export fn pinc_window_set_depth_bits(window: c.pinc_window_incomplete_handle_t, depth_bits: u16) bool {
    _ = window;
    _ = depth_bits;
    std.debug.panic("pinc_window_set_depth_bits is not implemented\n", .{});
}
pub export fn pinc_window_get_depth_bits(window: c.pinc_window_incomplete_handle_t) u16 {
    _ = window;
    std.debug.panic("pinc_window_get_depth_bits is not implemented\n", .{});
}
pub export fn pinc_window_set_stencil_bits(window: c.pinc_window_incomplete_handle_t, depth_bits: u16) bool {
    _ = window;
    _ = depth_bits;
    std.debug.panic("pinc_window_set_stencil_bits is not implemented\n", .{});
}
pub export fn pinc_window_get_stencil_bits(window: c.pinc_window_incomplete_handle_t) u16 {
    _ = window;
    std.debug.panic("pinc_window_get_stencil_bits is not implemented\n", .{});
}
pub export fn pinc_window_destroy(window: c.pinc_window_incomplete_handle_t) void {
    _ = window;
    std.debug.panic("pinc_window_destroy is not implemented\n", .{});
}
pub export fn pinc_window_complete(incomplete: c.pinc_window_incomplete_handle_t) c.pinc_window_handle_t {
    if (incomplete == 0) return 0;
    // Get a pointer to the internal window handle.
    // The list does not change within this function call so the memory will stay valid
    // the internal function does not keep a pointer to the window.
    const xWindow: *c.x11_window = &windows.items[incomplete - 1].native.x;
    if (!c.x11_window_complete(xWindow)) {
        // completing the window failed, return a null handle.
        return 0;
    }
    return incomplete;
}
pub export fn pinc_window_get_focused(window: c.pinc_window_handle_t) bool {
    _ = window;
    std.debug.panic("pinc_window_get_focused is not implemented\n", .{});
}
pub export fn pinc_window_request_attention(window: c.pinc_window_handle_t) void {
    _ = window;
    std.debug.panic("pinc_window_request_attention is not implemented\n", .{});
}
pub export fn pinc_window_close(window: c.pinc_window_handle_t) void {
    _ = window;
    std.debug.panic("pinc_window_close is not implemented\n", .{});
}
pub export fn pinc_poll_events() void {
    for (windows.items) |*window| {
        // Some things are backend specific
        switch (window.native) {
            .none => {},
            .x => |*xWindow| {
                // on X, update last cursor pos to current
                xWindow.lastCursorX = xWindow.cursorX;
                xWindow.lastCursorY = xWindow.cursorY;
            },
        }
    }
    // Also reset
    var event = c.x11_pop_event();
    // Does zig SERIOUSLY not have a do-while loop?
    while (event.type != c.pinc_event_none) {
        switch (event.type) {
            c.pinc_event_none => {},
            c.pinc_event_window_resize => {
                const evdat = event.data.window_resize;
                if (evdat.window == 0) break;
                if (windows.items[evdat.window - 1].native == .none) break;
                const window = &windows.items[evdat.window - 1];
                // override previous size
                window.eventWindowResize = evdat;
            },
            c.pinc_event_window_focus => {
                const evdat = event.data.window_focus;
                if (evdat.window == 0) break;
                if (windows.items[evdat.window - 1].native == .none) break;
                const window = &windows.items[evdat.window - 1];
                // override previous size
                window.eventWindowFocus = evdat;
            },
            c.pinc_event_window_unfocus => {
                const evdat = event.data.window_unfocus;
                if (evdat.window == 0) break;
                if (windows.items[evdat.window - 1].native == .none) break;
                const window = &windows.items[evdat.window - 1];
                // override previous size
                window.eventWindowUnfocus = evdat;
            },
            c.pinc_event_window_damaged => {
                const evdat = event.data.window_damaged;
                if (evdat.window == 0) break;
                if (windows.items[evdat.window - 1].native == .none) break;
                const window = &windows.items[evdat.window - 1];
                // override previous event
                window.eventWindowDamaged = evdat;
            },
            c.pinc_event_window_key_down => {
                const evdat = event.data.window_key_down;
                if (evdat.window == 0) break;
                if (windows.items[evdat.window - 1].native == .none) break;
                eventsWindowKeyDown.append(evdat) catch std.debug.panic("Out of memory", .{});
            },
            c.pinc_event_window_key_up => {
                const evdat = event.data.window_key_up;
                if (evdat.window == 0) break;
                if (windows.items[evdat.window - 1].native == .none) break;
                eventsWindowKeyUp.append(evdat) catch std.debug.panic("Out of memory", .{});
            },
            c.pinc_event_window_key_repeat => {
                const evdat = event.data.window_key_repeat;
                if (evdat.window == 0) break;
                if (windows.items[evdat.window - 1].native == .none) break;
                eventsWindowKeyRepeat.append(evdat) catch std.debug.panic("Out of memory", .{});
            },
            c.pinc_event_window_text => {
                const evdat = event.data.window_text;
                if (evdat.window == 0) break;
                if (windows.items[evdat.window - 1].native == .none) break;
                eventsWindowText.append(evdat) catch std.debug.panic("Out of memory", .{});
            },
            c.pinc_event_window_cursor_move => {
                // Remember: the X backend only sets the pixel coords, not delta or screen coords.
                const evdat = event.data.window_cursor_move;
                if (evdat.window == 0) break;
                if (windows.items[evdat.window - 1].native == .none) break;
                const window = &windows.items[evdat.window - 1];
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
                if (evdat.window == 0) break;
                if (windows.items[evdat.window - 1].native == .none) break;
                eventsWindowCursorEnter.append(evdat) catch std.debug.panic("Out of memory", .{});
            },
            c.pinc_event_window_cursor_exit => {
                const evdat = event.data.window_cursor_exit;
                if (evdat.window == 0) break;
                if (windows.items[evdat.window - 1].native == .none) break;
                eventsWindowCursorExit.append(evdat) catch std.debug.panic("Out of memory", .{});
            },
            c.pinc_event_window_cursor_button_down => {
                const evdat = event.data.window_cursor_button_down;
                if (evdat.window == 0) break;
                if (windows.items[evdat.window - 1].native == .none) break;
                eventsWindowCursorButtonDown.append(evdat) catch std.debug.panic("Out of memory", .{});
            },
            c.pinc_event_window_cursor_button_up => {
                const evdat = event.data.window_cursor_button_up;
                if (evdat.window == 0) break;
                if (windows.items[evdat.window - 1].native == .none) break;
                eventsWindowCursorButtonUp.append(evdat) catch std.debug.panic("Out of memory", .{});
            },
            c.pinc_event_window_scroll => {
                const evdat = event.data.window_scroll;
                if (evdat.window == 0) break;
                if (windows.items[evdat.window - 1].native == .none) break;
                const window = &windows.items[evdat.window - 1];
                // override previous event
                window.eventWindowScroll = evdat;
            },
            c.pinc_event_window_close => {
                const evdat = event.data.window_close;
                if (evdat.window == 0) break;
                if (windows.items[evdat.window - 1].native == .none) break;
                const window = &windows.items[evdat.window - 1];
                window.eventWindowClose = evdat;
            },
            // TODO: handle this case maybe?
            else => {},
        }
        // Go to next event for the next iteration
        event = c.x11_pop_event();
    }
}
pub export fn pinc_advance_event() void {
    // I think this stupidity makes the need to refactor event management really obvious
    _ = pinc_event_union(true);
}
pub export fn pinc_wait_events(timeout: f32) void {
    c.x11_wait_events(timeout);
}
pub export fn pinc_event_type() c.pinc_event_type_t {
    return pinc_event_union(false).type;
}
pub export fn pinc_event_window_close_data() c.pinc_event_window_close_t {
    std.debug.panic("pinc_event_window_close_data is not implemented\n", .{});
}
pub export fn pinc_event_window_resize_data() c.pinc_event_window_resize_t {
    std.debug.panic("pinc_event_window_resize_data is not implemented\n", .{});
}
pub export fn pinc_event_window_focus_data() c.pinc_event_window_focus_t {
    std.debug.panic("pinc_event_window_focus_data is not implemented\n", .{});
}
pub export fn pinc_event_window_unfocus_data() c.pinc_event_window_unfocus_t {
    std.debug.panic("pinc_event_window_unfocus_data is not implemented\n", .{});
}
pub export fn pinc_event_window_damaged_data() c.pinc_event_window_damaged_t {
    std.debug.panic("pinc_event_window_damaged_data is not implemented\n", .{});
}
pub export fn pinc_event_window_key_down_data() c.pinc_event_window_key_down_t {
    return pinc_event_union(false).data.window_key_down;
}
pub export fn pinc_event_window_key_up_data() c.pinc_event_window_key_up_t {
    return pinc_event_union(false).data.window_key_up;
}
pub export fn pinc_event_window_key_repeat_data() c.pinc_event_window_key_repeat_t {
    std.debug.panic("pinc_event_window_key_repeat_data is not implemented\n", .{});
}
pub export fn pinc_event_window_text_data() c.pinc_event_window_text_t {
    std.debug.panic("pinc_event_window_text_data is not implemented\n", .{});
}
pub export fn pinc_event_window_cursor_move_data() c.pinc_event_window_cursor_move_t {
    std.debug.panic("pinc_event_window_cursor_move_data is not implemented\n", .{});
}
pub export fn pinc_event_window_cursor_enter_data() c.pinc_event_window_cursor_enter_t {
    std.debug.panic("pinc_event_window_cursor_enter_data is not implemented\n", .{});
}
pub export fn pinc_event_window_cursor_exit_data() c.pinc_event_window_cursor_exit_t {
    std.debug.panic("pinc_event_window_cursor_exit_data is not implemented\n", .{});
}
pub export fn pinc_event_window_cursor_button_down_data() c.pinc_event_window_cursor_button_down_t {
    std.debug.panic("pinc_event_window_cursor_button_down_data is not implemented\n", .{});
}
pub export fn pinc_event_window_cursor_button_up_data() c.pinc_event_window_cursor_button_up_t {
    std.debug.panic("pinc_event_window_cursor_button_up_data is not implemented\n", .{});
}
pub export fn pinc_event_window_scroll_data() c.pinc_event_window_scroll_t {
    std.debug.panic("pinc_event_window_scroll_data is not implemented\n", .{});
}
pub export fn pinc_key_name(code: c.pinc_key_code_t) [*:0]const u8 {
    switch (code) {
        c.pinc_key_code_unknown => return "unknown",
        c.pinc_key_code_space => return "space",
        c.pinc_key_code_apostrophe => return "apostrophe",
        c.pinc_key_code_comma => return "comma",
        c.pinc_key_code_dash => return "dash",
        c.pinc_key_code_dot => return "dot",
        c.pinc_key_code_slash => return "slash",
        c.pinc_key_code_0 => return "0",
        c.pinc_key_code_1 => return "1",
        c.pinc_key_code_2 => return "2",
        c.pinc_key_code_3 => return "3",
        c.pinc_key_code_4 => return "4",
        c.pinc_key_code_5 => return "5",
        c.pinc_key_code_6 => return "6",
        c.pinc_key_code_7 => return "7",
        c.pinc_key_code_8 => return "8",
        c.pinc_key_code_9 => return "9",
        c.pinc_key_code_semicolon => return "semicolon",
        c.pinc_key_code_equals => return "equals",
        c.pinc_key_code_a => return "a",
        c.pinc_key_code_b => return "b",
        c.pinc_key_code_c => return "c",
        c.pinc_key_code_d => return "d",
        c.pinc_key_code_e => return "e",
        c.pinc_key_code_f => return "f",
        c.pinc_key_code_g => return "g",
        c.pinc_key_code_h => return "h",
        c.pinc_key_code_i => return "i",
        c.pinc_key_code_j => return "j",
        c.pinc_key_code_k => return "k",
        c.pinc_key_code_l => return "l",
        c.pinc_key_code_m => return "m",
        c.pinc_key_code_n => return "n",
        c.pinc_key_code_o => return "o",
        c.pinc_key_code_p => return "p",
        c.pinc_key_code_q => return "q",
        c.pinc_key_code_r => return "r",
        c.pinc_key_code_s => return "s",
        c.pinc_key_code_T => return "T",
        c.pinc_key_code_u => return "u",
        c.pinc_key_code_v => return "v",
        c.pinc_key_code_w => return "w",
        c.pinc_key_code_x => return "x",
        c.pinc_key_code_y => return "y",
        c.pinc_key_code_z => return "z",
        c.pinc_key_code_left_bracket => return "left_bracket",
        c.pinc_key_code_backslash => return "backslash",
        c.pinc_key_code_right_bracket => return "right_bracket",
        c.pinc_key_code_backtick, => return "backtick",
        c.pinc_key_code_escape => return "escape",
        c.pinc_key_code_enter => return "enter",
        c.pinc_key_code_tab => return "tab",
        c.pinc_key_code_backspace => return "backspace",
        c.pinc_key_code_insert => return "insert",
        c.pinc_key_code_delete => return "delete",
        c.pinc_key_code_right => return "right",
        c.pinc_key_code_left => return "left",
        c.pinc_key_code_down => return "down",
        c.pinc_key_code_up => return "up",
        c.pinc_key_code_page_up => return "page_up",
        c.pinc_key_code_page_down => return "page_down",
        c.pinc_key_code_home => return "home",
        c.pinc_key_code_end => return "end",
        c.pinc_key_code_caps_lock => return "caps_lock",
        c.pinc_key_code_scroll_lock => return "scroll_lock",
        c.pinc_key_code_num_lock => return "num_lock",
        c.pinc_key_code_print_screen => return "print_screen",
        c.pinc_key_code_pause => return "pause",
        c.pinc_key_code_f1 => return "f1",
        c.pinc_key_code_f2 => return "f2",
        c.pinc_key_code_f3 => return "f3",
        c.pinc_key_code_f4 => return "f4",
        c.pinc_key_code_f5 => return "f5",
        c.pinc_key_code_f6 => return "f6",
        c.pinc_key_code_f7 => return "f7",
        c.pinc_key_code_f8 => return "f8",
        c.pinc_key_code_f9 => return "f9",
        c.pinc_key_code_f10 => return "f10",
        c.pinc_key_code_f11 => return "f11",
        c.pinc_key_code_f12 => return "f12",
        c.pinc_key_code_f13 => return "f13",
        c.pinc_key_code_f14 => return "f14",
        c.pinc_key_code_f15 => return "f15",
        c.pinc_key_code_f16 => return "f16",
        c.pinc_key_code_f17 => return "f17",
        c.pinc_key_code_f18 => return "f18",
        c.pinc_key_code_f19 => return "f19",
        c.pinc_key_code_f20 => return "f20",
        c.pinc_key_code_f21 => return "f21",
        c.pinc_key_code_f22 => return "f22",
        c.pinc_key_code_f23 => return "f23",
        c.pinc_key_code_f24 => return "f24",
        c.pinc_key_code_f25 => return "f25",
        c.pinc_key_code_f26 => return "f26",
        c.pinc_key_code_f27 => return "f27",
        c.pinc_key_code_f28 => return "f28",
        c.pinc_key_code_f29 => return "f29",
        c.pinc_key_code_f30 => return "f30",
        c.pinc_key_code_numpad_0 => return "numpad_0",
        c.pinc_key_code_numpad_1 => return "numpad_1",
        c.pinc_key_code_numpad_2 => return "numpad_2",
        c.pinc_key_code_numpad_3 => return "numpad_3",
        c.pinc_key_code_numpad_4 => return "numpad_4",
        c.pinc_key_code_numpad_5 => return "numpad_5",
        c.pinc_key_code_numpad_6 => return "numpad_6",
        c.pinc_key_code_numpad_7 => return "numpad_7",
        c.pinc_key_code_numpad_8 => return "numpad_8",
        c.pinc_key_code_numpad_9 => return "numpad_9",
        c.pinc_key_code_numpad_dot => return "numpad_dot",
        c.pinc_key_code_numpad_slash => return "numpad_slash",
        c.pinc_key_code_numpad_asterisk => return "numpad_asterisk",
        c.pinc_key_code_numpad_dash => return "numpad_dash",
        c.pinc_key_code_numpad_plus => return "numpad_plus",
        c.pinc_key_code_numpad_enter => return "numpad_enter",
        c.pinc_key_code_numpad_equal => return "numpad_equal",
        c.pinc_key_code_left_shift => return "left_shift",
        c.pinc_key_code_left_control => return "left_control",
        c.pinc_key_code_left_alt => return "left_alt",
        c.pinc_key_code_left_super => return "left_super",
        c.pinc_key_code_right_shift => return "right_shift",
        c.pinc_key_code_right_control => return "right_control",
        c.pinc_key_code_right_alt => return "right_alt",
        c.pinc_key_code_right_super => return "right_super",
        c.pinc_key_code_menu => return "menu",
        else => return "unknown",
    }
}
pub export fn pinc_key_token_name(token: u32) [*:0]u8 {
    _ = token;
    std.debug.panic("pinc_key_token_name is not implemented\n", .{});
}
pub export fn pinc_set_cursor_mode(mode: c.pinc_cursor_mode_t, window: c.pinc_window_handle_t) void {
    _ = mode;
    _ = window;
    std.debug.panic("pinc_set_cursor_mode is not implemented\n", .{});
}
pub export fn pinc_set_cursor_theme_image(image: c.pinc_cursor_theme_image_t, window: c.pinc_window_handle_t) void {
    _ = image;
    _ = window;
    std.debug.panic("pinc_set_cursor_theme_image is not implemented\n", .{});
}
pub export fn pinc_set_cursor_image(window: c.pinc_window_handle_t, data: [*]u8, size: u32) void {
    _ = window;
    _ = data;
    _ = size;
    std.debug.panic("pinc_set_cursor_image is not implemented\n", .{});
}
pub export fn pinc_get_clipboard_string() [*:0]u8 {
    std.debug.panic("pinc_get_clipboard_string is not implemented\n", .{});
}
