// This is more of a unit test type thing rather than a real example.
// It will demonstrate use of all graphics features, however it is not meant as a demonstration.

#include <pinc.h>
#include <pinc_graphics.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

// Start off with useful types and functions

typedef struct RGBAColor {
    float r;
    float g;
    float b;
    float a;
} RGBAColor;

typedef struct RealColor {
    float c1;
    float c2;
    float c3;
    float c4;
} RealColor;

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

typedef struct Example {
    void (* start)(void);
    void (* frame)(void);
    void (* deinit)(void);
    char* name;
    char* description;
} Example;


/// @brief Collects errors from Pinc and prints them out.
/// @return 1 if there was a fatal error, 0 if not.
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

void empty_function(void) {}

// lol idk what header this is in so yeah
// TODO: figure out what header this function is in
extern void exit(int);

void on_error_exit(void) {
    // put your debugger's breakpoint here
    printf("There was an error!\n\n\n");
    exit(1);
}

// declare this list so main can come first
// Defining it here would require all of the examples functions being declared first, which would be very tedious.
extern const Example examples[];
extern const int NUM_EXAMPLES;

// these are declared up here so all of the examples can use them

int window;

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
    }
}

// This first example is the same as graphics.c

int test_basic_pipeline;

int test_basic_vertex_array;

void test_basic_start(void) {
    // Create a vertex attributes object and fill out the information for it
    int vertexAttribs = pinc_graphics_vertex_attributes_create(2);
    // this is the position of the vertex
    pinc_graphics_vertex_attributes_set_item(vertexAttribs, 0, pinc_graphics_attribute_type_vec2, 0, 0);
    // this is the color of the vertex
    pinc_graphics_vertex_attributes_set_item(vertexAttribs, 1, pinc_graphics_attribute_type_vec4, 8, 0);
    // the is the stride of each vertex as a whole. A float is 4 bytes, there are 6 total floats in a vertex, 4 * 6 = 24
    // This assumes the alignment of this is valid
    pinc_graphics_vertex_attributes_set_stride(vertexAttribs, 24);

    // create a uniforms object
    // Even though there will be no uniforms, a uniforms object is still required
    int uniforms = pinc_graphics_uniforms_create(0);

    // TODO: once fixed-shading is available, use that instead for maximum compatibility

    // Make a shaders object with the code

    int shaders = pinc_graphics_shaders_create(pinc_graphics_shader_type_glsl);

    char* vertexShaderCode = "\
        #version 110\n\
        attribute vec2 pos;\n\
        attribute vec4 color;\n\
        varying vec4 _color;\n\
        void main() {\n\
            gl_Position = vec4(pos, 0, 1);\n\
            _color = color;\n\
        }\
    ";

    int vertexShaderCodeLen = strlen(vertexShaderCode);

    char* fragmentShaderCode = "\
        #version 110\n\
        varying vec4 _color;\n\
        void main() {\n\
            gl_FragColor = _color;\n\
        }\
    ";

    int fragmentShaderCodeLen = strlen(vertexShaderCode);

    pinc_graphics_shaders_glsl_vertex_set_len(shaders, vertexShaderCodeLen);
    for(int i=0; i<vertexShaderCodeLen; ++i) {
        pinc_graphics_shaders_glsl_vertex_set_item(shaders, i, vertexShaderCode[i]);
    }

    pinc_graphics_shaders_glsl_fragment_set_len(shaders, fragmentShaderCodeLen);
    for(int i=0; i<fragmentShaderCodeLen; ++i) {
        pinc_graphics_shaders_glsl_fragment_set_item(shaders, i, fragmentShaderCode[i]);
    }

    // Tell Pinc how to map an index into the vertex attributes object to an actual vertex input.
    // This can be done through layout locations (explicit binding) instead, however GLSL 1.10 does not have that feature.
    pinc_graphics_shaders_glsl_attribute_mapping_set_num(shaders, 2);
    // attribute 0 is pos
    pinc_graphics_shaders_glsl_attribute_mapping_set_item_length(shaders, 0, 3);
    pinc_graphics_shaders_glsl_attribute_mapping_set_item(shaders, 0, 0, 'p');
    pinc_graphics_shaders_glsl_attribute_mapping_set_item(shaders, 0, 1, 'o');
    pinc_graphics_shaders_glsl_attribute_mapping_set_item(shaders, 0, 2, 's');
    // attribute 1 is color
    pinc_graphics_shaders_glsl_attribute_mapping_set_item_length(shaders, 1, 5);
    pinc_graphics_shaders_glsl_attribute_mapping_set_item(shaders, 1, 0, 'c');
    pinc_graphics_shaders_glsl_attribute_mapping_set_item(shaders, 1, 1, 'o');
    pinc_graphics_shaders_glsl_attribute_mapping_set_item(shaders, 1, 2, 'l');
    pinc_graphics_shaders_glsl_attribute_mapping_set_item(shaders, 1, 3, 'o');
    pinc_graphics_shaders_glsl_attribute_mapping_set_item(shaders, 1, 4, 'r');

    // Create the pipeline object.
    // Pinc puts all of the vertex assemlbly, uniform inputs, shader code, and other rendering state into a single object
    // more like Vulkan than OpenGL.
    // Pipeline is given an array of triangles
    test_basic_pipeline = pinc_graphics_pipeline_incomplete_create(vertexAttribs, uniforms, shaders, pinc_graphics_vertex_assembly_array_triangles);

    pinc_graphics_pipeline_complete(test_basic_pipeline);

    if(collect_errors()){
        on_error_exit();
    }

    // A single triangle using the same vertex attributes as the pipeline expects
    test_basic_vertex_array = pinc_graphics_vertex_array_create(vertexAttribs, 3);

    if(collect_errors()){
        on_error_exit();
    }

    pinc_graphics_vertex_array_lock(test_basic_vertex_array);

    pinc_graphics_vertex_array_set_item_vec2(test_basic_vertex_array, 0, 0, -0.5, -0.5);
    pinc_graphics_vertex_array_set_item_vec4(test_basic_vertex_array, 0, 1, 1, 0, 0, 1);

    pinc_graphics_vertex_array_set_item_vec2(test_basic_vertex_array, 1, 0, 0.5, -0.5);
    pinc_graphics_vertex_array_set_item_vec4(test_basic_vertex_array, 1, 1, 0, 1, 0, 1);

    pinc_graphics_vertex_array_set_item_vec2(test_basic_vertex_array, 2, 0, 0, 0.5);
    pinc_graphics_vertex_array_set_item_vec4(test_basic_vertex_array, 2, 1, 0, 0, 1, 1);

    pinc_graphics_vertex_array_unlock(test_basic_vertex_array);

    // destroy the temporary objects

    pinc_graphics_shaders_deinit(shaders);
    pinc_graphics_uniforms_deinit(uniforms);
    pinc_graphics_vertex_attributes_deinit(vertexAttribs);
}

void test_basic_frame(void) {
    RGBAColor color = {0, 0, 0, 1};
    // graphics fill uses channels instead of rgba
    RealColor real_color = color_to_real(color, pinc_framebuffer_format_get_channels(-1));
    pinc_graphics_fill_color(window, real_color.c1, real_color.c2, real_color.c3, real_color.c4);
    pinc_graphics_draw(window, test_basic_pipeline, test_basic_vertex_array, 0);
    pinc_graphics_done();
}

void test_basic_deinit(void) {
    pinc_graphics_pipeline_deinit(test_basic_pipeline);
    pinc_graphics_vertex_array_deinit(test_basic_vertex_array);
}

// This second test exists

void test_green_frame(void) {
    RGBAColor color = {0, 1, 0, 1};
    // graphics fill uses channels instead of rgba
    RealColor real_color = color_to_real(color, pinc_framebuffer_format_get_channels(-1));
    pinc_graphics_fill_color(window, real_color.c1, real_color.c2, real_color.c3, real_color.c4);
}

// This third test is meant to test unusual alignments
// This one caught a surprising number of erorrs

int test_align1_pipeline;

int test_align1_vertex_array;

void test_align1_start(void) {
    int vec2align = pinc_graphics_vertex_attributes_type_align(pinc_graphics_attribute_type_vec2);
    int vec4align = pinc_graphics_vertex_attributes_type_align(pinc_graphics_attribute_type_vec4);
    int posoffset = vec2align;
    int vertexAttribs = pinc_graphics_vertex_attributes_create(1);
    pinc_graphics_vertex_attributes_set_item(vertexAttribs, 0, pinc_graphics_attribute_type_vec2, posoffset, 0);
    pinc_graphics_vertex_attributes_set_stride(vertexAttribs, posoffset + 8);
    int uniforms = pinc_graphics_uniforms_create(0);

    // TODO: once fixed-shading is available, use that instead for maximum compatibility

    // Make a shaders object with the code

    int shaders = pinc_graphics_shaders_create(pinc_graphics_shader_type_glsl);

    char* vertexShaderCode = "\
        #version 110\n\
        attribute vec2 pos;\n\
        void main() {\n\
            gl_Position = vec4(pos, 0, 1);\n\
        }\
    ";

    int vertexShaderCodeLen = strlen(vertexShaderCode);

    char* fragmentShaderCode = "\
        #version 110\n\
        void main() {\n\
            gl_FragColor = vec4(1, 1, 1, 1);\n\
        }\
    ";

    int fragmentShaderCodeLen = strlen(vertexShaderCode);

    pinc_graphics_shaders_glsl_vertex_set_len(shaders, vertexShaderCodeLen);
    for(int i=0; i<vertexShaderCodeLen; ++i) {
        pinc_graphics_shaders_glsl_vertex_set_item(shaders, i, vertexShaderCode[i]);
    }

    pinc_graphics_shaders_glsl_fragment_set_len(shaders, fragmentShaderCodeLen);
    for(int i=0; i<fragmentShaderCodeLen; ++i) {
        pinc_graphics_shaders_glsl_fragment_set_item(shaders, i, fragmentShaderCode[i]);
    }

    // Tell Pinc how to map an index into the vertex attributes object to an actual vertex input.
    // This can be done through layout locations (explicit binding) instead, however GLSL 1.10 does not have that feature.
    pinc_graphics_shaders_glsl_attribute_mapping_set_num(shaders, 1);
    // attribute 0 is pos
    pinc_graphics_shaders_glsl_attribute_mapping_set_item_length(shaders, 0, 3);
    pinc_graphics_shaders_glsl_attribute_mapping_set_item(shaders, 0, 0, 'p');
    pinc_graphics_shaders_glsl_attribute_mapping_set_item(shaders, 0, 1, 'o');
    pinc_graphics_shaders_glsl_attribute_mapping_set_item(shaders, 0, 2, 's');

    // Create the pipeline object.
    // Pinc puts all of the vertex assemlbly, uniform inputs, shader code, and other rendering state into a single object
    // more like Vulkan than OpenGL.
    // Pipeline is given an array of triangles
    test_align1_pipeline = pinc_graphics_pipeline_incomplete_create(vertexAttribs, uniforms, shaders, pinc_graphics_vertex_assembly_array_triangles);

    pinc_graphics_pipeline_complete(test_align1_pipeline);

    if(collect_errors()){
        on_error_exit();
    }

    // A single triangle using the same vertex attributes as the pipeline expects
    test_align1_vertex_array = pinc_graphics_vertex_array_create(vertexAttribs, 3);

    if(collect_errors()){
        on_error_exit();
    }

    pinc_graphics_vertex_array_lock(test_align1_vertex_array);
    pinc_graphics_vertex_array_set_item_vec2(test_align1_vertex_array, 0, 0, -0.5, -0.5);
    pinc_graphics_vertex_array_set_item_vec2(test_align1_vertex_array, 1, 0, 0.5, -0.5);
    pinc_graphics_vertex_array_set_item_vec2(test_align1_vertex_array, 2, 0, 0, 0.5);
    pinc_graphics_vertex_array_unlock(test_align1_vertex_array);

    // destroy the temporary objects

    pinc_graphics_shaders_deinit(shaders);
    pinc_graphics_uniforms_deinit(uniforms);
    pinc_graphics_vertex_attributes_deinit(vertexAttribs);
}

void test_align1_frame(void) {
    RGBAColor color = {0, 0, 0, 1};
    // graphics fill uses channels instead of rgba
    RealColor real_color = color_to_real(color, pinc_framebuffer_format_get_channels(-1));
    pinc_graphics_fill_color(window, real_color.c1, real_color.c2, real_color.c3, real_color.c4);
    pinc_graphics_draw(window, test_align1_pipeline, test_align1_vertex_array, 0);
    pinc_graphics_done();
}

void test_align1_deinit(void) {
    pinc_graphics_pipeline_deinit(test_align1_pipeline);
    pinc_graphics_vertex_array_deinit(test_align1_vertex_array);
}

const Example examples[] = {
    {empty_function, test_green_frame, empty_function, "green", "Just Green"},
    {test_basic_start, test_basic_frame, test_basic_deinit, "basic", "A basic colored triangle"},
    {test_align1_start, test_align1_frame, test_align1_deinit, "align", "A basic white triangle"},
};

const int NUM_EXAMPLES = 3;
