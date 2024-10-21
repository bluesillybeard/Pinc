// A minimal example to initialize Pinc graphics and draw a triangle.

#include <pinc.h>
// TODO: in the future, the graphics header may be incorperated into the main header
#include <pinc_graphics.h>
#include <stdio.h>
#include <string.h>
#include <stdbool.h>

// declare stuff
int collect_errors(void);

// variables

int window;

int pipeline;

int vertexArray;

int texture;

// graphics functions

bool init(void) {
    // Create a vertex attributes object and fill out the information for it
    int vertexAttribs = pinc_graphics_vertex_attributes_create(2);
    // this is the position of the vertex
    pinc_graphics_vertex_attributes_set_item(vertexAttribs, 0, pinc_graphics_attribute_type_vec2, 0, 0);
    // this is the color of the vertex
    pinc_graphics_vertex_attributes_set_item(vertexAttribs, 1, pinc_graphics_attribute_type_vec4, 8, 0);
    // the is the stride of each vertex as a whole. A float is 4 bytes, there are 6 total floats in a vertex, 4 * 6 = 22
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
    pipeline = pinc_graphics_pipeline_incomplete_create(vertexAttribs, uniforms, shaders, pinc_graphics_vertex_assembly_array_triangles);

    pinc_graphics_pipeline_complete(pipeline);

    if(collect_errors()){
        return false;
    }

    // A single triangle using the same vertex attributes as the pipeline expects
    vertexArray = pinc_graphics_vertex_array_create(vertexAttribs, 3);

    if(collect_errors()){
        return false;
    }

    pinc_graphics_vertex_array_lock(vertexArray);

    pinc_graphics_vertex_array_set_item_vec2(vertexArray, 0, 0, -0.5, -0.5);
    pinc_graphics_vertex_array_set_item_vec4(vertexArray, 0, 1, 1, 0, 0, 1);

    pinc_graphics_vertex_array_set_item_vec2(vertexArray, 1, 0, 0.5, -0.5);
    pinc_graphics_vertex_array_set_item_vec4(vertexArray, 1, 1, 0, 1, 0, 1);

    pinc_graphics_vertex_array_set_item_vec2(vertexArray, 2, 0, 0, 0.5);
    pinc_graphics_vertex_array_set_item_vec4(vertexArray, 2, 1, 0, 0, 1, 1);

    pinc_graphics_vertex_array_unlock(vertexArray);

    // destroy the temporary objects

    pinc_graphics_shaders_deinit(shaders);
    pinc_graphics_uniforms_deinit(uniforms);
    pinc_graphics_vertex_attributes_deinit(vertexAttribs);

    return true;
}

void draw(void) {
    // No uniforms to set
    pinc_graphics_draw(window, pipeline, vertexArray, 0);
    pinc_graphics_done();
}

/// @brief You know what main is. At least, I hope you know what main is...
int main(int argc, char** argv) {
    pinc_incomplete_init();
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
    window = pinc_window_incomplete_create();
    // Setting all of these is optional, but set them anyway for demonstration
    char* title = "Pinc graphics example";
    int len = strlen(title);
    // In the future, there will be a more ergonomic method to set the title of a window.
    // But for now this is the only way, as the pinc public API does not allow pointers for required functions
    pinc_window_set_title_length(window, len);
    for(int i=0; i<len; ++i) {
        pinc_window_set_title_item(window, i, title[i]);
    }
    pinc_window_complete(window);
    // complete may trigger fatal errors
    if(collect_errors()) {
        return 255;
    }
    if(!init()) {
        return false;
    }
    int running = 1;
    while(running) {
        pinc_step();
        if(pinc_event_window_closed(window)) {
            running = 0;
            break;
        }
        draw();
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
