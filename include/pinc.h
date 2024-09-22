// pinc.h - Pinc's entire API.
// Pinc is designed to be extremely simple such that the entire API fits in a single easy to understand header
// Note that, at least for now, this header is entirely in regular C99.

// You'll notice, this header has no includes. Hooray for minimal dependencies!
// There are downsides to only using pure C with nothing else:
// - the sizes of types is completely and utterly undefined. An int could be 11 bits for all we know!
// - potential ABI mismatches (particularily on Linux where clang / gcc / whatever compiler might have subtle ABI differences)

// In general, here are the rules / properties of Pinc's api:
// - no unions or bit fields, as they tend to cause ABI problems
// - we assume floats are in the single precsision IEE754 format.
// - Any pinc functions that take or return pointers are optional
//     - This is to make bindings to other languages as freakishly straightforward as possible.
//     - Lists are returned by providing a length and a get function
//     - lists are entered by setting the length and using the set function
// - no structs either, particularily for languages like python where a 'struct' doesn't actually exist
// - using only void, int, char, and float seems limiting... because it is
//     - typedefs are allowed, however none of them have been made yet (oops)

// error policy:
// - incorrect usage of Pinc's API will trigger an assert in debug builds (-Doptimize=Debug or -Doptimize=ReleaseSafe)
// - errors caused by Pinc will also trigger asserts - when in doubt, make an issue / discussion / discord message with the error.
// - errors that are not fatal will trigger an error that can be collected using pinc_error_* functions
// - errors that are caused by external factors and are fatal will trigger errors that can be collected using pinc_error_* functions.
//   Fatal errors will cause pinc to be in an invalid state, and any non-error collecting function call from then on will trigger an assert.
// - NOTE: you should really compile pinc with -Doptimize=ReleaseSafe. Only use ReleaseFast if you *really* need that bit of extra speed.

// The flow of your code should be like this:
// - call pinc_incomplete_init()
// - TODO: refactor this to help give users more information and control over this while still allowing for flexibility between devices
// - (optional) decide which window backend to use
//     - use pinc_window_backend_is_supported to get if a backend is supported by Pinc
//     - use pinc_init_set_window_backend to set your chosen backend. Note that this MUST be the first init variable set, if you are going to set it.
// - (optional) decide which graphics backend to use
//     - use pinc_graphics_backend_is_supported on each backend your program will support, from best to worst.
//       The first one that returns true is the one you will use
//     - call pinc_init_set_graphics_backend with your choice
//     - This must be done before iterating available framebuffer formats
// - (optional) choose a framebuffer format:
//     - use pinc_framebuffer_format_get_num() and the pinc_framebuffer_format_get_* functions to determine which framebuffer format to use
//     - call pinc_init_set_framebuffer_format(framebuffer_index) to select your framebuffer format
//     - This whole framebuffer weirdness seems tedious but, due to how Pinc works, all framebuffers need to use the same format.
//     - The problem of all framebuffers requiring the same format is actually inherited from OpenGL 2.1.
// - call pinc_complete_init()
// - (optional) create objects:
//     - windows - you know what a window is.
// - main loop
//     - call pinc_step
//         - this will collect events, update window properties, clear arena allocators, etc.
//     - handle events (pinc_event_*)
//     - draw stuff (pinc_graphics_*)
//     - present framebuffers (pinc_window_present_framebuffer)

/// @section options
/// @brief this is for setting Pinc options. Note that, right now, the build system is not set up to use these.
// TODO: add these to build system

#ifndef PINC_API
#define PINC_API
#endif

// TODO: have the calling convention mirrored in the zig version too
#ifndef PINC_CALL
#define PINC_CALL
#endif

/// @section types (Notice there are no structs here.)

// Types and enums
enum pinc_window_backend {
    /// @brief The backend is unknown / not in this enum
    pinc_window_backend_any,
    /// @brief Pinc is using SDL2
    pinc_window_backend_sdl2,
    // New backends implemented are added at the end here.
    
};

enum pinc_graphics_backend {
    /// @brief the graphics backend is unknown / not in this enum.
    /// When chosen as the graphics backend, pinc will use the "best" one for the platform / device
    pinc_graphics_backend_none,
    /// @brief OpenGL 2.1
    pinc_graphics_backend_opengl_2_1,
    /// @brief just a plain pixel grid. No hardware acceleration, just a grid of pixels and grinding through pixel data on the CPU.
    pinc_graphics_backend_raw,
};

enum pinc_error_type {
    /// @brief Error does not have a designated type.
    pinc_error_any,
    // Errors that aren't here and why:
    // - wrong object type -> that is a programmer error, so it's an assert instead of an error
    // - attempt to get something that is cemented -> programmer error, its an assert
    // - calling pinc functions before its initialized -> programmer error = assert
    // - Pinc developers made a mistake and forgot something -> an error with Pinc itself, that's an assert
};

/// @brief Enumeration of Pinc object types.
enum pinc_object_type {
    /// @brief the object is empty / invalid
    pinc_object_none,
    pinc_object_window,
};

/// enumeration of pinc keyboard codes
/// These are not physical, but logical - when the user presses the button labeled 'q' on their keyboard, that's the key reported here.
/// In order words, this ignores the idea of a keyboard layout, and reports based on what the user is typing, not what actual buttons are being pressed.
enum pinc_keyboard_key {
    pinc_keyboard_key_unknown = -1,
    pinc_keyboard_key_space = 0,
    pinc_keyboard_key_apostrophe,
    pinc_keyboard_key_comma,
    pinc_keyboard_key_dash,
    pinc_keyboard_key_dot,
    pinc_keyboard_key_slash,
    pinc_keyboard_key_0,
    pinc_keyboard_key_1,
    pinc_keyboard_key_2,
    pinc_keyboard_key_3,
    pinc_keyboard_key_4,
    pinc_keyboard_key_5,
    pinc_keyboard_key_6,
    pinc_keyboard_key_7,
    pinc_keyboard_key_8,
    pinc_keyboard_key_9,
    pinc_keyboard_key_semicolon,
    pinc_keyboard_key_equals,
    pinc_keyboard_key_a,
    pinc_keyboard_key_b,
    pinc_keyboard_key_c,
    pinc_keyboard_key_d,
    pinc_keyboard_key_e,
    pinc_keyboard_key_f,
    pinc_keyboard_key_g,
    pinc_keyboard_key_h,
    pinc_keyboard_key_i,
    pinc_keyboard_key_j,
    pinc_keyboard_key_k,
    pinc_keyboard_key_l,
    pinc_keyboard_key_m,
    pinc_keyboard_key_n,
    pinc_keyboard_key_o,
    pinc_keyboard_key_p,
    pinc_keyboard_key_q,
    pinc_keyboard_key_r,
    pinc_keyboard_key_s,
    pinc_keyboard_key_t,
    pinc_keyboard_key_u,
    pinc_keyboard_key_v,
    pinc_keyboard_key_w,
    pinc_keyboard_key_x,
    pinc_keyboard_key_y,
    pinc_keyboard_key_z,
    pinc_keyboard_key_left_bracket,
    pinc_keyboard_key_backslash,
    pinc_keyboard_key_right_bracket,
    /// @brief The ` character. The ~` button on US keyboards.
    pinc_keyboard_key_backtick,
    pinc_keyboard_key_escape,
    pinc_keyboard_key_enter,
    pinc_keyboard_key_tab,
    pinc_keyboard_key_backspace,
    pinc_keyboard_key_insert,
    pinc_keyboard_key_delete,
    pinc_keyboard_key_right,
    pinc_keyboard_key_left,
    pinc_keyboard_key_down,
    pinc_keyboard_key_up,
    pinc_keyboard_key_page_up,
    pinc_keyboard_key_page_down,
    pinc_keyboard_key_home,
    pinc_keyboard_key_end,
    pinc_keyboard_key_caps_lock,
    pinc_keyboard_key_scroll_lock,
    pinc_keyboard_key_num_lock,
    pinc_keyboard_key_print_screen,
    pinc_keyboard_key_pause,
    pinc_keyboard_key_f1,
    pinc_keyboard_key_f2,
    pinc_keyboard_key_f3,
    pinc_keyboard_key_f4,
    pinc_keyboard_key_f5,
    pinc_keyboard_key_f6,
    pinc_keyboard_key_f7,
    pinc_keyboard_key_f8,
    pinc_keyboard_key_f9,
    pinc_keyboard_key_f10,
    pinc_keyboard_key_f11,
    pinc_keyboard_key_f12,
    pinc_keyboard_key_f13,
    pinc_keyboard_key_f14,
    pinc_keyboard_key_f15,
    pinc_keyboard_key_f16,
    pinc_keyboard_key_f17,
    pinc_keyboard_key_f18,
    pinc_keyboard_key_f19,
    pinc_keyboard_key_f20,
    pinc_keyboard_key_f21,
    pinc_keyboard_key_f22,
    pinc_keyboard_key_f23,
    pinc_keyboard_key_f24,
    // Note: I don't think any actual systems have support for function keys beyond 24.
    pinc_keyboard_key_f25,
    pinc_keyboard_key_f26,
    pinc_keyboard_key_f27,
    pinc_keyboard_key_f28,
    pinc_keyboard_key_f29,
    pinc_keyboard_key_f30,
    pinc_keyboard_key_numpad_0,
    pinc_keyboard_key_numpad_1,
    pinc_keyboard_key_numpad_2,
    pinc_keyboard_key_numpad_3,
    pinc_keyboard_key_numpad_4,
    pinc_keyboard_key_numpad_5,
    pinc_keyboard_key_numpad_6,
    pinc_keyboard_key_numpad_7,
    pinc_keyboard_key_numpad_8,
    pinc_keyboard_key_numpad_9,
    pinc_keyboard_key_numpad_dot,
    pinc_keyboard_key_numpad_slash,
    pinc_keyboard_key_numpad_asterisk,
    pinc_keyboard_key_numpad_dash,
    pinc_keyboard_key_numpad_plus,
    pinc_keyboard_key_numpad_enter,
    pinc_keyboard_key_numpad_equal,
    pinc_keyboard_key_left_shift,
    pinc_keyboard_key_left_control,
    pinc_keyboard_key_left_alt,
    /// @brief On many keyboards, this is a windows icon and is generally called "the windows button"
    pinc_keyboard_key_left_super,
    pinc_keyboard_key_right_shift,
    pinc_keyboard_key_right_control,
    pinc_keyboard_key_right_alt,
    /// @brief On many keyboards, this is a windows icon and is generally called "the windows button". Most keyboards only have the one on the left, not this one.
    pinc_keyboard_key_right_super,
    /// @brief On many keyboards, this is the button next to right control
    pinc_keyboard_key_menu,
    // Don't you just love C?
    pinc_keyboard_key_count,
};

/// @section initialization
// These are roughly in the order they should be called in a normal application

/// @brief preps pinc for initialization. This will ALWAYS be the first pinc function called, outside of utility functions.
/// Calling non-utility functions before this is undefined behavior, and will trigger asserts in debug mode.
PINC_API void PINC_CALL pinc_incomplete_init(void);

/// @brief Queries if a window backend is available.
/// @param backend the backend to query
/// @return 1 if the backend is supported, 0 if not.
PINC_API int PINC_CALL pinc_window_backend_is_supported(int backend);

/// @brief Sets the window backend to use. Once called, this cannot be called again as Pinc will fully initialize the backend.
/// Undefined if called after any function other than pinc_incomplete_init and pinc_window_backend_is_supported.
/// May create fatal errors
/// @param backend the backend to use. Undefined if pinc_window_backend_is_supported(backend) == 0.
PINC_API void PINC_CALL pinc_init_set_window_backend(int backend);

/// @brief Queries if a graphics backend is available.
/// @param backend the backend to query
/// @return 1 if the backend is supported, 0 if not.
PINC_API int PINC_CALL pinc_graphics_backend_is_supported(int backend);

/// May create fatal errors
PINC_API void PINC_CALL pinc_init_set_graphics_backend(int backend);

/// @brief returns the number of available framebuffer formats.
PINC_API int PINC_CALL pinc_framebuffer_format_get_num(void);

/// @brief this function does not trigger any errors, however it will return 0 if the input index is not a framebuffer. Undefined before pinc_init_set_graphics_api is called.
/// @param framebuffer_index the index of the framebuffer. starting at 0. The allowed range for this is from 0 to the output of pinc_framebuffer_format_get_num-1.
///                          Alternatively, -1 can be entered for the set framebuffer format. Note that this is undefined if a framebuffer format has not been determined.
/// @return the number of channels in the given framebuffer format. this will be 1 for value, 2 for value + alpha, 3 for color, 4 for color + alpha.
PINC_API int PINC_CALL pinc_framebuffer_format_get_channels(int framebuffer_index);

/// @brief Returns the number of bits in a framebuffer's channel. This function does not trigger any errors, however an invalid input will cause it to return 0. Undefined before pinc_init_set_graphics_api is called.
/// @param framebuffer_index the index of the framebuffer. starting at 0. The allowed range for this is from 0 to the output of pinc_framebuffer_format_get_num-1.
///                          Alternatively, -1 can be entered for the set framebuffer format. Note that this is undefined if a framebuffer format has not been determined.
/// @param channel the index of the channel within this framebuffer. Ranges from 0 to the output of pinc_framebuffer_format_get_channels(framebuffer_index)-1.
/// @return the number of bits in this color channel.
PINC_API int PINC_CALL pinc_framebuffer_format_get_bit_depth(int framebuffer_index, int channel);

/// @brief returns the number of bits in this framebuffer's depth buffer.
/// @param framebuffer_index the index of the framebuffer. starting at 0. The allowed range for this is from 0 to the output of pinc_framebuffer_format_get_num-1.
///                          Alternatively, -1 can be entered for the set framebuffer format. Note that this is undefined if a framebuffer format has not been determined.
/// @return 0 if there is no depth buffer, otherwise the number of bits in the depth buffer. Usually 24, sometimes 32.
PINC_API int PINC_CALL pinc_framebuffer_format_get_depth_buffer(int framebuffer_index);

/// @brief Sets the framebuffer to use. If an invalid framebuffer is given, it will trigger a non-fatal error and a default framebuffer.
/// May create fatal errors.
/// @param framebuffer_index the index of the framebuffer. starting at 0. The allowed range for this is from 0 to the output of pinc_framebuffer_format_get_num-1.
///                          Alternatively, -1 can be entered for the set framebuffer format. Note that this is undefined if a framebuffer format has not been determined.
PINC_API void PINC_CALL pinc_init_set_framebuffer_format(int framebuffer_index);

/// @brief Initializes Pinc fully. This can trigger fatal errors and non-fatal errors.
/// After calling this, pinc_init_* functions will do nothing.
PINC_API void PINC_CALL pinc_complete_init(void);

/// @brief Call this once you are completely done with Pinc. Pinc will automatically clean up most things (windows, framebuffers, etc)
/// Pinc will not initialize again. Pinc's lifetime should be inherently tied to your process. If you need to init pinc again, you'll have to spawn a separate process.
/// In the future, reinitializing pinc after deinit might (or might not) be supported.
PINC_API void PINC_CALL pinc_deinit(void);

/// @section errors
/// @brief Pinc errors are on a priority stack. Prioritizes fatal errors.
 
/// @return the number of errors in the error stack
PINC_API int PINC_CALL pinc_error_get_num(void);

PINC_API int PINC_CALL pinc_error_peek_type(void);

// 1 if fatal, 0 if non-fatal
PINC_API int PINC_CALL pinc_error_peek_fatal(void);

PINC_API int PINC_CALL pinc_error_peek_message_length(void);

PINC_API char PINC_CALL pinc_error_peek_message_byte(int index);

PINC_API void PINC_CALL pinc_error_pop(void);

/// @section platform

/// @brief get the window API being used, must be called after pinc_complete_init()
/// @return a value of enum pinc_window_api
PINC_API int PINC_CALL pinc_window_backend_get(void);

/// @section general management

/// @param id the Id of a pinc object handle
/// @return a value of enum pinc_object_type
PINC_API int PINC_CALL pinc_object_get_type(int id);

/// @param id the ID of a pinc object
/// @return 1 if the object is complete, 0 if it's not complete.
PINC_API int PINC_CALL pinc_object_get_complete(int id);

/// @section window management

PINC_API int PINC_CALL pinc_window_incomplete_create(void);

PINC_API void PINC_CALL pinc_window_complete(int window);

// window properties:
// ALL window properties have defaults so users can get up and running ASAP. However, many of those defaults cannot be determined until after some point.
// r -> can be read at any time. It has a default [default is in square brackets]
// rc -> can only be read after the default has been determined, so it needs a has_[property] function
// w -> can be set at any time
// r means it just has a get function, but rc properties have both a get and a has.
// - string title (rw)
//     - default is "Pinc window [window object id]"
// - int width (rcw)
//     - This is the size of the actual pixel buffer
//     - default is determined on completion
// - int height (rcw)
//     - This is the size of the actual pixel buffer
//     - default is determined on completion
// - float scale factor (rc)
//     - this is the system scale. For example, if the user wants everything to be 1.5x larger on screen, this is 1.5
//     - This is on the window so the user can, in theory, set a different scale for each window.
//     - This can be very dificult to obtain before a window is open on the desktop, and even then the system scale may not be set.
//     - If not set, you can probably assume 1.0
// - bool resizable (rw) [true]
// - bool minimized (rw) [false]
//     - when minimized, a window is in the system tray / app switcher / whatever, but is not open on the desktop
// - bool maximized (rw) [false]
//     - when maximized, the window's size is set to the largest it can get without covering elements of the desktop environment
// - bool fullscreen (rw) [false]
// - bool focused (rw) [false]
// - bool hidden (rw) [false]
//     - when hidden, a window cannot be seen anywhere to the user (at least not directly), but is still secretly open.

/// @brief Sets the length of a window's title and sets the title to all underscores
/// @param window the window whose title to set
/// @param len the new length for the title
PINC_API void PINC_CALL pinc_window_set_title_length(int window, int len);

// TODO: add way to check if utf8 is supported on a given plaform

/// @brief Sets a byte of a windows title. Generally, UTF8 is supported. On some platforms, only ASCII encoding is supported.
/// @param window the window whose title to change. May be a complete or incomplete window.
/// @param index the byte index into the string to change.
/// @param item the item to set.
PINC_API void PINC_CALL pinc_window_set_title_item(int window, int index, char item);

/// @brief Get the length of a windows title.
/// @param window the window whose title to query. May be a complete or incomplete window.
/// @return the length of the window title in bytes
PINC_API int PINC_CALL pinc_window_get_title_length(int window);

/// @brief Get a byte of a windows title.
/// @param window the window whose title to query. May be a complete or incomplete window.
/// @param index the index to query.
/// @return a byte of the window title.
PINC_API char PINC_CALL pinc_window_get_title_item(int window, int index);

/// @brief set the width of a window, in pixels.
/// @param window the window whose width to set. Asserts the object is valid, and is a window.
/// @param width the width to set.
PINC_API void PINC_CALL pinc_window_set_width(int window, int width);

/// @brief get the width of a window, in pixels
/// @param window the window whose width to get. Asserts the object is valid, is a window, and has its width set (see pinc_window_has_width)
/// @return the width of the window
PINC_API int PINC_CALL pinc_window_get_width(int window);

/// @brief get if a window has its width defined. A windows width will become defined either when completed, or when set using pinc_window_set_width
/// @param window the window. Asserts the object is valid, and is a window
/// @return 1 if the windows width is set, 0 if not.
PINC_API int PINC_CALL pinc_window_has_width(int window);

/// @brief set the height of a window, in pixels
/// @param window the window whose height to set. Asserts the object is valid, and is a window
/// @param height the heignt to set.
PINC_API void PINC_CALL pinc_window_set_height(int window, int height);

/// @brief get the height of a window, in pixels
/// @param window the window whose height to get. Asserts the object is valid, is a window, and has its height set (see pinc_window_has_height)
/// @return the height of the window
PINC_API int PINC_CALL pinc_window_get_height(int window);

/// @brief get if a window has its height defined. A windows height will become defined either when completed, or when set using pinc_window_set_height
/// @param window the window. Asserts the object is valid, and is a window
/// @return 1 if the windows height is set, 0 if not.
PINC_API int PINC_CALL pinc_window_has_height(int window);

/// @brief get the scale factor of a window. This is set by the user when they want to "zoom in" - a value of 1.5 should make everything appear 1.5x larger.
/// @param window the window. Asserts the object is valid, is a window, and has its scale factor set (see pinc_window_has_scale_factor)
/// @return the scale factor of this window.
PINC_API float PINC_CALL pinc_window_get_scale_factor(int window);

/// @brief get if a window has its scale factor defined. Whether this is true depends on the backend, whether the scale is set, and if the window is complete.
///        In general, it is safe to assume 1 unless it is set otherwise.
/// @param window the window. Asserts the object is valid, and is a window
/// @return 1 if the windows scale factor is set, 0 if not.
PINC_API int PINC_CALL pinc_window_has_scale_factor(int window);

/// @brief set if a window is resizable or not
/// @param window the window. Asserts the object is valid, is a window, has its width defined (see pinc_window_has_width), and has its height defined (see pinc_window_has_height)
/// @param resizable 1 if the window is resizable, 0 if not.
PINC_API void PINC_CALL pinc_window_set_resizable(int window, int resizable);

/// @brief get if a window is resizable or not
/// @param window the window. Asserts the object is valid, and is a window.
/// @return 1 if the window is resizable, 0 if not.
PINC_API int PINC_CALL pinc_window_get_resizable(int window);

/// @brief set if a window is minimized or not.
/// @param window the window. Asserts the object is valid, and is a window.
/// @param minimized 1 if the window is minimized, 0 if not
PINC_API void PINC_CALL pinc_window_set_minimized(int window, int minimized);

/// @brief get if a window is minimized or not.
/// @param window the window. Asserts the object is valid, and is a window.
/// @return 1 if the window is minimized, 0 if not
PINC_API int PINC_CALL pinc_window_get_minimized(int window);

/// @brief set if a window is maximized or not.
/// @param window the window. Asserts the object is valid, and is a window.
/// @param maximized 1 if the window is maximized, 0 if not
PINC_API void PINC_CALL pinc_window_set_maximized(int window, int maximized);

/// @brief get if a window is maximized or not.
/// @param window the window. Asserts the object is valid, and is a window.
/// @return 1 if the window is maximized, 0 if not
PINC_API int PINC_CALL pinc_window_get_maximized(int window);

/// @brief set if a window is fullscreen or not.
/// @param window the window. Asserts the object is valid, and is a window.
/// @param fullscreen 1 if the window is fullscreen, 0 if not
PINC_API void PINC_CALL pinc_window_set_fullscreen(int window, int fullscreen);

/// @brief get if a window is fullscreen or not.
/// @param window the window. Asserts the object is valid, and is a window.
/// @return 1 if the window is fullscreen, 0 if not
PINC_API int PINC_CALL pinc_window_get_fullscreen(int window);

/// @brief set if a window is focused or not.
/// @param window the window. Asserts the object is valid, and is a window.
/// @param focused 1 if the window is focused, 0 if not
PINC_API void PINC_CALL pinc_window_set_focused(int window, int focused);

/// @brief get if a window is focused or not.
/// @param window the window. Asserts the object is valid, and is a window.
/// @return 1 if the window is focused, 0 if not
PINC_API int PINC_CALL pinc_window_get_focused(int window);

/// @brief set if a window is hidden or not.
/// @param window the window. Asserts the object is valid, and is a window.
/// @param hidden 1 if the window is hidden, 0 if not
PINC_API void PINC_CALL pinc_window_set_hidden(int window, int hidden);

/// @brief get if a window is hidden or not.
/// @param window the window. Asserts the object is valid, and is a window.
/// @return 1 if the window is hidden, 0 if not
PINC_API int PINC_CALL pinc_window_get_hidden(int window);

/// @brief Present the framebuffer of a given window and prepares a backbuffer to draw on.
///        The number of backbuffers depends on the graphics backend, but it's generally 2 or 3.
/// @param window the window whose framebuffer to present.
/// @param vsync whether to sync with the monitor refresh or not.
PINC_API void PINC_CALL pinc_window_present_framebuffer(int window, int vsync);

/// @section user IO

// TODO: Clipboard

/// @brief Get the state of a mouse button
/// @param button the button to check. Generally, 0 is the left button, 1 is the right, and 2 is the middle
/// @return 1 if the button is pressed, 0 if it is not pressed OR if this application has no focused windows.
PINC_API int PINC_CALL pinc_mouse_button_get(int button);

/// @brief Get the state of a keyboard key.
/// @param button A value of pinc_keyboard_key to check
/// @return 1 if the key is pressed, 0 if it is not.
PINC_API int PINC_CALL pinc_keyboard_key_get(int button);

/// @brief Get the cursor X position relative to the window the cursor is currently in
/// @return the X position. 0 on the left to width-1 on the right.
PINC_API int PINC_CALL pinc_get_cursor_x(void);

/// @brief get the cursor Y position relative to the window the cursor is currently in
/// @return the X position. 0 on the top to height-1 on the bottom.
PINC_API int PINC_CALL pinc_get_cursor_y(void);

/// @section main loop & events

/// @brief Flushes internal buffers and collects user input
PINC_API void PINC_CALL pinc_step(void);

/// @brief Gets if a window was signalled to close during the last step.
/// @param window the window to query. Only accepts comple windows.
/// @return 1 if a window was signalled to close in the last step, 0 otherwise.
PINC_API int PINC_CALL pinc_event_window_closed(int window);

/// @brief Get if there was a mouse press/release from the last step
/// @param window The window to check - although all windows share the same cursor,
///     it is possible for multiple windows to be clicked in the same step.
/// @return 1 if there any mouse buttons were pressed or released, 0 otherwise.
PINC_API int PINC_CALL pinc_event_window_mouse_button(int window);

/// @brief Gets if a window was resized during the last step.
/// @param window the window to query. Only accepts complete windows.
/// @return 
PINC_API int PINC_CALL pinc_event_window_resized(int window);

/// @brief Gets if a window recieved input focus in the last step.
///        If a window lost and gained focus in the same step, it is safe to assume that window is not focused.
/// @param window the window to query. Only accepts complete windows.
/// @return 1 if the window was focused in the last step, 0 otherwise.
PINC_API int PINC_CALL pinc_event_window_focused(int window);

/// @brief gets if a window lost input focus in the last step, unless it regained focus in that same step.
/// @param window the window to query. Only accepts complete windows.
/// @return 1 if the window was focused in the last step, 0 otherwise.
PINC_API int PINC_CALL pinc_event_window_unfocused(int window);

/// @brief gets if a window should be redrawn from last step.
/// @param window the window to query. Only accepts complere windows.
/// @return 1 if the window should be redrawn this step, 0 otherwise.
PINC_API int PINC_CALL pinc_event_window_exposed(int window);

// Keyboard events require a window because it's possible for multiple windows to have key events in a single step

/// @brief Get the number of key presses/releases on a window during the last step
/// @param window the window to query. Only accepts complete windows.
/// @return the number of key events during last step
PINC_API int PINC_CALL pinc_event_window_keyboard_button_num(int window);

/// @brief Get a key whose state changed on a window since the last step.
/// @param window the window to query. Only complete windows are accepted.
/// @param index the index of the event to check. May range from 0 to the result of pinc_event_window_keyboard_button_num on this window.
/// @return which key was changed. A value of pinc_keyboard_key.
PINC_API int PINC_CALL pinc_event_window_keyboard_button_get(int window, int index);

/// @brief Get if a key whose state changed was a repeat
/// @param window the window to query. Only accepts complete windows.
/// @param index the index of the event to check. May range from 0 to the result of pinc_event_window_keyboard_button_num on this window.
/// @return 1 if this event was a key repeat, 0 if not.
PINC_API int PINC_CALL pinc_event_window_keyboard_button_get_repeat(int window, int index);

/// @brief Get if the cursor moved within a window during the last step.
///        Requires a window because it's possible for the cursor to move from one window to another window in a single step.
/// @param window the window to query. Only accepts complete windows.
/// @return 1 if the cursor moved in this window, 0 if not.
PINC_API int PINC_CALL pinc_event_window_cursor_move(int window);

/// @brief Get if the cursor has left a window during the last step.
/// @param window the window to query. Only accepts complete windows.
/// @return 1 if the cursor left the window, 0 if not.
PINC_API int PINC_CALL pinc_event_window_cursor_exit(int window);

/// @brief Get if the cursor has entered a window during the last step.
/// @param window the window to query. Only accepts complete windows.
/// @return 1 if the cursor entered the window, 0 if not.
PINC_API int PINC_CALL pinc_event_window_cursor_enter(int window);

/// @brief Get the number of bytes that were typed in a windpw during the last step.
/// @param window the window to query. Only accepts complete windows.
///               A window is required because it's possible that multiple windows were typed into in a single step.
/// @return the length of the text in bytes.
PINC_API int PINC_CALL pinc_event_window_text_len(int window);

/// @brief Get a byte of the text typed in a window during the last step. This is undefined if pinc_event_window_text_len(window)==0
/// @param window The window to query. Only accepts complete windows.
/// @param index The index to query. Accepts values between 0 and pinc_event_window_text_len(window)-1,
/// @return the byte. Text input is utf8 encoded, or ascii on platforms where unicode is not supported. It's safe to always assume utf8.
PINC_API char PINC_CALL pinc_event_window_text_item(int window, int index);

// TODO: doc
PINC_API float PINC_CALL pinc_event_window_scroll_vertical(int window);

// TODO: doc
PINC_API float PINC_CALL pinc_event_window_scroll_horizontal(int window);

/// @section graphics

// TODO: doc
PINC_API void PINC_CALL pinc_graphics_fill_color(int window, float c1, float c2, float c3, float c4);

// TODO: doc
PINC_API void PINC_CALL pinc_graphics_fill_depth(int window, float depth);

