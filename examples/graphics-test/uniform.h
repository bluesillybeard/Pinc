#include "graphics-test.h"

int test_uniform_pipeline;
int test_uniform_vertex_array;

void test_uniform_start(void) {
    // TODO: check GLSL version
    int vertexAttribs = pinc_graphics_vertex_attributes_create(1);
    pinc_graphics_vertex_attributes_set_item(vertexAttribs, 0, pinc_graphics_attribute_type_vec2, 0, 0);
    pinc_graphics_vertex_attributes_set_stride(vertexAttribs, 8);

    // this test has a single uniform called color
    int uniforms = pinc_graphics_uniforms_create(1);
    pinc_graphics_uniforms_set_item(uniforms, 0, pinc_graphics_uniform_type_vec4);

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
        uniform vec4 color;\n\
        void main() {\n\
            gl_FragColor = color;\n\
        }\
    ";

    int fragmentShaderCodeLen = strlen(fragmentShaderCode);

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

    // uniform 0 is color
    pinc_graphics_shaders_glsl_uniform_mapping_set_num(shaders, 1);
    pinc_graphics_shaders_glsl_uniform_mapping_set_item_length(shaders, 0, 5);
    pinc_graphics_shaders_glsl_uniform_mapping_set_item(shaders, 0, 0, 'c');
    pinc_graphics_shaders_glsl_uniform_mapping_set_item(shaders, 0, 1, 'o');
    pinc_graphics_shaders_glsl_uniform_mapping_set_item(shaders, 0, 2, 'l');
    pinc_graphics_shaders_glsl_uniform_mapping_set_item(shaders, 0, 3, 'o');
    pinc_graphics_shaders_glsl_uniform_mapping_set_item(shaders, 0, 4, 'r');

    // Create the pipeline object.
    // Pinc puts all of the vertex assemlbly, uniform inputs, shader code, and other rendering state into a single object
    // more like Vulkan than OpenGL.
    // Pipeline is given an array of triangles
    test_uniform_pipeline = pinc_graphics_pipeline_incomplete_create(vertexAttribs, uniforms, shaders, pinc_graphics_vertex_assembly_array_triangles);

    pinc_graphics_pipeline_complete(test_uniform_pipeline);

    if(collect_errors()){
        on_error_exit();
    }

    // A single triangle using the same vertex attributes as the pipeline expects
    test_uniform_vertex_array = pinc_graphics_vertex_array_create(vertexAttribs, 3);

    if(collect_errors()){
        on_error_exit();
    }

    pinc_graphics_vertex_array_lock(test_uniform_vertex_array);
    pinc_graphics_vertex_array_set_item_vec2(test_uniform_vertex_array, 0, 0, -0.5, -0.5);
    pinc_graphics_vertex_array_set_item_vec2(test_uniform_vertex_array, 1, 0, 0.5, -0.5);
    pinc_graphics_vertex_array_set_item_vec2(test_uniform_vertex_array, 2, 0, 0, 0.5);
    pinc_graphics_vertex_array_unlock(test_uniform_vertex_array);

    // destroy the temporary objects

    pinc_graphics_shaders_deinit(shaders);
    pinc_graphics_uniforms_deinit(uniforms);
    pinc_graphics_vertex_attributes_deinit(vertexAttribs);
}

void test_uniform_frame(void) {
    // ranges from 0 to 2pi
    float hue = (((float)(frame % 300)) / 299);
    // get (bad and unclamped) RGB from hue - copied from https://github.com/tobspr/GLSL-Color-Space
    float R = fabs(hue * 6.0 - 3.0) - 1.0;
    float G = 2.0 - fabs(hue * 6.0 - 2.0);
    float B = 2.0 - fabs(hue * 6.0 - 4.0);
    pinc_graphics_pipeline_set_uniform_vec4(test_uniform_pipeline, 0, R, G, B, 1);
    pinc_graphics_draw(window, test_uniform_pipeline, test_uniform_vertex_array, 0);
    pinc_graphics_done();
}

void test_uniform_deinit(void) {
    pinc_graphics_pipeline_deinit(test_uniform_pipeline);
    pinc_graphics_vertex_array_deinit(test_uniform_vertex_array);
}


