#include <X11/extensions/XInput2.h>

// This file was generated by AutoDynamicHeader: https://github.com/bluesillybeard/AutoDynamicHeader and modified

typedef Bool(*PFN_XIQueryPointer)(
    Display*             display,
    int                 deviceid,
    Window              win,
    Window*              root,
    Window*              child,
    double*              root_x,
    double*              root_y,
    double*              win_x,
    double*              win_y,
    XIButtonState* buttons,
    XIModifierState* mods,
    XIGroupState* group
);
typedef Bool(*PFN_XIWarpPointer)(
    Display*             display,
    int                 deviceid,
    Window              src_win,
    Window              dst_win,
    double              src_x,
    double              src_y,
    unsigned int        src_width,
    unsigned int        src_height,
    double              dst_x,
    double              dst_y
);
typedef Status(*PFN_XIDefineCursor)(
    Display*             display,
    int                 deviceid,
    Window              win,
    Cursor              cursor
);
typedef Status(*PFN_XIUndefineCursor)(
    Display*             display,
    int                 deviceid,
    Window              win
);
typedef Status(*PFN_XIChangeHierarchy)(
    Display*             display,
    XIAnyHierarchyChangeInfo*   changes,
    int                 num_changes
);
typedef Status(*PFN_XISetClientPointer)(
    Display*             dpy,
    Window              win,
    int                 deviceid
);
typedef Bool(*PFN_XIGetClientPointer)(
    Display*             dpy,
    Window              win,
    int*                 deviceid
);
typedef int(*PFN_XISelectEvents)(
     Display*             dpy,
     Window              win,
     XIEventMask* masks,
     int                 num_masks
);
typedef XIEventMask*(*PFN_XIGetSelectedEvents)(
     Display*             dpy,
     Window              win,
     int* num_masks_return
);
typedef Status(*PFN_XIQueryVersion)(
     Display*            dpy,
     int*                major_version_inout,
     int*                minor_version_inout
);
typedef XIDeviceInfo*(*PFN_XIQueryDevice)(
     Display*            dpy,
     int                deviceid,
     int*                ndevices_return
);
typedef Status(*PFN_XISetFocus)(
     Display*            dpy,
     int                deviceid,
     Window             focus,
     Time               time
);
typedef Status(*PFN_XIGetFocus)(
     Display*            dpy,
     int                deviceid,
     Window* focus_return);
typedef Status(*PFN_XIGrabDevice)(
     Display*            dpy,
     int                deviceid,
     Window             grab_window,
     Time               time,
     Cursor             cursor,
     int                grab_mode,
     int                paired_device_mode,
     Bool               owner_events,
     XIEventMask* mask
);
typedef Status(*PFN_XIUngrabDevice)(
     Display*            dpy,
     int                deviceid,
     Time               time
);
typedef Status(*PFN_XIAllowEvents)(
    Display*             display,
    int                 deviceid,
    int                 event_mode,
    Time                time
);
typedef Status(*PFN_XIAllowTouchEvents)(
    Display*             display,
    int                 deviceid,
    unsigned int        touchid,
    Window              grab_window,
    int                 event_mode
);
typedef int(*PFN_XIGrabButton)(
    Display*             display,
    int                 deviceid,
    int                 button,
    Window              grab_window,
    Cursor              cursor,
    int                 grab_mode,
    int                 paired_device_mode,
    int                 owner_events,
    XIEventMask* mask,
    int                 num_modifiers,
    XIGrabModifiers* modifiers_inout
);
typedef int(*PFN_XIGrabKeycode)(
    Display*             display,
    int                 deviceid,
    int                 keycode,
    Window              grab_window,
    int                 grab_mode,
    int                 paired_device_mode,
    int                 owner_events,
    XIEventMask* mask,
    int                 num_modifiers,
    XIGrabModifiers* modifiers_inout
);
typedef int(*PFN_XIGrabEnter)(
    Display*             display,
    int                 deviceid,
    Window              grab_window,
    Cursor              cursor,
    int                 grab_mode,
    int                 paired_device_mode,
    int                 owner_events,
    XIEventMask* mask,
    int                 num_modifiers,
    XIGrabModifiers* modifiers_inout
);
typedef int(*PFN_XIGrabFocusIn)(
    Display*             display,
    int                 deviceid,
    Window              grab_window,
    int                 grab_mode,
    int                 paired_device_mode,
    int                 owner_events,
    XIEventMask* mask,
    int                 num_modifiers,
    XIGrabModifiers* modifiers_inout
);
typedef int(*PFN_XIGrabTouchBegin)(
    Display*             display,
    int                 deviceid,
    Window              grab_window,
    int                 owner_events,
    XIEventMask* mask,
    int                 num_modifiers,
    XIGrabModifiers* modifiers_inout
);
typedef int(*PFN_XIGrabPinchGestureBegin)(
    Display*             display,
    int                 deviceid,
    Window              grab_window,
    int                 grab_mode,
    int                 paired_device_mode,
    int                 owner_events,
    XIEventMask* mask,
    int                 num_modifiers,
    XIGrabModifiers* modifiers_inout
);
typedef int(*PFN_XIGrabSwipeGestureBegin)(
    Display*             display,
    int                 deviceid,
    Window              grab_window,
    int                 grab_mode,
    int                 paired_device_mode,
    int                 owner_events,
    XIEventMask* mask,
    int                 num_modifiers,
    XIGrabModifiers* modifiers_inout
);
typedef Status(*PFN_XIUngrabButton)(
    Display*             display,
    int                 deviceid,
    int                 button,
    Window              grab_window,
    int                 num_modifiers,
    XIGrabModifiers* modifiers
);
typedef Status(*PFN_XIUngrabKeycode)(
    Display*             display,
    int                 deviceid,
    int                 keycode,
    Window              grab_window,
    int                 num_modifiers,
    XIGrabModifiers* modifiers
);
typedef Status(*PFN_XIUngrabEnter)(
    Display*             display,
    int                 deviceid,
    Window              grab_window,
    int                 num_modifiers,
    XIGrabModifiers* modifiers
);
typedef Status(*PFN_XIUngrabFocusIn)(
    Display*             display,
    int                 deviceid,
    Window              grab_window,
    int                 num_modifiers,
    XIGrabModifiers* modifiers
);
typedef Status(*PFN_XIUngrabTouchBegin)(
    Display*             display,
    int                 deviceid,
    Window              grab_window,
    int                 num_modifiers,
    XIGrabModifiers* modifiers
);
typedef Status(*PFN_XIUngrabPinchGestureBegin)(
    Display*             display,
    int                 deviceid,
    Window              grab_window,
    int                 num_modifiers,
    XIGrabModifiers* modifiers
);
typedef Status(*PFN_XIUngrabSwipeGestureBegin)(
    Display*             display,
    int                 deviceid,
    Window              grab_window,
    int                 num_modifiers,
    XIGrabModifiers* modifiers
);
typedef Atom*(*PFN_XIListProperties)(
    Display*             display,
    int                 deviceid,
    int* num_props_return
);
typedef void(*PFN_XIChangeProperty)(
    Display*             display,
    int                 deviceid,
    Atom                property,
    Atom                type,
    int                 format,
    int                 mode,
    unsigned char* data,
    int                 num_items
);
typedef void(*PFN_XIDeleteProperty)(
    Display*             display,
    int                 deviceid,
    Atom                property
);
typedef Status(*PFN_XIGetProperty)(
    Display*             display,
    int                 deviceid,
    Atom                property,
    long                offset,
    long                length,
    Bool                delete_property,
    Atom                type,
    Atom* type_return,
    int* format_return,
    unsigned long* num_items_return,
    unsigned long* bytes_after_return,
    unsigned char** data
);
typedef void(*PFN_XIBarrierReleasePointers)(
    Display*                     display,
    XIBarrierReleasePointerInfo* barriers,
    int                         num_barriers
);
typedef void(*PFN_XIBarrierReleasePointer)(
    Display*                     display,
    int                         deviceid,
    PointerBarrier              barrier,
    BarrierEventID              eventid
);
typedef void(*PFN_XIFreeDeviceInfo)(XIDeviceInfo* info);
PFN_XIQueryPointer src_XIQueryPointer;
PFN_XIWarpPointer src_XIWarpPointer;
PFN_XIDefineCursor src_XIDefineCursor;
PFN_XIUndefineCursor src_XIUndefineCursor;
PFN_XIChangeHierarchy src_XIChangeHierarchy;
PFN_XISetClientPointer src_XISetClientPointer;
PFN_XIGetClientPointer src_XIGetClientPointer;
PFN_XISelectEvents src_XISelectEvents;
PFN_XIGetSelectedEvents src_XIGetSelectedEvents;
PFN_XIQueryVersion src_XIQueryVersion;
PFN_XIQueryDevice src_XIQueryDevice;
PFN_XISetFocus src_XISetFocus;
PFN_XIGetFocus src_XIGetFocus;
PFN_XIGrabDevice src_XIGrabDevice;
PFN_XIUngrabDevice src_XIUngrabDevice;
PFN_XIAllowEvents src_XIAllowEvents;
PFN_XIAllowTouchEvents src_XIAllowTouchEvents;
PFN_XIGrabButton src_XIGrabButton;
PFN_XIGrabKeycode src_XIGrabKeycode;
PFN_XIGrabEnter src_XIGrabEnter;
PFN_XIGrabFocusIn src_XIGrabFocusIn;
PFN_XIGrabTouchBegin src_XIGrabTouchBegin;
PFN_XIGrabPinchGestureBegin src_XIGrabPinchGestureBegin;
PFN_XIGrabSwipeGestureBegin src_XIGrabSwipeGestureBegin;
PFN_XIUngrabButton src_XIUngrabButton;
PFN_XIUngrabKeycode src_XIUngrabKeycode;
PFN_XIUngrabEnter src_XIUngrabEnter;
PFN_XIUngrabFocusIn src_XIUngrabFocusIn;
PFN_XIUngrabTouchBegin src_XIUngrabTouchBegin;
PFN_XIUngrabPinchGestureBegin src_XIUngrabPinchGestureBegin;
PFN_XIUngrabSwipeGestureBegin src_XIUngrabSwipeGestureBegin;
PFN_XIListProperties src_XIListProperties;
PFN_XIChangeProperty src_XIChangeProperty;
PFN_XIDeleteProperty src_XIDeleteProperty;
PFN_XIGetProperty src_XIGetProperty;
PFN_XIBarrierReleasePointers src_XIBarrierReleasePointers;
PFN_XIBarrierReleasePointer src_XIBarrierReleasePointer;
PFN_XIFreeDeviceInfo src_XIFreeDeviceInfo;
#define XIQueryPointer src_XIQueryPointer
#define XIWarpPointer src_XIWarpPointer
#define XIDefineCursor src_XIDefineCursor
#define XIUndefineCursor src_XIUndefineCursor
#define XIChangeHierarchy src_XIChangeHierarchy
#define XISetClientPointer src_XISetClientPointer
#define XIGetClientPointer src_XIGetClientPointer
#define XISelectEvents src_XISelectEvents
#define XIGetSelectedEvents src_XIGetSelectedEvents
#define XIQueryVersion src_XIQueryVersion
#define XIQueryDevice src_XIQueryDevice
#define XISetFocus src_XISetFocus
#define XIGetFocus src_XIGetFocus
#define XIGrabDevice src_XIGrabDevice
#define XIUngrabDevice src_XIUngrabDevice
#define XIAllowEvents src_XIAllowEvents
#define XIAllowTouchEvents src_XIAllowTouchEvents
#define XIGrabButton src_XIGrabButton
#define XIGrabKeycode src_XIGrabKeycode
#define XIGrabEnter src_XIGrabEnter
#define XIGrabFocusIn src_XIGrabFocusIn
#define XIGrabTouchBegin src_XIGrabTouchBegin
#define XIGrabPinchGestureBegin src_XIGrabPinchGestureBegin
#define XIGrabSwipeGestureBegin src_XIGrabSwipeGestureBegin
#define XIUngrabButton src_XIUngrabButton
#define XIUngrabKeycode src_XIUngrabKeycode
#define XIUngrabEnter src_XIUngrabEnter
#define XIUngrabFocusIn src_XIUngrabFocusIn
#define XIUngrabTouchBegin src_XIUngrabTouchBegin
#define XIUngrabPinchGestureBegin src_XIUngrabPinchGestureBegin
#define XIUngrabSwipeGestureBegin src_XIUngrabSwipeGestureBegin
#define XIListProperties src_XIListProperties
#define XIChangeProperty src_XIChangeProperty
#define XIDeleteProperty src_XIDeleteProperty
#define XIGetProperty src_XIGetProperty
#define XIBarrierReleasePointers src_XIBarrierReleasePointers
#define XIBarrierReleasePointer src_XIBarrierReleasePointer
#define XIFreeDeviceInfo src_XIFreeDeviceInfo
void loadXInput2(void* context, void *(*load_fn)(void* context, const char* name)) {
    src_XIQueryPointer = (PFN_XIQueryPointer)load_fn(context, "XIQueryPointer");
    src_XIWarpPointer = (PFN_XIWarpPointer)load_fn(context, "XIWarpPointer");
    src_XIDefineCursor = (PFN_XIDefineCursor)load_fn(context, "XIDefineCursor");
    src_XIUndefineCursor = (PFN_XIUndefineCursor)load_fn(context, "XIUndefineCursor");
    src_XIChangeHierarchy = (PFN_XIChangeHierarchy)load_fn(context, "XIChangeHierarchy");
    src_XISetClientPointer = (PFN_XISetClientPointer)load_fn(context, "XISetClientPointer");
    src_XIGetClientPointer = (PFN_XIGetClientPointer)load_fn(context, "XIGetClientPointer");
    src_XISelectEvents = (PFN_XISelectEvents)load_fn(context, "XISelectEvents");
    src_XIGetSelectedEvents = (PFN_XIGetSelectedEvents)load_fn(context, "XIGetSelectedEvents");
    src_XIQueryVersion = (PFN_XIQueryVersion)load_fn(context, "XIQueryVersion");
    src_XIQueryDevice = (PFN_XIQueryDevice)load_fn(context, "XIQueryDevice");
    src_XISetFocus = (PFN_XISetFocus)load_fn(context, "XISetFocus");
    src_XIGetFocus = (PFN_XIGetFocus)load_fn(context, "XIGetFocus");
    src_XIGrabDevice = (PFN_XIGrabDevice)load_fn(context, "XIGrabDevice");
    src_XIUngrabDevice = (PFN_XIUngrabDevice)load_fn(context, "XIUngrabDevice");
    src_XIAllowEvents = (PFN_XIAllowEvents)load_fn(context, "XIAllowEvents");
    src_XIAllowTouchEvents = (PFN_XIAllowTouchEvents)load_fn(context, "XIAllowTouchEvents");
    src_XIGrabButton = (PFN_XIGrabButton)load_fn(context, "XIGrabButton");
    src_XIGrabKeycode = (PFN_XIGrabKeycode)load_fn(context, "XIGrabKeycode");
    src_XIGrabEnter = (PFN_XIGrabEnter)load_fn(context, "XIGrabEnter");
    src_XIGrabFocusIn = (PFN_XIGrabFocusIn)load_fn(context, "XIGrabFocusIn");
    src_XIGrabTouchBegin = (PFN_XIGrabTouchBegin)load_fn(context, "XIGrabTouchBegin");
    src_XIGrabPinchGestureBegin = (PFN_XIGrabPinchGestureBegin)load_fn(context, "XIGrabPinchGestureBegin");
    src_XIGrabSwipeGestureBegin = (PFN_XIGrabSwipeGestureBegin)load_fn(context, "XIGrabSwipeGestureBegin");
    src_XIUngrabButton = (PFN_XIUngrabButton)load_fn(context, "XIUngrabButton");
    src_XIUngrabKeycode = (PFN_XIUngrabKeycode)load_fn(context, "XIUngrabKeycode");
    src_XIUngrabEnter = (PFN_XIUngrabEnter)load_fn(context, "XIUngrabEnter");
    src_XIUngrabFocusIn = (PFN_XIUngrabFocusIn)load_fn(context, "XIUngrabFocusIn");
    src_XIUngrabTouchBegin = (PFN_XIUngrabTouchBegin)load_fn(context, "XIUngrabTouchBegin");
    src_XIUngrabPinchGestureBegin = (PFN_XIUngrabPinchGestureBegin)load_fn(context, "XIUngrabPinchGestureBegin");
    src_XIUngrabSwipeGestureBegin = (PFN_XIUngrabSwipeGestureBegin)load_fn(context, "XIUngrabSwipeGestureBegin");
    src_XIListProperties = (PFN_XIListProperties)load_fn(context, "XIListProperties");
    src_XIChangeProperty = (PFN_XIChangeProperty)load_fn(context, "XIChangeProperty");
    src_XIDeleteProperty = (PFN_XIDeleteProperty)load_fn(context, "XIDeleteProperty");
    src_XIGetProperty = (PFN_XIGetProperty)load_fn(context, "XIGetProperty");
    src_XIBarrierReleasePointers = (PFN_XIBarrierReleasePointers)load_fn(context, "XIBarrierReleasePointers");
    src_XIBarrierReleasePointer = (PFN_XIBarrierReleasePointer)load_fn(context, "XIBarrierReleasePointer");
    src_XIFreeDeviceInfo = (PFN_XIFreeDeviceInfo)load_fn(context, "XIFreeDeviceInfo");
}