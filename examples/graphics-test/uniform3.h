// Remember, all of these exampeles are unity builds.
// Headers included here are for LSP to work correctly.

#include "graphics-test.h"

int test_uniform3_pipeline;

int test_uniform3_vertex_array;

void test_uniform3_start(void) {
    if(!pinc_graphics_shader_glsl_version_supported(1, 10, 0)) {
        assert(false);
    }
    // Create a vertex attributes object and fill out the information for it
    int vertexAttribs = pinc_graphics_vertex_attributes_create(3);
    assert(pinc_graphics_vertex_attributes_type_align(pinc_graphics_attribute_type_vec3) < 16);
    assert(16 % pinc_graphics_vertex_attributes_type_align(pinc_graphics_attribute_type_vec3) == 0);
    assert(pinc_graphics_vertex_attributes_type_align(pinc_graphics_attribute_type_vec4) < 16);
    assert(16 % pinc_graphics_vertex_attributes_type_align(pinc_graphics_attribute_type_vec4) == 0);
    // this is the position of the vertex
    pinc_graphics_vertex_attributes_set_item(vertexAttribs, 0, pinc_graphics_attribute_type_vec3, 0, 0);
    // color
    pinc_graphics_vertex_attributes_set_item(vertexAttribs, 1, pinc_graphics_attribute_type_vec4, 16, 0);
    // normal
    pinc_graphics_vertex_attributes_set_item(vertexAttribs, 2, pinc_graphics_attribute_type_vec3, 32, 0);
    // This assumes the alignment of this is valid
    pinc_graphics_vertex_attributes_set_stride(vertexAttribs, 48);

    // create a uniforms object
    int uniforms = pinc_graphics_uniforms_create(5);
    // The three uniforms are:
    // 0 -> mat2x2 tint (this would be a vec4 but we're trying to test matrices here)
    // 1 -> mat3x3 with three vec3s for sky color, sky direction, light direction
    // 2 -> mat4x4 model transform
    // 3 -> mat4x4 camera transform
    // 4 -> mat4x4 projection transform
    pinc_graphics_uniforms_set_item(uniforms, 0, pinc_graphics_uniform_type_mat2x2);
    pinc_graphics_uniforms_set_item(uniforms, 1, pinc_graphics_uniform_type_mat3x3);
    pinc_graphics_uniforms_set_item(uniforms, 2, pinc_graphics_uniform_type_mat4x4);
    pinc_graphics_uniforms_set_item(uniforms, 3, pinc_graphics_uniform_type_mat4x4);
    pinc_graphics_uniforms_set_item(uniforms, 4, pinc_graphics_uniform_type_mat4x4);

    // Make a shaders object with the code

    int shaders = pinc_graphics_shaders_create(pinc_graphics_shader_type_glsl);

    char* vertexShaderCode = "\
        #version 110\n\
        attribute vec3 pos;\n\
        attribute vec4 color;\n\
        attribute vec3 normal;\n\
        uniform mat2 tint;\n\
        uniform mat3 light;\n\
        uniform mat4 m;\n\
        uniform mat4 c;\n\
        uniform mat4 p;\n\
        varying vec4 _color;\n\
        // normal in screen \n\
        varying vec3 _normal;\n\
        // sky direction in screen\n\
        varying vec3 _skyDir;\n\
        varying vec4 _skyCol;\n\
        // light direction in screen\n\
        varying vec3 _lightDir;\n\
        varying vec4 _lightCol;\n\
        void main() {\n\
            mat4 transform = p * c * m;\n\
            gl_Position = transform * vec4(pos, 1);\n\
            _color = color;\n\
            // from model space to screeen space\n\
            mat4 modelToScreen = c * m;\n\
            mat4 modelToScreenNoTranslation =  mat4(modelToScreen[0], modelToScreen[1], modelToScreen[2], vec4(0, 0, 0, 1));\n\
            // from world space to screen space\n\
            mat4 worldToScreen = c;\n\
            mat4 worldToScreenNoTranslation = mat4(worldToScreen[0], worldToScreen[1], worldToScreen[2], vec4(0, 0, 0, 1));\n\
            _normal = normalize(modelToScreenNoTranslation * vec4(normal, 1)).xyz;\n\
            _skyDir = normalize(worldToScreenNoTranslation * vec4(light[1], 1)).xyz;\n\
            _skyCol = vec4(light[0], 1);\n\
            _lightDir = normalize(worldToScreenNoTranslation * vec4(light[2], 1)).xyz;\n\
            _lightCol = vec4(1, 1, 1, 1);\n\
        }\
    ";

    int vertexShaderCodeLen = strlen(vertexShaderCode);

    char* fragmentShaderCode = "\
        #version 110\n\
        varying vec4 _color;\n\
        varying vec3 _normal;\n\
        varying vec3 _skyDir;\n\
        varying vec4 _skyCol;\n\
        varying vec3 _lightDir;\n\
        varying vec4 _lightCol;\n\
        void main() {\n\
            vec4 skyInfluence = _skyCol * clamp(dot(_normal, _skyDir), 0, 5);\n\
            vec4 lightInfluence = _lightCol * clamp(dot(_normal, _lightDir), 0, 5);\n\
            vec4 ambientLight = vec4(0.2, 0.2, 0.2, 1.0);\n\
            gl_FragColor = _color * (skyInfluence + lightInfluence + ambientLight);\n\
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
    pinc_graphics_shaders_glsl_attribute_mapping_set_num(shaders, 3);
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
    // attribute 2 is normal
    pinc_graphics_shaders_glsl_attribute_mapping_set_item_length(shaders, 2, 6);
    pinc_graphics_shaders_glsl_attribute_mapping_set_item(shaders, 2, 0, 'n');
    pinc_graphics_shaders_glsl_attribute_mapping_set_item(shaders, 2, 1, 'o');
    pinc_graphics_shaders_glsl_attribute_mapping_set_item(shaders, 2, 2, 'r');
    pinc_graphics_shaders_glsl_attribute_mapping_set_item(shaders, 2, 3, 'm');
    pinc_graphics_shaders_glsl_attribute_mapping_set_item(shaders, 2, 4, 'a');
    pinc_graphics_shaders_glsl_attribute_mapping_set_item(shaders, 2, 5, 'l');

    // same thing for the three uniforms
    pinc_graphics_shaders_glsl_uniform_mapping_set_num(shaders, 5);
    // uniform 0 is tint
    pinc_graphics_shaders_glsl_uniform_mapping_set_item_length(shaders, 0, 4);
    pinc_graphics_shaders_glsl_uniform_mapping_set_item(shaders, 0, 0, 't');
    pinc_graphics_shaders_glsl_uniform_mapping_set_item(shaders, 0, 1, 'i');
    pinc_graphics_shaders_glsl_uniform_mapping_set_item(shaders, 0, 2, 'n');
    pinc_graphics_shaders_glsl_uniform_mapping_set_item(shaders, 0, 3, 't');
    // uniform 1 is light
    pinc_graphics_shaders_glsl_uniform_mapping_set_item_length(shaders, 1, 5);
    pinc_graphics_shaders_glsl_uniform_mapping_set_item(shaders, 1, 0, 'l');
    pinc_graphics_shaders_glsl_uniform_mapping_set_item(shaders, 1, 1, 'i');
    pinc_graphics_shaders_glsl_uniform_mapping_set_item(shaders, 1, 2, 'g');
    pinc_graphics_shaders_glsl_uniform_mapping_set_item(shaders, 1, 3, 'h');
    pinc_graphics_shaders_glsl_uniform_mapping_set_item(shaders, 1, 4, 't');
    // uniform 2 is model transform
    pinc_graphics_shaders_glsl_uniform_mapping_set_item_length(shaders, 2, 1);
    pinc_graphics_shaders_glsl_uniform_mapping_set_item(shaders, 2, 0, 'm');
    // uniform 3 is camera transform
    pinc_graphics_shaders_glsl_uniform_mapping_set_item_length(shaders, 3, 1);
    pinc_graphics_shaders_glsl_uniform_mapping_set_item(shaders, 3, 0, 'c');
    // uniform 4 is projection transform
    pinc_graphics_shaders_glsl_uniform_mapping_set_item_length(shaders, 4, 1);
    pinc_graphics_shaders_glsl_uniform_mapping_set_item(shaders, 4, 0, 'p');
    // Create the pipeline object.
    // Pinc puts all of the vertex assembly, uniform inputs, shader code, and other rendering state into a single object
    // more like Vulkan than OpenGL.
    // Pipeline is given an array of triangles
    test_uniform3_pipeline = pinc_graphics_pipeline_incomplete_create(vertexAttribs, uniforms, shaders, pinc_graphics_vertex_assembly_array_triangles);

    pinc_graphics_pipeline_set_depth_test(test_uniform3_pipeline, pinc_graphics_depth_test_less);

    pinc_graphics_pipeline_complete(test_uniform3_pipeline);

    if(collect_errors()){
        on_error_exit();
    }

    // A single triangle using the same vertex attributes as the pipeline expects
    test_uniform3_vertex_array = pinc_graphics_vertex_array_create(vertexAttribs, 36);

    if(collect_errors()){
        on_error_exit();
    }

    pinc_graphics_vertex_array_lock(test_uniform3_vertex_array);

    // Building a cube is a lot... here we go!
    // numbering vertices 0 - 7 based on their location on the XYZ axis
    // this is a dual unit cube - side lengths are 2 units
    float cubeBits[] = {
        // X Y Z R G B A NX NY NZ
        // f0123
        -1, -1, -1, 150, 115, 84, 255, 0, -1, 0,
        +1, -1, -1, 150, 115, 84, 255, 0, -1, 0,
        -1, -1, +1, 150, 115, 84, 255, 0, -1, 0,

        +1, -1, -1, 150, 115, 84, 255, 0, -1, 0,
        +1, -1, +1, 150, 115, 84, 255, 0, -1, 0,
        -1, -1, +1, 150, 115, 84, 255, 0, -1, 0,
        // f0145
        -1, -1, -1, 150, 115, 84, 255, 0, 0, -1,
        +1, -1, -1, 150, 115, 84, 255, 0, 0, -1,
        -1, +1, -1, 213, 192, 165, 255, 0, 0, -1,

        +1, -1, -1, 150, 115, 84, 255, 0, 0, -1,
        -1, +1, -1, 213, 192, 165, 255, 0, 0, -1,
        +1, +1, -1, 213, 192, 165, 255, 0, 0, -1,
        // f0246
        -1, -1, -1, 150, 115, 84, 255, -1, 0, 0,
        -1, -1, +1, 150, 115, 84, 255, -1, 0, 0,
        -1, +1, -1, 213, 192, 165, 255, -1, 0, 0,

        -1, -1, +1, 150, 115, 84, 255, -1, 0, 0,
        -1, +1, -1, 213, 192, 165, 255, -1, 0, 0,
        -1, +1, +1, 213, 192, 165, 255, -1, 0, 0,
        // f1357
        +1, -1, -1, 150, 115, 84, 255, 1, 0, 0,
        +1, -1, +1, 150, 115, 84, 255, 1, 0, 0,
        +1, +1, -1, 213, 192, 165, 255, 1, 0, 0,

        +1, -1, +1, 150, 115, 84, 255, 1, 0, 0,
        +1, +1, -1, 213, 192, 165, 255, 1, 0, 0,
        +1, +1, +1, 213, 192, 165, 255, 1, 0, 0,
        // f2367
        -1, -1, +1, 150, 115, 84, 255, 0, 0, 1,
        +1, -1, +1, 150, 115, 84, 255, 0, 0, 1,
        -1, +1, +1, 213, 192, 165, 255, 0, 0, 1,

        +1, -1, +1, 150, 115, 84, 255, 0, 0, 1,
        -1, +1, +1, 213, 192, 165, 255, 0, 0, 1,
        +1, +1, +1, 213, 192, 165, 255, 0, 0, 1,
        // f4567
        -1, +1, -1, 213, 192, 165, 255, 0, 1, 0,
        +1, +1, -1, 213, 192, 165, 255, 0, 1, 0,
        -1, +1, +1, 213, 192, 165, 255, 0, 1, 0,

        +1, +1, -1, 213, 192, 165, 255, 0, 1, 0,
        -1, +1, +1, 213, 192, 165, 255, 0, 1, 0,
        +1, +1, +1, 213, 192, 165, 255, 0, 1, 0,
    };

    for(int i=0; i<36; ++i) {
        float vx = cubeBits[i*10+0];
        float vy = cubeBits[i*10+1];
        float vz = cubeBits[i*10+2];
        float vr = cubeBits[i*10+3] / 255.0;
        float vg = cubeBits[i*10+4] / 255.0;
        float vb = cubeBits[i*10+5] / 255.0;
        float va = cubeBits[i*10+6] / 255.0;
        float nx = cubeBits[i*10+7];
        float ny = cubeBits[i*10+8];
        float nz = cubeBits[i*10+9];
        pinc_graphics_vertex_array_set_item_vec3(test_uniform3_vertex_array, i, 0, vx, vy, vz);
        pinc_graphics_vertex_array_set_item_vec4(test_uniform3_vertex_array, i, 1, vr, vg, vb, va);
        pinc_graphics_vertex_array_set_item_vec3(test_uniform3_vertex_array, i, 2, nx, ny, nz);
    }

    pinc_graphics_vertex_array_unlock(test_uniform3_vertex_array);

    // destroy the temporary objects

    pinc_graphics_shaders_deinit(shaders);
    pinc_graphics_uniforms_deinit(uniforms);
    pinc_graphics_vertex_attributes_deinit(vertexAttribs);
}

void test_uniform3_frame(void) {
    RGBAColor color = {0, 0, 0, 1};
    // graphics fill uses channels instead of rgba
    RealColor real_color = color_to_real(color, pinc_framebuffer_format_get_channels(-1));
    pinc_graphics_fill_color(window, real_color.c1, real_color.c2, real_color.c3, real_color.c4);
    pinc_graphics_fill_depth(window, 1);
    // r, g, b, a light color
    pinc_graphics_pipeline_set_uniform_mat2x2(test_uniform3_pipeline, 0, 1, 1, 0.8, 1);
    pinc_graphics_pipeline_set_uniform_mat3x3(test_uniform3_pipeline, 1, 
        // sky color
        110.0/255.0, 200.0/255.0, 250.0/255.0,
        // sky direction
        3/sqrtf(3), 3/sqrtf(3), 3/sqrtf(3),
        // light direction
        0, 0, 1
    );
    // this makes the cube rotate over time
    struct timespec now;
    timespec_get(&now, TIME_UTC);
    // one rotation per 4 seconds
    int ms_per_rot = 4000;
    float ms_per_rad = ms_per_rot / (2 * 3.14159);

    float theta = (current_millis % (ms_per_rot)) / ms_per_rad;
    // OK so we don't have an actual matrix math library...
    // move in -z 4 units, rotate accros the Y axis by an angle proportional to frames, 
    // Note: matrices are transpose from what you may expect.
    // Pinc inherits this strangeness from OpenGL because I was more used to the OpenGL way.
    pinc_graphics_pipeline_set_uniform_mat4x4(test_uniform3_pipeline, 2, 
        cosf(theta) , 0, sinf(theta) , 0,
        0           , 1 , 0          , 0,
        -sinf(theta), 0, cosf(theta) , 0,
        0           , 0, -4          , 1
    );
    // camera transform - rotate down a bit and move up a few units
    // and move up a few units
    float camera_rotation = -0.5;
    pinc_graphics_pipeline_set_uniform_mat4x4(test_uniform3_pipeline, 3, 
        1, 0                    , 0                     , 0,
        0, cosf(camera_rotation), -sinf(camera_rotation), 0,
        0, sinf(camera_rotation), cosf(camera_rotation) , 0,
        0, -2                   , 0                     , 1
    );

    // apply an orthographic projection that's x units wide, near plane of 0.0 and far plane of 100
    float width = 5;
    float aspect = (float)pinc_window_get_height(window) / (float)pinc_window_get_width(window);
    float height = width * aspect;
    pinc_graphics_pipeline_set_uniform_mat4x4(test_uniform3_pipeline, 4, 
        2/width, 0.0     , 0.0  , 0.0,
        0.0    , 2/height, 0.0  , 0.0,
        0.0    , 0.0     , -0.02, 0.0,
        0.0    , 0.0     , -1   , 1.0
    );
    pinc_graphics_draw(window, test_uniform3_pipeline, test_uniform3_vertex_array, 0);
    pinc_graphics_done();
}

void test_uniform3_deinit(void) {
    pinc_graphics_pipeline_deinit(test_uniform3_pipeline);
    pinc_graphics_vertex_array_deinit(test_uniform3_vertex_array);
}
