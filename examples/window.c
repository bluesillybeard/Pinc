// This is a basic window example

#include <stdint.h>
#include <stdbool.h>
#include <pinc.h>
#include <stdio.h>

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
    bool running = true;
    while(running) {
        pinc_poll_events();
        do {
            // Get the current event
            pinc_event_type_t event_type = pinc_event_type();
            switch (event_type)
            {
                case pinc_event_window_resize:
                    printf("resize event\n");
                    break;
                case pinc_event_window_damaged:
                    printf("damage event\n");
                    break;
                case pinc_event_window_key_down:
                    printf("key down\n");
                    break;
                case pinc_event_window_key_up:
                    printf("key up\n");
                    break;
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
        // No buffer swapping yet.
    }
    // TODO: actually dispose of things
    return 0;
}

