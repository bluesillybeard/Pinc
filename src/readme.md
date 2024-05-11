# Pinc's internal structure

the C folder exists because significant parts of Pinc are written in C, as certain native libraries (*cough cough* Xlib *cough cough*) are an absolute abomination to get working nicely any other way.

Eventually, there will be a third folder, probably named 'objc' or 'm' for parts of the codebase that interact with Cocoa, which requires objective C. Unfortunately, there does not appear to be C or C++ bindings for Cocoa, which is definitely annoying as someone who doesn't care to learn yet another dynamic dispatch OOP language.

the ext folder contains ALL headers required by Pinc. Most of them are unused, but in total their file size is small so I do not particularily care. I believe all of them are free to distribute in libraries like this, if any of them aren't please let me know so they can be removed. I just copied them from various development environments (namely my local /usr/include)

the zig folder contains the zig code of Pinc. It is also where all of the public API is implemented. pincdef.zig is the root source file.
