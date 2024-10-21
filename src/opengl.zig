const gl = @import("ext/gl21load.zig");
const pinc = @import("pinc.zig");
const std = @import("std");

pub const Opengl21GraphicsBackend = struct {
    pub fn init(this: *Opengl21GraphicsBackend) void {
        _ = this;
    }

    // This shouldn't be required, but for some reason Zig complains when we try to give gl.load the window backend glGetProc function directly
    pub fn loadProcFnGl(b: pinc.IWindowBackend, name: [:0]const u8) ?*anyopaque {
        return b.glGetProc(name);
    }

    pub fn prepareFramebuffer(this: *Opengl21GraphicsBackend, framebuffer: pinc.FramebufferFormat) void {
        _ = this;
        _ = framebuffer;
        // This seems like a decent function in which to load the OpenGL procs
        // TODO: error instead of unreachable on load error
        gl.load(pinc.state.set_graphics_backend.windowBackend, loadProcFnGl) catch unreachable;
    }

    pub fn deinit(this: *Opengl21GraphicsBackend) void {
        pinc.allocator.?.destroy(this);
    }

    pub fn step(this: *Opengl21GraphicsBackend) void {
        _ = this;
    }

    pub fn fillColor(this: *Opengl21GraphicsBackend, window: pinc.ICompleteWindow, c1: f32, c2: f32, c3: f32, c4: f32) void {
        _ = this;
        window.glMakeCurrent();
        // Due to reasons, Some OpenGL state needs to be reset
        gl.viewport(0, 0, @intCast(window.getWidth()), @intCast(window.getHeight()));
        const color = pinc.state.getFramebufferFormat().?.channelsToRgbaColor(c1, c2, c3, c4);
        gl.clearColor(color.r, color.g, color.b, color.a);
        gl.clear(gl.COLOR_BUFFER_BIT);
    }

    pub fn fillDepth(this: *Opengl21GraphicsBackend, window: pinc.ICompleteWindow, c1: f32) void {
        _ = this;
        window.glMakeCurrent();
        // Due to reasons, Some OpenGL state needs to be reset
        gl.viewport(0, 0, @intCast(window.getWidth()), @intCast(window.getHeight()));
        gl.clearDepth(c1);
        gl.clear(gl.DEPTH_BUFFER_BIT);
    }

    pub fn createPipeline(this: *Opengl21GraphicsBackend, initData: pinc.PipelineInitData) ?pinc.IPipeline {
        _ = this;
        // grab the data needed to build the pipeline with OpenGL
        const assembly = initData.assembly;
        const shaderSources = &pinc.refObject(initData.shadersObj).shaders;
        // The uniforms and vertex attributes will be kept, but the original references may be modified.
        // SO they need to be deep copied. Technically all of their memory is inline, but that may not always be true in the future.
        const uniforms = pinc.refObject(initData.uniformsObj).uniforms.copy();
        const attributes = pinc.refObject(initData.vertexAttribsObj).vertexAttributes.copy();
        // the vertex attributes needs to have the same number of entries as the attribute binding map.
        if (shaderSources.glsl.numAttributeMaps != attributes.numAttribs) unreachable;
        // We need an OpenGL context, but don't care what window to use
        pinc.state.getWindowBackend().?.glMakeAnyCurrent();

        // Make the OpenGL shader program
        const vertexShader = gl.createShader(gl.VERTEX_SHADER);
        defer gl.deleteShader(vertexShader);
        const vStringLen: gl.GLint = @intCast(shaderSources.glsl.vertexSource.len);
        gl.shaderSource(vertexShader, 1, &shaderSources.glsl.vertexSource.ptr, &vStringLen);
        gl.compileShader(vertexShader);
        var vCompileStatus: gl.GLint = undefined;
        gl.getShaderiv(vertexShader, gl.COMPILE_STATUS, &vCompileStatus);
        var vInfoLogLen: gl.GLint = undefined;
        gl.getShaderiv(vertexShader, gl.INFO_LOG_LENGTH, &vInfoLogLen);
        if (vInfoLogLen > 0) {
            // the info log exists, get it and report it
            const shaderLogMem = pinc.allocator.?.alloc(u8, @intCast(vInfoLogLen)) catch unreachable;
            defer pinc.allocator.?.free(shaderLogMem);
            gl.getShaderInfoLog(vertexShader, vInfoLogLen, null, shaderLogMem.ptr);
            if (vCompileStatus == gl.FALSE) {
                // Error occured!
                pinc.pushError(true, .any, "OpenGL 2.1 Backend: Vertex Shader Compilation Failed: {s}", .{shaderLogMem});
                return null;
            } else {
                pinc.pushError(false, .any, "OpenGL 2.1 Backend: Vertex Shader Compilation: {s}", .{shaderLogMem});
            }
        }
        if (vCompileStatus == gl.FALSE) {
            // Error occured without an info log!
            pinc.pushError(true, .any, "OpenGL 2.1 Backend: Vertex Shader Compilation Failed for an unknown reason!", .{});
        }
        // hmm, I don't remember doing shaders in OpenGL being *this* complex.
        const fragmentShader = gl.createShader(gl.FRAGMENT_SHADER);
        defer gl.deleteShader(fragmentShader);
        const fStringLen: gl.GLint = @intCast(shaderSources.glsl.fragmentSource.len);
        gl.shaderSource(fragmentShader, 1, &shaderSources.glsl.fragmentSource.ptr, &fStringLen);
        gl.compileShader(fragmentShader);
        var fCompileStatus: gl.GLint = undefined;
        gl.getShaderiv(fragmentShader, gl.COMPILE_STATUS, &fCompileStatus);
        var fInfoLogLen: gl.GLint = undefined;
        gl.getShaderiv(fragmentShader, gl.INFO_LOG_LENGTH, &fInfoLogLen);
        if (fInfoLogLen > 0) {
            // the info log exists, get it and report it
            const shaderLogMem = pinc.allocator.?.alloc(u8, @intCast(fInfoLogLen)) catch unreachable;
            defer pinc.allocator.?.free(shaderLogMem);
            gl.getShaderInfoLog(fragmentShader, fInfoLogLen, null, shaderLogMem.ptr);
            if (fCompileStatus == gl.FALSE) {
                // Error occured!
                pinc.pushError(true, .any, "OpenGL 2.1 Backend: Fragment Shader Compilation Failed: {s}", .{shaderLogMem});
                return null;
            } else {
                pinc.pushError(false, .any, "OpenGL 2.1 Backend: Fragment Shader Compilation: {s}", .{shaderLogMem});
            }
        }
        if (fCompileStatus == gl.FALSE) {
            // Error occured without an info log!
            pinc.pushError(true, .any, "OpenGL 2.1 Backend: Fragment Shader Compilation Failed for an unknown reason!", .{});
        }
        // Finally, after all of that faffing about, the program can be linked.
        const program = gl.createProgram();
        gl.attachShader(program, vertexShader);
        defer gl.detachShader(program, vertexShader);
        gl.attachShader(program, fragmentShader);
        defer gl.detachShader(program, fragmentShader);
        gl.linkProgram(program);
        var linkStatus: gl.GLint = undefined;
        gl.getProgramiv(program, gl.LINK_STATUS, &linkStatus);
        var pInfoLogLen: gl.GLint = undefined;
        gl.getProgramiv(program, gl.INFO_LOG_LENGTH, &pInfoLogLen);
        if (pInfoLogLen > 0) {
            // the info log exists, get it and report it
            const programLogMem = pinc.allocator.?.alloc(u8, @intCast(pInfoLogLen)) catch unreachable;
            defer pinc.allocator.?.free(programLogMem);
            gl.getProgramInfoLog(program, pInfoLogLen, null, programLogMem.ptr);
            if (linkStatus == gl.FALSE) {
                // Error occured!
                pinc.pushError(true, .any, "OpenGL 2.1 Backend: Fragment Program Link Failed: {s}", .{programLogMem});
                return null;
            } else {
                pinc.pushError(false, .any, "OpenGL 2.1 Backend: Fragment Program Link: {s}", .{programLogMem});
            }
        }
        if (linkStatus == gl.FALSE) {
            // Error occured without an info log!
            pinc.pushError(true, .any, "OpenGL 2.1 Backend: Fragment Program Link Failed for an unknown reason!", .{});
        }
        // Holy Moly Guacamole, that was a bit of an ordeal. So many potential errors and edge cases...
        // Anyway, the program is done. Time for the next step.

        // Map from input index to 'real' opengl layout binding
        var attributeBindMap: [pinc.GlslShadersObj.maxAttributeMaps]u32 = undefined;
        // TODO: uniform binding map
        for (0..shaderSources.glsl.numAttributeMaps) |mapIndex| {
            const map = shaderSources.glsl.attributeMaps[mapIndex];
            var name: [pinc.AttributeMap.maxAttributeNameSize + 1]u8 = undefined;
            @memcpy((&name)[0..map.nameLen], map.name[0..map.nameLen]);
            name[map.nameLen] = 0;
            // TODO: error when location returns -1
            const location = gl.getAttribLocation(program, &name);
            attributeBindMap[mapIndex] = @intCast(location);
        }
        // -> construct the pipeline instance and return it.
        const pipeline = pinc.allocator.?.create(Opengl21Pipeline) catch unreachable;
        pipeline.* = Opengl21Pipeline{
            .attributeBindMap = attributeBindMap,
            .shaderProgram = program,
            .vertexAssembly = assembly,
            .uniforms = uniforms,
            .attributes = attributes,
            .state = .{},
        };
        return pinc.IPipeline.init(Opengl21Pipeline, pipeline);
    }

    pub fn createVertexArray(this: *Opengl21GraphicsBackend, attributes: *const pinc.VertexAttributesObj, num: usize) ?pinc.IVertexArray {
        _ = this;
        pinc.state.getWindowBackend().?.glMakeAnyCurrent();
        var buffer: gl.GLuint = undefined;
        gl.genBuffers(1, &buffer);
        gl.bindBuffer(gl.ARRAY_BUFFER, buffer);
        // TODO: Pinc NEEDS a way to actually specify this!
        // (But not the traditional gl way - probably something more similar to the modern opengl way)
        // As a reminder, the modern opengl way is a bitfield with these flags:
        // dynamic storage bit: whether the buffer data may be mofified dynamically
        // map read bit: if the data can be mapped to readable memory
        // map write bit: if the data can be mapped to writable memory
        // map persistent bit: if the data may be persistently mapped whilst being used for graphics/compute as well
        // map coherent bit: forces the server-side (opengl) version of the buffer and the client side (application) version to always be equal
        // client storage bit: if set, the buffer should be stored in client memory (the CPU, basically)

        // For now, use static draw.
        gl.bufferData(gl.ARRAY_BUFFER, @intCast(num * attributes.stride), null, gl.STATIC_DRAW);
        const array = pinc.allocator.?.create(OpenGL21VertexArray) catch unreachable;
        array.* = .{
            .buffer = buffer,
            .attributes = attributes.copy(),
            .num = num,
            .mapped = null,
        };
        return pinc.IVertexArray.init(OpenGL21VertexArray, array);
    }

    pub fn draw(this: *Opengl21GraphicsBackend, window: pinc.ICompleteWindow, pipeline: pinc.IPipeline, vertexArray: pinc.IVertexArray, elementArray: ?pinc.IElementArray) void {
        _ = elementArray;
        // cast the objects into the opengl versions
        // This is safe because only one graphics backend can be active at a time, so all graphics objects created must be OpenGL ones
        const pipelineV: *Opengl21Pipeline = @alignCast(@ptrCast(pipeline.obj));
        const vertexArrayV: *OpenGL21VertexArray = @alignCast(@ptrCast(vertexArray.obj));
        window.glMakeCurrent();
        if (vertexArrayV.mapped != null) unreachable;
        gl.bindBuffer(gl.ARRAY_BUFFER, vertexArrayV.buffer);
        gl.useProgram(pipelineV.shaderProgram);
        // I'm not sure what OpenGL thinks of using mapped buffers to draw, but Pinc should not allow that.
        for (0..pipelineV.attributes.numAttribs) |attr| {
            // the attribute location that OpenGL uses / knows
            const attribIndex = pipelineV.attributeBindMap[attr];
            const attribV = pipelineV.attributes.attribsBuffer[attr];
            // convert pinc attribute type to opengl attribute settings
            var _size: gl.GLint = undefined;
            var _type: gl.GLenum = undefined;
            switch (attribV.type) {
                .float => {
                    _size = 1;
                    _type = gl.FLOAT;
                },
                .vec2 => {
                    _size = 2;
                    _type = gl.FLOAT;
                },
                .vec3 => {
                    _size = 3;
                    _type = gl.FLOAT;
                },
                .vec4 => {
                    _size = 4;
                    _type = gl.FLOAT;
                },
                .int => {
                    _size = 1;
                    _type = gl.INT;
                },
                .ivec2 => {
                    _size = 2;
                    _type = gl.INT;
                },
                .ivec3 => {
                    _size = 3;
                    _type = gl.INT;
                },
                .ivec4 => {
                    _size = 4;
                    _type = gl.INT;
                },
                .short => {
                    _size = 1;
                    _type = gl.SHORT;
                },
                .svec2 => {
                    _size = 2;
                    _type = gl.SHORT;
                },
                .svec3 => {
                    _size = 3;
                    _type = gl.SHORT;
                },
                .svec4 => {
                    _size = 4;
                    _type = gl.SHORT;
                },
                .byte => {
                    _size = 1;
                    _type = gl.UNSIGNED_BYTE;
                },
                .bvec2 => {
                    _size = 2;
                    _type = gl.UNSIGNED_BYTE;
                },
                .bvec3 => {
                    _size = 3;
                    _type = gl.UNSIGNED_BYTE;
                },
                .bvec4 => {
                    _size = 4;
                    _type = gl.UNSIGNED_BYTE;
                },
            }
            // I absolutely hate the fact that this function is required.
            // Why did they decide that vertexAttribPointer shouldn't automatically enable it?
            // Anyway, more than an hour was lost due to forgetting to use this function.
            gl.enableVertexAttribArray(attribIndex);
            gl.vertexAttribPointer(attribIndex, _size, _type, if (attribV.normalize) gl.TRUE else gl.FALSE, @intCast(pipelineV.attributes.stride), @ptrFromInt(attribV.offset));
            this.collectGlErrors();
        }
        switch (pipelineV.vertexAssembly) {
            .array_triangles => gl.drawArrays(gl.TRIANGLES, 0, @intCast(vertexArrayV.num)),
            .array_triangle_fan => gl.drawArrays(gl.TRIANGLE_FAN, 0, @intCast(vertexArrayV.num)),
            .array_triangle_strip => gl.drawArrays(gl.TRIANGLE_STRIP, 0, @intCast(vertexArrayV.num)),
            .element_triangles => unreachable,
            .element_triangle_fan => unreachable,
            .element_triangle_strip => unreachable,
        }
        this.collectGlErrors();
    }

    pub fn done(this: *Opengl21GraphicsBackend) void {
        _ = this;
        gl.flush();
    }

    // converts GL errors / warnings into Pinc errors/warnings
    // Assumes a current context
    pub fn collectGlErrors(this: *Opengl21GraphicsBackend) void {
        _ = this;
        while (true) {
            const er = gl.getError();
            switch (er) {
                gl.NO_ERROR => return,
                gl.INVALID_ENUM => pinc.pushError(false, .any, "OpenGL backend: INVALID_ENUM", .{}),
                gl.INVALID_VALUE => pinc.pushError(false, .any, "OpenGL backend: INVALID_VALUE", .{}),
                gl.INVALID_OPERATION => pinc.pushError(false, .any, "OpenGL backend: INVALID_OPERATION", .{}),
                gl.STACK_OVERFLOW => pinc.pushError(false, .any, "OpenGL backend: STACK_OVERFLOW", .{}),
                gl.STACK_UNDERFLOW => pinc.pushError(false, .any, "OpenGL backend: STACK_UNDERFLOW", .{}),
                gl.OUT_OF_MEMORY => pinc.pushError(false, .any, "OpenGL backend: OUT_OF_MEMORY", .{}),
                else => pinc.pushError(false, .any, "OpenGL backend: unknown error", .{}),
            }
        }
    }
};

pub const Opengl21Pipeline = struct {
    // This is merely to please the interface API requirement. Honestly regret making init() required.
    pub fn init(this: *Opengl21Pipeline) void {
        _ = this;
    }

    attributeBindMap: [pinc.GlslShadersObj.maxAttributeMaps]u32,
    shaderProgram: gl.GLuint,
    vertexAssembly: pinc.VertexAssembly,
    // Local copy of the uniforms object
    uniforms: pinc.UniformsObj,
    // local copy of the vertex attributes object
    attributes: pinc.VertexAttributesObj,
    state: struct {
        // TODO: uniform state
        // Actually, uniforms are like basically the only pipeline state at the moment. The struct remains empty...
    },
};

pub const OpenGL21VertexArray = struct {
    // This is merely to please the interface API requirement. Honestly regret making init() required.
    pub fn init(this: *OpenGL21VertexArray) void {
        _ = this;
    }

    pub fn lock(this: *OpenGL21VertexArray) void {
        pinc.state.getWindowBackend().?.glMakeAnyCurrent();
        if (this.mapped != null) unreachable;
        gl.bindBuffer(gl.ARRAY_BUFFER, this.buffer);
        // Right now, the Pinc api only supports writing to a locked vertex array
        this.mapped = @ptrCast(gl.mapBuffer(gl.ARRAY_BUFFER, gl.WRITE_ONLY));
        // sanity check - the returned pointer should be mapped to a 4 byte boundary
        // TODO: don't assume this
        if (!std.mem.isAlignedLog2(@intFromPtr(this.mapped), 2)) unreachable;
    }

    pub fn unlock(this: *OpenGL21VertexArray) void {
        pinc.state.getWindowBackend().?.glMakeAnyCurrent();
        if (this.mapped == null) unreachable;
        gl.bindBuffer(gl.ARRAY_BUFFER, this.buffer);
        if (gl.unmapBuffer(gl.ARRAY_BUFFER) == gl.FALSE) {
            // Oh no! Better hope this doesn't happen.
            // For context, this will only ever happen if the opengl implementation decides to remap the memory for technical reasons.
            // TODO: handle this better!
            unreachable;
        }
        this.mapped = null;
    }

    pub fn setItemVec2(this: *OpenGL21VertexArray, vertex: usize, attribute: usize, v: [2]f32) void {
        pinc.state.getWindowBackend().?.glMakeAnyCurrent();
        if (this.mapped == null) unreachable;
        if (vertex >= this.num) unreachable;
        const attributeV = this.attributes.attribsBuffer[attribute];
        if (attributeV.type != .vec2) unreachable;
        // Note: this assumes an alignment of 4 bytes, which I believe OpenGL might already require (I haven't looked into that yet)
        const mapped = @as([*]f32, @alignCast(@ptrCast(this.mapped.?)));
        // the divexact here will trigger undefined behavior if the alignment is not compatible with 4 bytes
        const index = @divExact(vertex * this.attributes.stride + attribute * attributeV.offset, 4);
        mapped[index] = v[0];
        mapped[index + 1] = v[1];
    }

    pub fn setItemVec4(this: *OpenGL21VertexArray, vertex: usize, attribute: usize, v: [4]f32) void {
        pinc.state.getWindowBackend().?.glMakeAnyCurrent();
        pinc.state.getWindowBackend().?.glMakeAnyCurrent();
        if (this.mapped == null) unreachable;
        if (vertex >= this.num) unreachable;
        const attributeV = this.attributes.attribsBuffer[attribute];
        if (attributeV.type != .vec4) unreachable;
        // Note: this assumes an alignment of 4 bytes, which I believe OpenGL might already require (I haven't looked into that yet)
        const mapped = @as([*]f32, @alignCast(@ptrCast(this.mapped.?)));
        // the divexact here will trigger undefined behavior if the alignment is not compatible with 4 bytes
        const index = @divExact(vertex * this.attributes.stride + attribute * attributeV.offset, 4);
        mapped[index] = v[0];
        mapped[index + 1] = v[1];
        mapped[index + 2] = v[2];
        mapped[index + 3] = v[3];
    }

    pub fn deinit(this: *OpenGL21VertexArray) void {
        if (this.mapped != null) this.unlock();
        const buffers = [_]gl.GLuint{this.buffer};
        gl.deleteBuffers(1, &buffers);
        // TODO: perhaps a better memory model where this is not allocated like this
        pinc.allocator.?.destroy(this);
    }

    buffer: gl.GLuint,
    num: usize,
    attributes: pinc.VertexAttributesObj,
    mapped: ?[*]u8,
};
