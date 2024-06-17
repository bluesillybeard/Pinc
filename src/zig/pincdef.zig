const builtin = @import("builtin");
const pinc = switch (builtin.os.tag) {
    .linux => @import("x11.zig"),
    .windows => @import("win32.zig"),
    else => @compileError("Unsupported OS"),
};
pub usingnamespace pinc;
