// Like uniform2, this tests all of the attribute types
// Attributes get more complex because they have alignment requirements.

// Remember, all of these exampeles are unity builds.
// Headers included here are for LSP to work correctly.

// This is basically the same as the graphics.c example

#include "graphics-test.h"

int test_allAttributes_pipeline;

int test_allAttributes_vertex_array;

// TODO: This probably belongs in graphics-test.[c|h]
int test_AllAttribute_alignForward(int index, int align) {
    // The formula at the botom works correctly but only when the index is not already aligned
    if(index % align == 0) return index;
    // division truncates, thus this will work as we want
    return align * (index / align + 1);
}

// TODO: this probably belongs in graphics-test.h
struct test_AllAttribute_VertexAttribute {
    int type;
    const char* name;
};

// declare this function ahead of time
void test_allAttributes_submitVertices(void);

void test_allAttributes_start(void) {
    if(!pinc_graphics_shader_glsl_version_supported(1, 1, 0)) {
        assert(false);
    }

    static const struct test_AllAttribute_VertexAttribute vertexAttributes[] = {
        {pinc_graphics_attribute_type_float, "f1"},
        {pinc_graphics_attribute_type_vec2, "pos"},
        {pinc_graphics_attribute_type_vec3, "f3"},
        {pinc_graphics_attribute_type_vec4, "f4"},
    };

    // this trick works because vertexAttributeTypes is a static array
    static const int numVertexAttributes = sizeof(vertexAttributes)/sizeof(struct test_AllAttribute_VertexAttribute);

    int vertexAttribs = pinc_graphics_vertex_attributes_create(numVertexAttributes);
    assert(vertexAttribs != 0);
    int offset = 0;
    int largestAlign = 1;
    for(int i=0; i<numVertexAttributes; ++i) {
        int align = pinc_graphics_vertex_attributes_type_align(vertexAttributes[i].type);
        assert(align > 0);
        if(largestAlign < align) largestAlign = align;
        offset = test_AllAttribute_alignForward(offset, align);
        pinc_graphics_vertex_attributes_set_item(vertexAttribs, i, vertexAttributes[i].type, offset, 0);
        offset += pinc_graphics_vertex_attributes_type_size(vertexAttributes[i].type);
    }
    // The offset is not yet the stride, as we need to consider the largest alignment attribute.
    // If the stride does not align to that, then the second vertex (and most often ones after) will not align correctly
    offset = test_AllAttribute_alignForward(offset, largestAlign);
    pinc_graphics_vertex_attributes_set_stride(vertexAttribs, offset);

    // create a uniforms object
    // Even though there will be no uniforms, a uniforms object is still required
    int uniforms = pinc_graphics_uniforms_create(0);
    assert(uniforms != 0);
    
    // Make a shaders object with the code

    int shaders = pinc_graphics_shaders_create(pinc_graphics_shader_type_glsl);
    assert(shaders != 0);

    // The check is a basic checksum.
    // Sum each value x a prime number, check the result makes sense.
    // This checksum system allows each vertex to be different while still being checked fully.
    char* vertexShaderCode = "\
        #version 110\n\
        attribute float f1;\n\
        attribute vec2 pos;\n\
        attribute vec3 f3;\n\
        attribute vec4 f4;\n\
        varying vec4 _color;\n\
        void main() {\n\
            gl_Position = vec4(pos, 0, 1);\n\
            int sum = int(f1 * 2.0);\n\
            sum += int(f3.x * 3.0) + int(f3.y * 5.0) + int(f4.z * 7.0);\n\
            sum += int(f4.x * 11.0) + int(f4.y * 13.0) + int(f4.z * 17.0) + int(f4.w * 23.0);\n\
            // correct value is zero so generating new values is relatively simple\n\
            if(sum == 0) {\n\
                _color = vec4(0, 1, 0, 1);\n\
            } else {\n\
                _color = vec4(1, 0, 0, 1);\n\
            }\n\
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

    int fragmentShaderCodeLen = strlen(fragmentShaderCode);

    pinc_graphics_shaders_glsl_vertex_set_len(shaders, vertexShaderCodeLen);
    for(int i=0; i<vertexShaderCodeLen; ++i) {
        pinc_graphics_shaders_glsl_vertex_set_item(shaders, i, vertexShaderCode[i]);
    }

    pinc_graphics_shaders_glsl_fragment_set_len(shaders, fragmentShaderCodeLen);
    for(int i=0; i<fragmentShaderCodeLen; ++i) {
        pinc_graphics_shaders_glsl_fragment_set_item(shaders, i, fragmentShaderCode[i]);
    }

    pinc_graphics_shaders_glsl_attribute_mapping_set_num(shaders, numVertexAttributes);

    for(int i=0; i<numVertexAttributes; ++i) {
        struct test_AllAttribute_VertexAttribute attribute = vertexAttributes[i];
        int len = strlen(attribute.name);
        pinc_graphics_shaders_glsl_attribute_mapping_set_item_length(shaders, i, len);
        for(int c=0; c<len; ++c) {
            pinc_graphics_shaders_glsl_attribute_mapping_set_item(shaders, i, c, attribute.name[c]);
        }
    }

    // Create the pipeline object.
    // Pinc puts all of the vertex assemlbly, uniform inputs, shader code, and other rendering state into a single object
    // more like Vulkan than OpenGL.
    // Pipeline is given an array of triangles
    test_allAttributes_pipeline = pinc_graphics_pipeline_incomplete_create(vertexAttribs, uniforms, shaders, pinc_graphics_vertex_assembly_array_triangles);

    pinc_graphics_pipeline_complete(test_allAttributes_pipeline);

    if(collect_errors()){
        on_error_exit();
    }

    // A single triangle using the same vertex attributes as the pipeline expects
    test_allAttributes_vertex_array = pinc_graphics_vertex_array_create(vertexAttribs, 3);

    if(collect_errors()){
        on_error_exit();
    }

    test_allAttributes_submitVertices();

    // destroy the temporary objects

    pinc_graphics_shaders_deinit(shaders);
    pinc_graphics_uniforms_deinit(uniforms);
    pinc_graphics_vertex_attributes_deinit(vertexAttribs);
}

int xorshift(int s, int v) {
    int r = v ^ s;
    r ^= (s & ((1<<(31-15))-1)) << 15;
    r ^= s >> 3;
    r ^= (s & ((1<<(31-13))-1)) << 13;
    r ^= (v & ((1<<(31-10))-1)) << 10;
    r ^= v >> 2;
    int z = (v & ((1<<(31-25))-1));
    r ^= z << 25;
    return r;
}

void test_allAttributes_submitVertices(void) {
    // the idea behind doing this using a sort of random thing is so that we can test any kind of error that could prop up from random values.
    static int v = 42069;
    float pos[6] = {
        0.5, -0.5,
        -0.5, -0.5,
        0, 0.5,
    };
    pinc_graphics_vertex_array_lock(test_allAttributes_vertex_array);
    for(int i=0; i<3; ++i) {
        v = xorshift(frame, v);
        float f1 = (v & 1023) / 128.0;
        pinc_graphics_vertex_array_set_item_float(test_allAttributes_vertex_array, i, 0, f1);
        pinc_graphics_vertex_array_set_item_vec2(test_allAttributes_vertex_array, i, 1, pos[2 * i], pos[2 * i + 1]);
        v = xorshift(frame, v);
        float f3x = (v & 1023) / 128.0;
        v = xorshift(frame, v);
        float f3y = (v & 1023) / 128.0;
        v = xorshift(frame, v);
        float f3z = (v & 1023) / 128.0;
        pinc_graphics_vertex_array_set_item_vec3(test_allAttributes_vertex_array, i, 2, f3x, f3y, f3z);
        v = xorshift(frame, v);
        float f4x = (v & 1023) / 128.0;
        v = xorshift(frame, v);
        float f4y = (v & 1023) / 128.0;
        v = xorshift(frame, v);
        float f4z = (v & 1023) / 128.0;
        // set f4w such that  the sum will be equal to zero
        int partialSum = f1 * 2;
        partialSum += (int)(f3x * 3) + (int)(f3y * 5) + (int)(f4z * 7);
        partialSum += (int)(f4x * 11) + (int)(f4y * 13) + (int)(f4z * 17); // f4w * 23;
        // the +0.5 is required so that when f4w is truncated within the shader for the checksum, it still is the correct value
        float f4w = -(partialSum + 0.5) / 23.0;
        // verify it's correct
        int realSum = partialSum + (int)(f4w * 23);
        assert(realSum == 0);
        pinc_graphics_vertex_array_set_item_vec4(test_allAttributes_vertex_array, i, 3, f4x, f4y, f4z, f4w);
    }
    pinc_graphics_vertex_array_unlock(test_allAttributes_vertex_array);
}

void test_allAttributes_frame(void) {
    // randomize the vertex values
    test_allAttributes_submitVertices();
    RGBAColor color = {0, 0, 0, 1};
    // graphics fill uses channels instead of rgba
    RealColor real_color = color_to_real(color, pinc_framebuffer_format_get_channels(-1));
    pinc_graphics_fill_color(window, real_color.c1, real_color.c2, real_color.c3, real_color.c4);
    pinc_graphics_draw(window, test_allAttributes_pipeline, test_allAttributes_vertex_array, 0);
    pinc_graphics_done();
}

void test_allAttributes_deinit(void) {
    pinc_graphics_pipeline_deinit(test_allAttributes_pipeline);
    pinc_graphics_vertex_array_deinit(test_allAttributes_vertex_array);
}
