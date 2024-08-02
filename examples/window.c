// This is a basic window example
#include <stdint.h>
#include <stdbool.h>
#include <pinc.h>
#include <stdio.h>
// I don't even know how it's physically possible for the modulus operator to be undefined for floats
#include <math.h>

// How does libc STILL not have a sleep function?
#ifdef _WIN32
#include <windows.h>
#else
#include <unistd.h>
#endif

int main(int argc, char** argv) {
    // Initialize Pinc
    if(!pinc_init(pinc_window_api_automatic, pinc_graphics_api_automatic)) {
        printf("Failed to initialize Pinc: %s\n", pinc_error_string());
        return 1;
    }
    // Before makine a window, print out the API we're going to use
    switch(pinc_get_window_api()) {
        case pinc_window_api_x:
            printf("Using X11\n");
            break;
        case pinc_window_api_win32:
            printf("Using win32\n");
            break;
        default:
            printf("Using unknown API");
    }
    // Create the incomplete window
    pinc_window_incomplete_handle_t incomplete_window = pinc_window_incomplete_create("Hello, I am a window!");
    // complete the window
    pinc_window_handle_t window = pinc_window_complete(incomplete_window);
    int frames = 0;
    bool running = true;
    while(running) {
        pinc_event_wait(1);
        do {
            // Get the current event
            pinc_event_type_enum event_type = pinc_event_type();
            switch (event_type)
            {
                case pinc_event_window_resize:
                {
                    pinc_event_window_resize_t ev = pinc_event_window_resize_data();
                    printf("window %i resized to (%i, %i)\n", ev.window, ev.width, ev.height);
                    break;
                }
                case pinc_event_window_focus:
                {
                    pinc_event_window_focus_t ev = pinc_event_window_focus_data();
                    printf("window %i focused\n", ev.window);
                    break;
                }
                case pinc_event_window_unfocus:
                {
                    pinc_event_window_unfocus_t ev = pinc_event_window_unfocus_data();
                    printf("Window %i UNfocused\n", ev.window);
                    break;
                }
                case pinc_event_window_damaged:
                {
                    pinc_event_window_damaged_t ev = pinc_event_window_damaged_data();
                    printf("Window %i damaged\n", ev.window);
                    break;
                }
                case pinc_event_window_key_down:
                {
                    pinc_event_window_key_down_t ev = pinc_event_window_key_down_data();
                    printf("Window %i key %s down\n", ev.window, pinc_util_key_name(ev.key));
                    if(ev.key == pinc_key_code_escape) {
                        running = false;
                    }
                    break;
                }
                case pinc_event_window_key_up:
                {
                    pinc_event_window_key_up_t ev = pinc_event_window_key_up_data();
                    printf("Window %i key %s up\n", ev.window, pinc_util_key_name(ev.key));
                    break;
                }
                case pinc_event_window_key_repeat:
                {
                    pinc_event_window_key_repeat_t ev = pinc_event_window_key_repeat_data();
                    printf("Window %i key %s repeat\n", ev.window, pinc_util_key_name(ev.key));
                    break;
                }
                case pinc_event_window_text:
                {
                    // Assuming stdout is UTF8
                    pinc_event_window_text_t ev = pinc_event_window_text_data();
                    char buf[5];
                    if(pinc_util_unicode_to_uft8(ev.codepoint, buf)) {
                        printf("Window %i text %s unicode %i\n", ev.window, buf, ev.codepoint);
                    } else {
                        printf("Window %i Recieved invalid unicode %i\n", ev.window, ev.codepoint);
                    }
                    break;
                }
                case pinc_event_window_cursor_move:
                {
                    pinc_event_window_cursor_move_t ev = pinc_event_window_cursor_move_data();
                    printf("Window %i cursor moved to (%i, %i)\n", ev.window, ev.x_pixels, ev.y_pixels);
                    break;
                }
                case pinc_event_window_cursor_enter:
                {
                    pinc_event_window_cursor_enter_t ev = pinc_event_window_cursor_enter_data();
                    printf("Window %i cursor enter\n", ev.window);
                    break;
                }
                case pinc_event_window_cursor_exit:
                {
                    pinc_event_window_cursor_exit_t ev = pinc_event_window_cursor_exit_data();
                    printf("Window %i cursor exit\n", ev.window);
                    break;
                }
                case pinc_event_window_cursor_button_down:
                {
                    pinc_event_window_cursor_button_down_t ev = pinc_event_window_cursor_button_down_data();
                    printf("Window %i button %i down\n", ev.window, ev.button);
                    break;
                }
                case pinc_event_window_cursor_button_up:
                {
                    pinc_event_window_cursor_button_up_t ev = pinc_event_window_cursor_button_up_data();
                    printf("Window %i button %i up\n", ev.window, ev.button);
                    break;
                }
                case pinc_event_window_scroll:
                {
                    pinc_event_window_scroll_t ev = pinc_event_window_scroll_data();
                    printf("Window %i scroll (%f, %f)\n", ev.window, ev.delta_x, ev.delta_y);
                    // Funny effect: when scrolling, resize the window according to the scroll
                    uint16_t oldWidth = pinc_window_get_width(window);
                    uint16_t oldHeight = pinc_window_get_height(window);

                    int newWidth = oldWidth + ev.delta_x * 10;
                    int newHeight = oldHeight + ev.delta_y * 10;
                    if((newWidth > 0) && (newHeight > 0)) {
                        if(pinc_window_set_size(window, newWidth, newHeight)){
                            printf("Resized window from (%i, %i) to (%i, %i)\n", oldWidth, oldHeight, newWidth, newHeight);
                        }
                    }
                    break;
                }
                case pinc_event_window_close:
                {
                    pinc_event_window_close_t ev = pinc_event_window_close_data();
                    printf("Window %i close\n", ev.window);
                    running = false;
                    break;
                }
                case pinc_event_none:
                {
                    // In theory, this event rarely / never happens with an event based main loop.
                    // in practice, since ANY native event can cause a pinc_wait_events to exit, 
                    // but some native events do not result in pinc events, this is triggered frequently.
                    // For example, the X window system sends cursor events when moving a window,
                    // but those cursor events do not result in a pinc event since they are not actually useful.
                    printf("Empty Event\n");
                    break;
                }
                default:
                    printf("Unknown event type %i\n", event_type);
                    break;
            }
            // Move to the next event
            pinc_event_advance();
            // If the next event is none, we are done iterating events
        } while(pinc_event_type() != pinc_event_none);
        // The G component makes the window fade from magenta to white as frames are rendered.
        // Since this window is event based, it creates an interesting effect where the window gets brighter as it is touched.
        float gComponent = fmod(frames / 100.0f, 1.0f);
        pinc_graphics_clear_color(window, 1, gComponent, 1, 1);
        pinc_graphics_present_window(window, false);
        ++frames;
    }
    pinc_window_destroy(window);
    pinc_destroy();
    // Plot twist: wait 2 seconds before actually exiting, so if the window didn't actually exit we can see that's the case
    #ifdef _WIN32
    Sleep(2000);
    #else
    sleep(2);
    #endif
    return 0;
}

