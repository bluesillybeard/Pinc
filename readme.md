![Logo](logo.svg)

# Pinc

Pinc is a cross platform windowing / rendering library written in Zig.

## Pincs goals
- Lightweight - minimal dependencies (within reason)
    - fundamental libraries are fair game (Xlib, libGL, Kernel32, etc)
    - (most) external libraries are linked statically
        - There are exceptions for libraries that are widely available and optional, such as SDL
- Language agnostic - The external API is entirely in C, which makes binding to other languages relatively simple
    - Specifically, the header is written in C99 as described in the [GNU C manual](https://www.gnu.org/software/gnu-c-manual/gnu-c-manual.html)
    - ABI compatibility is a nightmare, but the Zig compiler makes that (relatively) a breeze.
- ABSOLUTELY ZERO compile time dependencies, other than Pinc and and the Zig compiler
    - This includes system libraries that are not included in Zig's cross-compile toolchain. They must be loaded at runtime.
    - All of the headers needed are included in the repository. The headers all have their individual licenses listed at the top of the file.
- Easy to use
    - comparable to something like SDL or SFML, with the bonus of being a lot easier to compile and link
    - admittedly the API is a bit verbose
- Flexible
    - can be linked statically or dynamically
    - determines the API to use at runtime, so fewer compilation targets are needed
    - cross-compiles from any platform to any platform (supported by the Zig compiler of course)
    - Can be made to work with any C ABI (Zig's compiler for the win!)
        - Except for musl, since it doesn't allow loading libraries at runtime (sad)

## Other things
- Pinc does not take hold of the entry point.
- Pinc does not provide a main loop

## Supported platforms
- Linux/X11 (directly)
- Anything supported by SDL2

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

It's worth noting the Pinc makes heavy use of asserts that will not trigger in ReleaseFast mode. I suggest using Debug to build the library, until you are confident everything works correctly, in which case ReleaseFast is a decent option. That being said, ReleaseSafe is almost certainly fast enough for any reasonable use case, but retains the safety checks of Debug mode.

## Other notes
- When cross-compiling, it is generally a good idea to specify the ABI (eg: `x86_64-linux-gnu` instead of `x86_64-linux`) as it tends to default to the wrong ABI which is quite annoying.
    - In particular, compiling from Windows to Linux uses musl, which does not work as Pinc uses dynamic loading
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
- OpenGL 4.1 (Low Priority) (for Macos which apparently never supported anything newer)
- OpenGL 3.3 (Low Priority)
- Software rasterizer (Low Priority)

## Supported & tested platforms
OS + Arch         | Hardware I have        | notes 
---               |---                     |---
Linux x64         | #2 #3 #4 #8            |

## Planned supported platforms
Platforms I want to support & whether I have real hardware to test it on:

OS + Arch         | Hardware I have        | notes                 | Justification
---               |---                     |---                    |---
Windows x86       | #1 #2 #3 #4 #5 #6 #8   |                       | 32 bit may be unsupported, but compilers still support it pretty well so yeah
Windows x64       | #2 #3 #4 #4 #8         |                       | This is the primary PC platform
Windows arm       | #7? #9?                | Surface RT. 32 bit arm support on Windows was short lived. |
Windows aarch64   | #7? #9?                | One of those ARM microsoft surface things are probably a good bet | This is where Microsoft seems to want to go
Linux x86         | #1 #2 #3 #4 #5 #6 #8   |                       | 32 bit linux, although rare, is still supported by some distros and used by some people
Linux arm         | #7? #9?                |                       | rasberry pi moment
Linux aarch64     | #7? #9?                | A modern Rasberry pi (or similar) is probably a good idea | This is the future (in my opinion)
Linux riscv64     |                        | Nobody really has good affordable consumer grade hardware for this yet. | It is modern, supported by compilers, and growing
Linux powerpc     |                        | a G2 or G3 desktop computer is probably the best bet here | G3 and newer are still usable today with the right software
Macos x64         | #2? #3? #4? #5? #8?    | A used macbook is probably the best bet here | the tertiary PC platform
Macos aarch64     | #7? #9?                | A used M1 mac is a probably the best bet here | the other tertiary PC platform
Macos powerpc     |                        | a G2 or G3 desktop computer is probably the best bet here | G3 and newer are still usable with the right software
BSD x86           | #1 #2 #3 #4 #5 #6 #8   |                       | BSD x86 is well supported (as far as I know)
BSD x64           | #2 #3 #4 #8            |                       | BSD is well supported
BSD powerpc       |                        | a G2 or G3 desktop computer is probably the best bet here | G3 and newer is still usable today with the right software

here is all the hardware I have available for testing:
1. Hackberry, My dad's old Pentium II computer. I don't know if it works or not, or if its GPU supports OpenGL 2.1
2. My main PC, x64, supports most of the modern extensions
3. An old computer with a Pentium D, saved from being thrown away by an organization, one of the earliest 64 bit x86 machines made for the mass market. I don't know if it works or if its GPU supports OpenGl 2.1.
4. An old laptop from ~2008 or so, works and the GPU supports OpenGL
5. EEE PC, 32 bit x86. Works great, despite how old it is. The battery life is even pretty decent still, somehow. I don't know if the GPU supports OpenGL 2.1.
6. Pentium PC I plan on taking from an uncle
7. Cubieboard, arm (idk if its 32 bit or 64 bit)
8. My wndows dev machine - x64, GPU supports up to OpenGL 4.6
9. Rasberry pi, (unknown if 32bit or 64bit)

Priority of supported platforms:
1. Linux x64
2. Windows x64
3. Macos x64
4. Windows aarch64
5. Linux aarch64
6. Macos aarch64
7. Linux x86
8. Windows x86
9. Linux arm
1. Linux riscv64
1. Linux powerpc
1. Macos powerpc
1. Windows arm
1. BSD x64
1. BSD powerpc
1. BSD x86

- Haiku
    - They have an X11 compatibility layer so this shouldn't be too hard
- Andriod (Low Priority)
- IOS (Low Priority)
- Wayland (Low Priority)
    - XWayland means this is essentially a waste of time until wayland-specific features start to get added (such as trackpad gestures)
    - The performance gain is nice, but not a particularily big deal at the moment

## Planned supported platforms in the far future
None of these are going to be implemented any time soon - if ever.
- Playstation 4/5
- Xbox (Low Priority)
- Nintendo switch (Low Priority)
    - There seems to be a lack of info on how this could be done.
- Windows PowerPC
    - Yes, this did actually exist at one point, although Macos beat them to it and Microsoft abandoned PowerPC for x86
- Raw X11 - no client library, just pure network packets and weird horrible hacks to get glX to work
    - This is an insane undertaking that nobody in their right mind should do for a library like this. Xlib is literally on every system with X11 and it's way more than fast enough.
- Xcb instead of Xlib
    - Like with raw X11, this would be a complete waste of everyone's time. Xcb as a whole is kinda a big waste of people's time, although from what I've heard modern Xlib is actually implemented on top of Xcb, which is interesting. Either way, for Pinc specifically, Xcb is a no-go.

## Other planned features
- ability to access native API interactions and convert native objects to/from pinc objects
    - there are a LOT of these - not to mention there is a completely different set of them for every platform and graphics API.
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
        - could probably just read the GTK and QT system themes and get 99% coverage
- window positioning
- It might be worth making something like an SDL or GLFW backend, that implements Pinc on top of another library. This has the benefit of:
    - making it easier to migrate to/from Pinc and the other library
    - Wider platform support (for example, we wouldn't have to implement a Cocoa backend directly in order to get macos support)
    - People can read the source code for the backend, and it will be easier to understand since it's not a backend directly to some convoluted platform-specific API

## Next steps for this library - not nessesarily in order
- Refactor to start supporting alternate backends
- Win32 backend
- Create the graphics API
    - Refer to [include/readme.md](./include/readme.md)
- OpenGL 2.1
    - Rendering is already possible, but 
- Cocoa backend
    - I do not have a real mac. Maybe someone can donate one?
    - XQuartz exists, but it's a terrible solution
- any final touches to the API
- Implement all API functions for all backends
- Clean things up a bunch up
- prepare for first major release

## Todo (NOT IN ORDER)
- SDL backends
    - SDL 2.x
    - SDL 3.x
    - SDL 1.x maybe??
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
- The API needs some decent changes
    - Setting the bit depth of a framebuffer is just not well designed. OpenGL needs bit depths before even creating a window in many cases, so it is probably best to add the limitation of the user getting their framebuffer bit depths set before calling init.
- error callback function, instead of forcing everyone to manually get the error if a function returns a value indicating an error
- Test (theoretically) supported platforms that haven't been tested yet:
    - x86 linux
    - arm linux
    - aarch64 linux
    - riscv64 linux
    - powerpc linux


## Some stats (may be outdated)

backend      |functions|todos|lines (approx, excluding auto-generated code)
---          |---      |---  |--
Linux/X11    |15       |7    |2300
Windows/Win32|0        |2    |70
