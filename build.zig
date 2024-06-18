const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const pincStatic = b.addStaticLibrary(.{
        .root_source_file = b.path("src/zig/pinc.zig"),
        .name = "pinc",
        .optimize = optimize,
        .target = target,
        .link_libc = true,
    });
    pincStatic.addIncludePath(b.path("include"));
    pincStatic.addIncludePath(b.path("ext"));
    pincStatic.addIncludePath(b.path("src/c"));
    pincStatic.addCSourceFiles(.{
        .files = &[_][]const u8{
            "pincx.c",
            "pincwin32.c",
        },
        .root = b.path("src/c"),
    });

    const pincDynamic = b.addSharedLibrary(.{
        .root_source_file = b.path("src/zig/pinc.zig"),
        .name = "pinc",
        .optimize = optimize,
        .target = target,
        .link_libc = true,
    });
    pincDynamic.addIncludePath(b.path("include"));
    pincDynamic.addIncludePath(b.path("ext"));
    pincDynamic.addIncludePath(b.path("src/c"));
    pincDynamic.addCSourceFiles(.{
        .files = &[_][]const u8{
            "pincx.c",
            "pincwin32.c",
        },
        .root = b.path("src/c"),
    });

    // This is the basic window example
    const exe = b.addExecutable(.{
        .optimize = optimize,
        .target = target,
        .name = "window",
    });
    exe.addIncludePath(b.path("include"));
    exe.addCSourceFile(.{
        .file = b.path("examples/window.c"),
    });
    exe.linkLibrary(pincStatic);
    exe.step.dependOn(&pincStatic.step);

    const exeInstall = b.addInstallArtifact(exe, .{});
    var exeStep = b.step("example", "Build the example");
    exeStep.dependOn(&exeInstall.step);

    const run = b.addRunArtifact(exe);
    var runStep = b.step("run", "run the example");
    runStep.dependOn(&run.step);

    const staticInstall = b.addInstallArtifact(pincStatic, .{});
    var staticStep = b.step("static", "Build Pinc as a static library (.a / .lib)");
    staticStep.dependOn(&staticInstall.step);

    const dynamicInstall = b.addInstallArtifact(pincDynamic, .{});
    var dynamicStep = b.step("dynamic", "Build Pinc as a dynaic / shader library (.so / .dll)");
    dynamicStep.dependOn(&dynamicInstall.step);

    const headerInstall = b.addInstallHeaderFile(b.path("include/pinc.h"), "pinc.h");
    staticStep.dependOn(&headerInstall.step);
    dynamicStep.dependOn(&headerInstall.step);
}
