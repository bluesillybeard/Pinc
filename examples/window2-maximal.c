// A demonstration of using Pinc to open a window and fill it with colors.

#include <pinc2.h>
#include <stdio.h>

/// @brief You know what main is. At least, I hope you know what main is...
int main(int argc, char** argv) {
    pinc_incomplete_init();
    // The window backends we want to use
    const int supported_window_backends[2] = {
        // Prioritize using SDL2
        pinc_window_backend_sdl2,
        // If SDL2 isn't available, use whatever.
        pinc_window_backend_any,
    };
    // Select a backend
    int window_backend_found = 0;
    for (int i=0; i<2; ++i) {
        int backend = supported_window_backends[i];
        if(pinc_window_backend_is_supported(backend)) {
            pinc_init_set_window_backend(backend);
            window_backend_found = 1;
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
    if(collect_errors()) {
        return 255;
    }
    // Now that pinc is initialized, let's open a window.
    int window = pinc_window_incomplete_create();
    // Setting all of these is optional, but set them anyway for demonstration
    pinc_window_set_width(window, 800);
    pinc_window_set_height(window, 600);
    // We actually don't want to be resizable
    pinc_window_set_resizable(window, 0);
    pinc_window_set_minimized(window, 0);
    pinc_window_set_maximized(window, 0);
    pinc_window_set_fullscreen(window, 0);
    // This isn't the default! So if you want a window to gain focus when openened, you'll have to do this.
    pinc_window_set_focused(window, 1);
    pinc_window_set_hidden(window, 0);
    pinc_window_complete(window);
    // complete may trigger fatal errors
    if(collect_errors()) {
        return 255;
    }
    // Finally, we're in the main loop
    int running = 1;
    while(running) {
        pinc_step();
        if(pinc_window_event_closed(window)) {
            running = 0;
            break;
        }
        // Set the fill color to opaque black
        pinc_graphics_set_fill_color(0, 0);
        pinc_graphics_set_fill_color(1, 0);
        pinc_graphics_set_fill_color(2, 0);
        if(best_framebuffer_format_channels == 4) pinc_graphics_set_fill_color(3, (1 << best_framebuffer_format_alpha_bits) - 1);
        pinc_graphics_fill(window, pinc_graphics_fill_flag_color);
        pinc_window_present_framebuffer(window, 1);
    }
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
