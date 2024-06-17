// Unlike the Linux functions, Windows headers are a giant disaster of calling conventions, shoving everything into a single header, and other crap.
// So, this had to be done manually...
// There aren't that many wgl functions though, so its ok.

// We have to include THE ENTIRE FREAKING WINDOWS HEADER just to get a handful of types...
// What a joke. You would think literal Microsoft would at least be able to split their headers in a meaningful way.
#define WIN32_LEAN_AND_MEAN
#include <windows.h>

typedef BOOL  (WINAPI *PFN_wglCopyContext)(HGLRC, HGLRC, UINT);
typedef HGLRC (WINAPI *PFN_wglCreateContext)(HDC);
typedef HGLRC (WINAPI *PFN_wglCreateLayerContext)(HDC, int);
typedef BOOL  (WINAPI *PFN_wglDeleteContext)(HGLRC);
typedef HGLRC (WINAPI *PFN_wglGetCurrentContext)(VOID);
typedef HDC   (WINAPI *PFN_wglGetCurrentDC)(VOID);
typedef PROC  (WINAPI *PFN_wglGetProcAddress)(LPCSTR);
typedef BOOL  (WINAPI *PFN_wglMakeCurrent)(HDC, HGLRC);
typedef BOOL  (WINAPI *PFN_wglShareLists)(HGLRC, HGLRC);
typedef BOOL  (WINAPI *PFN_wglUseFontBitmapsA)(HDC, DWORD, DWORD, DWORD);
typedef BOOL  (WINAPI *PFN_wglUseFontBitmapsW)(HDC, DWORD, DWORD, DWORD);
typedef BOOL  (WINAPI *PFN_SwapBuffers)(HDC);
typedef BOOL  (WINAPI *PFN_wglUseFontOutlinesA)(HDC, DWORD, DWORD, DWORD, FLOAT, FLOAT, int, LPGLYPHMETRICSFLOAT);
typedef BOOL  (WINAPI *PFN_wglUseFontOutlinesW)(HDC, DWORD, DWORD, DWORD, FLOAT, FLOAT, int, LPGLYPHMETRICSFLOAT);
typedef BOOL  (WINAPI *PFN_wglDescribeLayerPlane)(HDC, int, int, UINT, LPLAYERPLANEDESCRIPTOR);
typedef int   (WINAPI *PFN_wglSetLayerPaletteEntries)(HDC, int, int, int, CONST COLORREF *);
typedef int   (WINAPI *PFN_wglGetLayerPaletteEntries)(HDC, int, int, int, COLORREF *);
typedef BOOL  (WINAPI *PFN_wglRealizeLayerPalette)(HDC, int, BOOL);
typedef BOOL  (WINAPI *PFN_wglSwapLayerBuffers)(HDC, UINT);
typedef DWORD (WINAPI *PFN_wglSwapMultipleBuffers)(UINT, CONST WGLSWAP *);

PFN_wglCopyContext src_wglCopyContext;
PFN_wglCreateContext src_wglCreateContext;
PFN_wglCreateLayerContext src_wglCreateLayerContext;
PFN_wglDeleteContext src_wglDeleteContext;
PFN_wglGetCurrentContext src_wglGetCurrentContext;
PFN_wglGetCurrentDC src_wglGetCurrentDC;
PFN_wglGetProcAddress src_wglGetProcAddress;
PFN_wglMakeCurrent src_wglMakeCurrent;
PFN_wglShareLists src_wglShareLists;
PFN_wglUseFontBitmapsA src_wglUseFontBitmapsA;
PFN_wglUseFontBitmapsW src_wglUseFontBitmapsW;
PFN_SwapBuffers src_SwapBuffers;
PFN_wglUseFontOutlinesA src_wglUseFontOutlinesA;
PFN_wglUseFontOutlinesW src_wglUseFontOutlinesW;
PFN_wglDescribeLayerPlane src_wglDescribeLayerPlane;
PFN_wglSetLayerPaletteEntries src_wglSetLayerPaletteEntries;
PFN_wglGetLayerPaletteEntries src_wglGetLayerPaletteEntries;
PFN_wglRealizeLayerPalette src_wglRealizeLayerPalette;
PFN_wglSwapLayerBuffers src_wglSwapLayerBuffers;
PFN_wglSwapMultipleBuffers src_wglSwapMultipleBuffers;

#define wglCopyContext src_wglCopyContext
#define wglCreateContext src_wglCreateContext
#define wglCreateLayerContext src_wglCreateLayerContext
#define wglDeleteContext src_wglDeleteContext
#define wglGetCurrentContext src_wglGetCurrentContext
#define wglGetCurrentDC src_wglGetCurrentDC
#define wglGetProcAddress src_wglGetProcAddress
#define wglMakeCurrent src_wglMakeCurrent
#define wglShareLists src_wglShareLists
#define wglUseFontBitmapsA src_wglUseFontBitmapsA
#define wglUseFontBitmapsW src_wglUseFontBitmapsW
#define SwapBuffers src_SwapBuffers
#define wglUseFontOutlinesA src_wglUseFontOutlinesA
#define wglUseFontOutlinesW src_wglUseFontOutlinesW
#define wglDescribeLayerPlane src_wglDescribeLayerPlane
#define wglSetLayerPaletteEntries src_wglSetLayerPaletteEntries
#define wglGetLayerPaletteEntries src_wglGetLayerPaletteEntries
#define wglRealizeLayerPalette src_wglRealizeLayerPalette
#define wglSwapLayerBuffers src_wglSwapLayerBuffers
#define wglSwapMultipleBuffers src_wglSwapMultipleBuffers

void loadWgl(void* context, void *(*load_fn)(void* context, const char* name)) {
    src_wglCopyContext = (PFN_wglCopyContext)load_fn(context, "wglCopyContext");
    src_wglCreateContext = (PFN_wglCreateContext)load_fn(context, "wglCreateContext");
    src_wglCreateLayerContext = (PFN_wglCreateLayerContext)load_fn(context, "wglCreateLayerContext");
    src_wglDeleteContext = (PFN_wglDeleteContext)load_fn(context, "wglDeleteContext");
    src_wglGetCurrentContext = (PFN_wglGetCurrentContext)load_fn(context, "wglGetCurrentContext");
    src_wglGetCurrentDC = (PFN_wglGetCurrentDC)load_fn(context, "wglGetCurrentDC");
    src_wglGetProcAddress = (PFN_wglGetProcAddress)load_fn(context, "wglGetProcAddress");
    src_wglMakeCurrent = (PFN_wglMakeCurrent)load_fn(context, "wglMakeCurrent");
    src_wglShareLists = (PFN_wglShareLists)load_fn(context, "wglShareLists");
    src_wglUseFontBitmapsA = (PFN_wglUseFontBitmapsA)load_fn(context, "wglUseFontBitmapsA");
    src_wglUseFontBitmapsW = (PFN_wglUseFontBitmapsW)load_fn(context, "wglUseFontBitmapsW");
    src_SwapBuffers = (PFN_SwapBuffers)load_fn(context, "SwapBuffers");
    src_wglUseFontOutlinesA = (PFN_wglUseFontOutlinesA)load_fn(context, "wglUseFontOutlinesA");
    src_wglUseFontOutlinesW = (PFN_wglUseFontOutlinesW)load_fn(context, "wglUseFontOutlinesW");
    src_wglDescribeLayerPlane = (PFN_wglDescribeLayerPlane)load_fn(context, "wglDescribeLayerPlane");
    src_wglSetLayerPaletteEntries = (PFN_wglSetLayerPaletteEntries)load_fn(context, "wglSetLayerPaletteEntries");
    src_wglGetLayerPaletteEntries = (PFN_wglGetLayerPaletteEntries)load_fn(context, "wglGetLayerPaletteEntries");
    src_wglRealizeLayerPalette = (PFN_wglRealizeLayerPalette)load_fn(context, "wglRealizeLayerPalette");
    src_wglSwapLayerBuffers = (PFN_wglSwapLayerBuffers)load_fn(context, "wglSwapLayerBuffers");
    src_wglSwapMultipleBuffers = (PFN_wglSwapMultipleBuffers)load_fn(context, "wglSwapMultipleBuffers");
}
