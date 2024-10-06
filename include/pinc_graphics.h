#include "pinc.h"

// header guard
#ifndef PINC_GRAPHICS_HEADER_GUARD
#define PINC_GRAPHICS_HEADER_GUARD

/// @section graphics

// see graphics.md

// TODO: the enire graphics section is in need of documentation

/// @subsection graphics enums

enum pinc_graphics_attribute_type {
    pinc_graphics_attribute_type_float,
    pinc_graphics_attribute_type_vec2,
    pinc_graphics_attribute_type_vec3,
    pinc_graphics_attribute_type_vec4,
    // 4 byte integer
    pinc_graphics_uniform_type_int,
    pinc_graphics_uniform_type_ivec2,
    pinc_graphics_uniform_type_ivec3,
    pinc_graphics_uniform_type_ivec4,
    // 2 byte integer
    pinc_graphics_uniform_type_short,
    pinc_graphics_uniform_type_svec2,
    pinc_graphics_uniform_type_svec3,
    pinc_graphics_uniform_type_svec4,
    // 1 byte integer
    pinc_graphics_uniform_type_byte,
    pinc_graphics_uniform_type_bvec2,
    pinc_graphics_uniform_type_bvec3,
    pinc_graphics_uniform_type_bvec4,
};

enum pinc_graphics_uniform_type {
    pinc_graphics_uniform_type_float,
    pinc_graphics_uniform_type_vec2,
    pinc_graphics_uniform_type_vec3,
    pinc_graphics_uniform_type_vec4,
    pinc_graphics_uniform_type_int,
    pinc_graphics_uniform_type_ivec2,
    pinc_graphics_uniform_type_ivec3,
    pinc_graphics_uniform_type_ivec4,
    pinc_graphics_uniform_type_mat2x2,
    pinc_graphics_uniform_type_mat3x3,
    pinc_graphics_uniform_type_mat4x4,
    pinc_graphics_uniform_type_texture,
};

enum pinc_graphics_texture_wrap {
    pinc_graphics_texture_wrap_clamp,
    pinc_graphics_texture_wrap_clamp_to_edge,
    pinc_graphics_texture_wrap_clamp_to_border,
    pinc_graphics_texture_wrap_repeat,
    pinc_graphics_texture_wrap_mirrored_repeat,
};

enum pinc_graphics_filter {
    pinc_graphics_filter_nearest,
    pinc_graphics_filter_linear,
    pinc_graphics_filter_nearest_mipmap_nearest,
    pinc_graphics_filter_nearest_mipmap_linear,
    pinc_graphics_filter_linear_mipmap_nearest,
    pinc_graphics_filter_linear_mipmap_linear,
};

enum pinc_graphics_shader_type {
    pinc_graphics_shader_type_glsl,
};

enum pinc_graphics_vertex_assembly {
    pinc_vertex_assembly_array_triangles,
    pinc_vertex_assembly_array_triangle_fan,
    pinc_vertex_assembly_array_triangle_strip,
    pinc_vertex_assembly_element_triangles,
    pinc_vertex_assembly_element_triangle_fan,
    pinc_vertex_assembly_element_triangle_strip,
};

/// @subsection Graphics capibilities querying

// Get alignment of an attribute type
PINC_API int PINC_CALL pinc_graphics_vertex_attributes_type_align(int type);

// get the maximum number of vertex attributes allowed
PINC_API int PINC_CALL pinc_graphics_vertex_attributes_max_num();

// get the maximum number of uniforms on a single pipeline
PINC_API int PINC_CALL pinc_graphics_uniforms_max_num();

// get the maximum width / height of a texture
PINC_API int PINC_CALL pinc_graphics_texture_max_size();

// Query if a GLSL version is available
PINC_API int PINC_CALL pinc_graphics_shader_glsl_version_supported(int major, int minor, int patch);

/// @subsection Graphics initialization functions

// make a vertex attributes object
PINC_API int PINC_CALL pinc_graphics_vertex_attributes_create(int num);

// Set a vertex attributes
PINC_API void PINC_CALL pinc_graphics_vertex_attributes_set_item(int vertex_attributes_obj, int index, int type, int offset, int normalize);

// set the stride of a vertex attributes
PINC_API void PINC_CALL pinc_graphics_vertex_attributes_set_stride(int vertex_attributes_obj, int stride);

// create a uniforms object
PINC_API int PINC_CALL pinc_graphics_uniforms_create(int num);

// set the type of a uniform
PINC_API void PINC_CALL pinc_graphics_uniforms_set_item(int uniforms_obj, int index, int type);

// for a texture uniform, how should the texture be sampled? By default, it will use nearest for the min and mag filter.
PINC_API void PINC_CALL pinc_graphics_uniforms_set_item_texture_sampler_properties(int uniforms_obj, int index, int wrap, int min_filter, int mag_filter, int mipmap);

PINC_API int PINC_CALL pinc_graphics_shaders_create(int type);

PINC_API void PINC_CALL pinc_graphics_shaders_glsl_vertex_set_len(int shaders_obj, int len);

PINC_API void PINC_CALL pinc_graphics_shaders_glsl_vertex_set_item(int shaders_obj, int index, char item);

PINC_API void PINC_CALL pinc_graphics_shaders_glsl_fragment_set_len(int shaders_obj, int len);

PINC_API void PINC_CALL pinc_graphics_shaders_glsl_fragment_set_item(int shaders_obj, int index, char item);

PINC_API int PINC_CALL pinc_graphics_pipeline_incomplete_create(int vertex_attributes_obj, int uniforms, int shaders);

PINC_API void PINC_CALL pinc_graphics_pipeline_set_vertex_assembly(int pipeline_obj, int assembly);

PINC_API void PINC_CALL pinc_graphics_pipeline_complete(int pipeline_obj);

PINC_API int PINC_CALL pinc_graphics_vertex_array_create(int vertex_attributes_obj, int num);

PINC_API void PINC_CALL pinc_graphics_vertex_array_lock(int vertex_array_obj);

PINC_API void PINC_CALL pinc_graphics_vertex_array_set_len(int vertex_array_obj);

PINC_API void PINC_CALL pinc_graphics_vertex_array_set_item_float(int vertex_array_obj, int vertex, int attribute, float v);
PINC_API void PINC_CALL pinc_graphics_vertex_array_set_item_vec2(int vertex_array_obj, int vertex, int attribute, float v1, float v2);
PINC_API void PINC_CALL pinc_graphics_vertex_array_set_item_vec3(int vertex_array_obj, int vertex, int attribute, float v1, float v2, float v3);
PINC_API void PINC_CALL pinc_graphics_vertex_array_set_item_vec4(int vertex_array_obj, int vertex, int attribute, float v1, float v2, float v3, float v4);
PINC_API void PINC_CALL pinc_graphics_vertex_array_set_item_int(int vertex_array_obj, int vertex, int attribute, int v1);
PINC_API void PINC_CALL pinc_graphics_vertex_array_set_item_ivec2(int vertex_array_obj, int vertex, int attribute, int v1, int v2);
PINC_API void PINC_CALL pinc_graphics_vertex_array_set_item_ivec3(int vertex_array_obj, int vertex, int attribute, int v1, int v2, int v3);
PINC_API void PINC_CALL pinc_graphics_vertex_array_set_item_ivec4(int vertex_array_obj, int vertex, int attribute, int v1, int v2, int v3, int v4);
PINC_API void PINC_CALL pinc_graphics_vertex_array_set_item_short(int vertex_array_obj, int vertex, int attribute, short v1);
PINC_API void PINC_CALL pinc_graphics_vertex_array_set_item_svec2(int vertex_array_obj, int vertex, int attribute, short v1, short v2);
PINC_API void PINC_CALL pinc_graphics_vertex_array_set_item_svec3(int vertex_array_obj, int vertex, int attribute, short v1, short v2, short v3);
PINC_API void PINC_CALL pinc_graphics_vertex_array_set_item_svec4(int vertex_array_obj, int vertex, int attribute, short v1, short v2, short v3, short v4);
PINC_API void PINC_CALL pinc_graphics_vertex_array_set_item_byte(int vertex_array_obj, int vertex, int attribute, char v1);
PINC_API void PINC_CALL pinc_graphics_vertex_array_set_item_bvec2(int vertex_array_obj, int vertex, int attribute, char v1, char v2);
PINC_API void PINC_CALL pinc_graphics_vertex_array_set_item_bvec3(int vertex_array_obj, int vertex, int attribute, char v1, char v2, char v3);
PINC_API void PINC_CALL pinc_graphics_vertex_array_set_item_bvec4(int vertex_array_obj, int vertex, int attribute, char v1, char v2, char v3, char v4);

PINC_API void PINC_CALL pinc_graphics_vertex_array_set_byte(int vertex_array_obj, int index, char byte);

PINC_API void PINC_CALL pinc_graphics_vertex_array_unlock(int vertex_array_obj);

/// @subsection Graphics draw functions

// TODO: once this header is incorperated into the main header, deduplicate these from the main header

// TODO: doc
PINC_API void PINC_CALL pinc_graphics_fill_color(int window, float c1, float c2, float c3, float c4);

// TODO: doc
PINC_API void PINC_CALL pinc_graphics_fill_depth(int window, float depth);

#endif
