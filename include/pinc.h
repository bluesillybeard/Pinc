// pinc.h - Pinc's entire API.
// Pinc is designed to be extremely simple such that the entire API fits in a single easy to understand header
// Note that, at least for now, this header is entirely in regular C99.

// You'll notice, this header has no includes. Hooray for minimal dependencies!
// There are downsides to only using pure C with nothing else:
// - the sizes of types is completely and utterly undefined. An int could be 11 bits for all we know!
// - potential ABI mismatches (particularily on Linux where clang / gcc / whatever compiler might have subtle ABI differences)

// In general, here are the rules / properties of Pinc's api:
// - no unions or bit fields, as they tend to cause ABI problems
// - we assume floats are in the IEE754 format. There are some whack platforms where floats do not follow the IEE654 standard. Thankfully, Pinc does not support any of those
// - Pinc functions will never return a pointer, and they will never take a pointer.
//     - This is to make bindings to other languages as freakishly straightforward as possible.
//     - Lists are returned as iterators, and entered using a stream type system. Worse for performance, but it's probably negligible
//     - In the future, we might support faster versions of the stream-like functions for languages that can effectively take advantage of that.
// - no structs either, particularily for languages like python where a 'struct' doesn't actually exist
// - using only void, int, and float seems limiting... because it is

// error policy:
// - incorrect usage of Pinc's API will trigger an assert in debug builds (-Doptimize=Debug or -Doptimize=ReleaseSafe)
// - errors caused by Pinc will also trigger asserts,
//   but they will be clear about the fact that it's an error due to Pinc rather than the program.
// - errors that are not fatal will trigger an error that can be collected using pinc_error_* functions
// - errors that are caused by external factors and are fatal will trigger errors that can be collected using pinc_error_* functions.
//   Fatal errors will cause pinc to be in an invalid state, and any non-error collecting function call from then on will trigger an assert.
// - NOTE: you should really compile pinc with -Doptimize=ReleaseSafe. Only use ReleaseFast if you *really* need that bit of extra speed.

// The flow of your code should be like this:
// - call pinc_incomplete_init()
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
//     - windows - you know what a window is. It can be used as a texture, although that's generally a bad idea
// - main loop
//     - call pinc_step
//         - this will collect events, update window properties, clear arena allocators, etc.
//     - handle events
//     - draw stuff (pinc_graphics_*)
//     - present framebuffers (pinc_window_present_framebuffer)

/// @section initialization
// These are roughly in the order they should be called in a normal application

/// @brief preps pinc for initialization. This will ALWAYS be the first pinc function called, outside of utility functions.
/// Calling non-utility functions before this is undefined behavior, and will trigger asserts in debug mode.
void pinc_incomplete_init(void);

enum pinc_window_backend {
    /// @brief The backend is unknown / not in this enum
    pinc_window_backend_any,
    /// @brief Pinc is using X11
    pinc_window_backend_x11,
    /// @brief Pinc is using SDL2
    pinc_window_backend_sdl2,
};

/// @brief Queries if a window backend is available.
/// @param backend the backend to query
/// @return 1 if the backend is supported, 0 if not.
int pinc_window_backend_is_supported(int backend);

/// @brief Sets the window backend to use
/// Undefined if called after any function other than pinc_incomplete_init and pinc_window_backend_is_supported.
/// @param backend the backend to use. Undefined if pinc_window_backend_is_supported(backend) == 0.
void pinc_init_set_window_backend(int backend);

enum pinc_graphics_backend {
    /// @brief the graphics backend is unknown / not in this enum.
    /// When chosen as the graphics backend, pinc will use the "best" one for the platform / device
    pinc_graphics_backend_none,
    /// @brief just a plain pixel grid. No hardware acceleration, just a grid of pixels and grinding through pixel data on the CPU.
    pinc_graphics_backend_raw,
    /// @brief OpenGL 2.1
    pinc_graphics_backend_opengl_2_1,
};

/// @brief Queries if a graphics backend is available.
/// @param backend the backend to query
/// @return 1 if the backend is supported, 0 if not.
int pinc_graphics_backend_is_supported(int backend);

void pinc_init_set_graphics_backend(int backend);

/// @brief returns the number of available framebuffer formats.
int pinc_framebuffer_format_get_num(void);

/// @brief this function does not trigger any errors, however it will return 0 if the input index is not a framebuffer. Undefined before pinc_init_set_graphics_api is called.
/// @param framebuffer_index the index of the framebuffer. starting at 0. The allowed range for this is from 0 to the output of pinc_framebuffer_format_get_num-1.
///                          Alternatively, -1 can be entered for the set framebuffer format. Note that this is undefined if a framebuffer format has not been determined.
/// @return the number of channels in the given framebuffer format. this will be 1 for value, 2 for value + alpha, 3 for color, 4 for color + alpha.
int pinc_framebuffer_format_get_channels(int framebuffer_index);

/// @brief Returns the number of bits in a framebuffer's channel. This function does not trigger any errors, however an invalid input will cause it to return 0. Undefined before pinc_init_set_graphics_api is called.
/// @param framebuffer_index the index of the framebuffer. starting at 0. The allowed range for this is from 0 to the output of pinc_framebuffer_format_get_num-1.
///                          Alternatively, -1 can be entered for the set framebuffer format. Note that this is undefined if a framebuffer format has not been determined.
/// @param channel the index of the channel within this framebuffer. Ranges from 0 to the output of pinc_framebuffer_format_get_channels(framebuffer_index)-1.
/// @return the number of bits in this color channel.
int pinc_framebuffer_format_get_bit_depth(int framebuffer_index, int channel);

/// @param framebuffer_index the index of the framebuffer. starting at 0. The allowed range for this is from 0 to the output of pinc_framebuffer_format_get_num-1.
///                          Alternatively, -1 can be entered for the set framebuffer format. Note that this is undefined if a framebuffer format has not been determined.
/// @param channel the index of the channel within this framebuffer. Ranges from 0 to the output of pinc_framebuffer_format_get_channels(framebuffer_index)-1.
/// @return the range in a framebufer's channel. Black is always at 0 (although HDR formats may allow negative values), and white (ignoring HDR brighter-than-white values) is the output of this function.
int pinc_framebuffer_format_get_range(int framebuffer_index, int channel);

/// @brief returns the number of bits in this framebuffer's depth buffer.
/// @param framebuffer_index the index of the framebuffer. starting at 0. The allowed range for this is from 0 to the output of pinc_framebuffer_format_get_num-1.
///                          Alternatively, -1 can be entered for the set framebuffer format. Note that this is undefined if a framebuffer format has not been determined.
/// @return 0 if there is no depth buffer, otherwise the number of bits in the depth buffer. Usually 24, sometimes 32.
int pinc_framebuffer_format_get_depth_buffer(int framebuffer_index);

/// @brief Sets the framebuffer to use. If an invalid framebuffer is given, it will trigger a non-fatal error and a default framebuffer.
/// @param framebuffer_index the index of the framebuffer. starting at 0. The allowed range for this is from 0 to the output of pinc_framebuffer_format_get_num-1.
///                          Alternatively, -1 can be entered for the set framebuffer format. Note that this is undefined if a framebuffer format has not been determined.
void pinc_init_set_framebuffer_format(int framebuffer_index);

/// @brief Initializes Pinc fully. This can trigger fatal errors and non-fatal errors.
/// After calling this, pinc_init_* functions will do nothing.
void pinc_complete_init(void);

/// @brief Call this once you are completely done with Pinc. Pinc will automatically clean up most things (windows, framebuffers, etc)
/// Pinc will not initialize again. Pinc's lifetime should be inherently tied to your process. If you need to init pinc again, you'll have to spawn a separate process.
/// In the future, reinitializing pinc after deinit might (or might not) be supported.
void pinc_deinit(void);

/// @section errors
/// @brief Pinc errors are on a priority stack. Prioritizes fatal errors.
 
/// @return the number of errors in the error stack
int pinc_error_get_num(void);

enum pinc_error_type {
    /// @brief Error does not have a designated type.
    pinc_error_any,
    /// @brief A memory allocation failed
    pinc_error_allocation,
    // Errors that aren't here and why:
    // - wrong object type -> that is a programmer error, so it's an assert instead of an error
    // - attempt to set something that is cemented -> programmer error, its an assert
    // - calling pinc functions before its initialized -> programmer error = assert
    // - Pinc developers made a mistake and forgot something -> an error with Pinc itself, that's an assert
};

int pinc_error_peek_type(void);

// 1 if fatal, 0 if non-fatal
int pinc_error_peek_fatal(void);

int pinc_error_peek_message_length(void);

char pinc_error_peek_message_byte(int index);

void pinc_error_pop(void);

/// @section platform

/// @brief get the window API being used, must be called after pinc_complete_init()
/// @return a value of enum pinc_window_api
int pinc_window_backend_get(void);

/// @section general management

enum pinc_object_type {
    /// @brief the object is empty / invalid
    pinc_object_none,
    pinc_object_window,
};

/// @param id the Id of a pinc object handle
/// @return a value of enum pinc_object_type
int pinc_object_get_type(int id);

/// @param id the ID of a pinc object
/// @return 1 if the object is complete, 0 if it's not complete.
int pinc_object_get_complete(int id);

/// @section window management

int pinc_window_incomplete_create(void);

void pinc_window_complete(int window);

// window properties:
// ALL window properties have defaults so users can get up and running ASAP. However, many of those defaults cannot be determined until after some point.
// r -> can be read at any time. It has a default [default is in square brackets]
// rc -> can only be read after the default has been determined, so it needs a has_[property] function
// w -> can be set at any time
// r means it just has a get function, but rc properties have both a get and a has.
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

/// @brief set the width of a window, in pixels
/// @param window the window whose width to set. Asserts the object is valid, and is a window
/// @param width the width to set.
void pinc_window_set_width(int window, int width);

/// @brief get the width of a window, in pixels
/// @param window the window whose width to get. Asserts the object is valid, is a window, and has its width set (see pinc_window_has_width)
/// @return the width of the window
int pinc_window_get_width(int window);

/// @brief get if a window has its width defined. A windows width will become defined either when completed, or when set using pinc_window_set_width
/// @param window the window. Asserts the object is valid, and is a window
/// @return 1 if the windows width is set, 0 if not.
int pinc_window_has_width(int window);

/// @brief set the height of a window, in pixels
/// @param window the window whose height to set. Asserts the object is valid, and is a window
/// @param height the heignt to set.
void pinc_window_set_height(int window, int height);

/// @brief get the height of a window, in pixels
/// @param window the window whose height to get. Asserts the object is valid, is a window, and has its height set (see pinc_window_has_height)
/// @return the height of the window
int pinc_window_get_height(int window);

/// @brief get if a window has its height defined. A windows height will become defined either when completed, or when set using pinc_window_set_height
/// @param window the window. Asserts the object is valid, and is a window
/// @return 1 if the windows height is set, 0 if not.
int pinc_window_has_height(int window);

/// @brief get the scale factor of a window. This is set by the user when they want to "zoom in" - a value of 1.5 should make everything appear 1.5x larger.
/// @param window the window. Asserts the object is valid, is a window, and has its scale factor set (see pinc_window_has_scale_factor)
/// @return the scale factor of this window.
float pinc_window_get_scale_factor(int window);

/// @brief get if a window has its scale factor defined. Whether this is true depends on the backend, whether the scale is set, and if the window is complete.
///        In general, it is safe to assume 1 unless it is set otherwise.
/// @param window the window. Asserts the object is valid, and is a window
/// @return 1 if the windows scale factor is set, 0 if not.
int pinc_window_has_scale_factor(int window);

/// @brief set if a window is resizable or not
/// @param window the window. Asserts the object is valid, is a window, has its width defined (see pinc_window_has_width), and has its height defined (see pinc_window_has_height)
/// @param resizable 1 if the window is resizable, 0 if not.
void pinc_window_set_resizable(int window, int resizable);

/// @brief get if a window is resizable or not
/// @param window the window. Asserts the object is valid, and is a window.
/// @return 1 if the window is resizable, 0 if not.
int pinc_window_get_resizable(int window);

/// @brief set if a window is minimized or not.
/// @param window the window. Asserts the object is valid, and is a window.
/// @param minimized 1 if the window is minimized, 0 if not
void pinc_window_set_minimized(int window, int minimized);

/// @brief get if a window is minimized or not.
/// @param window the window. Asserts the object is valid, and is a window.
/// @return 1 if the window is minimized, 0 if not
int pinc_window_get_minimized(int window);

/// @brief set if a window is maximized or not.
/// @param window the window. Asserts the object is valid, and is a window.
/// @param maximized 1 if the window is maximized, 0 if not
void pinc_window_set_maximized(int window, int maximized);

/// @brief get if a window is maximized or not.
/// @param window the window. Asserts the object is valid, and is a window.
/// @return 1 if the window is maximized, 0 if not
int pinc_window_get_maximized(int window);

/// @brief set if a window is fullscreen or not.
/// @param window the window. Asserts the object is valid, and is a window.
/// @param fullscreen 1 if the window is fullscreen, 0 if not
void pinc_window_set_fullscreen(int window, int fullscreen);

/// @brief get if a window is fullscreen or not.
/// @param window the window. Asserts the object is valid, and is a window.
/// @return 1 if the window is fullscreen, 0 if not
int pinc_window_get_fullscreen(int window);

/// @brief set if a window is focused or not.
/// @param window the window. Asserts the object is valid, and is a window.
/// @param focused 1 if the window is focused, 0 if not
void pinc_window_set_focused(int window, int focused);

/// @brief get if a window is focused or not.
/// @param window the window. Asserts the object is valid, and is a window.
/// @return 1 if the window is focused, 0 if not
int pinc_window_get_focused(int window);

/// @brief set if a window is hidden or not.
/// @param window the window. Asserts the object is valid, and is a window.
/// @param hidden 1 if the window is hidden, 0 if not
void pinc_window_set_hidden(int window, int hidden);

/// @brief get if a window is hidden or not.
/// @param window the window. Asserts the object is valid, and is a window.
/// @return 1 if the window is hidden, 0 if not
int pinc_window_get_hidden(int window);

// TODO: doc
void pinc_window_present_framebuffer(int window, int vsync);

/// @section main loop & user IO / events

// TODO: doc
void pinc_step();

// TODO: doc
int pinc_window_event_closed(int window);

// TODO: the rest of the events / event-like things:
// - resize - size can already be retrieved, just need an event for it
// - focus
// - unfocus
// - damaged / exposed
// - key_down
// - key_up
// - key_repeat
// - text - just have the entire text over this frame in a buffer
// - cursor_move
// - cursor_enter
// - cursor_exit
// - cursor_button_down
// - cursor_button_up
// - scroll

/// @section graphics

// TODO: doc
void pinc_graphics_set_fill_color(int channel, int value);

// TODO: doc
void pinc_graphics_set_fill_depth(int value);

// TODO: doc
enum pinc_graphics_fill_flag {
    pinc_graphics_fill_flag_color = 1,
    pinc_graphics_fill_flag_depth = 2,
};

// TODO: doc
void pinc_graphics_fill(int framebuffer, int flags);


