const std = @import("std");
pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    // For now, we only build Pinc and the window example
    const pinc = b.addStaticLibrary(.{
        .root_source_file = .{.path = "src/zig/pincdef.zig"},
        .name = "pinc",
        .optimize = optimize,
        .target = target,
        // libc is so fundamentally engrained into all software that it's insanely dificult to avoid linking with it.
        .link_libc = true,
    });
    pinc.addIncludePath(.{.path = "include"});
    pinc.addIncludePath(.{.path = "src/ext"});
    pinc.addIncludePath(.{.path = "src/c"});
    pinc.addCSourceFiles(.{
        .files = &[_][]const u8 {
            "pincx.c",
        },
        .root = .{.path = "src/c"},
    });
    // Get all C files
    const exe = b.addExecutable(.{
        .optimize = optimize,
        .target = target,
        .name = "window",
    });
    exe.addIncludePath(.{.path = "include"});
    exe.addCSourceFile(.{
        .file = .{.path = "examples/window.c"},
    });
    exe.linkLibrary(pinc);
    exe.step.dependOn(&pinc.step);
    b.installArtifact(exe);
    b.installArtifact(pinc);
    const run = b.addRunArtifact(exe);
    var runStep = b.step("run", "run the example");
    runStep.dependOn(&run.step);
}
