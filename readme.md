# Pinc

Pinc is a cross platform windowing / rendering library written in Zig.

## Pinc design goals
- Lightweight - minimal dependencies (within reason)
    - fundamental libraries (Xlib for example) are fair game
        - Technically Xlib is not a fundamental library but it's cut deep into the rendering so it basically is a fundamental library at this point
    - Any non-system libraries are statically linked (ex: SPIRV-cross)
- Language agnostic - The external API is entirely in C, which makes binding to other languages relatively simple
    - Specifically, the header is written in C99 as described in the [GNU C manual](https://www.gnu.org/software/gnu-c-manual/gnu-c-manual.html)
    - ABI compatibility is a nightmare, but the Zig compiler makes that (relatively) a breeze.
- ABSOLUTELY ZERO compile time dependencies, other than Pinc and and the Zig compiler
    - This includes system libraries that are not included in Zig's cross-compile toolchain. They must be loaded at runtime.
- Easy to use
    - Similar ease of use, comparable to something like SDL or SFML
- Flexible
    - can be linked statically or dynamically
    - determines the API to use at runtime, so fewer compilation targets are needed
    - cross-compiles from any platform to any platform (supported by the Zig compiler of course)
    - Can be made to work with any C ABI (Zig's compiler for the win!)

## Q&A
- Why make this when other libraries already exist?
    - I am frustrated at the state of low-level windowing / graphics libraries. Kinc's build system is a mess, Raylib is too minimal to do anything serious, V-EZ hasn't been updated in many years, bgfx is written in C++, SDL is a giant pain to cross-compile with, nicegraf and llgl don't proide a way to create a window, GLFW has no way to have multiple windows on a single OpenGL context, Jai is a programming language instead of a library, and the list goes on and on and on. They are all great, but they all suck in specific ways that are conveniently very bad for my own requirements.
- Why support OpenGL 2.1. It's so old! (and deprecated)
    - I thought it would be cool to be able to run this on extremely ancient hardware and OS, for no other reason than to see it run. It sounds stupid, but as a stupid person myself, I think it's a great reason. This was partially inspired by [MattKC porting .NET framework 2 to Windows 95.](https://www.youtube.com/watch?v=CTUMNtKQLl8)
    - It's the most widely supported graphics API, hands down. You'd be hard pressed to find a platform that doesn't have some way to get OpenGL 2 apps running.
        - I would use OpenGL 1.x but that doesn't have shaders which are pretty much fundamental to any half-decent graphics API.
    - It's the simplest low-level cross platform graphics API, so getting started is easier.
- Why use X11 / Win32 / Cocoa directly
    - To minimize dependencies
    - GLFW is hardwired to bond each window to a GL context permanently, which is fundamentally incompatible to how this library works
    - SDL is difficult to work with in terms of getting it to cross-compile, and it's not designed for static linking
- Why make an abomination of Zig and C?
    - This library was going to be written entirely in Zig. Then Xlib happened.
    - Zig makes exporting a C api easy as pie, without having to write the entire thing using the masochistic nightmare that is C.
    - Rust is far too complicated for its own good, and it's just not as ergonomic for C interop.
    - C is just such an annoying language. The pure language itself is mostly fine, but the standard library is famously bad and limited.


## Important notes

Pinc is a very new library, and is MASSIVELY out of scope for a single developer like myself. As such:
- Expect bugs / issues
- the API is highly variable at the moment
    - Give me your suggestions - the API is VERY incomplete and I don't know what's missing!
- the project desparately needs contributors
    - there are so many TODOs all over the place. Anyone willing to help is welcome! Just search for instances of the string "TODO" in the repo and you're guaranteed to find something

Pinc's current API is fundamentally incompatible with multithreading at the moment. If you are building a new project with Pinc, design around that constraint. If you are integrating Pinc into an existing project with multithreaded rendering, you're probably making a mistake.

## Supported platforms
- Linux/X11

## Supported APIs
- OpenGL 2.1

## Planned (directly) supported APIs
- Vulkan

## Planned (directly) supported APIs that are low priority
- OpenGL 4.6
- OpenGL 4.1
- OpenGL 3.3
- Software rasterizer

## Planned indirectly supported APIs
- Metal via MoltenVK

## Planned supported platforms
These are top priority
- Windows
    - Win32 API
- Macos
    - Coacoa

## Planned supported platforms in the future
- Andriod
- IOS
- Xbox
    - Microsoft are the good guys for once, creating Dozen so engines that use Vulkan can run on Xbox. Props to Microsoft for not being a jerk.
- Nintendo switch
    - There seems to be a lack of info on how this could be done.
- Wayland, a very low priority because XWayland exists

## Planned supported platforms in the far future
None of these are going to be implemented any time soon - if ever.
- Playstation 4/5
    - their custom proprietary grahpics API will make this difficult as this library is open source and WILL NOT support the existence of closed source components. Sorry playstation developers, your platform is fundamentally incompatible with the open source model.
    - I've heard they support Vulkan, but their NDA makes it hard to get any information
- BSD
    - BSD might already work (due to X11), however it is not tested.
- Haiku
    - They have an X11 compatibility layer so I'm not too worried at the moment

## Other planned features
- ability to access native API interactions and convert native objects to/from pinc objects
    - there are a LOT of these - X display, windows, events, input contexts, colormap, glX context and related objects, the list goes on and on and on.

## Next steps for this library - not nessesarily in order
- X11
- Release to the public
- Create the graphics API
    - Refer to [include/readme.md](./include/readme.md)
- OpenGL 2.1
- Refactor to start supporting alternate backends
- Win32 backend
    - Making sure to avoid functions added after Windows 95 because reasons
- Cocoa backend
- any final touches to the API
    - At this point, Pinc is (hopefully) fully usable on all major desktop platforms
- Clean up X11 backend (it's got a lot of work to be done)
- Clean up Win32 backend and test on a Win95 VM
- Clean up Cocoa backend and test on a real mac
- prepare for first major release

## Todo
- Test zero-dependency compilation
- Figure out an error reporting solution
- internal refactor of event system
    - on X11 backend, trigger cursor exit event when the window looses focus (X does not trigger an exit event when focus is lost for some reason)
- Make tests to check for certain annoying things
    - duplicate key events
    - duplicate cursor movement events
    - This could be implemented in two stages:
        - a 'mock' library that probes user programs to make sure they use Pinc correctly, like Vulkan validation layers
        - a test program that probes the library to make sure it behaves correctly
            - I can't think of a good robust way to do everything automatically without tons of extra effort.
