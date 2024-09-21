![Logo](logo.svg)

# Pinc

Pinc is a cross platform windowing / rendering library written in Zig.

## Pincs goals
- Language agnostic - The external API is entirely in C, which makes binding to other languages relatively simple
    - The header is written plain C, which can be loaded through any C compatible FFI system imaginable
    - the external API only makes used of `int`, and `char` (and `void` obviously) - it doesn't even need pointers!
        - there will be versions of functions that make use of more specific types, for languages that can make use of that.
    - TODO: need bindings
- ABSOLUTELY ZERO compile time dependencies, other than the Zig compiler
    - This includes system libraries that are not included in Zig's cross-compile toolchain. They must be loaded at runtime.
    - All of the headers needed are included in the repository. The headers all have their individual licenses listed at the top of the file.
    - TODO: option to statically / directly link required libraries instead of loading them at runtime.
- Easy to use
    - comparable to something like SDL or SFML, with the bonus of being a lot easier to compile and link
    - admittedly the API is a bit verbose
- Flexible
    - can be linked statically or dynamically
    - determines the API to use at runtime, so fewer compilation targets are needed
    - cross-compiles from any platform to any platform (supported by the Zig compiler of course)
    - Can be made to work with any C ABI (Zig's compiler for the win!)
        - Except for musl, since it doesn't allow loading libraries at runtime (sad)
    - TODO: options to select the API visibility and calling convention

## Other things
- Pinc does not take hold of the entry point.
    - note: it's unclear how well this pans out with platforms like Android where the entry point is non-standard.
- Pinc does not provide a main loop
    - note: it's unclear how this will effect platforms like the web where the main loop is supposed to be managed externally

## Windowing backends
- SDL2

## Graphics backends
- OpenGL 2.1

## Important notes
Pinc is a very new library, and is MASSIVELY out of scope for a single developer like myself. As such:
- Expect bugs / issues
    - a large portion of the API is not implemented yet
- the API is highly variable for the forseeable future
    - Give me your suggestions - the API is VERY incomplete and we don't know what's missing!
- the project desparately needs contributors - see [contribution guide](contribute.md)

Pinc's current API is fundamentally incompatible with multithreading. Sorry.

## How to get started
- Get Zig (this is tested on zig master but it might work on older versions)
- Clone the repository
- Make sure it works by running `zig build window -Drun=true`, which will build and run the window example.
- The library is ready to be used...

The easiest way to do it would be to just compile Pinc into a library with `zig build static` or `zig build dynamic`, copy the artifact and the header, and just add it to your linker flags. Automating that would be a good idea, especially for cross-compilation so you don't have a bajillion copies of the same library pre-compiled for different platforms.

This project does not integrate with any existing build systems other than Zig. It doesn't even integrate with Zig's build system properly, since this is intended for use with C and not Zig. That being said, contributions that add support for other build systems / package managers are accepted and celebrated! Once a build system is implemented, it shouldn't need much (or any) maintainence due to the fact that Pinc has all dependencies self-contained or loaded at runtime.

Hopefully the header is self-exaplanatory. If it's not clear what a function or type does, consider submitting an issue so we can improve documentation.

It's worth noting the Pinc makes heavy use of asserts that will not trigger in ReleaseFast mode. We suggest using Debug to build the library, until you are confident everything works correctly, in which case ReleaseFast is a decent option. That being said, ReleaseSafe is almost certainly fast enough for any reasonable use case, but retains the safety checks of Debug mode.

## Other notes
- When cross-compiling, it is generally a good idea to specify the ABI (example: `x86_64-linux-gnu` instead of `x86_64-linux`) as it tends to default to the wrong ABI which is quite annoying.
    - In particular, compiling from Windows to Linux uses musl by default, which does not work as Pinc uses dynamic loading with libc on Linux
- The main branch is "stable" in the sense that it should always work. Before commiting to the main branch, We'll make sure everything still works.
    - the library as a whole is NOT stable. DO not use Pinc unless you are willing to face the consequences!

## Q&A
- Why make this when other libraries already exist?
    - the state of low-level windowing / graphics libraries is not ideal. Kinc's build system is a mess, Raylib is too basic, V-EZ hasn't been updated in many years, bgfx is written in C++, SDL doesn't cross-compile easily, nicegraf and llgl don't provide a way to create a window, GLFW has no way to have multiple windows on a single OpenGL context, Jai is a programming language instead of a library, and the list goes on and on and on. They are all great, but they all suck in specific ways that are conveniently very bad for a certain group of programmers
    - Additionally, a library with an insanely wide net of supported backends is very useful. Admittedly, the only backend implemented at the moment is based on SDL2, but take a look at the [Planned Backends](#planned-window-backends-not-final),
- Why support OpenGL 2.1. It's so old! (and deprecated)
    - I thought it would be cool to be able to run this on extremely ancient hardware and OS, for no other reason than to see it run. Partially inspired by [MattKC porting .NET framework 2 to Windows 95.](https://www.youtube.com/watch?v=CTUMNtKQLl8)
    - If a platform is capible of running OpenGL 2.1, someone has probably made an opengl driver for it

## Planned graphics backends (NOT FINAL)
- Raw / framebuffer on the CPU / software rasterizer
- SDL 1
    - Is this even worth implementing despite the raw and opengl backends?
- SDL 2
    - Is this even worth implementing despite the raw and opengl backends?
- SDL 3
    - Is this even worth implementing despite the raw and opengl backends?
- OpenGL 1.x
    - not sure which 1.x version(s) yet
- OpenGL 3.x
    - not sure which 3.x verison yet
- OpenGL 4.x
    - note sure which 4.x version(s) yet
- OpenGL 4.6 (last OpenGL release)
- Vulkan 1.0 (first vulkan release)
- Vulkan 1.2 (last Vulkan release that is very widely supported on older hardware)
- Vulkan 1.3 (last Vulkan release)

## Planned window backends (NOT FINAL)
- SDL 1
- SDL 3
- X11 (Xlib)
- win32
- windows 9x (TODO: figure out what the API is called for this)
- Cocoa
- Wayland
- GLFW
- Haiku
- Andriod
- IOS

## Planned backends / platforms in the VERY FAR future
None of these are going to be implemented any time soon - if ever.
- Playstation 4/5
- Xbox
    - It's basically just Windows (I think), should be pretty easy actually
- Nintendo switch
    - There seems to be a lack of info on how this could be done.
- N64 would be funny
- Playstation would also be funny
- Microsoft DOS
    - an msdos backend doesn't even make sense, as I don't think it has a universal way to draw pixels on the screen
- terminal text output
    - haha ascii art go BRRR

## backends that will NEVER be implemented
- Raw X11 network packets
    - are you crazy!? Also, good luck getting OpenGL or Vulkan to work.
- Xcb
    - Not worth the effort. Xlib works fine for X11.

## Missing features (LOOKING FOR CONTRIBUTORS / API DESIGN IDEAS)
- window position
    - wayland be like:
- lots of events aren't implemented yet
- ability get data from specific backends
    - X display, X windows, SDL2 opengl context, Win32 window handle, etc etc etc
- backend-specific settings
- ability to use backend objects to create Pinc objects
    - example: init pinc's X backend with an X Display, or a window with an X window handle, etc.
- general input methods
    - controller / gamepad
    - touch screen
    - drawing tablet
    - VR headsets
        - every headset seems to have its own position / velocity system...
- HDR support
    - Admittedly, HDR support is still in the early stages on anything other than Windows...
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

## Todo (NOT IN ORDER)
Note: Even if a feature/item you want is in here, make an issue anyway! Features are prioritized based on github issues.
- Test zero-dependency compilation
- Set up github discussions thingy
- error callback function, instead of forcing everyone to manually get the error if a function returns a value indicating an error
- test on ALL zig tier 3 platforms, ideally using real hardware. As of right now, those are:
    - Windows x86_64 (testing hardware is available)
    - Windows x86
    - Windows aarch64
    - Macos aarch64
    - Macos x86_64
    - Linux x86_64 (testing hardware is available)
    - Linux x86 (testing hardware is available)
    - Linux aarch64
    - Linux armv7a
    - Linux riscv64
    - Linux powerpc64le
- add functions that take advantage of pointers for performance
    - particularily for 3D rendering with large meshes
- Replace the global state "OpenGl-y" graphics functions to use a graphics context object
    - Maybe each graphics context could even use a different graphics backend? Probably not...
- the graphics API as a whole does not exist really
- example / test for having multiple windows
- get the cursor movement within a specific window
- get cursor movement delta
- lock cursor
- properly implement and test scaling
- add a way to get the size of a window in real units (like inches or something)
- empty / "null" / mock window backend
- empty / "null" / mock graphics backend
