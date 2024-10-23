// Remember, all of these exampeles are unity builds.
// Headers included here are for LSP to work correctly.

// This is basically the same as the graphics.c example

#include "graphics-test.h"

int test_basic_pipeline;

int test_basic_vertex_array;

void test_basic_start(void) {
    pinc_graphics_shader_glsl_version_supported(1, 1, 0);
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
