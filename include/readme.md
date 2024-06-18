# Designing the API

Pinc's graphics API does not exist yet. This serves as a reminder of what that API needs to have

Pinc's API needs to have these fundamental graphics features:
- mesh
- texture
- GLSL shaders
    - vertex and fragment for now
- the features in readme.md
- drawing to any surface & using it as a texture
    - OpenGL 2.1 does not initally appear to natively support this, however by blitting the framebuffer to a texture it is possible. (blitting happens entirely on the GPU, the CPU is not involved other than to issue the command)
    - There might also be a way to set up another framebuffer (aka a secret window) to be used directly as a texture, and make everyframebuffer secretly a window.
- drawing from just vertices
- drawing with an index buffer
    - indices with 8, 16, 32 bits

It also needs these fundamental IO features
- window presentation
- keyboard / mouse / window events

Properties / principles of the API:
- data oriented
    - state is held in objects
    - functions only interact with objects given to it in a parameter
    - The only exception is the Pinc instance (similar to a Vulkan instance or X display), since there should only ever be one of those.
- no big structures like in Vulkan
    - This is for languages like Java where creating an entire object just to be immediately discarded is insanely bad for performance and usability
    - In other words, functions (usually) only take basic types or objects that were created from other functions.
    - In order to achieve this, first create an 'incomplete object' where all of its parameters can be set, then the object can be completed into the actual thing. A complete object can often act as an incomplete one, but not the other way around.
- no raw pointers to objects - everything is a numeric ID.
    - Like with the point about info structures, this is for languages where pointers are dificult to work with or missing.
    - IDs start at 1 to maximize the variability in the bit size of an ID. 
        - Python uses an infinitely expandable data structure for integers, which means smaller numbers are generally faster to work with than larger ones.
        - JS doesn't even have integers, so using a hash would basically be a death wish upon JS users. A binding would have to convert everything to either use BigInt or string. With index-like IDs, casting to/from floats is acceptable.
    - Pointers can only be taken into Pinc functions for arrays, like creating a vertex array, index array, or string.
- Function calls are cheap, and easy. This is a similar philosophy to what OpenGL uses.
    - Sure, ABIs can get complicated, but that's the case no matter what
    - function calls do incur a cost, but it's very very small compared to what that function actually does

The basic order of events:
- init Pinc
- enter main loop (or not, what happens in and out of the loop is up to the user.)
- Optionally create drawables
    - this can happen before any windows are created, and in fact an application can be created that never opens a window.
    - First create an incomplete drawable with required parameters (width, height)
    - optionally set drawable properties (bit depth of channels)
    - complete the drawable
    - A drawable is also polymorphically also a 
- Optionally create window(s)
    - create an incomplete window with required parameters
    - set optional parameters
    - complete the window
    - the window is polymorphically also a drawable.
- Upload mesh and texture data
    - create an incomplete object with the required parameters, set any optional parameters, and complete the object
    - An existing mesh or texture can have its data modified 
- draw stuff
- swap buffers

General notes:
- This library has no equivalent to a Vertex Buffer Object like in OpenGL.
    - Instead, the pipeline defines how a buffer is interpereted as vertices
- Pinc has no such thing as a texture sampler
    - Again, this is part of the pipeline
