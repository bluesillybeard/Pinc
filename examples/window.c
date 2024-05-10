// This is a basic window example
#include <stdint.h>
#include <stdbool.h>
#include <pinc.h>
#include <stdio.h>
// I don't even know how it's physically possible for the modulus operator to be undefined for floats
#include <math.h>

int main(int argc, char** argv) {
    // Initialize Pinc
    if(!pinc_init(pinc_window_api_automatic, pinc_graphics_api_automatic)) {
        printf("Failed to initialize Pinc\n");
        return 1;
    }
    // Create the incomplete window
    pinc_window_incomplete_handle_t incomplete_window = pinc_window_incomplete_create("Hello, I am a window!");
    // complete the window
    pinc_window_handle_t window = pinc_window_complete(incomplete_window);
    int frames = 0;
    bool running = true;
    while(running) {
        pinc_wait_events(1);
        do {
            // Get the current event
            pinc_event_type_enum event_type = pinc_event_type();
            switch (event_type)
            {
                case pinc_event_window_resize:
                    printf("resize event\n");
                    break;
                case pinc_event_window_focus:
                    printf("focus event\n");
                    break;
                case pinc_event_window_unfocus:
                    printf("unfocus event\n");
                    break;
                case pinc_event_window_damaged:
                    printf("damage event\n");
                    break;
                case pinc_event_window_key_down:
                {
                    pinc_event_window_key_down_t key_down_data = pinc_event_window_key_down_data();
                    printf("key %s down\n", pinc_key_name(key_down_data.key));
                    break;
                }
                case pinc_event_window_key_up:
                {
                    pinc_event_window_key_up_t key_up_data = pinc_event_window_key_up_data();
                    printf("key %s up\n", pinc_key_name(key_up_data.key));
                    break;
                }
                case pinc_event_window_key_repeat:
                    printf("key repeat\n");
                    break;
                case pinc_event_window_text:
                    printf("text\n");
                    break;
                case pinc_event_window_cursor_move:
                    printf("cursor move\n");
                    break;
                case pinc_event_window_cursor_enter:
                    printf("cursor enter\n");
                    break;
                case pinc_event_window_cursor_exit:
                    printf("cursor exit\n");
                    break;
                case pinc_event_window_cursor_button_down:
                    printf("button down\n");
                    break;
                case pinc_event_window_cursor_button_up:
                    printf("button up\n");
                    break;
                case pinc_event_window_scroll:
                    printf("scroll\n");
                    break;
                case pinc_event_window_close:
                    printf("close\n");
                    running = false;
                    break;
                case pinc_event_none:
                    break;
                default:
                    printf("Unknown event type %i\n", event_type);
                    break;
            }
            // Move to the next event
            pinc_advance_event();
            // If the next event is none, we are done iterating events
        } while(pinc_event_type() != pinc_event_none);
        // The G component makes the window fade from magenta to white as frames are rendered.
        // Since this window is event based, it creates an interesting effect where the window gets brighter as it is touched.
        float gComponent = fmod(frames / 100.0f, 1.0f);
        pinc_graphics_clear_color(window, 1, gComponent, 1, 1);
        pinc_graphics_present_window(window, false);
        ++frames;
    }
    // TODO: actually dispose of things
    return 0;
}

