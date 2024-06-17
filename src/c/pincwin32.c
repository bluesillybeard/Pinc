// this C file contains ALL code that directly interacts with the Windows stuff.
// (Other than the Zig standard library which uses win32 for certain things probably)
// We don't actually need to load that much stuff at runtime since Zig's cross-compile toolkit
// contains pretty much everything we need

// I know there are win32 bindings for Zig, but I felt it would probably just be easier to do it in C.

// Just like the X backend, this is more or less taken from GLFW.

// This is so we don't try to compile windows-specific code on a non-windows targets
#if _WIN32
#define WIN32_LEAN_AND_MEAN
#include <windows.h>

// things that need to be loaded at runtime
#include "load/wglLoad.h"

#define PINC_WIN32_INCLUDED
#include "pincwin32.h"

#include "pincinternal.h"

// TODO: implement DLL main

// -> Static variables
HINSTANCE instance;
void* libopengl;

// -> declare private functions (implement ones that are really short)



bool win32_load_libraries(void);
// - > implementations of functions in pincwin32.h

bool win32_init(void) {
    if(!win32_load_libraries()) {
        return false;
    }
    return true;
}

void win32_deinit(void) {
    FreeLibrary((HMODULE) libopengl);
}

// implementaions of private functions

void* win32_load_proc(void* lib, const char* proc) {
    return GetProcAddress((HMODULE) lib, proc);
}

bool win32_load_libraries(void) {
    if(!GetModuleHandleExW(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS | GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT, &instance, &instance)) {
        return pinci_make_error(pinc_error_init, "Failed to retrieve our module handle");
    }
    // I want to only load things that aren't in Zig's cross-compile toolchain (to save work)
    // GLFW dynamically loads user32, dinput8, xinput (one of the various dlls that may exist), dwmapi, shcore, and ntdll.
    // We do need to load OpenGL.dll because it's not part of Zig's cross-compile toolchain
    // TODO: when we decouple from OpenGL, refactor
    libopengl = LoadLibraryA("opengl32.dll");
    if(libopengl == 0) {
        return pinci_make_error(pinc_error_init, "Failed to load opengl32.dll");
    }
    loadWgl(libopengl, win32_load_proc);
    return true;
}

#endif
