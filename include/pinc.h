#pragma once
#include <stdint.h>
#include <stdbool.h>

// general functions and types

typedef enum {
    /// @brief Automatically choose a windowing API
    pinc_window_api_automatic,
    /// @brief X window system Xlib is loaded dynamically at runtime, to avoid a compile time dependency.
    pinc_window_api_x,
} pinc_window_api_t;

typedef enum {
    /// @brief Automatically choose a graphics API
    pinc_graphics_api_automatic,
    /// @brief OpenGL 2.1.
    pinc_graphics_api_opengl_2_1,
} pinc_graphics_api_t;

/// @brief Initializes Pinc. This loads required system libraries, and gets everything ready for using functionality.
/// @return true if success, false otherwise.
extern bool pinc_init(pinc_window_api_t window_api, pinc_graphics_api_t graphics_api);

typedef enum {
    /// @brief No error
    pinc_error_none = 0,
    /// @brief something went wrong, no idea what though
    pinc_error_some,
    /// @brief something went wrong at init.
    pinc_error_init,
    /// @brief The API the program asked for is not supported on this system
    pinc_error_unsupported_api,
    /// @brief A pinc function was given a null handle
    pinc_error_null_handle,
    /// @brief A memory allocation failed
    pinc_error_allocation,
} pinc_error_t;

/// @brief Get the most recent error.
extern pinc_error_t pinc_error_get(void);

/// @brief Get a message for the most recent error.
/// @return null terminated ascii string. Will never be null, but may have a length of zero.
extern const char* pinc_error_string(void);

/// @brief Returns the window api used by Pinc.
extern pinc_window_api_t pinc_get_window_api(void);

/// @brief A generic handle to a Pinc object. An id of 0 is equivalent to a null handle.
typedef uint32_t pinc_handle;

// Window and framebuffer types and functions

/// @brief A handle to a window that hasn't been finalized yet. All incomplete windows are also incomplete framebuffers, as a window contains a framebuffer.
typedef pinc_handle pinc_window_incomplete_handle_t;

/// @brief A handle to a window. All windows are also framebuffers.
typedef pinc_handle pinc_window_handle_t;

/// @brief An incomplete handle to something that can be drawn to. Includes incomplete windows.
typedef pinc_handle pinc_framebuffer_incomplete_handle_t;

/// @brief A handle to something that can be drawn to. Includes windows.
typedef pinc_handle pinc_framebuffer_handle_t;

/// @brief Creates a window. Only params of this function are required, all other window properties have default values.
/// @param title A null-terminated UTF8 string for the title of the window
/// @return a handle to the window - it is not done yet, call pinc_complete_window
extern pinc_window_incomplete_handle_t pinc_window_incomplete_create(char* title);

/// @brief Sets the size of a window in pixels. Note that the underlying system has ultimate control over the window size and this call may be ignored.
/// @param window the window to set the size of
/// @param width the width of the window. Enter 0 for an automatic value.
/// @param height the height of the window. Enter 0 for an automatic value.
extern void pinc_window_set_size(pinc_window_incomplete_handle_t window, uint16_t width, uint16_t height);

extern uint16_t pinc_window_get_width(pinc_window_incomplete_handle_t window);

extern uint16_t pinc_window_get_height(pinc_window_incomplete_handle_t window);

/// @brief Gets the scale of a window, in pixels per screen unit. A screen unit is defined separately from pixels on many platforms, such as MacOS.
/// @param window a window, complete or not
/// @return the scale factor of the given window, in pixels per screen unit.
extern float pinc_window_get_scale(pinc_window_incomplete_handle_t window);

/// @brief Returns the thickness of the top border / decoration of a window.
/// @param window a window, complete or not
/// @return the thickness of the windows top border, in screen units (NOT PIXELS!)
extern float pinc_window_get_top_border(pinc_window_incomplete_handle_t window);

/// @brief Returns the thickness of the left border / decoration of a window.
/// @param window a window, complete or not
/// @return the thickness of the windows left border, in screen units (NOT PIXELS!)
extern float pinc_window_get_left_border(pinc_window_incomplete_handle_t window);

/// @brief Returns the thickness of the right border / decoration of a window.
/// @param window a window, complete or not
/// @return the thickness of the windows right border, in screen units (NOT PIXELS!)
extern float pinc_window_get_right_border(pinc_window_incomplete_handle_t window);

/// @brief Returns the thickness of the bottom border / decoration of a window.
/// @param window a window, complete or not
/// @return the thickness of the windows bottom border, in screen units (NOT PIXELS!)
extern float pinc_window_get_bottom_border(pinc_window_incomplete_handle_t window);

/// @brief Gets the zoom factor of a window. Often, as an accessibility setting, users can scale things.
///        For example, a user with a high resolution but small screen may set the scale to 2, so everything is twice as large.
/// @param window a window, complete or not 
/// @return zoom level
extern float pinc_window_get_zoom(pinc_window_incomplete_handle_t window);

/// @brief Sets a window icon. Note that some platforms do not support this function for some abominable reason. The default icon is Pinc's logo.
/// @param window a window, incomplete or not
/// @param data Pixel data. Like in GLFW, the image data is 8 bits per channel little-endian RGBA.
///             The pixels are arranged starting at the top left, each row defined as left to right, each row stacked top to bottom.
/// @param size the size of each side the icon. Exactly 256 pixels is recomended.
extern void pinc_window_set_icon(pinc_window_incomplete_handle_t window, uint8_t* data, uint32_t size);


/// @brief Sets a window to be iconified / minimized
/// @param window a window, complete or not
/// @param minimized whether the window should be minimized or not. Default is false
extern void pinc_window_set_minimized(pinc_window_incomplete_handle_t window, bool minimized);    

extern bool pinc_window_get_minimized(pinc_window_incomplete_handle_t window);

/// @brief Sets if a window is resizable or not
/// @param window a window
/// @param resizable if the given window is resizable or not. Default is true.
extern void pinc_window_set_resizable(pinc_window_incomplete_handle_t window, bool resizable);

extern bool pinc_window_get_resizable(pinc_window_incomplete_handle_t window);

/// @brief Sets a window to be maximized. Not to be confused with fullscreen.
/// @param window a window, complete or not
/// @param maximized wheter the window is maximized or not. Default is false.
extern void pinc_window_set_maximized(pinc_window_incomplete_handle_t window, bool maximized);

extern bool pinc_window_get_maximized(pinc_window_incomplete_handle_t window);

/// @brief Sets a window to use fullscreen or not. Default is false.
/// @param window the window to set the parameter of. This accepts both complete and incomplete windows.
/// @param fullscreen whether the window os fullscreen or not. Default is false.
/// @param resize Whether the window is allowed to resize when set to fullscreen. In 99% of cases, this should be true
///               as some systems behave badly when the window resolution does not match the screen resolution.
extern void pinc_window_set_fullscreen(pinc_window_incomplete_handle_t window, bool fullscreen, bool resize);

/// @brief Gets if a window is fullscreen or not
/// @param window window, complete or not.
/// @return whether the window is fullscreen or not.
extern bool pinc_window_get_fullscreen(pinc_window_incomplete_handle_t window);

/// @brief Sets a window to be visible or hidden.
/// @param window The window to set the parameter of. This accepts both complete and incomplete windows.
/// @param visible whether the window is visible or not. The default is true.
extern void pinc_window_set_visible(pinc_window_incomplete_handle_t window, bool visible);

/// @brief Gets if a window is visible
/// @param window a window, complete or not.
/// @return true if the given window is visible
extern bool pinc_window_get_visible(pinc_window_incomplete_handle_t window);

/// @brief Sets a window to have transparency or not. If enabled and supported, the framebuffer's alpha value will be used to blend between this window and anything behind it.
/// @param window the window to set the parameter of. Accepts both complete and incomplete windows.
/// @param blend whether to blend or not. The default is false.
extern void pinc_window_set_transparency(pinc_window_incomplete_handle_t window, bool blend);

/// @brief Gets if a window supports transparency
/// @param window a window
/// @return whether the given window's alpha channel will be used to blend with anything behind it.
extern bool pinc_window_get_transparency(pinc_window_incomplete_handle_t window);

/// @brief Attempts to set the number of bits for the red channel for the windows framebuffer. Returns false if the bit depth is unsupported.
///        Note that some platforms may treat each channel differently, but they will always be roughly the same. (+- 1 bit, maybe 2 or 3 bits in certain edge cases)
/// @param window the INCOMPLETE window.
/// @param red_bits the number of bits for the red channel
/// @return whether that bit depth is actually supported
extern bool pinc_window_set_red_bits(pinc_window_incomplete_handle_t window, uint16_t red_bits);

extern uint16_t pinc_window_get_red_bits(pinc_window_incomplete_handle_t window);

/// @brief Attempts to set the number of bits for the green channel for the windows framebuffer. Returns false if the bit depth is unsupported.
///        Note that some platforms may treat each channel differently, but they will always be roughly the same. (+- 1 bit, maybe 2 or 3 bits in certain edge cases)
/// @param window the INCOMPLETE window.
/// @param green_bits the number of bits for the green channel
/// @return whether that bit depth is actually supported
extern bool pinc_window_set_green_bits(pinc_window_incomplete_handle_t window, uint16_t green_bits);

extern uint16_t pinc_window_get_green_bits(pinc_window_incomplete_handle_t window);

/// @brief Attempts to set the number of bits for the blue channel for the windows framebuffer. Returns false if the bit depth is unsupported.
///        Note that some platforms may treat each channel differently, but they will always be roughly the same. (+- 1 bit, maybe 2 or 3 bits in certain edge cases)
/// @param window the INCOMPLETE window.
/// @param blue_bits the number of bits for the blue channel
/// @return whether that bit depth is actually supported
extern bool pinc_window_set_blue_bits(pinc_window_incomplete_handle_t window, uint16_t blue_bits);

extern uint16_t pinc_window_get_blue_bits(pinc_window_incomplete_handle_t window);

/// @brief Attempts to set the number of bits for the alpha channel for the windows framebuffer. Returns false if the bit depth is unsupported.
///        Note that some platforms may treat each channel differently, but they will always be roughly the same. (+- 1 bit, maybe 2 or 3 bits in certain edge cases)
/// @param window the INCOMPLETE window.
/// @param alpha_bits the number of bits for the alpha channel
/// @return whether that bit depth is actually supported
extern bool pinc_window_set_alpha_bits(pinc_window_incomplete_handle_t window, uint16_t alpha_bits);

extern uint16_t pinc_window_get_alpha_bits(pinc_window_incomplete_handle_t window);

/// @brief Attempts to set the number of bits for the depth buffer for the windows framebuffer. Returns false if the bit depth is unsupported.
/// @param window the INCOMPLETE window.
/// @param depth_bits the number of bits for the depbht buffer
/// @return whether that bit depth is actually supported
extern bool pinc_window_set_depth_bits(pinc_window_incomplete_handle_t window, uint16_t depth_bits);

extern uint16_t pinc_window_get_depth_bits(pinc_window_incomplete_handle_t window);

/// @brief Attempts to set the number of bits for the stencil buffer for the windows framebuffer. Returns false if the bit depth is unsupported.
/// @param window the INCOMPLETE window.
/// @param stencil_bits the number of bits for the stencil buffer
/// @return whether that bit depth is actually supported
extern bool pinc_window_set_stencil_bits(pinc_window_incomplete_handle_t window, uint16_t depth_bits);

extern uint16_t pinc_window_get_stencil_bits(pinc_window_incomplete_handle_t window);

/// @brief Closes and frees a window.
/// @param window the window to free. Accepts both complete and incomplete windows.
extern void pinc_window_destroy(pinc_window_incomplete_handle_t window);

/// @brief Completes a window
/// @param incomplete the incomplete window.
/// @return the newly completed window - the handle is guaranteed to be the same, however this will be 0 if an error occured.
extern pinc_window_handle_t pinc_window_complete(pinc_window_incomplete_handle_t incomplete);

/// @brief Gets if a window is the focused window or not
/// @param window a window
/// @return if the given window is the current focused window.
extern bool pinc_window_get_focused(pinc_window_handle_t window);

/// @brief Notifies the user that this window is "ready".
/// @param window a window
extern void pinc_window_request_attention(pinc_window_handle_t window);

/// @brief Closes a window. Once a window is closed, it must never be referenced again.
extern void pinc_window_close(pinc_window_handle_t window);

// Types and functions for events

/// @brief Event type enum. Enum values that are lower will (generally) appear first in the event buffer. In the source file, they are separated into sections.
typedef enum {
    /// @brief There is no event in the buffer.
    pinc_event_none,
    // Section for top priority

    /// @brief triggered when a window is resized. On windows, this is only triggered once per resize, but on other platforms this may be called every frame as the window is resized.
    pinc_event_window_resize,
    /// @brief triggered when a window gains focus. Window focus events only occur once per frame
    pinc_event_window_focus,
    /// @brief triggered when a window looses focus. Window focus events only occur once per frame
    pinc_event_window_unfocus,
    // section for second priority

    /// @brief triggered when a window needs to be redrawn. Note that many systems store the window surface internally, and thus only call this when resizing the window.
    ///        Only triggered once per window per call to poll_events or wait_event at most.
    pinc_event_window_damaged,
    // section for tertiary priority

    /// @brief triggered when a key is pressed down
    pinc_event_window_key_down,
    /// @brief triggered when a key is released up
    pinc_event_window_key_up,
    /// @brief triggered when a key repeats
    pinc_event_window_key_repeat,
    /// @brief triggered when the system's text input enters a unicode character.
    pinc_event_window_text,
    // section for 4th priority

    /// @brief triggered when the mouse cursor moves.
    ///        Only triggered once per window per call to poll_events or wait_event at most.
    pinc_event_window_cursor_move,
    /// @brief triggered when the mouse cursor enters a window
    ///        Only triggered once per window per call to poll_events or wait_event at most.
    pinc_event_window_cursor_enter,
    /// @brief triggered when the mouse cursor exits a window
    ///        Only triggered once per window per call to poll_events or wait_event at most.
    pinc_event_window_cursor_exit,
    /// @brief triggered when a mouse button is pressed down
    pinc_event_window_cursor_button_down,
    /// @brief triggered when a mouse button is released up
    pinc_event_window_cursor_button_up,
    /// @brief triggered when scrolling. Only triggered once per call to poll_events or wait_event.
    pinc_event_window_scroll,
    // section for lowest priority.

    /// @brief triggered when a window is told to close. This is usually the X button in the corner. This event is always placed last in the event buffer.
    ///        Only triggered once per window per call to poll_events or wait_event at most.
    pinc_event_window_close,
} pinc_event_type_t;

// General event functions

/// @brief Pulls events for all windows into an internal buffer. Does not block. This merges all events for the entire frame.
/// Events that were not processed from the last call are incorperated into the new buffer, and properly sorted accordingly.
extern void pinc_poll_events(void);

/// @brief Moves to the next event.
extern void pinc_advance_event(void);

/// @brief Waits for events. Does not block if the event buffer contains events to be processed.
///        Note that using this function still requires calling advance event. The timeout is in seconds, use Infinity, NaN, or 0 for an infinite timeout.
///        This is logically equivalent calling poll_events and event_type in a loop until event_type != none, implemented more efficiently.
extern void pinc_wait_events(float timeout);

/// @brief Gets the type of the current event
extern pinc_event_type_t pinc_event_type(void);

// alternates between type and function for each type of event.

/// @brief Data for window close event
typedef struct {
    /// @brief The window that was told to close.
    pinc_window_handle_t window;
} pinc_event_window_close_t;

/// @brief Gets the current window close event. Undefined if the current event is not a window close event. 
extern pinc_event_window_close_t pinc_event_window_close_data(void);

/// @brief Data for window resize event
typedef struct {
    /// @brief the window that was resized
    pinc_window_handle_t window;
    /// @brief The new width of the window, in pixels
    uint32_t width;
    /// @brief The new height of the window, in pixels
    uint32_t height;
} pinc_event_window_resize_t;

/// @brief Gets the current window resize event. Undefined if the current event is not a window resize event. 
extern pinc_event_window_resize_t pinc_event_window_resize_data(void);

/// @brief Focus event data
typedef struct {
    pinc_window_handle_t window;
} pinc_event_window_focus_t;

/// @brief Gets the current pinc_event_window_focus_t. Undefined if the current event is not a pinc_event_window_focus_t. 
extern pinc_event_window_focus_t pinc_event_window_focus_data(void);

/// @brief Unfocus event data
typedef struct {
    pinc_window_handle_t window;
} pinc_event_window_unfocus_t;

/// @brief Gets the current pinc_event_window_unfocus_t. Undefined if the current event is not a pinc_event_window_unfocus_t. 
extern pinc_event_window_unfocus_t pinc_event_window_unfocus_data(void);

/// @brief Data for window damage event
typedef struct {
    /// @brief The window that should be redrawn
    pinc_window_handle_t window;
} pinc_event_window_damaged_t;

/// @brief Gets the current window damaged event. Undefined if the current event is not a window damaged event. 
extern pinc_event_window_damaged_t pinc_event_window_damaged_data(void);

/// @brief Enumeration of Pinc key codes. They are basically just copied from GLFW, which means they (more or less) map to ASCII codes.
typedef enum {
    pinc_key_code_unknown = -1,
    pinc_key_code_space = 32,
    pinc_key_code_apostrophe = 39,
    pinc_key_code_comma = 44,
    pinc_key_code_dash,
    pinc_key_code_dot,
    pinc_key_code_slash,
    pinc_key_code_0,
    pinc_key_code_1,
    pinc_key_code_2,
    pinc_key_code_3,
    pinc_key_code_4,
    pinc_key_code_5,
    pinc_key_code_6,
    pinc_key_code_7,
    pinc_key_code_8,
    pinc_key_code_9,
    pinc_key_code_semicolon = 59,
    pinc_key_code_equals = 61,
    pinc_key_code_a = 65,
    pinc_key_code_b,
    pinc_key_code_c,
    pinc_key_code_d,
    pinc_key_code_e,
    pinc_key_code_f,
    pinc_key_code_g,
    pinc_key_code_h,
    pinc_key_code_i,
    pinc_key_code_j,
    pinc_key_code_k,
    pinc_key_code_l,
    pinc_key_code_m,
    pinc_key_code_n,
    pinc_key_code_o,
    pinc_key_code_p,
    pinc_key_code_q,
    pinc_key_code_r,
    pinc_key_code_s,
    pinc_key_code_T,
    pinc_key_code_u,
    pinc_key_code_v,
    pinc_key_code_w,
    pinc_key_code_x,
    pinc_key_code_y,
    pinc_key_code_z,
    pinc_key_code_left_bracket,
    pinc_key_code_backslash,
    pinc_key_code_right_bracket,
    /// @brief The ` character. The ~` button on US keyboards.
    pinc_key_code_backtick = 96, 
    // TODO: what are GLFW_WORLD_1 and GLFW_WORLD_2
    pinc_key_code_escape = 256,
    pinc_key_code_enter,
    pinc_key_code_tab,
    pinc_key_code_backspace,
    pinc_key_code_insert,
    pinc_key_code_delete,
    pinc_key_code_right,
    pinc_key_code_left,
    pinc_key_code_down,
    pinc_key_code_up,
    pinc_key_code_page_up,
    pinc_key_code_page_down,
    pinc_key_code_home,
    pinc_key_code_end,
    pinc_key_code_caps_lock,
    pinc_key_code_scroll_lock,
    pinc_key_code_num_lock,
    pinc_key_code_print_screen,
    pinc_key_code_pause,
    pinc_key_code_f1 = 290,
    pinc_key_code_f2,
    pinc_key_code_f3,
    pinc_key_code_f4,
    pinc_key_code_f5,
    pinc_key_code_f6,
    pinc_key_code_f7,
    pinc_key_code_f8,
    pinc_key_code_f9,
    pinc_key_code_f10,
    pinc_key_code_f11,
    pinc_key_code_f12,
    pinc_key_code_f13,
    pinc_key_code_f14,
    pinc_key_code_f15,
    pinc_key_code_f16,
    pinc_key_code_f17,
    pinc_key_code_f18,
    pinc_key_code_f19,
    pinc_key_code_f20,
    pinc_key_code_f21,
    pinc_key_code_f22,
    pinc_key_code_f23,
    pinc_key_code_f24,
    // Note: I don't think any actual systems have support for function keys beyond 24.
    pinc_key_code_f25,
    pinc_key_code_f26,
    pinc_key_code_f27,
    pinc_key_code_f28,
    pinc_key_code_f29,
    pinc_key_code_f30,
    pinc_key_code_numpad_0,
    pinc_key_code_numpad_1,
    pinc_key_code_numpad_2,
    pinc_key_code_numpad_3,
    pinc_key_code_numpad_4,
    pinc_key_code_numpad_5,
    pinc_key_code_numpad_6,
    pinc_key_code_numpad_7,
    pinc_key_code_numpad_8,
    pinc_key_code_numpad_9,
    pinc_key_code_numpad_dot,
    pinc_key_code_numpad_slash,
    pinc_key_code_numpad_asterisk,
    pinc_key_code_numpad_dash,
    pinc_key_code_numpad_plus,
    pinc_key_code_numpad_enter,
    pinc_key_code_numpad_equal,
    pinc_key_code_left_shift,
    pinc_key_code_left_control,
    pinc_key_code_left_alt,
    /// @brief On many keyboards, this is a windows icon and is generally called "the windows button"
    pinc_key_code_left_super,
    pinc_key_code_right_shift,
    pinc_key_code_right_control,
    pinc_key_code_right_alt,
    /// @brief On many keyboards, this is a windows icon and is generally called "the windows button". Most keyboards only have the one on the left, not this one.
    pinc_key_code_right_super,
    /// @brief On many keyboards, this is the button next to right control
    pinc_key_code_menu,
    // Don't you just love C?
    pinc_key_code_count,
} pinc_key_code_t;

/// @brief Key modifiers are a bitfield, however those may have strange ABI differences so it's represented the "raw" way
typedef uint32_t pinc_key_modifiers_t;
#define pinc_shift_bit 0x1
#define pinc_control_bit 0x2
#define pinc_alt_bit 0x4
#define pinc_super_bit 0x8
#define pinc_caps_lock_bit 0x10
#define pinc_num_lock_bit 0x20

/// @brief Data for window key down event
typedef struct {
    /// @brief The window that the key was pressed on
    pinc_window_handle_t window;
    /// @brief Cross platform key code
    pinc_key_code_t key;
    /// @brief Platform specific key code. This depends on the users keyboard layout, language, and platform.
    uint32_t token;
    pinc_key_modifiers_t modifiers;
} pinc_event_window_key_down_t;

/// @brief Gets the current window key down event. Undefined if the current event is not a window key down event.
extern pinc_event_window_key_down_t pinc_event_window_key_down_data(void);

/// @brief Data for window key up event
typedef struct {
    /// @brief The window that the key was released on
    pinc_window_handle_t window;
    /// @brief Cross platform key code
    pinc_key_code_t key;
    /// @brief Platform specific key code. This depends on the users keyboard layout, language, and platform.
    uint32_t token;
    pinc_key_modifiers_t modifiers;
} pinc_event_window_key_up_t;

/// @brief Gets the current window key up event. Undefined if the current event is not a windowkey up event.
extern pinc_event_window_key_up_t pinc_event_window_key_up_data(void);


/// @brief Data for window key repeat event
typedef struct {
    /// @brief The window that the key was repeated on
    pinc_window_handle_t window;
    /// @brief Cross platform key code
    pinc_key_code_t key;
    /// @brief Platform specific key code. This depends on the users keyboard layout, language, and platform.
    uint32_t token;
    pinc_key_modifiers_t modifiers;
} pinc_event_window_key_repeat_t;

/// @brief Gets the current window key repeat event. Undefined if the current event is not a window key repeat event.
extern pinc_event_window_key_repeat_t pinc_event_window_key_repeat_data(void);

/// @brief Data for window text event
typedef struct {
    /// @brief The window that was typed into
    pinc_window_handle_t window;
    /// @brief Unicode codepoint that was entered.
    uint32_t codepoint;
} pinc_event_window_text_t;

/// @brief Gets the current window key text event. Undefined if the current event is not a window key text event.
extern pinc_event_window_text_t pinc_event_window_text_data(void);

typedef struct {
    pinc_window_handle_t window;
    /// @brief X coordinate in screen coordinates
    float x_screen;
    /// @brief Y coordinate in screen coordinates
    float y_screen;
    /// @brief Change of the X coordinate in screen coordinates since last event poll
    float delta_x_screen;
    /// @brief Change of the Y coordinate in screen coordinates since last event poll
    float delta_y_screen;
    /// @brief X coordinate in pixels
    int32_t x_pixels;
    /// @brief Y coordinate in pixels
    int32_t y_pixels;
    /// @brief Change of the X coordinate in pixels since last event poll
    int32_t delta_x_pixels;
    /// @brief Change of the Y coordinate in pixels since last event poll
    int32_t delta_y_pixels;
} pinc_event_window_cursor_move_t;

/// @brief Gets the current window cursor move event. Undefined if the current event is not a window cursor move event.
extern pinc_event_window_cursor_move_t pinc_event_window_cursor_move_data(void);

/// @brief Data for pinc_event_window_cursor_enter
typedef struct {
    /// @brief The window that the cursor entered
    pinc_window_handle_t window;
} pinc_event_window_cursor_enter_t;

/// @brief Gets the current pinc_event_window_cursor_enter. Undefined if the current event is not pinc_event_window_cursor_enter
extern pinc_event_window_cursor_enter_t pinc_event_window_cursor_enter_data(void);

/// @brief Data for pinc_event_window_cursor_exit
typedef struct {
    /// @brief The window that the cursor exited
    pinc_window_handle_t window;
} pinc_event_window_cursor_exit_t;

/// @brief Gets the current pinc_event_window_cursor_exit. Undefined if the current event is not pinc_event_window_cursor_exit
extern pinc_event_window_cursor_exit_t pinc_event_window_cursor_exit_data(void);

/// @brief Mouse buttons enum
typedef enum {
    pinc_cursor_button_left,
    pinc_cursor_button_right,
    pinc_cursor_button_middle,
    pinc_cursor_button_front,
    pinc_cursor_button_back,
    pinc_cursor_button_6,
    pinc_cursor_button_7,
    pinc_cursor_button_8,
} pinc_cursor_button_t;

/// @brief Data for pinc_event_window_cursor_button_down
typedef struct {
    pinc_window_handle_t window;
    pinc_cursor_button_t button;

} pinc_event_window_cursor_button_down_t;

/// @brief Gets the current pinc_event_window_cursor_button_down. Undefined if the current event is not pinc_event_window_cursor_button_down
extern pinc_event_window_cursor_button_down_t pinc_event_window_cursor_button_down_data(void);

/// @brief Data for pinc_event_window_cursor_button_up
typedef struct {
    pinc_window_handle_t window;
    pinc_cursor_button_t button;

} pinc_event_window_cursor_button_up_t;

/// @brief Gets the current pinc_event_window_cursor_button_up. Undefined if the current event is not pinc_event_window_cursor_button_up
extern pinc_event_window_cursor_button_up_t pinc_event_window_cursor_button_up_data(void);

typedef struct {
    pinc_window_handle_t window;
    float delta_x;
    float delta_y;
} pinc_event_window_scroll_t;

/// @brief Gets the current pinc_event_window_scroll. Undefined if the current event is not pinc_event_window_scroll
extern pinc_event_window_scroll_t pinc_event_window_scroll_data(void);

// Additional keyboard types and functions

/// @brief Get the name of a key
/// @return The name of the key. This returns null if the code is invalid.
extern const char* pinc_key_name(pinc_key_code_t code);

/// @brief Get the name of a platform specific key code. This depends on the users keyboard layout, language, and platform.
/// @return The name of the key token. This returns null if the token does not have a name
extern const char* pinc_key_token_name(uint32_t token);

// Additional cursor types and functions

typedef enum {
    /// @brief Normal cursor movement and visibility
    pinc_cursor_mode_normal,
    /// @brief Cursor is hidden and locked to a window. The position is undefined in this state, use movement deltas only
    pinc_cursor_mode_locked,
    /// @brief Cursor is hidden but free
    pinc_cursor_mode_hidden,
    /// @brief Cursor is still visible but captured. The position is undefined in this state, use movement deltas only
    pinc_cursor_mode_captured,
} pinc_cursor_mode_t;

/// @brief Sets the cursor mode
/// @param mode The mode to set to
/// @param window The window to use for the mode. This is ignored when setting to normal mode.
extern void pinc_set_cursor_mode(pinc_cursor_mode_t mode, pinc_window_handle_t window);

typedef enum {
    /// @brief The normal arrow cursor
    pinc_cursor_theme_image_arrow,
    /// @brief the I beam cursor for text inputs
    pinc_cursor_theme_image_I,
    pinc_cursor_theme_image_crosshair,
    /// @brief The pointing hand cursor
    pinc_cursor_theme_image_pointing,
    /// @brief Resize up / down
    pinc_cursor_theme_image_resize_1,
    /// @brief Resize left / right
    pinc_cursor_theme_image_resize_2,
    /// @brief Resize diagonally from the bottom left or top right
    pinc_cursor_theme_image_resize_3,
    /// @brief Resize diagonally from the top left or bottom right
    pinc_cursor_theme_image_resize_4,
    /// @brief Generic resize cursor. Generally represented by all of the resize images merged together.
    pinc_cursor_theme_image_resize,
    /// @brief Cursor for something being disallowed or disabled.
    pinc_cursor_theme_image_no,
} pinc_cursor_theme_image_t;

extern void pinc_set_cursor_theme_image(pinc_cursor_theme_image_t image, pinc_window_handle_t window);

/// @brief Sets the cursor image to a texture
/// @param window the window to set the cursor of
/// @param data cursor image, as described in set_icon
/// @param size the size of the image, in pixels. Generally 256 is a good value.
extern void pinc_set_cursor_image(pinc_window_handle_t window, uint8_t* data, uint32_t size);

// general IO functions

/// @brief Gets the clipboard string
/// @return the clipboard string. Its lifetime is at least as long as until the next call to Pinc, it is recomended to make a copy of it.
extern char* pinc_get_clipboard_string(void);

// Pinc functions that allow Pinc to be used like GLFW - in other words, use the graphics API directly
// These CANNOT be used alongisde graphics functions. Things WILL break if you do that!

/// @brief Set the OpenGL context to a framebuffer or window.
///        There is one OpenGL context for the entire application, unlike GLFW where the context is per window.
/// @param window The framebuffer whose framebuffer to draw to. Must be complete.
extern void pinc_graphics_opengl_set_framebuffer(pinc_framebuffer_handle_t framebuffer);

/// @brief Returns the pointer of an OpenGL function.
/// @param procname the name of the opengl function
/// @return a raw pointer to that function.
extern void* pinc_graphics_opengl_get_proc(const char* procname);

// pinc graphics functions

/// @brief Clears a given framebuffer to an RGB color. The color values range from 0 to 1.
/// @param framebuffer The framebuffer to clear. Must be complete
extern void pinc_graphics_clear_color(pinc_framebuffer_handle_t framebuffer, float r, float g, float b, float a);

/// @brief Presents a window framebuffer
/// @param window the window to swap the
/// @param vsync Whether to wait for vertical sync. Depending on the graphics driver & system, this may behave differently or be ignored.
extern void pinc_graphics_present_window(pinc_window_handle_t window, bool vsync);
