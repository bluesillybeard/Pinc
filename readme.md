# Pinc

Pinc is a cross platform windowing / rendering library written in Zig.

## Pinc design goals
- Lightweight - minimal dependencies (within reason)
    - fundamental libraries (Xlib for example) are fair game
    - Any non-system libraries are statically linked (ex: SPIRV-cross)
- Language agnostic - The external API is entirely in C, which makes binding to other languages relatively simple
    - Specifically, the header is written in C99 as described in the [GNU C manual](https://www.gnu.org/software/gnu-c-manual/gnu-c-manual.html)
- ABSOLUTELY ZERO compile time dependencies, other than Pinc and and the Zig compiler
    - This includes system libraries that are not included in Zig's cross-compile toolchain
- Easy to use
    - Similar ease of use compared to something like SDL or SFML
- Statically linked
    - Technically can be compiled and loaded dynamically, but it is reccommended to link to Pinc statically since its ABI is not stable.

## Important notes

Pinc is a very new library. It will have issues. It will have bugs. It will have missing features. I'm not telling you to not use Pinc, but if you do decide to use it, please be patient and report issues as they show up.

Pinc is actually in such an early state that the API is open for changes. So, if you have any critique of the API or want something changed, now is the time to say it! Anything from missing keyboard buttons to a complete redesign of the API will be considered.

If you want to make a pull request, PLEASE make a github issue and/or send me an email first to get my approval. Wasting time on pull requests with no use is dissapointing for everyone involved.

Pinc's current API is fundamentally incompatible with multithreading at the moment. If you are building a new project with Pinc, design around that constraint. If you are integrating Pinc into an existing project with multithreaded rendering, you will need to either use a mutex everywhere or do some serious refactoring.

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
- Posix
    - Wayland
    - I am not aware of any Posix windowing systems other than X11 and Wayland
- Macos
    - X11
    - Coacoa

## Planned supported platforms in the future
- Andriod
- IOS
- Xbox
    - Microsoft are the good guys for once, creating Dozen so engines that use Vulkan can run on Xbox. Props to Microsoft for not being a jerk.
- Nintendo switch
    - There seems to be a lack of info on how this could be done.

## Planned supported platforms in the far future
None of these are going to be implemented any time soon - if ever.
- Playstation 4/5
    - their custom proprietary grahpics API will make this difficult as this library is open source and WILL NOT support the existence of closed source components. Sorry playstation developers, your platform is fundamentally incompatible with the open source model.
    - I've heard they support Vulkan
- BSD
    - BSD might already work (due to X11), however it is not tested.
- Haiku

## Next steps for this library
- Work on the API until it feels ready enough
- X11
    - The last revision to the header was in 1997. I think there won't be any problems running on older systems.
- OpenGL 2.1
- Release to the public
- Refactor to start supporting alternate backends
- Win32 backend
    - Making sure to avoid functions added after Windows 95 because reasons
- Cocoa backend
- any final touches to the API
    - At this point, Pinc is (hopefully) fully usable on all major desktop platforms
- Vulkan backend
- OpenGL 4.1 backend
- OpenGL 3.3 backend
- Software rasterizer backend
- Wayland
    - This is a lower priority because XWayland exists and the Wayland protocol is still undergoing frequent and substantial changes.

## Todo
- Test zero-dependency compilation
- Figure out an error reporting solution
- internal refactor of event system
- on X11 backend, trigger cursor exit event when the window looses focus (X does not trigger an exit event when focus is lost for some reason)

## Q&A
- Why make this when other libraries like Kinc, Raylib, V-EZ, bgfx, and however many others already exist?
    - None of them met the criteria for my own projects, so I did it myself. My criteria are:
        - easy integration into existing build systems and projects (this is painfully rare among C/C++ codebases)
        - easy cross-compilation
        - usable in Zig and other languages (aka C api)
        - zero compile time dependencies (other than a compiler)
        - multiple windows on desktop platforms
        - arbitrary draw surfaces
- Why support OpenGL 2.1
    - I thought it would be cool to be able to run this on extremely ancient hardware and OS, for no other reason than to see it run. It sounds stupid, but as a stupid person I think it's a great reason. This was partially inspired by [MattKC porting .NET framework 2 to Windows 95.](https://www.youtube.com/watch?v=CTUMNtKQLl8)

