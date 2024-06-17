// Zig has one SUPER EXTREMELY annoying problem: different Cimports clash and cause type errors which do not make sense.
// Thankfully, none of my headers cause issues when included in a compilation on the wrong platform, so including all of them everywhere works fine.
const c = @cImport({
    @cInclude("pinc.h");
    @cInclude("pincx.h");
    @cInclude("pincinternal.h");
    @cInclude("pincwin32.h");
});

pub usingnamespace c;
