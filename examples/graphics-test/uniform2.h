// Same idea as the uniform example, however this tests more uniform types
// this test has many uniforms, and the triangle will be green if all of them are the correct values.

#include "graphics-test.h"

int test_uniform2_pipeline;
int test_uniform2_vertex_array;

void test_uniform2_start(void) {
    // TODO: check glsl version
    int vertexAttribs = pinc_graphics_vertex_attributes_create(1);
    pinc_graphics_vertex_attributes_set_item(vertexAttribs, 0, pinc_graphics_attribute_type_vec2, 0, 0);
    pinc_graphics_vertex_attributes_set_stride(vertexAttribs, 8);

    int uniforms = pinc_graphics_uniforms_create(8);
    pinc_graphics_uniforms_set_item(uniforms, 0, pinc_graphics_uniform_type_float);
    pinc_graphics_uniforms_set_item(uniforms, 1, pinc_graphics_uniform_type_vec2);
    pinc_graphics_uniforms_set_item(uniforms, 2, pinc_graphics_uniform_type_vec3);
    pinc_graphics_uniforms_set_item(uniforms, 3, pinc_graphics_uniform_type_vec4);
    pinc_graphics_uniforms_set_item(uniforms, 4, pinc_graphics_uniform_type_int);
    pinc_graphics_uniforms_set_item(uniforms, 5, pinc_graphics_uniform_type_ivec2);
    pinc_graphics_uniforms_set_item(uniforms, 6, pinc_graphics_uniform_type_ivec3);
    pinc_graphics_uniforms_set_item(uniforms, 7, pinc_graphics_uniform_type_ivec4);

    // TODO: once fixed-shading is available, use that instead for maximum compatibility

    // Make a shaders object with the code

    int shaders = pinc_graphics_shaders_create(pinc_graphics_shader_type_glsl);

    char* vertexShaderCode = "\
        #version 110\n\
        attribute vec2 pos;\n\
        uniform float tv1; // should be 0.5 \n\
        uniform vec2 tv2; // should be <-0.5, 1.0>\n\
        uniform vec3 tv3; // should be <7, 5, 6>\n\
        uniform vec4 tv4; // should be <1, 2, 3, 4>\n\
        uniform int ti1; // should be 83\n\
        uniform ivec2 ti2; //should be <8, 3>\n\
        uniform ivec3 ti3; //should be <1, 2, 4>\n\
        uniform ivec4 ti4; //should be <5, 6, 7, 9>\n\
        varying float vw;\n\
        void main() {\n\
            gl_Position = vec4(pos, 0, 1);\n\
            if(\n\
                tv1 == 0.5\n\
                && tv2 == vec2(-0.5, 1.0)\n\
                && tv3 == vec3(7, 5, 6)\n\
                && tv4 == vec4(1, 2, 3, 4)\n\
                && ti1 == 83\n\
                && ti2 == ivec2(8, 3)\n\
                && ti3 == ivec3(1, 2, 4)\n\
                && ti4 == ivec4(5, 6, 7, 9))\n\
            {\n\
                vw = 1.0;\n\
            } else {\n\
                vw = 0.0;\n\
            }\n\
        }\
    ";

    int vertexShaderCodeLen = strlen(vertexShaderCode);

    char* fragmentShaderCode = "\
        #version 110\n\
        uniform float tv1; // should be 0.5 \n\
        uniform vec2 tv2; // should be <-0.5, 1.0>\n\
        uniform vec3 tv3; // should be <7, 5, 6>\n\
        uniform vec4 tv4; // should be <1, 2, 3, 4>\n\
        uniform int ti1; // should be 83\n\
        uniform ivec2 ti2; //should be <8, 3>\n\
        uniform ivec3 ti3; //should be <1, 2, 4>\n\
        uniform ivec4 ti4; //should be <5, 6, 7, 9>\n\
        varying float vw;\n\
        void main() {\n\
            if (\n\
                vw == 1.0\n\
                && tv1 == 0.5\n\
                && tv2 == vec2(-0.5, 1.0)\n\
                && tv3 == vec3(7, 5, 6)\n\
                && tv4 == vec4(1, 2, 3, 4)\n\
                && ti1 == 83\n\
                && ti2 == ivec2(8, 3)\n\
                && ti3 == ivec3(1, 2, 4)\n\
                && ti4 == ivec4(5, 6, 7, 9))\n\
            {\n\
                gl_FragColor = vec4(0.0, 1.0, 0.0, 1.0);\n\
            } else {\n\
                gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);\n\
            }\n\
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

    // uniforms
    pinc_graphics_shaders_glsl_uniform_mapping_set_num(shaders, 8);

    pinc_graphics_shaders_glsl_uniform_mapping_set_item_length(shaders, 0, 3);
    pinc_graphics_shaders_glsl_uniform_mapping_set_item(shaders, 0, 0, 't');
    pinc_graphics_shaders_glsl_uniform_mapping_set_item(shaders, 0, 1, 'v');
    pinc_graphics_shaders_glsl_uniform_mapping_set_item(shaders, 0, 2, '1');

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

    pinc_graphics_shaders_glsl_uniform_mapping_set_item_length(shaders, 4, 3);
    pinc_graphics_shaders_glsl_uniform_mapping_set_item(shaders, 4, 0, 't');
    pinc_graphics_shaders_glsl_uniform_mapping_set_item(shaders, 4, 1, 'i');
    pinc_graphics_shaders_glsl_uniform_mapping_set_item(shaders, 4, 2, '1');

    pinc_graphics_shaders_glsl_uniform_mapping_set_item_length(shaders, 5, 3);
    pinc_graphics_shaders_glsl_uniform_mapping_set_item(shaders, 5, 0, 't');
    pinc_graphics_shaders_glsl_uniform_mapping_set_item(shaders, 5, 1, 'i');
    pinc_graphics_shaders_glsl_uniform_mapping_set_item(shaders, 5, 2, '2');

    pinc_graphics_shaders_glsl_uniform_mapping_set_item_length(shaders, 6, 3);
    pinc_graphics_shaders_glsl_uniform_mapping_set_item(shaders, 6, 0, 't');
    pinc_graphics_shaders_glsl_uniform_mapping_set_item(shaders, 6, 1, 'i');
    pinc_graphics_shaders_glsl_uniform_mapping_set_item(shaders, 6, 2, '3');

    pinc_graphics_shaders_glsl_uniform_mapping_set_item_length(shaders, 7, 3);
    pinc_graphics_shaders_glsl_uniform_mapping_set_item(shaders, 7, 0, 't');
    pinc_graphics_shaders_glsl_uniform_mapping_set_item(shaders, 7, 1, 'i');
    pinc_graphics_shaders_glsl_uniform_mapping_set_item(shaders, 7, 2, '4');

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
    pinc_graphics_pipeline_set_uniform_int(test_uniform2_pipeline, 4, 83);
    pinc_graphics_pipeline_set_uniform_ivec2(test_uniform2_pipeline, 5, 8, 3);
    pinc_graphics_pipeline_set_uniform_ivec3(test_uniform2_pipeline, 6, 1, 2, 4);
    pinc_graphics_pipeline_set_uniform_ivec4(test_uniform2_pipeline, 7, 5, 6, 7, 9);
    pinc_graphics_draw(window, test_uniform2_pipeline, test_uniform2_vertex_array, 0);
    pinc_graphics_done();
}

void test_uniform2_deinit(void) {
    pinc_graphics_pipeline_deinit(test_uniform2_pipeline);
    pinc_graphics_vertex_array_deinit(test_uniform2_vertex_array);
}
