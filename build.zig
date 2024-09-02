const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Compile options

    const run = b.option(bool, "run", "Whether to run or not. Defaults to false") orelse false;

    // TODO: option to set the priority / order for each of the backends
    // TODO: option to enable/disable certain backends
    // TODO: options for the PINC_API and PINC_CALL options in the header, so the lib and header will actually match

    // static library
    const staticLib = blk: {
        const lib = b.addStaticLibrary(.{
            .root_source_file = b.path("src/pinc.zig"),
            .target = target,
            .optimize = optimize,
            .link_libc = true,
            .name = "pinc",
        });
        // The implementation of Pinc (which is all Zig, obviously) has a translated version of pinc.h so it does not need the header.
        // lib.addIncludePath(b.path("include"));
        // It does need the headers in ext because translating every header for every library Pinc uses would be an insane task.
        lib.addIncludePath(b.path("ext"));

        const install = b.addInstallArtifact(lib, .{});
        const installStep = b.step("static", "Build static library");
        installStep.dependOn(&install.step);

        break :blk lib;
    };

    // shared library
    const sharedLib = blk: {
        const lib = b.addSharedLibrary(.{
            .root_source_file = b.path("src/pinc.zig"),
            .target = target,
            .optimize = optimize,
            .link_libc = true,
            .name = "pinc",
        });
        lib.addIncludePath(b.path("include"));
        lib.addIncludePath(b.path("ext"));

        const install = b.addInstallArtifact(lib, .{});
        const installStep = b.step("dynamic", "build shared / dynamic library");
        installStep.dependOn(&install.step);

        break :blk lib;
    };

    // copy headers
    {
        const install = b.addInstallHeaderFile(b.path("include/pinc.h"), "pinc.h");
        staticLib.step.dependOn(&install.step);
        sharedLib.step.dependOn(&install.step);
    }

    // window example
    {
        const exe = b.addExecutable(.{
            .target = target,
            .optimize = optimize,
            .name = "window",
        });
        exe.addIncludePath(b.path("include"));
        exe.addIncludePath(b.path("ext"));
        exe.addCSourceFile(.{
            .file = b.path("examples/window.c"),
        });
        exe.linkLibrary(staticLib);
        exe.step.dependOn(&staticLib.step);

        if (run) {
            const runArtifact = b.addRunArtifact(exe);
            var runStep = b.step("window", "window example");
            runStep.dependOn(&runArtifact.step);
        } else {
            const install = b.addInstallArtifact(exe, .{});
            var installStep = b.step("window", "window example");
            installStep.dependOn(&install.step);
        }
    }
    // TODO: maximal window example
}
