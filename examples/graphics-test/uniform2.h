// Same idea as the uniform example, however this tests more uniform types
// this test has many uniforms, and the triangle will be green if all of them are the correct values.

#include "graphics-test.h"

int test_uniform2_pipeline;
int test_uniform2_vertex_array;

void test_uniform2_start(void) {
    int vertexAttribs = pinc_graphics_vertex_attributes_create(1);
    pinc_graphics_vertex_attributes_set_item(vertexAttribs, 0, pinc_graphics_attribute_type_vec2, 0, 0);
    pinc_graphics_vertex_attributes_set_stride(vertexAttribs, 8);

    int uniforms = pinc_graphics_uniforms_create(4);
    pinc_graphics_uniforms_set_item(uniforms, 0, pinc_graphics_uniform_type_float);
    pinc_graphics_uniforms_set_item(uniforms, 1, pinc_graphics_uniform_type_vec2);
    pinc_graphics_uniforms_set_item(uniforms, 2, pinc_graphics_uniform_type_vec3);
    pinc_graphics_uniforms_set_item(uniforms, 3, pinc_graphics_uniform_type_vec4);

    // TODO: once fixed-shading is available, use that instead for maximum compatibility

    // Make a shaders object with the code

    int shaders = pinc_graphics_shaders_create(pinc_graphics_shader_type_glsl);

    char* vertexShaderCode = "\
        #version 110\n\
        attribute vec2 pos;\n\
        uniform float tvf; // should be 0.5 \n\
        uniform vec2 tv2; // should be <-0.5, 1.0>\n\
        uniform vec3 tv3; // should be <7, 5, 6>\n\
        uniform vec4 tv4; // should be <1, 2, 3, 4>\n\
        varying float vertexWorks;\n\
        void main() {\n\
            gl_Position = vec4(pos, 0, 1);\n\
            if(tvf == 0.5 && tv2 == vec2(-0.5, 1.0) && tv3 == vec3(7, 5, 6) && tv4 == vec4(1, 2, 3, 4)) {\n\
                vertexWorks = 1.0;\n\
            } else {\n\
                vertexWorks = 0.0;\n\
            }\n\
        }\
    ";

    int vertexShaderCodeLen = strlen(vertexShaderCode);

    char* fragmentShaderCode = "\
        #version 110\n\
        uniform float tvf; // should be 0.5 \n\
        uniform vec2 tv2; // should be <-0.5, 1.0>\n\
        uniform vec3 tv3; // should be <7, 5, 6>\n\
        uniform vec4 tv4; // should be <1, 2, 3, 4>\n\
        varying float vertexWorks;\n\
        void main() {\n\
            if(tvf == 0.5 && tv2 == vec2(-0.5, 1.0) && tv3 == vec3(7, 5, 6) && tv4 == vec4(1, 2, 3, 4) && vertexWorks == 1.0) {\n\
                gl_FragColor = vec4(0.0, 1.0, 0.0, 1.0);\n\
            } else {\n\
                gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);\n\
            }\n\
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

    // uniforms
    pinc_graphics_shaders_glsl_uniform_mapping_set_num(shaders, 4);

    pinc_graphics_shaders_glsl_uniform_mapping_set_item_length(shaders, 0, 3);
    pinc_graphics_shaders_glsl_uniform_mapping_set_item(shaders, 0, 0, 't');
    pinc_graphics_shaders_glsl_uniform_mapping_set_item(shaders, 0, 1, 'v');
    pinc_graphics_shaders_glsl_uniform_mapping_set_item(shaders, 0, 2, 'f');

    pinc_graphics_shaders_glsl_uniform_mapping_set_item_length(shaders, 1, 3);
    pinc_graphics_shaders_glsl_uniform_mapping_set_item(shaders, 1, 0, 't');
    pinc_graphics_shaders_glsl_uniform_mapping_set_item(shaders, 1, 1, 'v');
    pinc_graphics_shaders_glsl_uniform_mapping_set_item(shaders, 1, 2, '2');

    pinc_graphics_shaders_glsl_uniform_mapping_set_item_length(shaders, 2, 3);
    pinc_graphics_shaders_glsl_uniform_mapping_set_item(shaders, 2, 0, 't');
    pinc_graphics_shaders_glsl_uniform_mapping_set_item(shaders, 2, 1, 'v');
    pinc_graphics_shaders_glsl_uniform_mapping_set_item(shaders, 2, 2, '3');

    pinc_graphics_shaders_glsl_uniform_mapping_set_item_length(shaders, 3, 3);
    pinc_graphics_shaders_glsl_uniform_mapping_set_item(shaders, 3, 0, 't');
    pinc_graphics_shaders_glsl_uniform_mapping_set_item(shaders, 3, 1, 'v');
    pinc_graphics_shaders_glsl_uniform_mapping_set_item(shaders, 3, 2, '4');

    // Create the pipeline object.
    // Pinc puts all of the vertex assemlbly, uniform inputs, shader code, and other rendering state into a single object
    // more like Vulkan than OpenGL.
    // Pipeline is given an array of triangles
    test_uniform2_pipeline = pinc_graphics_pipeline_incomplete_create(vertexAttribs, uniforms, shaders, pinc_graphics_vertex_assembly_array_triangles);

    pinc_graphics_pipeline_complete(test_uniform2_pipeline);

    if(collect_errors()){
        on_error_exit();
    }

    // A single triangle using the same vertex attributes as the pipeline expects
    test_uniform2_vertex_array = pinc_graphics_vertex_array_create(vertexAttribs, 3);

    if(collect_errors()){
        on_error_exit();
    }

    pinc_graphics_vertex_array_lock(test_uniform2_vertex_array);
    pinc_graphics_vertex_array_set_item_vec2(test_uniform2_vertex_array, 0, 0, -0.5, -0.5);
    pinc_graphics_vertex_array_set_item_vec2(test_uniform2_vertex_array, 1, 0, 0.5, -0.5);
    pinc_graphics_vertex_array_set_item_vec2(test_uniform2_vertex_array, 2, 0, 0, 0.5);
    pinc_graphics_vertex_array_unlock(test_uniform2_vertex_array);

    // destroy the temporary objects

    pinc_graphics_shaders_deinit(shaders);
    pinc_graphics_uniforms_deinit(uniforms);
    pinc_graphics_vertex_attributes_deinit(vertexAttribs);
}

void test_uniform2_frame(void) {
    pinc_graphics_pipeline_set_uniform_float(test_uniform2_pipeline, 0, 0.5);
    pinc_graphics_pipeline_set_uniform_vec2(test_uniform2_pipeline, 1, -0.5, 1);
    pinc_graphics_pipeline_set_uniform_vec3(test_uniform2_pipeline, 2, 7, 5, 6);
    pinc_graphics_pipeline_set_uniform_vec4(test_uniform2_pipeline, 3, 1, 2, 3, 4);
    pinc_graphics_draw(window, test_uniform2_pipeline, test_uniform2_vertex_array, 0);
    pinc_graphics_done();
}

void test_uniform2_deinit(void) {
    pinc_graphics_pipeline_deinit(test_uniform2_pipeline);
    pinc_graphics_vertex_array_deinit(test_uniform2_vertex_array);
}
