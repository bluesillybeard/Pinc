// pinc util functions are exported here
// Anything with the "pinc_util_" prefix

const std = @import("std");

// TODO: set pinc error
pub export fn pinc_util_unicode_to_uft8(unicode: u32, dest: ?[*:0]u8) bool {
    if (unicode > std.math.maxInt(u21)) return false;
    if (dest == null) return false;
    // Create a slice that points to the actual dest
    var destSlice: []u8 = undefined;
    destSlice.len = 5;
    destSlice.ptr = @ptrCast(dest.?);
    const count = std.unicode.utf8Encode(@intCast(unicode), destSlice) catch return false;
    destSlice[count] = 0;
    return true;
}