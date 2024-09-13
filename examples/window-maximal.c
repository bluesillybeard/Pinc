// A demonstration of using Pinc to open a window and fill it with colors.
// This is like the window example, however it makes use of many optional features.

#include <pinc.h>
#include <stdio.h>
#include <string.h>

// color struct. Values range from 0 to 1.
typedef struct Color {
    float red;
    float green;
    float blue;
} Color;

// declare stuff
int collect_errors(void);

/// @brief You know what main is. At least, I hope you know what main is...
int main(int argc, char** argv) {
    pinc_incomplete_init();
    // The window backends we want to use
    const int supported_window_backends[2] = {
        // Prioritize using SDL2
        pinc_window_backend_sdl2,
        // If SDL2 isn't available, use whatever
        pinc_window_backend_any,
    };
    // Select a backend
    int window_backend_found = 0;
    for (int i=0; i<2; ++i) {
        int backend = supported_window_backends[i];
        if(pinc_window_backend_is_supported(backend)) {
            pinc_init_set_window_backend(backend);
            window_backend_found = 1;
            if(collect_errors()) {
                return 255;
            }
            break;
        }
    }
    if(!window_backend_found) {
        // This will actually never happen, but I probably should remind you that this is a demonstrative example, not an actual application.
        printf("Pinc window example: Could not find a window backend to use\n");
        return 255;
    }
    // Do the same thing with the graphics backends.
    const int supported_graphics_backends[2] = {
        // Prioritize using OpenGL 2.1
        pinc_graphics_backend_opengl_2_1,
        // No opengl, use whatever
        pinc_graphics_backend_none,
    };
    int graphics_backend_found = 0;
    for (int i=0; i<2; ++i) {
        int backend = supported_graphics_backends[i];
        if(pinc_graphics_backend_is_supported(backend)) {
            pinc_init_set_graphics_backend(backend);
            graphics_backend_found = 1;
            if(collect_errors()) {
                return 255;
            }
            break;
        }
    }
    if(!graphics_backend_found) {
        printf("Pinc window example: Could not find a graphics backend to use\n");
        return 255;
    }
    // Choose a framebuffer format
    // We will only allow RGB or RGBA framebuffers.
    int num_framebuffer_formats = pinc_framebuffer_format_get_num();
    if(num_framebuffer_formats == 0) {
        printf("Pinc window example: There are no framebuffer formats available!\n");
        return 255;
    }
    int best_framebuffer_format = 0;
    int best_framebuffer_format_channels = 0;
    int best_framebuffer_format_color_bits = 0;
    for(int i=0; i<num_framebuffer_formats; ++i) {
        int framebuffer_channels = pinc_framebuffer_format_get_channels(i);
        if(framebuffer_channels < 3) continue;
        int framebuffer_color_bits = pinc_framebuffer_format_get_bit_depth(i, 0) + pinc_framebuffer_format_get_bit_depth(i, 1) + pinc_framebuffer_format_get_bit_depth(i, 2);
        if(i == 0 || best_framebuffer_format_channels < 3 || best_framebuffer_format_color_bits < framebuffer_color_bits) {
            best_framebuffer_format = i;
            best_framebuffer_format_channels = framebuffer_channels;
            best_framebuffer_format_color_bits = framebuffer_color_bits;
        }
    }
    if(best_framebuffer_format_channels < 3) {
        printf("Pinc window example: There are no RGB or RGBA framebuffer formats available!\n");
        return 255;
    }
    int best_framebuffer_format_alpha_bits = 0;
    if(best_framebuffer_format_channels == 4) {
        best_framebuffer_format_alpha_bits = pinc_framebuffer_format_get_bit_depth(best_framebuffer_format, 3);
    }
    pinc_complete_init();
    // init may trigger fatal errors
    // If a fatal error occurs, any other calls to Pinc (other than deinit) will assert false.
    if(collect_errors()) {
        return 255;
    }
    // Now that pinc is initialized, let's open a window.
    int window = pinc_window_incomplete_create();
    // Setting all of these is optional, but set them anyway for demonstration
    char* title = "Pinc window TO THE MAX!";
    int len = strlen(title);
    // In the future, there will be a more ergonomic method to set the title of a window.
    // But for now this is the only way, as the pinc public API does not allow pointers for required functions
    pinc_window_set_title_length(window, len);
    for(int i=0; i<len; ++i) {
        pinc_window_set_title_item(window, i, title[i]);
    }
    pinc_window_set_width(window, 498);
    pinc_window_set_height(window, 700);
    pinc_window_set_resizable(window, 0);
    pinc_window_set_minimized(window, 1);
    pinc_window_set_maximized(window, 0);
    pinc_window_set_fullscreen(window, 0);
    pinc_window_set_focused(window, 1);
    pinc_window_set_hidden(window, 0);
    pinc_window_complete(window);
    // complete may trigger fatal errors
    if(collect_errors()) {
        return 255;
    }
    // List of colors for later
    int num_colors = 4;
    const Color colors[4] = {
        {0, 0, 0},
        {1, 0, 0},
        {0, 1, 0},
        {0, 0, 1}
    };
    int color = 0;
    // some more data used for later
    // Yes, we could just use best_framebuffer_format_channels,
    // but this is to demonstrate the ability to get framebuffer format info for the chosen framebuffer.
    int num_channels = pinc_framebuffer_format_get_channels(-1);
    if(num_channels < 3) {
        // Again, this should NEVER happen, but we check it anyway just to be safe.
        return 255;
    }
    // Pinc input colors expects integers, but we represent them in floats to make things simple.
    // To convert that, we need some information about how to do that, since we can't assume 8 bit channels.
    // TODO: pinc may support HDR in the future.
    // Also consider that there are formats where each channel is a different number of bits (source: https://www.khronos.org/opengl/wiki/Image_Format)
    // Floating point formats are handled by interanally mapping them as reasonably as possible to an integer format.
    // Pinc provides a nice function to retrieve that information
    int red_channel_range = pinc_framebuffer_format_get_range(-1, 0);
    int green_channel_range = pinc_framebuffer_format_get_range(-1, 1);
    int blue_channel_range = pinc_framebuffer_format_get_range(-1, 2);
    // Finally, we're in the main loop
    int running = 1;
    while(running) {
        pinc_step();
        if(pinc_window_event_closed(window)) {
            running = 0;
            break;
        }
        if(pinc_window_event_mouse_button(window)) {
            // When left click is pressed
            if(pinc_mouse_button_get(0)) {
                ++color;
                if(color >= num_colors) {
                    color = 0;
                }
                printf("Left click: Set color to %i\n", color);
            }
            // When right click is either pressed OR released, change the window color
            // Do do that, keep track of what it was last time.
            static int lastRightClickState = 0;
            if(pinc_mouse_button_get(1) != lastRightClickState) {
                lastRightClickState = pinc_mouse_button_get(1);
                --color;
                if(color < 0) {
                    color = num_colors-1;
                }
                printf("Right Click or Release: Set color to %i\n", color);
            }
        }
        // Set the fill color
        pinc_graphics_set_fill_color(0, colors[color].red * red_channel_range);
        pinc_graphics_set_fill_color(1, colors[color].green * green_channel_range);
        pinc_graphics_set_fill_color(2, colors[color].blue * blue_channel_range);
        // Pinc will automatically clamp values that are outside of the range.
        // so to get opaque, just input a massively huge number instead of dealing with the actual range
        if(num_channels == 4) pinc_graphics_set_fill_color(3, 1 >> 30);
        pinc_graphics_fill(window, pinc_graphics_fill_flag_color);
        pinc_window_present_framebuffer(window, 1);
        // It is good practice to collect errors after each frame
        if(collect_errors()) {
            return 255;
        }
    }
    // No need to clean up the window or anything, Pinc will do that automatically.
    pinc_deinit();
}

/// @brief Collects errors from Pinc and prints them out.
/// @return 1 if there was a fatal error, 0 if not.
int collect_errors(void) {
    int had_fatal = 0;
    int num_errors = pinc_error_get_num();
    for(int i=0; i<num_errors; ++i) {
        int fatal = pinc_error_peek_fatal();
        if(fatal) had_fatal = 1;
        char buffer[1024] = {0};
        int len = pinc_error_peek_message_length();
        if(len > 1023) len = 1023;
        for(int bi=0; bi<len; ++bi) {
            buffer[bi] = pinc_error_peek_message_byte(bi);
        }
        buffer[len] = 0; //Pinc does not give us a null byte, but printf needs it.
        if(fatal) {
            printf("Fatal pinc error: %s\n", &buffer);
        } else {
            printf("pinc error: %s\n", &buffer);
        }
        pinc_error_pop();
    }
    return had_fatal;
}
