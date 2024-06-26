#include <X11/X.h>
#include <X11/Xutil.h>

// generated by autodynamicheader and modified

typedef XClassHint*(*PFN_XAllocClassHint)(
    void
);
typedef XIconSize*(*PFN_XAllocIconSize)(
    void
);
typedef XSizeHints*(*PFN_XAllocSizeHints)(
    void
);
typedef XStandardColormap*(*PFN_XAllocStandardColormap)(
    void
);
typedef XWMHints*(*PFN_XAllocWMHints)(
    void
);
typedef int(*PFN_XClipBox)(
    Region		,
    XRectangle* 		
);
typedef Region(*PFN_XCreateRegion)(
    void
);
typedef char*(*PFN_XDefaultString)(void);
typedef int(*PFN_XDeleteContext)(
    Display* 		,
    XID			,
    XContext		
);
typedef int(*PFN_XDestroyRegion)(
    Region		
);
typedef int(*PFN_XEmptyRegion)(
    Region		
);
typedef int(*PFN_XEqualRegion)(
    Region		,
    Region		
);
typedef int(*PFN_XFindContext)(
    Display* 		,
    XID			,
    XContext		,
    XPointer* 		
);
typedef Status(*PFN_XGetClassHint)(
    Display* 		,
    Window		,
    XClassHint* 		
);
typedef Status(*PFN_XGetIconSizes)(
    Display* 		,
    Window		,
    XIconSize** 		,
    int* 		
);
typedef Status(*PFN_XGetNormalHints)(
    Display* 		,
    Window		,
    XSizeHints* 		
);
typedef Status(*PFN_XGetRGBColormaps)(
    Display* 		,
    Window		,
    XStandardColormap**  ,
    int* 		,
    Atom		
);
typedef Status(*PFN_XGetSizeHints)(
    Display* 		,
    Window		,
    XSizeHints* 		,
    Atom		
);
typedef Status(*PFN_XGetStandardColormap)(
    Display* 		,
    Window		,
    XStandardColormap* 	,
    Atom		
);
typedef Status(*PFN_XGetTextProperty)(
    Display* 		,
    Window		,
    XTextProperty* 	,
    Atom		
);
typedef XVisualInfo*(*PFN_XGetVisualInfo)(
    Display* 		,
    long		,
    XVisualInfo* 	,
    int* 		
);
typedef Status(*PFN_XGetWMClientMachine)(
    Display* 		,
    Window		,
    XTextProperty* 	
);
typedef XWMHints*(*PFN_XGetWMHints)(
    Display* 		,
    Window		
);
typedef Status(*PFN_XGetWMIconName)(
    Display* 		,
    Window		,
    XTextProperty* 	
);
typedef Status(*PFN_XGetWMName)(
    Display* 		,
    Window		,
    XTextProperty* 	
);
typedef Status(*PFN_XGetWMNormalHints)(
    Display* 		,
    Window		,
    XSizeHints* 		,
    long* 		
);
typedef Status(*PFN_XGetWMSizeHints)(
    Display* 		,
    Window		,
    XSizeHints* 		,
    long* 		,
    Atom		
);
typedef Status(*PFN_XGetZoomHints)(
    Display* 		,
    Window		,
    XSizeHints* 		
);
typedef int(*PFN_XIntersectRegion)(
    Region		,
    Region		,
    Region		
);
typedef void(*PFN_XConvertCase)(
    KeySym		,
    KeySym* 		,
    KeySym* 		
);
typedef int(*PFN_XLookupString)(
    XKeyEvent* 		,
    char* 		,
    int			,
    KeySym* 		,
    XComposeStatus* 	
);
typedef Status(*PFN_XMatchVisualInfo)(
    Display* 		,
    int			,
    int			,
    int			,
    XVisualInfo* 	
);
typedef int(*PFN_XOffsetRegion)(
    Region		,
    int			,
    int			
);
typedef Bool(*PFN_XPointInRegion)(
    Region		,
    int			,
    int			
);
typedef Region(*PFN_XPolygonRegion)(
    XPoint* 		,
    int			,
    int			
);
typedef int(*PFN_XRectInRegion)(
    Region		,
    int			,
    int			,
    unsigned int	,
    unsigned int	
);
typedef int(*PFN_XSaveContext)(
    Display* 		,
    XID			,
    XContext		,
    _Xconst char* 	
);
typedef int(*PFN_XSetClassHint)(
    Display* 		,
    Window		,
    XClassHint* 		
);
typedef int(*PFN_XSetIconSizes)(
    Display* 		,
    Window		,
    XIconSize* 		,
    int			
);
typedef int(*PFN_XSetNormalHints)(
    Display* 		,
    Window		,
    XSizeHints* 		
);
typedef void(*PFN_XSetRGBColormaps)(
    Display* 		,
    Window		,
    XStandardColormap* 	,
    int			,
    Atom		
);
typedef int(*PFN_XSetSizeHints)(
    Display* 		,
    Window		,
    XSizeHints* 		,
    Atom		
);
typedef int(*PFN_XSetStandardProperties)(
    Display* 		,
    Window		,
    _Xconst char* 	,
    _Xconst char* 	,
    Pixmap		,
    char** 		,
    int			,
    XSizeHints* 		
);
typedef void(*PFN_XSetTextProperty)(
    Display* 		,
    Window		,
    XTextProperty* 	,
    Atom		
);
typedef void(*PFN_XSetWMClientMachine)(
    Display* 		,
    Window		,
    XTextProperty* 	
);
typedef int(*PFN_XSetWMHints)(
    Display* 		,
    Window		,
    XWMHints* 		
);
typedef void(*PFN_XSetWMIconName)(
    Display* 		,
    Window		,
    XTextProperty* 	
);
typedef void(*PFN_XSetWMName)(
    Display* 		,
    Window		,
    XTextProperty* 	
);
typedef void(*PFN_XSetWMNormalHints)(
    Display* 		,
    Window		,
    XSizeHints* 		
);
typedef void(*PFN_XSetWMProperties)(
    Display* 		,
    Window		,
    XTextProperty* 	,
    XTextProperty* 	,
    char** 		,
    int			,
    XSizeHints* 		,
    XWMHints* 		,
    XClassHint* 		
);
typedef void(*PFN_XmbSetWMProperties)(
    Display* 		,
    Window		,
    _Xconst char* 	,
    _Xconst char* 	,
    char** 		,
    int			,
    XSizeHints* 		,
    XWMHints* 		,
    XClassHint* 		
);
typedef void(*PFN_Xutf8SetWMProperties)(
    Display* 		,
    Window		,
    _Xconst char* 	,
    _Xconst char* 	,
    char** 		,
    int			,
    XSizeHints* 		,
    XWMHints* 		,
    XClassHint* 		
);
typedef void(*PFN_XSetWMSizeHints)(
    Display* 		,
    Window		,
    XSizeHints* 		,
    Atom		
);
typedef int(*PFN_XSetRegion)(
    Display* 		,
    GC			,
    Region		
);
typedef void(*PFN_XSetStandardColormap)(
    Display* 		,
    Window		,
    XStandardColormap* 	,
    Atom		
);
typedef int(*PFN_XSetZoomHints)(
    Display* 		,
    Window		,
    XSizeHints* 		
);
typedef int(*PFN_XShrinkRegion)(
    Region		,
    int			,
    int			
);
typedef Status(*PFN_XStringListToTextProperty)(
    char** 		,
    int			,
    XTextProperty* 	
);
typedef int(*PFN_XSubtractRegion)(
    Region		,
    Region		,
    Region		
);
typedef int(*PFN_XmbTextListToTextProperty)(
    Display* 		display,
    char** 		list,
    int			count,
    XICCEncodingStyle	style,
    XTextProperty* 	text_prop_return
);
typedef int(*PFN_XwcTextListToTextProperty)(
    Display* 		display,
    wchar_t** 		list,
    int			count,
    XICCEncodingStyle	style,
    XTextProperty* 	text_prop_return
);
typedef int(*PFN_Xutf8TextListToTextProperty)(
    Display* 		display,
    char** 		list,
    int			count,
    XICCEncodingStyle	style,
    XTextProperty* 	text_prop_return
);
typedef void(*PFN_XwcFreeStringList)(
    wchar_t** 		list
);
typedef Status(*PFN_XTextPropertyToStringList)(
    XTextProperty* 	,
    char*** 		,
    int* 		
);
typedef int(*PFN_XmbTextPropertyToTextList)(
    Display* 		display,
    const XTextProperty*  text_prop,
    char*** 		list_return,
    int* 		count_return
);
typedef int(*PFN_XwcTextPropertyToTextList)(
    Display* 		display,
    const XTextProperty*  text_prop,
    wchar_t*** 		list_return,
    int* 		count_return
);
typedef int(*PFN_Xutf8TextPropertyToTextList)(
    Display* 		display,
    const XTextProperty*  text_prop,
    char*** 		list_return,
    int* 		count_return
);
typedef int(*PFN_XUnionRectWithRegion)(
    XRectangle* 		,
    Region		,
    Region		
);
typedef int(*PFN_XUnionRegion)(
    Region		,
    Region		,
    Region		
);
typedef int(*PFN_XWMGeometry)(
    Display* 		,
    int			,
    _Xconst char* 	,
    _Xconst char* 	,
    unsigned int	,
    XSizeHints* 		,
    int* 		,
    int* 		,
    int* 		,
    int* 		,
    int* 		
);
typedef int(*PFN_XXorRegion)(
    Region		,
    Region		,
    Region		
);
PFN_XAllocClassHint src_XAllocClassHint;
PFN_XAllocIconSize src_XAllocIconSize;
PFN_XAllocSizeHints src_XAllocSizeHints;
PFN_XAllocStandardColormap src_XAllocStandardColormap;
PFN_XAllocWMHints src_XAllocWMHints;
PFN_XClipBox src_XClipBox;
PFN_XCreateRegion src_XCreateRegion;
PFN_XDefaultString src_XDefaultString;
PFN_XDeleteContext src_XDeleteContext;
PFN_XDestroyRegion src_XDestroyRegion;
PFN_XEmptyRegion src_XEmptyRegion;
PFN_XEqualRegion src_XEqualRegion;
PFN_XFindContext src_XFindContext;
PFN_XGetClassHint src_XGetClassHint;
PFN_XGetIconSizes src_XGetIconSizes;
PFN_XGetNormalHints src_XGetNormalHints;
PFN_XGetRGBColormaps src_XGetRGBColormaps;
PFN_XGetSizeHints src_XGetSizeHints;
PFN_XGetStandardColormap src_XGetStandardColormap;
PFN_XGetTextProperty src_XGetTextProperty;
PFN_XGetVisualInfo src_XGetVisualInfo;
PFN_XGetWMClientMachine src_XGetWMClientMachine;
PFN_XGetWMHints src_XGetWMHints;
PFN_XGetWMIconName src_XGetWMIconName;
PFN_XGetWMName src_XGetWMName;
PFN_XGetWMNormalHints src_XGetWMNormalHints;
PFN_XGetWMSizeHints src_XGetWMSizeHints;
PFN_XGetZoomHints src_XGetZoomHints;
PFN_XIntersectRegion src_XIntersectRegion;
PFN_XConvertCase src_XConvertCase;
PFN_XLookupString src_XLookupString;
PFN_XMatchVisualInfo src_XMatchVisualInfo;
PFN_XOffsetRegion src_XOffsetRegion;
PFN_XPointInRegion src_XPointInRegion;
PFN_XPolygonRegion src_XPolygonRegion;
PFN_XRectInRegion src_XRectInRegion;
PFN_XSaveContext src_XSaveContext;
PFN_XSetClassHint src_XSetClassHint;
PFN_XSetIconSizes src_XSetIconSizes;
PFN_XSetNormalHints src_XSetNormalHints;
PFN_XSetRGBColormaps src_XSetRGBColormaps;
PFN_XSetSizeHints src_XSetSizeHints;
PFN_XSetStandardProperties src_XSetStandardProperties;
PFN_XSetTextProperty src_XSetTextProperty;
PFN_XSetWMClientMachine src_XSetWMClientMachine;
PFN_XSetWMHints src_XSetWMHints;
PFN_XSetWMIconName src_XSetWMIconName;
PFN_XSetWMName src_XSetWMName;
PFN_XSetWMNormalHints src_XSetWMNormalHints;
PFN_XSetWMProperties src_XSetWMProperties;
PFN_XmbSetWMProperties src_XmbSetWMProperties;
PFN_Xutf8SetWMProperties src_Xutf8SetWMProperties;
PFN_XSetWMSizeHints src_XSetWMSizeHints;
PFN_XSetRegion src_XSetRegion;
PFN_XSetStandardColormap src_XSetStandardColormap;
PFN_XSetZoomHints src_XSetZoomHints;
PFN_XShrinkRegion src_XShrinkRegion;
PFN_XStringListToTextProperty src_XStringListToTextProperty;
PFN_XSubtractRegion src_XSubtractRegion;
PFN_XmbTextListToTextProperty src_XmbTextListToTextProperty;
PFN_XwcTextListToTextProperty src_XwcTextListToTextProperty;
PFN_Xutf8TextListToTextProperty src_Xutf8TextListToTextProperty;
PFN_XwcFreeStringList src_XwcFreeStringList;
PFN_XTextPropertyToStringList src_XTextPropertyToStringList;
PFN_XmbTextPropertyToTextList src_XmbTextPropertyToTextList;
PFN_XwcTextPropertyToTextList src_XwcTextPropertyToTextList;
PFN_Xutf8TextPropertyToTextList src_Xutf8TextPropertyToTextList;
PFN_XUnionRectWithRegion src_XUnionRectWithRegion;
PFN_XUnionRegion src_XUnionRegion;
PFN_XWMGeometry src_XWMGeometry;
PFN_XXorRegion src_XXorRegion;
#define XAllocClassHint src_XAllocClassHint
#define XAllocIconSize src_XAllocIconSize
#define XAllocSizeHints src_XAllocSizeHints
#define XAllocStandardColormap src_XAllocStandardColormap
#define XAllocWMHints src_XAllocWMHints
#define XClipBox src_XClipBox
#define XCreateRegion src_XCreateRegion
#define XDefaultString src_XDefaultString
#define XDeleteContext src_XDeleteContext
#define XDestroyRegion src_XDestroyRegion
#define XEmptyRegion src_XEmptyRegion
#define XEqualRegion src_XEqualRegion
#define XFindContext src_XFindContext
#define XGetClassHint src_XGetClassHint
#define XGetIconSizes src_XGetIconSizes
#define XGetNormalHints src_XGetNormalHints
#define XGetRGBColormaps src_XGetRGBColormaps
#define XGetSizeHints src_XGetSizeHints
#define XGetStandardColormap src_XGetStandardColormap
#define XGetTextProperty src_XGetTextProperty
#define XGetVisualInfo src_XGetVisualInfo
#define XGetWMClientMachine src_XGetWMClientMachine
#define XGetWMHints src_XGetWMHints
#define XGetWMIconName src_XGetWMIconName
#define XGetWMName src_XGetWMName
#define XGetWMNormalHints src_XGetWMNormalHints
#define XGetWMSizeHints src_XGetWMSizeHints
#define XGetZoomHints src_XGetZoomHints
#define XIntersectRegion src_XIntersectRegion
#define XConvertCase src_XConvertCase
#define XLookupString src_XLookupString
#define XMatchVisualInfo src_XMatchVisualInfo
#define XOffsetRegion src_XOffsetRegion
#define XPointInRegion src_XPointInRegion
#define XPolygonRegion src_XPolygonRegion
#define XRectInRegion src_XRectInRegion
#define XSaveContext src_XSaveContext
#define XSetClassHint src_XSetClassHint
#define XSetIconSizes src_XSetIconSizes
#define XSetNormalHints src_XSetNormalHints
#define XSetRGBColormaps src_XSetRGBColormaps
#define XSetSizeHints src_XSetSizeHints
#define XSetStandardProperties src_XSetStandardProperties
#define XSetTextProperty src_XSetTextProperty
#define XSetWMClientMachine src_XSetWMClientMachine
#define XSetWMHints src_XSetWMHints
#define XSetWMIconName src_XSetWMIconName
#define XSetWMName src_XSetWMName
#define XSetWMNormalHints src_XSetWMNormalHints
#define XSetWMProperties src_XSetWMProperties
#define XmbSetWMProperties src_XmbSetWMProperties
#define Xutf8SetWMProperties src_Xutf8SetWMProperties
#define XSetWMSizeHints src_XSetWMSizeHints
#define XSetRegion src_XSetRegion
#define XSetStandardColormap src_XSetStandardColormap
#define XSetZoomHints src_XSetZoomHints
#define XShrinkRegion src_XShrinkRegion
#define XStringListToTextProperty src_XStringListToTextProperty
#define XSubtractRegion src_XSubtractRegion
#define XmbTextListToTextProperty src_XmbTextListToTextProperty
#define XwcTextListToTextProperty src_XwcTextListToTextProperty
#define Xutf8TextListToTextProperty src_Xutf8TextListToTextProperty
#define XwcFreeStringList src_XwcFreeStringList
#define XTextPropertyToStringList src_XTextPropertyToStringList
#define XmbTextPropertyToTextList src_XmbTextPropertyToTextList
#define XwcTextPropertyToTextList src_XwcTextPropertyToTextList
#define Xutf8TextPropertyToTextList src_Xutf8TextPropertyToTextList
#define XUnionRectWithRegion src_XUnionRectWithRegion
#define XUnionRegion src_XUnionRegion
#define XWMGeometry src_XWMGeometry
#define XXorRegion src_XXorRegion
void loadXutil(void* ctx, void *(*load_fn)(void* ctx, const char* name)) {
    src_XAllocClassHint = (PFN_XAllocClassHint)load_fn(ctx, "XAllocClassHint");
    src_XAllocIconSize = (PFN_XAllocIconSize)load_fn(ctx, "XAllocIconSize");
    src_XAllocSizeHints = (PFN_XAllocSizeHints)load_fn(ctx, "XAllocSizeHints");
    src_XAllocStandardColormap = (PFN_XAllocStandardColormap)load_fn(ctx, "XAllocStandardColormap");
    src_XAllocWMHints = (PFN_XAllocWMHints)load_fn(ctx, "XAllocWMHints");
    src_XClipBox = (PFN_XClipBox)load_fn(ctx, "XClipBox");
    src_XCreateRegion = (PFN_XCreateRegion)load_fn(ctx, "XCreateRegion");
    src_XDefaultString = (PFN_XDefaultString)load_fn(ctx, "XDefaultString");
    src_XDeleteContext = (PFN_XDeleteContext)load_fn(ctx, "XDeleteContext");
    src_XDestroyRegion = (PFN_XDestroyRegion)load_fn(ctx, "XDestroyRegion");
    src_XEmptyRegion = (PFN_XEmptyRegion)load_fn(ctx, "XEmptyRegion");
    src_XEqualRegion = (PFN_XEqualRegion)load_fn(ctx, "XEqualRegion");
    src_XFindContext = (PFN_XFindContext)load_fn(ctx, "XFindContext");
    src_XGetClassHint = (PFN_XGetClassHint)load_fn(ctx, "XGetClassHint");
    src_XGetIconSizes = (PFN_XGetIconSizes)load_fn(ctx, "XGetIconSizes");
    src_XGetNormalHints = (PFN_XGetNormalHints)load_fn(ctx, "XGetNormalHints");
    src_XGetRGBColormaps = (PFN_XGetRGBColormaps)load_fn(ctx, "XGetRGBColormaps");
    src_XGetSizeHints = (PFN_XGetSizeHints)load_fn(ctx, "XGetSizeHints");
    src_XGetStandardColormap = (PFN_XGetStandardColormap)load_fn(ctx, "XGetStandardColormap");
    src_XGetTextProperty = (PFN_XGetTextProperty)load_fn(ctx, "XGetTextProperty");
    src_XGetVisualInfo = (PFN_XGetVisualInfo)load_fn(ctx, "XGetVisualInfo");
    src_XGetWMClientMachine = (PFN_XGetWMClientMachine)load_fn(ctx, "XGetWMClientMachine");
    src_XGetWMHints = (PFN_XGetWMHints)load_fn(ctx, "XGetWMHints");
    src_XGetWMIconName = (PFN_XGetWMIconName)load_fn(ctx, "XGetWMIconName");
    src_XGetWMName = (PFN_XGetWMName)load_fn(ctx, "XGetWMName");
    src_XGetWMNormalHints = (PFN_XGetWMNormalHints)load_fn(ctx, "XGetWMNormalHints");
    src_XGetWMSizeHints = (PFN_XGetWMSizeHints)load_fn(ctx, "XGetWMSizeHints");
    src_XGetZoomHints = (PFN_XGetZoomHints)load_fn(ctx, "XGetZoomHints");
    src_XIntersectRegion = (PFN_XIntersectRegion)load_fn(ctx, "XIntersectRegion");
    src_XConvertCase = (PFN_XConvertCase)load_fn(ctx, "XConvertCase");
    src_XLookupString = (PFN_XLookupString)load_fn(ctx, "XLookupString");
    src_XMatchVisualInfo = (PFN_XMatchVisualInfo)load_fn(ctx, "XMatchVisualInfo");
    src_XOffsetRegion = (PFN_XOffsetRegion)load_fn(ctx, "XOffsetRegion");
    src_XPointInRegion = (PFN_XPointInRegion)load_fn(ctx, "XPointInRegion");
    src_XPolygonRegion = (PFN_XPolygonRegion)load_fn(ctx, "XPolygonRegion");
    src_XRectInRegion = (PFN_XRectInRegion)load_fn(ctx, "XRectInRegion");
    src_XSaveContext = (PFN_XSaveContext)load_fn(ctx, "XSaveContext");
    src_XSetClassHint = (PFN_XSetClassHint)load_fn(ctx, "XSetClassHint");
    src_XSetIconSizes = (PFN_XSetIconSizes)load_fn(ctx, "XSetIconSizes");
    src_XSetNormalHints = (PFN_XSetNormalHints)load_fn(ctx, "XSetNormalHints");
    src_XSetRGBColormaps = (PFN_XSetRGBColormaps)load_fn(ctx, "XSetRGBColormaps");
    src_XSetSizeHints = (PFN_XSetSizeHints)load_fn(ctx, "XSetSizeHints");
    src_XSetStandardProperties = (PFN_XSetStandardProperties)load_fn(ctx, "XSetStandardProperties");
    src_XSetTextProperty = (PFN_XSetTextProperty)load_fn(ctx, "XSetTextProperty");
    src_XSetWMClientMachine = (PFN_XSetWMClientMachine)load_fn(ctx, "XSetWMClientMachine");
    src_XSetWMHints = (PFN_XSetWMHints)load_fn(ctx, "XSetWMHints");
    src_XSetWMIconName = (PFN_XSetWMIconName)load_fn(ctx, "XSetWMIconName");
    src_XSetWMName = (PFN_XSetWMName)load_fn(ctx, "XSetWMName");
    src_XSetWMNormalHints = (PFN_XSetWMNormalHints)load_fn(ctx, "XSetWMNormalHints");
    src_XSetWMProperties = (PFN_XSetWMProperties)load_fn(ctx, "XSetWMProperties");
    src_XmbSetWMProperties = (PFN_XmbSetWMProperties)load_fn(ctx, "XmbSetWMProperties");
    src_Xutf8SetWMProperties = (PFN_Xutf8SetWMProperties)load_fn(ctx, "Xutf8SetWMProperties");
    src_XSetWMSizeHints = (PFN_XSetWMSizeHints)load_fn(ctx, "XSetWMSizeHints");
    src_XSetRegion = (PFN_XSetRegion)load_fn(ctx, "XSetRegion");
    src_XSetStandardColormap = (PFN_XSetStandardColormap)load_fn(ctx, "XSetStandardColormap");
    src_XSetZoomHints = (PFN_XSetZoomHints)load_fn(ctx, "XSetZoomHints");
    src_XShrinkRegion = (PFN_XShrinkRegion)load_fn(ctx, "XShrinkRegion");
    src_XStringListToTextProperty = (PFN_XStringListToTextProperty)load_fn(ctx, "XStringListToTextProperty");
    src_XSubtractRegion = (PFN_XSubtractRegion)load_fn(ctx, "XSubtractRegion");
    src_XmbTextListToTextProperty = (PFN_XmbTextListToTextProperty)load_fn(ctx, "XmbTextListToTextProperty");
    src_XwcTextListToTextProperty = (PFN_XwcTextListToTextProperty)load_fn(ctx, "XwcTextListToTextProperty");
    src_Xutf8TextListToTextProperty = (PFN_Xutf8TextListToTextProperty)load_fn(ctx, "Xutf8TextListToTextProperty");
    src_XwcFreeStringList = (PFN_XwcFreeStringList)load_fn(ctx, "XwcFreeStringList");
    src_XTextPropertyToStringList = (PFN_XTextPropertyToStringList)load_fn(ctx, "XTextPropertyToStringList");
    src_XmbTextPropertyToTextList = (PFN_XmbTextPropertyToTextList)load_fn(ctx, "XmbTextPropertyToTextList");
    src_XwcTextPropertyToTextList = (PFN_XwcTextPropertyToTextList)load_fn(ctx, "XwcTextPropertyToTextList");
    src_Xutf8TextPropertyToTextList = (PFN_Xutf8TextPropertyToTextList)load_fn(ctx, "Xutf8TextPropertyToTextList");
    src_XUnionRectWithRegion = (PFN_XUnionRectWithRegion)load_fn(ctx, "XUnionRectWithRegion");
    src_XUnionRegion = (PFN_XUnionRegion)load_fn(ctx, "XUnionRegion");
    src_XWMGeometry = (PFN_XWMGeometry)load_fn(ctx, "XWMGeometry");
    src_XXorRegion = (PFN_XXorRegion)load_fn(ctx, "XXorRegion");
}