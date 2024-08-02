// Internal stuff.
// This is the implementation of pincinternal.h

const c = @import("c.zig");
const pinc = @import("pinc.zig");
const std = @import("std");

pub export fn pinci_make_error(er: c.pinc_error_enum, str: [*:0]const u8) bool {
    pinc.latestError = er;
    pinc.latestErrorString = str;
    return false;
}

pub export fn pinci_alloc_string(length: usize) [*:0]u8 {
    // For now, just use the ordinary allocator
    // TODO: more efficient string allocator
    const buffer = pinc.allocator.alloc(u8, length + 1) catch std.debug.panic("Failed to allocate string", .{});
    return @ptrCast(buffer.ptr);
}

pub export fn pinci_dupe_string(str: [*:0]u8) [*:0]u8 {
    const strSl = std.mem.sliceTo(str, 0);
    const buffer = pinc.allocator.dupeZ(u8, strSl) catch std.debug.panic("Failed to allocate memory", .{});
    return buffer.ptr;
}

pub export fn pinci_free_string(str: [*:0]u8) void {
    var buffer: []u8 = std.mem.sliceTo(str, 0);
    buffer.len += 1;
    pinc.allocator.free(buffer);
}

pub export fn pinci_send_event(event: c.pinc_event_union_t) void {
    pinc.sendEvent(event);
}