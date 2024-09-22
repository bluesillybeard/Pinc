// A minimal example of using Pinc to open a window and fill it with colors.

#include <pinc.h>
#include <stdio.h>

// color struct. Values range from 0 to 1.
typedef struct Color {
    float red;
    float green;
    float blue;
} Color;

// "why not average them"?
// Consider that blue appears darker than red, even at the same brightness. Color is flipping complicated.
// source: goodcalculators.com
float color_to_grayscale(Color col) {
    return col.red * 0.299 + col.green * 0.587 + col.blue * 0.144;
}

// forward declare
int collect_errors(void);

/// @brief You know what main is. At least, I hope you know what main is...
int main(int argc, char** argv) {
    pinc_incomplete_init();
    pinc_complete_init();
    // init may trigger fatal errors
    // If a fatal error occurs, any other calls to Pinc (other than deinit) will assert false.
    if(collect_errors()) {
        return 255;
    }
    // Now that pinc is initialized, let's open a window.
    int window = pinc_window_incomplete_create();
    pinc_window_complete(window);
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
    int num_channels = pinc_framebuffer_format_get_channels(-1);
    // Finally, we're in the main loop
    int running = 1;
    while(running) {
        pinc_step();
        if(pinc_event_window_closed(window)) {
            running = 0;
            break;
        }
        if(pinc_event_window_mouse_button(window)) {
            // When left click is pressed
            if(pinc_mouse_button_get(0)) {
                ++color;
                if(color >= num_colors) {
                    color = 0;
                }
                printf("Left click: Set color to %i\n", color);
            }
            // When right click is either pressed OR released, change the window color
            // To do that, keep track of what it was last time.
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
        switch(num_channels) {
            case 2:
                pinc_graphics_set_fill_color(1, 1);
                // fall through
            case 1:
                pinc_graphics_set_fill_color(0, color_to_grayscale(colors[color]));
                break;
            case 4:
                pinc_graphics_set_fill_color(3, 1);
                // fall through
            case 3:
                pinc_graphics_set_fill_color(0, colors[color].red);
                pinc_graphics_set_fill_color(1, colors[color].green);
                pinc_graphics_set_fill_color(2, colors[color].blue);
                break;
            default:
                // This should never happen
                return 255;
        }
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
            printf("Fatal pinc error: %s\n", buffer);
        } else {
            printf("pinc error: %s\n", buffer);
        }
        pinc_error_pop();
    }
    return had_fatal;
}
