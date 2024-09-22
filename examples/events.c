// A minimal example of using Pinc to open a window and fill it with colors.

#include <pinc.h>
#include <stdio.h>

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
    // Finally, we're in the main loop
    int running = 1;
    while(running) {
        pinc_step();
        if(pinc_event_window_closed(window)) {
            printf("Window closed\n");
            running = 0;
            break;
        }
        if(pinc_event_window_mouse_button(window)) {
            printf("Mouse button state changed:\n");
            printf("\tleft click: %i\n", pinc_mouse_button_get(0));
            printf("\tright click: %i\n", pinc_mouse_button_get(1));
            printf("\tmiddle click: %i\n", pinc_mouse_button_get(2));
            printf("\t'back' click: %i\n", pinc_mouse_button_get(3));
            printf("\t'front' click: %i\n", pinc_mouse_button_get(4));
            // There are theoretically 32 mouse buttons, but only the first 5 are meaningful.
            // print the 6th one anyway
            printf("\t6th click: %i\n", pinc_mouse_button_get(5));
        }
        if(pinc_event_window_resized(window)) {
            int width = pinc_window_get_width(window);
            int height = pinc_window_get_height(window);
            printf("Window was resized to %ix%i pixels", width, height);
            if(pinc_window_has_scale_factor(window)) {
                float scale = pinc_window_get_scale_factor(window);
                float realWidth = width * scale;
                float realHeight = height * scale;
                printf(", %fx%f 'real' screen units", realWidth, realHeight);
            }
            printf("\n");
        }
        if(pinc_event_window_focused(window)) {
            printf("Window gained focus\n");
        }
        if(pinc_event_window_unfocused(window)) {
            printf("Window lost focus\n");
        }
        if(pinc_event_window_exposed(window)) {
            printf("Window was exposed\n");
        }
        int numKeyChanges = pinc_event_window_keyboard_button_num(window);
        for(int eventIndex=0; eventIndex<numKeyChanges; ++eventIndex) {
            // TODO: key name
            int key = pinc_event_window_keyboard_button_get(window, eventIndex);
            printf("Key %i ", key);
            if(pinc_keyboard_key_get(key)) {
                if(pinc_event_window_keyboard_button_get_repeat(window, eventIndex)) {
                    printf("repeated\n");
                } else {
                    printf("down\n");
                }
            } else {
                printf("up\n");
            }
        }
        if(pinc_event_window_cursor_enter(window)) {
            printf("cursor entered\n");
        }
        if(pinc_event_window_cursor_move(window)) {
            // TODO: once the ability to get the movement of this specific window event is added, change this
            printf("cursor moved to (%i, %i)\n", pinc_get_cursor_x(), pinc_get_cursor_y());
        }
        if(pinc_event_window_cursor_exit(window)) {
            printf("cursor exited\n");
        }
        int textLen = pinc_event_window_text_len(window);
        if(textLen > 0) {
            printf("Text typed: \"");
            for(int textIndex=0; textIndex<textLen; ++textIndex) {
                printf("%c", pinc_event_window_text_item(window, textIndex));
            }
            printf("\"\n");
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
