const builtin = @import("builtin");
const native = switch (builtin.os.tag) {
    .linux => @import("x11.zig"),
    .windows => @import("win32.zig"),
    else => @compileError("Unsupported OS"),
};
pub usingnamespace native;

const graphics = @import("graphics.zig");
pub usingnamespace graphics;
