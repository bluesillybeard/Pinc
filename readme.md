![Logo](logo.svg)

# Pinc

Pinc is a cross platform windowing / rendering library written in Zig.

## Pincs goals
- Lightweight - minimal dependencies (within reason)
    - fundamental libraries are fair game (Xlib, libGL, Kernel32, etc)
    - Any non-system libraries are statically linked (ex: SPIRV-cross)
- Language agnostic - The external API is entirely in C, which makes binding to other languages relatively simple
    - Specifically, the header is written in C99 as described in the [GNU C manual](https://www.gnu.org/software/gnu-c-manual/gnu-c-manual.html)
    - ABI compatibility is a nightmare, but the Zig compiler makes that (relatively) a breeze.
- ABSOLUTELY ZERO compile time dependencies, other than Pinc and and the Zig compiler
    - This includes system libraries that are not included in Zig's cross-compile toolchain. They must be loaded at runtime.
- Easy to use
    - comparable to something like SDL or SFML, with the bonus of being a lot easier to compile and link
    - admittedly the API is a bit verbose
- Flexible
    - can be linked statically or dynamically
    - determines the API to use at runtime, so fewer compilation targets are needed
    - cross-compiles from any platform to any platform (supported by the Zig compiler of course)
    - Can be made to work with any C ABI (Zig's compiler for the win!)
        - Except for musl, since it doesn't allow loading libraries at runtime (sad)

## Supported platforms
- Linux/X11

## Supported APIs
- OpenGL 2.1

## Important notes
Pinc is a very new library, and is MASSIVELY out of scope for a single developer like myself. As such:
- Expect bugs / issues
    - a large portion of the API is not implemented yet
- the API is highly variable for the forseeable future
    - Give me your suggestions - the API is VERY incomplete and I don't know what's missing!
- the project desparately needs contributors - see [contribution guide](contribute.md)

Pinc's current API is fundamentally incompatible with multithreading.

## How to get started
- Get Zig (this is tested on zig master but it might work on older versions)
- Clone the repository
- Make sure it works by running `zig build run`, which will run the window example.
- The library is ready to be used...

The easiest way to do it would be to just compile Pinc into a library using `zig build static` or `zig build dynamic`, copy the artifact and the header, and just adding it to your linker flags. Automating that would be a good idea, especially for cross-compilation so you don't have a bajillion copies of the same library pre-compiled for different platforms.

Hopefully the header is self-exaplanatory. If it's not clear what a function or type does, consider submitting an issue so we can improve documentation.

## Other notes
- When cross-compiling, it is generally a good idea to specify the ABI (eg: `x86_64-linux-gnu` instead of `x86_64-linux`) as it tends to default to the wrong ABI which is quite annoying. (In particular, compiling from Windows to Linux uses musl, which does not work as Pinc uses dynamic loading)
- The main branch is "stable" in the sense that it should always work. Before commiting to the main branch, We'll make sure everything still works.

## Q&A
- Why make this when other libraries already exist?
    - I am frustrated at the state of low-level windowing / graphics libraries. Kinc's build system is a mess, Raylib is too minimal to do anything serious, V-EZ hasn't been updated in many years, bgfx is written in C++, SDL is a giant pain to cross-compile with, nicegraf and llgl don't provide a way to create a window, GLFW has no way to have multiple windows on a single OpenGL context, Jai is a programming language instead of a library, and the list goes on and on and on. They are all great, but they all suck in specific ways that are conveniently very bad for my own requirements.
- Why support OpenGL 2.1. It's so old! (and deprecated)
    - I thought it would be cool to be able to run this on extremely ancient hardware and OS, for no other reason than to see it run. It sounds stupid, but as a stupid person myself, I think it's a great reason. This was partially inspired by [MattKC porting .NET framework 2 to Windows 95.](https://www.youtube.com/watch?v=CTUMNtKQLl8)
    - It's the most widely supported graphics API, hands down. You'd be hard pressed to find a platform that doesn't have some way to get OpenGL 2 apps running.
        - I would use OpenGL 1.x but that doesn't have shaders which are pretty much fundamental to any half-decent graphics API.
    - It's the simplest low-level cross platform graphics API, so getting started is easier.
- Why use X11 / Win32 / Cocoa directly
    - To minimize dependencies
    - GLFW is hardwired to bond each window to a GL context permanently, which is fundamentally incompatible to how this library works
    - SDL is difficult to work with in terms of getting it to cross-compile, and it's not designed for static linking
    - Kinc's build system is completely asinine
- Why make an abomination of Zig and C?
    - This library was going to be written entirely in Zig. Then Xlib happened.
    - Zig makes exporting a C api easy as pie, without having to write the entire thing using the masochistic nightmare that is C.
    - Rust is far too complicated for its own good, and it's just not as ergonomic for C interop.
    - C is just such an annoying language. The pure language itself is mostly fine, but the standard library is famously bad and limited.

## Planned supported APIs
- Vulkan (Medium Priority)
- Metal via MoltenVK (Medium Priority)
- OpenGL 4.6 (Low Priority)
- OpenGL 4.1 (Low Priority)
- OpenGL 3.3 (Low Priority)
- Software rasterizer (Low Priority)

## Planned supported platforms
- freeBSD
    - this should be quite easy. I just need an install to test it on.
- Win32 API / windows
- Coacoa / macos
    - I do not own a mac so this probably a ways off.
- Haiku
    - They have an X11 compatibility layer so this shouldn't be too hard
- Andriod (Low Priority)
- IOS (Low Priority)
- Wayland (Low Priority)

## Planned supported platforms in the far future
None of these are going to be implemented any time soon - if ever.
- Playstation 4/5
- Xbox (Low Priority)
- Nintendo switch (Low Priority)
    - There seems to be a lack of info on how this could be done.

## Other planned features
- ability to access native API interactions and convert native objects to/from pinc objects
    - there are a LOT of these - X display, windows, events, input contexts, colormap, glX context and related objects, the list goes on and on and on.
- Ability to get system theme colors and name
    - Probably pretty easy on Windows
    - Does MacOS even have themes?
    - good luck doing this on Linux lol
        - GNOME
        - KDE Plasma
        - Cosmic
        - XFCE
        - AwesomeWM
        - Sway
        - Cinnamon
        - Budgeee
        - Mate
        - ... and a billion more, although most of the current smaller ones will likely die along with X11
- window positioning

## Next steps for this library - not nessesarily in order
- Refactor to start supporting alternate backends
- Win32 backend
- Create the graphics API
    - Refer to [include/readme.md](./include/readme.md)
- OpenGL 2.1
- Cocoa backend
    - I do not have a real mac. Maybe someone can donate one?
- any final touches to the API
- Implement all API functions for all backends
- Clean things up a bunch up
- prepare for first major release

## Todo
- Test zero-dependency compilation
- internal refactor of event system
    - on X11 backend, trigger cursor exit event when the window looses focus (X does not trigger an exit event when focus is lost for some reason)
- Make tests to check for certain annoying things
    - duplicate key events
    - duplicate cursor movement events
    - This could be implemented in two stages:
        - a 'mock' library that probes user programs to make sure they use Pinc correctly, like Vulkan validation layers
        - a test program that probes the library to make sure it behaves correctly
            - I can't think of a good robust way to do everything automatically without tons of extra effort.
- Set up github discussions thingy

## Some stats (may be outdated)

backend      |functions|todos|lines (approx, excluding auto-generated code)
---          |---      |---  |--
Linux/X11    |15       |7    |2300
Windows/Win32|0        |2    |70
