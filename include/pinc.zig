// This is so Pinc can be used as a regular dependency as part of a Zig project
// without needing to do some kind of hack to get the header
pub usingnamespace @cImport(@cInclude("pinc.h"));
