// This is more of a unit test type thing rather than a real example.
// It will demonstrate use of all graphics features, however it is not meant as a demonstration.

// TODO: once Pinc can report back framebuffer color values, use that to actually create a pass/fail based on pixel values in the framebuffer.
// Probably need a margin for error as different backends may produce slightly different colors
// and we need to account for framebuffer channels and depth.

#include "graphics-test.h"

// include the examples into this unity build
#include "basic.h"
#include "align1.h"
#include "uniform.h"
#include "uniform2.h"
#include "allAttributes.h"

const Example examples[] = {
    {test_basic_start, test_basic_frame, test_basic_deinit, "basic", "A basic colored triangle"},
    {test_align1_start, test_align1_frame, test_align1_deinit, "align1", "A basic white triangle"},
    {test_uniform_start, test_uniform_frame, test_uniform_deinit, "uniform", "A color changing triangle"},
    {test_uniform2_start, test_uniform2_frame, test_uniform2_deinit, "uniform2", "A green triangle - will be red if something isn't correct"},
    {test_allAttributes_start, test_allAttributes_frame, test_allAttributes_deinit, "allAttributes", "A blue triangle - will be red if something isn't correct"}
};

// examples is a static array (not a pointer) so this trick will work
const int NUM_EXAMPLES = sizeof(examples) / sizeof(Example);

// implementations of functions in graphics-test.h
// Even though this is a unity build, we should still follow good C principles.

// lol idk what header this is in so yeah
// TODO: figure out what header this function is in
extern void exit(int);

void on_error_exit(void) {
    // put your debugger's breakpoint here
    printf("There was an error!\n\n\n");
    exit(1);
}

RealColor color_to_real(RGBAColor col, int channels) {
    RealColor ret = {};
    switch (channels)
    {
    case 2:
        ret.c2 = col.a;
        // flow through
    case 1:
        ret.c1 = col.r * 0.299 + col.g * 0.587 + col.b * 0.144;
        break;
    case 4:
        ret.c4 = col.a;
        // flow through
    case 3:
        ret.c1 = col.r;
        ret.c2 = col.g;
        ret.c3 = col.b;
        break;
    }
    return ret;
}

bool collect_errors(void) {
    bool had_fatal = false;
    int num_errors = pinc_error_get_num();
    for(int i=0; i<num_errors; ++i) {
        int fatal = pinc_error_peek_fatal();
        if(fatal) had_fatal = true;
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

int main(int argc, char** argv) {
    // We have no care about what window backend, graphics backend, or framebuffer format is used.
    // So, go through with the most basic init seqence
    pinc_incomplete_init();
    pinc_complete_init();
    if(collect_errors()){
        on_error_exit();
    }
    window = pinc_window_incomplete_create();
    pinc_window_complete(window);
    if(collect_errors()){
        on_error_exit();
    }
    // the most basic main loop - also slightly scuffed but it's fine
    int example = 0;
    frame = 0;
    examples[example].start();
    printf("Starting example %s: %s\n", examples[example].name, examples[example].description);
    bool running = true;
    while(running) {
        pinc_step();
        if(pinc_event_window_closed(window)) {
            examples[example].deinit();
            printf("Exiting example %s\n", examples[example].name);
            break;
            running = false;
        }
        int num_key_events = pinc_event_window_keyboard_button_num(window);
        for(int i=0; i<num_key_events; ++i) {
            if(pinc_event_window_keyboard_button_get(window, i) == pinc_keyboard_key_enter) {
                if(pinc_keyboard_key_get(pinc_keyboard_key_enter)) {
                    // Enter key was pressed, go to the next test
                    examples[example].deinit();
                    printf("Exiting example %s\n", examples[example].name);
                    example = (example + 1) % NUM_EXAMPLES;
                    frame = 0;
                    examples[example].start();
                    printf("Starting example %s: %s\n", examples[example].name, examples[example].description);
                }
            }
        }
        examples[example].frame();
        if(collect_errors()){
            on_error_exit();
        }
        pinc_window_present_framebuffer(window, 1);
        frame++;
    }
}
