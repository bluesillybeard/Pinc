// Raw opengl example

#define PINC_RAW_OPENGL
#include <pinc.h>
#include <stdio.h>
#include <string.h>
// The application can't link against OpenGL directly due to how Pinc works
// (well, it can, it's just not recomended)
// The header is only used to get type declarations,
// functions have to be loaded manually.
#include <GL/gl.h>

// declare stuff
int collect_errors(void);

/// @brief You know what main is. At least, I hope you know what main is...
int main(int argc, char** argv) {
    pinc_incomplete_init();
    // The window backends to allow
    const int supported_window_backends[2] = {
        // Prioritize using SDL2
        pinc_window_backend_sdl2,
        // If SDL2 isn't available, use whatever
        pinc_window_backend_any,
    };
    // Select a backend
    int window_backend_found = 0;
    for (int i=0; i<2; ++i) {
        int backend = supported_window_backends[i];
        // TODO: eventually, Pinc will have a way to ask if a backend supports OpenGL without having to init it first.
        // The only reason this is guaranteed to work is because the only implemented window backend supports OpenGL
        if(pinc_window_backend_is_supported(backend)) {
            pinc_init_set_window_backend(backend);
            window_backend_found = 1;
            if(collect_errors()) {
                return 255;
            }
            break;
        }
    }
    if(!window_backend_found) {
        // This will actually never happen, but I probably should remind you that this is a demonstrative example, not an actual application.
        printf("Pinc window example: Could not find a window backend to use\n");
        return 255;
    }
    // Do the same thing with the graphics backends.
    const int supported_graphics_backends[2] = {
        // Only allow legacy OpenGL (to use the deprecated glBegin / glEnd functions)
        pinc_graphics_backend_opengl_2_1,
    };
    int graphics_backend_found = 0;
    for (int i=0; i<2; ++i) {
        int backend = supported_graphics_backends[i];
        if(pinc_graphics_backend_is_supported(backend)) {
            pinc_init_set_graphics_backend(backend);
            graphics_backend_found = 1;
            if(collect_errors()) {
                return 255;
            }
            break;
        }
    }
    if(!graphics_backend_found) {
        printf("Pinc window example: Could not find a graphics backend to use\n");
        return 255;
    }
    // Choose a framebuffer format
    // only allow RGB or RGBA framebuffers.
    // OpenGL itself will only allow RGB framebuffers, but it's good to be explicit.
    int num_framebuffer_formats = pinc_framebuffer_format_get_num();
    if(num_framebuffer_formats == 0) {
        printf("Pinc window example: There are no framebuffer formats available!\n");
        return 255;
    }
    int best_framebuffer_format = 0;
    int best_framebuffer_format_channels = 0;
    int best_framebuffer_format_color_bits = 0;
    for(int i=0; i<num_framebuffer_formats; ++i) {
        int framebuffer_channels = pinc_framebuffer_format_get_channels(i);
        if(framebuffer_channels < 3) continue;
        int framebuffer_color_bits = pinc_framebuffer_format_get_bit_depth(i, 0) + pinc_framebuffer_format_get_bit_depth(i, 1) + pinc_framebuffer_format_get_bit_depth(i, 2);
        if(i == 0 || best_framebuffer_format_channels < 3 || best_framebuffer_format_color_bits < framebuffer_color_bits) {
            best_framebuffer_format = i;
            best_framebuffer_format_channels = framebuffer_channels;
            best_framebuffer_format_color_bits = framebuffer_color_bits;
        }
    }
    if(best_framebuffer_format_channels < 3) {
        printf("Pinc window example: There are no RGB or RGBA framebuffer formats available!\n");
        return 255;
    }
    int best_framebuffer_format_alpha_bits = 0;
    if(best_framebuffer_format_channels == 4) {
        best_framebuffer_format_alpha_bits = pinc_framebuffer_format_get_bit_depth(best_framebuffer_format, 3);
    }
    pinc_complete_init();
    // init may trigger fatal errors
    // If a fatal error occurs, any other calls to Pinc (other than deinit) will assert false.
    if(collect_errors()) {
        return 255;
    }
    // Now that pinc is initialized, let's open a window.
    int window = pinc_window_incomplete_create();
    // Setting all of these is optional, but set them anyway for demonstration
    char* title = "Pinc OpenGL example";
    int len = strlen(title);
    // In the future, there will be a more ergonomic method to set the title of a window.
    // But for now this is the only way, as the pinc public API does not allow pointers for required functions
    pinc_window_set_title_length(window, len);
    for(int i=0; i<len; ++i) {
        pinc_window_set_title_item(window, i, title[i]);
    }
    pinc_window_complete(window);
    // complete may trigger fatal errors
    if(collect_errors()) {
        return 255;
    }
    // There is only one window and one thread, so this only needs to be called once at the start.
    pinc_raw_opengl_make_current(window);
    // Now, grab the required OpenGL functiosn
    // In a 'real' application, one should create a more robust function loader than just a bunch of local variables.
    // Since this is just a demonstration, this is everything needed.
    // Due to how C works, these override the functions from the header.
    void (GLAPIENTRYP glClearColor)(GLclampf red, GLclampf green, GLclampf blue, GLclampf alpha) = pinc_raw_opengl_get_proc("glClearColor");
    void (GLAPIENTRYP glClear)(GLbitfield flags) = pinc_raw_opengl_get_proc("glClear");
    void (GLAPIENTRYP glBegin)(GLenum mode) = pinc_raw_opengl_get_proc("glBegin");
    void (GLAPIENTRYP glEnd)(void) = pinc_raw_opengl_get_proc("glEnd");
    void (GLAPIENTRYP glVertex2f)(GLfloat x, GLfloat y) = pinc_raw_opengl_get_proc("glVertex2f");
    void (GLAPIENTRYP glColor4f)(GLfloat red, GLfloat green, GLfloat blue, GLfloat alpha) = pinc_raw_opengl_get_proc("glColor4f");
    void (GLAPIENTRYP glViewport)(GLint x, GLint y, GLsizei width, GLsizei height) = pinc_raw_opengl_get_proc("glViewport");
    // Set the viewport before the main loop because it's currently the wrong size.
    // The reason for this is due to a strange quirk of how Pinc works under the hood.
    // It ultimately stems from the fact that a window is often required to make an OpenGL context,
    // and the temp window Pinc uses is the wrong size.
    glViewport(0, 0, pinc_window_get_width(window), pinc_window_get_height(window));
    // Finally, the main loop
    int running = 1;
    while(running) {
        pinc_step();
        // collect events
        if(pinc_event_window_closed(window)) {
            running = 0;
            break;
        }
        if(pinc_event_window_resized(window)) {
            glViewport(0, 0, pinc_window_get_width(window), pinc_window_get_height(window));
        }
        // Draw a triangle with OpenGL.
        glClearColor(0, 0, 0, 1);
        glClear(GL_COLOR_BUFFER_BIT);
        glBegin(GL_TRIANGLES);
            glColor4f(1.0, 0.0, 0.0, 1.0);
            glVertex2f(-0.5, -0.5);
            glColor4f(0.0, 1.0, 0.0, 1.0);
            glVertex2f(-0.5, 0.5);
            glColor4f(0.0, 0.0, 1.0, 1.0);
            glVertex2f(0.5, 0.5);
        glEnd();
        pinc_window_present_framebuffer(window, 1);
        // It is good practice to collect errors after each frame
        if(collect_errors()) {
            return 255;
        }
    }
    // No need to clean up the window or anything, Pinc will do that automatically.
    pinc_deinit();
}

/// @brief Collects errors from Pinc and prints them out.
/// @return 1 if there was a fatal error, 0 if not.
int collect_errors(void) {
    int had_fatal = 0;
    int num_errors = pinc_error_get_num();
    for(int i=0; i<num_errors; ++i) {
        int fatal = pinc_error_peek_fatal();
        if(fatal) had_fatal = 1;
        char buffer[1024] = {0};
        int len = pinc_error_peek_message_length();
        if(len > 1023) len = 1023;
        for(int bi=0; bi<len; ++bi) {
            buffer[bi] = pinc_error_peek_message_byte(bi);
        }
        buffer[len] = 0; //Pinc does not give us a null byte, but printf needs it.
        if(fatal) {
            printf("Fatal pinc error: %s\n", &buffer);
        } else {
            printf("pinc error: %s\n", &buffer);
        }
        pinc_error_pop();
    }
    return had_fatal;
}
