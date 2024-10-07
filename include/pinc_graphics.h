#include "pinc.h"

// header guard
#ifndef PINC_GRAPHICS_HEADER_GUARD
#define PINC_GRAPHICS_HEADER_GUARD

/// @section graphics

// see graphics.md

// NOTE: The graphics API is *highly* experimental at the moment. Using OpenGL 2.1 directly is recommended.

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

// there are an actual ton of texture formats
// This is essentially an enumeration of every possible combination of type and format that OpenGL can take,
// with some options strategically removed.
// This is not used in the API yet, as these types are meant to describe how the data is laid out in-memory before being converted to the GPU format and uploaded.
// The current API has no understanding of the memory layout of a texture on the CPU, as right now textures are a GPU-only construct.
// This type was created ahead of time in hope of a raw-memory CPU representation of textures being available in the future.
// general format (per channel): [r = red, g = green, b = blue a = alpha, l = luminance][u = unsigned integer, i = signed integer, f = float][number of bits]
enum pinc_graphics_source_texture_format {
    // enumerated / "standard" formats
    pinc_graphics_source_texture_format_ru8,
    pinc_graphics_source_texture_format_gu8,
    pinc_graphics_source_texture_format_bu8,
    pinc_graphics_source_texture_format_au8,
    pinc_graphics_source_texture_format_ru8gu8bu8,
    pinc_graphics_source_texture_format_ru8gu8bu8au8,
    pinc_graphics_source_texture_format_bu8gu8ru8,
    pinc_graphics_source_texture_format_bu8gu8ru8au8,
    pinc_graphics_source_texture_format_lu8,
    pinc_graphics_source_texture_format_lu8au8,
    pinc_graphics_source_texture_format_ri8,
    pinc_graphics_source_texture_format_gi8,
    pinc_graphics_source_texture_format_bi8,
    pinc_graphics_source_texture_format_ai8,
    pinc_graphics_source_texture_format_ri8gi8bi8,
    pinc_graphics_source_texture_format_ri8gi8bi8ai8,
    pinc_graphics_source_texture_format_bi8gi8ri8,
    pinc_graphics_source_texture_format_bi8gi8ri8ai8,
    pinc_graphics_source_texture_format_li8,
    pinc_graphics_source_texture_format_li8ai8,
    pinc_graphics_source_texture_format_ru16,
    pinc_graphics_source_texture_format_gu16,
    pinc_graphics_source_texture_format_bu16,
    pinc_graphics_source_texture_format_au16,
    pinc_graphics_source_texture_format_ru16gu16bu16,
    pinc_graphics_source_texture_format_ru16gu16bu16au16,
    pinc_graphics_source_texture_format_bu16gu16ru16,
    pinc_graphics_source_texture_format_bu16gu16ru16au16,
    pinc_graphics_source_texture_format_lu16,
    pinc_graphics_source_texture_format_lu16au16,
    pinc_graphics_source_texture_format_ri16,
    pinc_graphics_source_texture_format_gi16,
    pinc_graphics_source_texture_format_bi16,
    pinc_graphics_source_texture_format_ai16,
    pinc_graphics_source_texture_format_ri16gi16bi16,
    pinc_graphics_source_texture_format_ri16gi16bi16ai16,
    pinc_graphics_source_texture_format_bi16gi16ri16,
    pinc_graphics_source_texture_format_bi16gi16ri16ai16,
    pinc_graphics_source_texture_format_li16,
    pinc_graphics_source_texture_format_li16ai16,
    pinc_graphics_source_texture_format_ru32,
    pinc_graphics_source_texture_format_gu32,
    pinc_graphics_source_texture_format_bu32,
    pinc_graphics_source_texture_format_au32,
    pinc_graphics_source_texture_format_ru32gu32bu32,
    pinc_graphics_source_texture_format_ru32gu32bu32au32,
    pinc_graphics_source_texture_format_bu32gu32ru32,
    pinc_graphics_source_texture_format_bu32gu32ru32au32,
    pinc_graphics_source_texture_format_lu32,
    pinc_graphics_source_texture_format_lu32au32,
    pinc_graphics_source_texture_format_ri32,
    pinc_graphics_source_texture_format_gi32,
    pinc_graphics_source_texture_format_bi32,
    pinc_graphics_source_texture_format_ai32,
    pinc_graphics_source_texture_format_ri32gi32bi32,
    pinc_graphics_source_texture_format_ri32gi32bi32ai32,
    pinc_graphics_source_texture_format_bi32gi32ri32,
    pinc_graphics_source_texture_format_bi32gi32ri32ai32,
    pinc_graphics_source_texture_format_li32,
    pinc_graphics_source_texture_format_li32ai32,
    pinc_graphics_source_texture_format_rf32,
    pinc_graphics_source_texture_format_gf32,
    pinc_graphics_source_texture_format_bf32,
    pinc_graphics_source_texture_format_af32,
    pinc_graphics_source_texture_format_rf32gf32bf32,
    pinc_graphics_source_texture_format_rf32gf32bf32af32,
    pinc_graphics_source_texture_format_bf32gf32rf32,
    pinc_graphics_source_texture_format_bf32gf32rf32af32,
    pinc_graphics_source_texture_format_lf32,
    pinc_graphics_source_texture_format_lf32af32,
    // special formats
    pinc_graphics_source_texture_format_ru3gu3bu2,
    pinc_graphics_source_texture_format_bu3gu3ru2,
    pinc_graphics_source_texture_format_ru2gu3bu3,
    pinc_graphics_source_texture_format_bu2gu3ru3,
    pinc_graphics_source_texture_format_ru5gu6bu5,
    pinc_graphics_source_texture_format_bu5gu6ru5,
    pinc_graphics_source_texture_format_ru4gu4bu4au4,
    pinc_graphics_source_texture_format_au4bu4gu4ru4,
    pinc_graphics_source_texture_format_ru10gu10bu10au2,
    pinc_graphics_source_texture_format_au2bu10gu10ru10,
    // the most special format - this one is meant to be a high-depth interchange format for converting between formats.
    pinc_graphics_source_texture_format_rf64gf64bf64af64,
};

// These values DO NOT MATCH int channels from framebuffer formats.
// these are for textures.
enum pinc_graphics_channels_enum {
    pinc_graphics_channels_alpha,
    pinc_graphics_channels_luminance,
    pinc_graphics_channels_luminance_alpha,
    pinc_graphics_channels_rgb,
    pinc_graphics_channels_rgba,
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

PINC_API void PINC_CALL pinc_graphics_vertex_attributes_deinit(int vertex_attributes);

// Set a vertex attributes
PINC_API void PINC_CALL pinc_graphics_vertex_attributes_set_item(int vertex_attributes_obj, int index, int type, int offset, int normalize);

// set the stride of a vertex attributes
PINC_API void PINC_CALL pinc_graphics_vertex_attributes_set_stride(int vertex_attributes_obj, int stride);

// create a uniforms object
PINC_API int PINC_CALL pinc_graphics_uniforms_create(int num);

PINC_API void PINC_CALL pinc_graphics_uniforms_deinit(int uniforms);

// set the type of a uniform
PINC_API void PINC_CALL pinc_graphics_uniforms_set_item(int uniforms_obj, int index, int type);

// for a texture uniform, how should the texture be sampled? By default, it will use nearest for the min and mag filter.
PINC_API void PINC_CALL pinc_graphics_uniforms_set_item_texture_sampler_properties(int uniforms_obj, int index, int wrap, int min_filter, int mag_filter, int mipmap);

PINC_API int PINC_CALL pinc_graphics_shaders_create(int type);

PINC_API void PINC_CALL pinc_graphics_shaders_deinit(int shaders);

PINC_API void PINC_CALL pinc_graphics_shaders_glsl_vertex_set_len(int shaders_obj, int len);

PINC_API void PINC_CALL pinc_graphics_shaders_glsl_vertex_set_item(int shaders_obj, int index, char item);

PINC_API void PINC_CALL pinc_graphics_shaders_glsl_fragment_set_len(int shaders_obj, int len);

PINC_API void PINC_CALL pinc_graphics_shaders_glsl_fragment_set_item(int shaders_obj, int index, char item);

PINC_API int PINC_CALL pinc_graphics_pipeline_incomplete_create(int vertex_attributes_obj, int uniforms, int shaders);

PINC_API void PINC_CALL pinc_graphics_pipeline_set_vertex_assembly(int pipeline_obj, int assembly);

PINC_API void PINC_CALL pinc_graphics_pipeline_complete(int pipeline_obj);

PINC_API void PINC_CALL pinc_graphics_pipeline_deinit(int pipeline);

PINC_API int PINC_CALL pinc_graphics_vertex_array_create(int vertex_attributes_obj, int num);

PINC_API void PINC_CALL pinc_graphics_vertex_array_deinit(int vertex_array);

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

PINC_API int PINC_CALL pinc_graphics_texture_create(int channels_enum, int width, int height, int depth1, int depth2, int depth3, int depth4);

PINC_API void PINC_CALL pinc_graphics_texture_deinit(int texture);

PINC_API void PINC_CALL pinc_graphics_texture_lock(int texture_obj);

PINC_API void PINC_CALL pinc_graphics_texture_set_pixel(int texture_obj, int x, int y, float c1, float c2, float c3, float c4);

PINC_API void PINC_CALL pinc_graphics_texture_update_mipmaps(int texture_obj, int mipmap, int levels, int filter);

PINC_API void PINC_CALL pinc_graphics_texture_unlock(int texture_obj);

/// @subsection Graphics draw functions

// TODO: once this header is incorperated into the main header, deduplicate these from the main header

// TODO: doc
PINC_API void PINC_CALL pinc_graphics_fill_color(int window, float c1, float c2, float c3, float c4);

// TODO: doc
PINC_API void PINC_CALL pinc_graphics_fill_depth(int window, float depth);

PINC_API void PINC_CALL pinc_graphics_draw(int window, int pipeline_obj, int vertex_array_obj, int element_array_obj);

PINC_API void PINC_CALL pinc_graphics_done();

#endif
