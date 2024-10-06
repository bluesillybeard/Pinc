# Pinc's general rendering API

NOTE: Currently in the planning phase! None of this has been implemented.

Unlike the windowing API, the graphics API is a lot more dificult to understand straight from the header file. Thus, a document describing it. In the future, there may be full documentation for every feature, but for now there simply is not enough time to do so.

Pincs's graphics API is meant to be able to run on OpenGL 2.1 while avoiding potential performance issues for newer APIs like OpenGL 3/4 or Vulkan. All while being as simple as possible and avoiding the use of pointers.

It is recommended to learn OpenGl 2.1 or something similar before using Pinc's API for now, because the documentation for Pinc does not teach any graphics programming concepts.

If you want the performance or power of something like OpenGl 4 or Vulkan, Pinc's graphics API is not the way to go. For this purpose, every pinc graphics backend has the option to use the underlying API itself. In the future, there will be graphics backends specifically for using the underlying API that have more flexibility - for example, a raw opengl backend that allows setting all of the opengl context information and creating multiple contexts like SDL.

## Features
- package all of the complex rendering steps into a simple Pipeline object
    - no need for a vertex array object or anything like that
    - no static state - although pipelines do hold state that can be modified.
- GLSL shaders
    - maximum supported version depends on graphics API
- There is a single global Renderer. This is not like SDL where you can have multiple renderers - one program, one renderer.
    - As noted before, the renderer itself holds very little state - so making multiple of them would have no use anyway

## Outline

1. create things
    - Pipeline(s)
        - this is the most complex object
        - vertex attributes
        - uniform inputs
            - texture samplers
        - shader code
            - GLSL vertex and fragment shader
        - vertex assembling settings
            - pure vertex list
            - element indexing
        - other pipeline settings
            - viewport
            - scissor rect
    - Vertex Array (buffer)
        - based on pipeline vertex attributes, but is not tied to a pipeline.
        - using a vertex array and pipeline with mismatched vertex attributes is generally a bad idea. If you want to use the same vertices between two pipelines, then the two pipelines should have the same vertex attribute layouts.
    - Element Array (buffer)
        - just a list of numbers
    - Texture
3. draw stuff
    - `pinc_graphics_draw(window, pipeline, vertexArray, elementArray, first, count)`
        - This stores a draw command to a command list
        - the state of the pipeline is copied
        - first is the first element / vertex to draw
        - count is the number of elements / vertices to draw, or 0 for the rest of the array.
    - `pinc_graphics_done()`
        - Tells pinc that you are done drawing this frame. This allows Pinc to immediately begin working on the drawing commands.
        - For best performance: step -> graphics_draw -> graphics_done -> game logic -> present framebuffers
            - This makes it easier to have the GPU and CPU doing work in parallel
            - this is usually the better option if vsync is disabled, as in that case presenting framebuffers has no impact.
        - For best latency (and still very good performance): step -> game logic -> graphics_draw -> graphics_done -> present framebuffers
            - This makes it a little harder to parallelize between the CPU and GPU, but realistically the underlying API has its own buffers and bits that will make this run just fine
        - Between step() and graphics_done(), Reading and writing to/from general GPU data (arrays, textures) is generally undefined behavior
        - Should only be called once per frame

## Quick example

This example is not so quick actually, but low-level graphics is not quick to explain.

```C
// handle to pipeline object
int pipeline;
// handle to vertex array object (not to be confused with an OpenGL vertex array object!!)
int vertexArray;
// handle to a texture
int texture;

// Initializes drawing bits. This is called right after pinc_complete_init
bool init() {
    // As a sanity check, make sure vec3 can be aligned to any 4-byte offset
    // For now, all backends can align all types to this, however in the future there may be backends that cannot do this.
    // For example, vec3 sometimes needs to be aligned to 12 or 16 bytes.
    int vec3Align = pinc_graphics_vertex_attributes_get_type_align(pinc_graphics_attribute_type_vec3);
    if(vec3Align > 4) {
        // return false to signify something went wrong
        printf("vec3 alignment is not 4 bytes!");
        return false;
    }
    // Unlike with other objects, creating a pipeline in Pinc is actually fairly involved
    // Because of how much stuff a pipeline encompasses,
    // there are a number of intermediate objects that need to be created.
    // these objects are temporary and are only used to hold configuration data,
    // although they can be reused, rebuilding them for every pipeline should have a negligible performance impact.

    // Vertex attribs do not need to be completed - they only have a complete version
    // The reason is because this object is basically just a data structure with defaults for all fields.
    // only have two attributes: position (vec3), texture coordinates (vec2)
    int vertexAttribs = pinc_graphics_vertex_attributes_create(2);
    
    
    // params: attribs, index, type, offset, normalize
    // If normalize is true, Pinc will convert int inputs into floats by dividing them by their maximum value.
    // Normalization is only valid for integer vertex inputs.
    pinc_graphics_vertex_attributes_set_item(vertexAttribs, 0, pinc_graphics_attribute_type_vec3, 0, 0);
    pinc_graphics_vertex_attributes_set_item(vertexAttribs, 1, pinc_graphics_attribute_type_vec2, 12, 0);
    // Pinc can theoretically calculate the stride based on the attribute that reaches furthest,
    // however in order to allow sparse arrays or other weird things, the stride must be set manually
    pinc_graphics_vertex_attributes_set_stride(vertexAttribs, 20);
    
    // Same thing for uniforms - although in this case they won't be reused.
    // transform and texture sampler
    int uniforms = pinc_graphics_uniforms_create(2);
    // params: uniforms, index, type
    pinc_graphics_uniforms_set_item(uniforms, 0, pinc_graphics_uniform_type_mat4x4);
    pinc_graphics_uniforms_set_item(uniforms, 1, pinc_graphics_uniform_type_texture);

    // Believe it or not, there is more to do with the uniforms.
    // Texture sampling uniforms need more information about *how* to sample the texture.
    // Unlike with other APIs, Pinc does not have a separate object for a texture sampler;
    // the information that a texture sampler provides is baked into the pipeline itself.
    // params: uniforms, index, wrapping, minFilter, magFilter, mipmap
    // wrapping is used to determine what happens when the texture coordinates are outside,
    // minFilter is what happenes when the texture needs to be scaled down,
    // magFilter is what happens when the texture needs to be scaled up
    // mipmap is a boolean (int) telling whether Pinc should expect mitmapped textures in this slot or not.
    // Note that mipmap is more of a hint than an expectation of behavior.
    // Particularly when using backends for older APIs, mipmap generally ignored.
    pinc_graphics_uniforms_set_item_texture_sampler_properties(uniforms, 1,
        pinc_graphics_texture_wrap_clamp_to_border, // Unlike OpenGL, the border color cannot be set (for now at least) and will always be black.
        pinc_graphics_filter_linear_mipmap_linear, // interpolate linearly between mipmaps and between pixels when downscaling
        pinc_graphics_filter_nearest, // don't interpolate when upscaling
        1 // use mipmaps
    );

    // Pinc uses GLSL for shaders.
    if(!pinc_graphics_shader_glsl_version_supported(1, 10, 0)) {
        printf("GLSL version 1.10.0 is not supported!")
        return false;
    }

    // like with the attributes and uniforms, this only exists to store some data.
    // it holds what kind of shaders (in this case it's GLSL) and the code for them.
    // In the future more shader types may be supported - most likely to be first is a fixed-pipeline setup like what OpenGL 1.x has.
    int shaders = pinc_graphics_shaders_create(pinc_graphics_shader_type_glsl);

    // Pinc actually forces explicit layout bindings,
    // even when using a version of GLSL that isn't even supposed to have them.
    // Pinc will process the GLSL code and extract the layout bindings.

    // When when using GLSL versions that don't support them,
    // Pinc will remove those and use the old binding location system
    // to create a map from the user-facing location (index into the list of attributes / uniforms)
    // to the 'real' location that OpenGl uses.
    char* vertexShaderCode = "\
    #version 110\n\
    layout(location=0) in vec3 pos;\n\
    layout(location=1) in vec2 uv;\n\
    layout(location=0) uniform mat4 transform;\n\
    varying vec2 _uv;\n\
    void main() {\n\
        gl_Position = vec4(pos, 1) * transform;\n\
        _uv = uv;\n\
    }\
    ";
    int vertexShaderCodeLen = strlen(vertexShaderCode);

    char* fragmentShaderCode = "\
    #version 110\n\
    layout(location=1) uniform sampler2D texture;\n\
    varying vec2 _uv;\n\
    void main() {\n\
        gl_FragColor = texture(texture, _uv);\n\
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

    // Finally, the pipeline creation can begin
    pipeline = pinc_graphics_pipeline_incomplete_create(vertexAttribs, uniforms, shaders);
    // this tells Pinc to do the equivalent of glDrawArrays with GL_TRIANGLES.
    // pinc also has array_triangle_fan, array_triangle_strip, element_triangles, element_triangle_fan, and element_triangle_strip
    // array_* does the same as glDrawArrays, element_* does the same as glDrawElements
    pinc_graphics_pipeline_set_vertex_assembly(pipeline, pinc_graphics_vertex_assembly_array_triangles);
    // There are more pipeline settings, but for the sake of demonstration they will be left as default.
    // To see the options available, search for pinc_graphics_pipeline_set_*

    pinc_graphics_pipeline_complete(pipeline);

    // The pipeline is done! Hooray!

    // All that's left is a mesh and a texture.

    // Make a basic mesh that doesn't use any elements - just a list of vertices, each set of 3 defining a triangle.
    // Even though this function takes a vertexAttribs object, the vertex array can be applied to pipelines with different vertex attributes.
    // However, applying a vertex array to a pipeline with the 'wrong' vertex attributes can cause strange and unusual effects.
    // Generally, try to avoid mismatching vertex arrays and pipelines.
    // both vertex array objects and pipeline objects hold their own copies of the vertex attributes,
    // so as a sanity check they can be retrieved and compared manually. 
    // Whether that action is done by Pinc itself depends on which graphics backend is in use.
    vertexArray = pinc_graphics_vertex_array_create(vertexAttribs, 6);

    // This tells Pinc to make the vertex array's data available for reading / writing on the CPU
    pinc_graphics_vertex_array_lock(vertexArray);

    // input length is number of vertices.
    // This is to demonstrate that the number of vertices in a vertex array can be changed after its creation
    pinc_graphics_vertex_array_set_len(vertexArray, 6);

    // params: array, vertex, attribute, value(s)
    // Triangle 1
    // bottom left
    pinc_graphics_vertex_array_set_item_vec3(vertexArray, 0, 0, -1, -1, 0);
    pinc_graphics_vertex_array_set_item_vec2(vertexArray, 0, 1, 0, 0);
    // top left
    pinc_graphics_vertex_array_set_item_vec3(vertexArray, 1, 0, -1, 1, 0);
    pinc_graphics_vertex_array_set_item_vec2(vertexArray, 1, 1, 0, 1);
    // top right
    pinc_graphics_vertex_array_set_item_vec3(vertexArray, 2, 0, 1, 1, 0);
    pinc_graphics_vertex_array_set_item_vec2(vertexArray, 2, 1, 1, 1);
    // For the sake of demonstration, use the "other" API to upload the next triangle
    float vertexData[15] = {
        // Remember the attributes:
        // vec3 pos, vec2 uv.
        // x, y, z, u, v
        // top right
        1, 1, 0, 1, 1,
        // bottom right
        1, -1, 0, 1, 0,
        // bottom left
        -1, -1, 0, 0, 0,
    };
    // TODO: figure out endianness more robustly
    // Every graphics API in history seems to use the native CPU endianness
    // I find that rather odd as both ARM and X86 CPUs need to support the same GPUs
    // Maybe all modern GPUs support both big and little endianness?
    // Perhaps all modern operating systems running on ARM use little endian mode?
    // Does the same hold true for PowerPC?
    // Anyway, this type pun cast appears to be safe under all circumstances.
    // Also remember, in C all arrays are pointers for some reason.
    char* rawVertexData = (char*)vertexData;
    for(int i=0; i<15*4; ++i) {
        // params: array, index, value
        pinc_graphics_vertex_array_set_byte(vertexArray, 15 * 4 + i, rawVertexData[i]);
    }

    // A locked vertex array cannot be used for any GPU operations (like drawing), so it needs to be locked once the data is ready for the GPU
    pinc_graphics_vertex_array_unlock(vertexArray);

    // make a 8 x 8 texture.
    // there are many texture formats available, but for the sake of keeping things simple, we will only use 8bpp rgba.
    // params: format, width, height
    texture = pinc_graphics_texture_create(pinc_texture_format_r8g8b8a8, 8, 8);

    // Like with a vertex array, the data needs to be locked before being read or written
    pinc_graphics_texture_lock(texture);

    // A texture's size can be modified after creation. That is not demonstrated.
    // set the texture data
    for(int x=0; x<8; ++x) {
        for(int y=0; y<8; ++y) {
            // All pinc graphics apis, when taking about a color, take four color channels.
            // What those channel means depends on what is recieving the color.
            // This makes an alternating pattern of black and magenta pixels assuming an RGB or RGBA color format.
            pinc_graphics_texture_set_pixel(texture, x, y, (x + y) & 1, (x + y) & 1, 0, 1);
        }
    }

    // Calling this function is optional, however the default is to not make any mipmaps when unlocking the texture.
    // texture, use mipmaps (1 -> true, 0 -> false), mipmap levels (or 0 for auto), mipmap filter
    pinc_graphics_texture_update_mipmaps(texture, 1, 0, pinc_filter_linear);
    pinc_graphics_texture_unlock(texture);

    // This is everything needed!
    // Technically everything other than a pipeline is "optional" in the sense that something can be drawn with only a pipeline.
    // The vertices can be baked into the vertex shader and one can use vertex colors instead of a texture.
    // But this is a demonstration of all of Pinc's main features.
    // A pipeline, vertex array, and texture have all been made.
    // Pinc also supports using an element buffer for something like what glDrawElements provides,
    // however, for the sake of keeping things simpler when reasonable, that was left out of the example.

    // Clean up those temporary objects
    pinc_graphics_shaders_deinit(shaders);
    pinc_graphics_uniforms_deinit(uniforms);
    pinc_graphics_vertex_attributes_deinit(vertexAttribs);
}
// Submits all of the draw commands for this frame.
// Runs right after pinc_step() is called
void draw() {
    // transform is defined elsewhere
    pinc_graphics_pipeline_set_uniform_mat4x4(pipeline, 0, transform);
    pinc_graphics_pipeline_set_uniform_texture(pipeline, 1, texture);
    // Window is defined outside of this example code
    // Since the pipeline is set to use pinc_vertex_assembly_element_array_triangles, no element buffer is provided.
    pinc_graphics_draw(window, pipeline, vertexArray, 0);

    // That was the only draw.
    pinc_graphics_done();

    // presenting the framebuffer is done elsewhere.
}
```
