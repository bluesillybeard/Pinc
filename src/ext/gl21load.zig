//
// This code file is licenced under any of Public Domain, WTFPL or CC0.
// There are no restrictions in the use of this file.
//

//
// Generation parameters:
// API:        GL_VERSION_2_1
// Profile:    core
// Extensions:
//

//
// This file was generated with the following command line:
// generator OpenGL-Registry/xml/gl.xml gl21load.zig GL_VERSION_2_1
//

const std = @import("std");
const builtin = @import("builtin");
const log = std.log.scoped(.OpenGL);

pub const FunctionPointer: type = *align(@alignOf(fn (u32) callconv(.C) u32)) const anyopaque;

pub const GLenum = c_uint;
pub const GLboolean = u8;
pub const GLbitfield = c_uint;
pub const GLbyte = i8;
pub const GLubyte = u8;
pub const GLshort = i16;
pub const GLushort = u16;
pub const GLint = c_int;
pub const GLuint = c_uint;
pub const GLclampx = i32;
pub const GLsizei = c_int;
pub const GLfloat = f32;
pub const GLclampf = f32;
pub const GLdouble = f64;
pub const GLclampd = f64;
pub const GLeglClientBufferEXT = void;
pub const GLeglImageOES = void;
pub const GLchar = u8;
pub const GLcharARB = u8;

pub const GLhandleARB = if (builtin.os.tag == .macos) *anyopaque else c_uint;

pub const GLhalf = u16;
pub const GLhalfARB = u16;
pub const GLfixed = i32;
pub const GLintptr = usize;
pub const GLintptrARB = usize;
pub const GLsizeiptr = isize;
pub const GLsizeiptrARB = isize;
pub const GLint64 = i64;
pub const GLint64EXT = i64;
pub const GLuint64 = u64;
pub const GLuint64EXT = u64;

pub const GLsync = *opaque {};

pub const _cl_context = opaque {};
pub const _cl_event = opaque {};

pub const GLDEBUGPROC = *const fn (source: GLenum, _type: GLenum, id: GLuint, severity: GLenum, length: GLsizei, message: [*:0]const u8, userParam: ?*anyopaque) callconv(.C) void;
pub const GLDEBUGPROCARB = *const fn (source: GLenum, _type: GLenum, id: GLuint, severity: GLenum, length: GLsizei, message: [*:0]const u8, userParam: ?*anyopaque) callconv(.C) void;
pub const GLDEBUGPROCKHR = *const fn (source: GLenum, _type: GLenum, id: GLuint, severity: GLenum, length: GLsizei, message: [*:0]const u8, userParam: ?*anyopaque) callconv(.C) void;

pub const GLDEBUGPROCAMD = *const fn (id: GLuint, category: GLenum, severity: GLenum, length: GLsizei, message: [*:0]const u8, userParam: ?*anyopaque) callconv(.C) void;

pub const GLhalfNV = u16;
pub const GLvdpauSurfaceNV = GLintptr;
pub const GLVULKANPROCNV = *const fn () callconv(.C) void;

pub const DEPTH_BUFFER_BIT = 0x00000100;
pub const STENCIL_BUFFER_BIT = 0x00000400;
pub const COLOR_BUFFER_BIT = 0x00004000;
pub const FALSE = 0;
pub const TRUE = 1;
pub const POINTS = 0x0000;
pub const LINES = 0x0001;
pub const LINE_LOOP = 0x0002;
pub const LINE_STRIP = 0x0003;
pub const TRIANGLES = 0x0004;
pub const TRIANGLE_STRIP = 0x0005;
pub const TRIANGLE_FAN = 0x0006;
pub const QUADS = 0x0007;
pub const NEVER = 0x0200;
pub const LESS = 0x0201;
pub const EQUAL = 0x0202;
pub const LEQUAL = 0x0203;
pub const GREATER = 0x0204;
pub const NOTEQUAL = 0x0205;
pub const GEQUAL = 0x0206;
pub const ALWAYS = 0x0207;
pub const ZERO = 0;
pub const ONE = 1;
pub const SRC_COLOR = 0x0300;
pub const ONE_MINUS_SRC_COLOR = 0x0301;
pub const SRC_ALPHA = 0x0302;
pub const ONE_MINUS_SRC_ALPHA = 0x0303;
pub const DST_ALPHA = 0x0304;
pub const ONE_MINUS_DST_ALPHA = 0x0305;
pub const DST_COLOR = 0x0306;
pub const ONE_MINUS_DST_COLOR = 0x0307;
pub const SRC_ALPHA_SATURATE = 0x0308;
pub const NONE = 0;
pub const FRONT_LEFT = 0x0400;
pub const FRONT_RIGHT = 0x0401;
pub const BACK_LEFT = 0x0402;
pub const BACK_RIGHT = 0x0403;
pub const FRONT = 0x0404;
pub const BACK = 0x0405;
pub const LEFT = 0x0406;
pub const RIGHT = 0x0407;
pub const FRONT_AND_BACK = 0x0408;
pub const NO_ERROR = 0;
pub const INVALID_ENUM = 0x0500;
pub const INVALID_VALUE = 0x0501;
pub const INVALID_OPERATION = 0x0502;
pub const OUT_OF_MEMORY = 0x0505;
pub const CW = 0x0900;
pub const CCW = 0x0901;
pub const POINT_SIZE = 0x0B11;
pub const POINT_SIZE_RANGE = 0x0B12;
pub const POINT_SIZE_GRANULARITY = 0x0B13;
pub const LINE_SMOOTH = 0x0B20;
pub const LINE_WIDTH = 0x0B21;
pub const LINE_WIDTH_RANGE = 0x0B22;
pub const LINE_WIDTH_GRANULARITY = 0x0B23;
pub const POLYGON_MODE = 0x0B40;
pub const POLYGON_SMOOTH = 0x0B41;
pub const CULL_FACE = 0x0B44;
pub const CULL_FACE_MODE = 0x0B45;
pub const FRONT_FACE = 0x0B46;
pub const DEPTH_RANGE = 0x0B70;
pub const DEPTH_TEST = 0x0B71;
pub const DEPTH_WRITEMASK = 0x0B72;
pub const DEPTH_CLEAR_VALUE = 0x0B73;
pub const DEPTH_FUNC = 0x0B74;
pub const STENCIL_TEST = 0x0B90;
pub const STENCIL_CLEAR_VALUE = 0x0B91;
pub const STENCIL_FUNC = 0x0B92;
pub const STENCIL_VALUE_MASK = 0x0B93;
pub const STENCIL_FAIL = 0x0B94;
pub const STENCIL_PASS_DEPTH_FAIL = 0x0B95;
pub const STENCIL_PASS_DEPTH_PASS = 0x0B96;
pub const STENCIL_REF = 0x0B97;
pub const STENCIL_WRITEMASK = 0x0B98;
pub const VIEWPORT = 0x0BA2;
pub const DITHER = 0x0BD0;
pub const BLEND_DST = 0x0BE0;
pub const BLEND_SRC = 0x0BE1;
pub const BLEND = 0x0BE2;
pub const LOGIC_OP_MODE = 0x0BF0;
pub const DRAW_BUFFER = 0x0C01;
pub const READ_BUFFER = 0x0C02;
pub const SCISSOR_BOX = 0x0C10;
pub const SCISSOR_TEST = 0x0C11;
pub const COLOR_CLEAR_VALUE = 0x0C22;
pub const COLOR_WRITEMASK = 0x0C23;
pub const DOUBLEBUFFER = 0x0C32;
pub const STEREO = 0x0C33;
pub const LINE_SMOOTH_HINT = 0x0C52;
pub const POLYGON_SMOOTH_HINT = 0x0C53;
pub const UNPACK_SWAP_BYTES = 0x0CF0;
pub const UNPACK_LSB_FIRST = 0x0CF1;
pub const UNPACK_ROW_LENGTH = 0x0CF2;
pub const UNPACK_SKIP_ROWS = 0x0CF3;
pub const UNPACK_SKIP_PIXELS = 0x0CF4;
pub const UNPACK_ALIGNMENT = 0x0CF5;
pub const PACK_SWAP_BYTES = 0x0D00;
pub const PACK_LSB_FIRST = 0x0D01;
pub const PACK_ROW_LENGTH = 0x0D02;
pub const PACK_SKIP_ROWS = 0x0D03;
pub const PACK_SKIP_PIXELS = 0x0D04;
pub const PACK_ALIGNMENT = 0x0D05;
pub const MAX_TEXTURE_SIZE = 0x0D33;
pub const MAX_VIEWPORT_DIMS = 0x0D3A;
pub const SUBPIXEL_BITS = 0x0D50;
pub const TEXTURE_1D = 0x0DE0;
pub const TEXTURE_2D = 0x0DE1;
pub const TEXTURE_WIDTH = 0x1000;
pub const TEXTURE_HEIGHT = 0x1001;
pub const TEXTURE_BORDER_COLOR = 0x1004;
pub const DONT_CARE = 0x1100;
pub const FASTEST = 0x1101;
pub const NICEST = 0x1102;
pub const BYTE = 0x1400;
pub const UNSIGNED_BYTE = 0x1401;
pub const SHORT = 0x1402;
pub const UNSIGNED_SHORT = 0x1403;
pub const INT = 0x1404;
pub const UNSIGNED_INT = 0x1405;
pub const FLOAT = 0x1406;
pub const STACK_OVERFLOW = 0x0503;
pub const STACK_UNDERFLOW = 0x0504;
pub const CLEAR = 0x1500;
pub const AND = 0x1501;
pub const AND_REVERSE = 0x1502;
pub const COPY = 0x1503;
pub const AND_INVERTED = 0x1504;
pub const NOOP = 0x1505;
pub const XOR = 0x1506;
pub const OR = 0x1507;
pub const NOR = 0x1508;
pub const EQUIV = 0x1509;
pub const INVERT = 0x150A;
pub const OR_REVERSE = 0x150B;
pub const COPY_INVERTED = 0x150C;
pub const OR_INVERTED = 0x150D;
pub const NAND = 0x150E;
pub const SET = 0x150F;
pub const TEXTURE = 0x1702;
pub const COLOR = 0x1800;
pub const DEPTH = 0x1801;
pub const STENCIL = 0x1802;
pub const STENCIL_INDEX = 0x1901;
pub const DEPTH_COMPONENT = 0x1902;
pub const RED = 0x1903;
pub const GREEN = 0x1904;
pub const BLUE = 0x1905;
pub const ALPHA = 0x1906;
pub const RGB = 0x1907;
pub const RGBA = 0x1908;
pub const POINT = 0x1B00;
pub const LINE = 0x1B01;
pub const FILL = 0x1B02;
pub const KEEP = 0x1E00;
pub const REPLACE = 0x1E01;
pub const INCR = 0x1E02;
pub const DECR = 0x1E03;
pub const VENDOR = 0x1F00;
pub const RENDERER = 0x1F01;
pub const VERSION = 0x1F02;
pub const EXTENSIONS = 0x1F03;
pub const NEAREST = 0x2600;
pub const LINEAR = 0x2601;
pub const NEAREST_MIPMAP_NEAREST = 0x2700;
pub const LINEAR_MIPMAP_NEAREST = 0x2701;
pub const NEAREST_MIPMAP_LINEAR = 0x2702;
pub const LINEAR_MIPMAP_LINEAR = 0x2703;
pub const TEXTURE_MAG_FILTER = 0x2800;
pub const TEXTURE_MIN_FILTER = 0x2801;
pub const TEXTURE_WRAP_S = 0x2802;
pub const TEXTURE_WRAP_T = 0x2803;
pub const REPEAT = 0x2901;
pub const CURRENT_BIT = 0x00000001;
pub const POINT_BIT = 0x00000002;
pub const LINE_BIT = 0x00000004;
pub const POLYGON_BIT = 0x00000008;
pub const POLYGON_STIPPLE_BIT = 0x00000010;
pub const PIXEL_MODE_BIT = 0x00000020;
pub const LIGHTING_BIT = 0x00000040;
pub const FOG_BIT = 0x00000080;
pub const ACCUM_BUFFER_BIT = 0x00000200;
pub const VIEWPORT_BIT = 0x00000800;
pub const TRANSFORM_BIT = 0x00001000;
pub const ENABLE_BIT = 0x00002000;
pub const HINT_BIT = 0x00008000;
pub const EVAL_BIT = 0x00010000;
pub const LIST_BIT = 0x00020000;
pub const TEXTURE_BIT = 0x00040000;
pub const SCISSOR_BIT = 0x00080000;
pub const ALL_ATTRIB_BITS = 0xFFFFFFFF;
pub const QUAD_STRIP = 0x0008;
pub const POLYGON = 0x0009;
pub const ACCUM = 0x0100;
pub const LOAD = 0x0101;
pub const RETURN = 0x0102;
pub const MULT = 0x0103;
pub const ADD = 0x0104;
pub const AUX0 = 0x0409;
pub const AUX1 = 0x040A;
pub const AUX2 = 0x040B;
pub const AUX3 = 0x040C;
pub const @"2D" = 0x0600;
pub const @"3D" = 0x0601;
pub const @"3D_COLOR" = 0x0602;
pub const @"3D_COLOR_TEXTURE" = 0x0603;
pub const @"4D_COLOR_TEXTURE" = 0x0604;
pub const PASS_THROUGH_TOKEN = 0x0700;
pub const POINT_TOKEN = 0x0701;
pub const LINE_TOKEN = 0x0702;
pub const POLYGON_TOKEN = 0x0703;
pub const BITMAP_TOKEN = 0x0704;
pub const DRAW_PIXEL_TOKEN = 0x0705;
pub const COPY_PIXEL_TOKEN = 0x0706;
pub const LINE_RESET_TOKEN = 0x0707;
pub const EXP = 0x0800;
pub const EXP2 = 0x0801;
pub const COEFF = 0x0A00;
pub const ORDER = 0x0A01;
pub const DOMAIN = 0x0A02;
pub const PIXEL_MAP_I_TO_I = 0x0C70;
pub const PIXEL_MAP_S_TO_S = 0x0C71;
pub const PIXEL_MAP_I_TO_R = 0x0C72;
pub const PIXEL_MAP_I_TO_G = 0x0C73;
pub const PIXEL_MAP_I_TO_B = 0x0C74;
pub const PIXEL_MAP_I_TO_A = 0x0C75;
pub const PIXEL_MAP_R_TO_R = 0x0C76;
pub const PIXEL_MAP_G_TO_G = 0x0C77;
pub const PIXEL_MAP_B_TO_B = 0x0C78;
pub const PIXEL_MAP_A_TO_A = 0x0C79;
pub const CURRENT_COLOR = 0x0B00;
pub const CURRENT_INDEX = 0x0B01;
pub const CURRENT_NORMAL = 0x0B02;
pub const CURRENT_TEXTURE_COORDS = 0x0B03;
pub const CURRENT_RASTER_COLOR = 0x0B04;
pub const CURRENT_RASTER_INDEX = 0x0B05;
pub const CURRENT_RASTER_TEXTURE_COORDS = 0x0B06;
pub const CURRENT_RASTER_POSITION = 0x0B07;
pub const CURRENT_RASTER_POSITION_VALID = 0x0B08;
pub const CURRENT_RASTER_DISTANCE = 0x0B09;
pub const POINT_SMOOTH = 0x0B10;
pub const LINE_STIPPLE = 0x0B24;
pub const LINE_STIPPLE_PATTERN = 0x0B25;
pub const LINE_STIPPLE_REPEAT = 0x0B26;
pub const LIST_MODE = 0x0B30;
pub const MAX_LIST_NESTING = 0x0B31;
pub const LIST_BASE = 0x0B32;
pub const LIST_INDEX = 0x0B33;
pub const POLYGON_STIPPLE = 0x0B42;
pub const EDGE_FLAG = 0x0B43;
pub const LIGHTING = 0x0B50;
pub const LIGHT_MODEL_LOCAL_VIEWER = 0x0B51;
pub const LIGHT_MODEL_TWO_SIDE = 0x0B52;
pub const LIGHT_MODEL_AMBIENT = 0x0B53;
pub const SHADE_MODEL = 0x0B54;
pub const COLOR_MATERIAL_FACE = 0x0B55;
pub const COLOR_MATERIAL_PARAMETER = 0x0B56;
pub const COLOR_MATERIAL = 0x0B57;
pub const FOG = 0x0B60;
pub const FOG_INDEX = 0x0B61;
pub const FOG_DENSITY = 0x0B62;
pub const FOG_START = 0x0B63;
pub const FOG_END = 0x0B64;
pub const FOG_MODE = 0x0B65;
pub const FOG_COLOR = 0x0B66;
pub const ACCUM_CLEAR_VALUE = 0x0B80;
pub const MATRIX_MODE = 0x0BA0;
pub const NORMALIZE = 0x0BA1;
pub const MODELVIEW_STACK_DEPTH = 0x0BA3;
pub const PROJECTION_STACK_DEPTH = 0x0BA4;
pub const TEXTURE_STACK_DEPTH = 0x0BA5;
pub const MODELVIEW_MATRIX = 0x0BA6;
pub const PROJECTION_MATRIX = 0x0BA7;
pub const TEXTURE_MATRIX = 0x0BA8;
pub const ATTRIB_STACK_DEPTH = 0x0BB0;
pub const ALPHA_TEST = 0x0BC0;
pub const ALPHA_TEST_FUNC = 0x0BC1;
pub const ALPHA_TEST_REF = 0x0BC2;
pub const LOGIC_OP = 0x0BF1;
pub const AUX_BUFFERS = 0x0C00;
pub const INDEX_CLEAR_VALUE = 0x0C20;
pub const INDEX_WRITEMASK = 0x0C21;
pub const INDEX_MODE = 0x0C30;
pub const RGBA_MODE = 0x0C31;
pub const RENDER_MODE = 0x0C40;
pub const PERSPECTIVE_CORRECTION_HINT = 0x0C50;
pub const POINT_SMOOTH_HINT = 0x0C51;
pub const FOG_HINT = 0x0C54;
pub const TEXTURE_GEN_S = 0x0C60;
pub const TEXTURE_GEN_T = 0x0C61;
pub const TEXTURE_GEN_R = 0x0C62;
pub const TEXTURE_GEN_Q = 0x0C63;
pub const PIXEL_MAP_I_TO_I_SIZE = 0x0CB0;
pub const PIXEL_MAP_S_TO_S_SIZE = 0x0CB1;
pub const PIXEL_MAP_I_TO_R_SIZE = 0x0CB2;
pub const PIXEL_MAP_I_TO_G_SIZE = 0x0CB3;
pub const PIXEL_MAP_I_TO_B_SIZE = 0x0CB4;
pub const PIXEL_MAP_I_TO_A_SIZE = 0x0CB5;
pub const PIXEL_MAP_R_TO_R_SIZE = 0x0CB6;
pub const PIXEL_MAP_G_TO_G_SIZE = 0x0CB7;
pub const PIXEL_MAP_B_TO_B_SIZE = 0x0CB8;
pub const PIXEL_MAP_A_TO_A_SIZE = 0x0CB9;
pub const MAP_COLOR = 0x0D10;
pub const MAP_STENCIL = 0x0D11;
pub const INDEX_SHIFT = 0x0D12;
pub const INDEX_OFFSET = 0x0D13;
pub const RED_SCALE = 0x0D14;
pub const RED_BIAS = 0x0D15;
pub const ZOOM_X = 0x0D16;
pub const ZOOM_Y = 0x0D17;
pub const GREEN_SCALE = 0x0D18;
pub const GREEN_BIAS = 0x0D19;
pub const BLUE_SCALE = 0x0D1A;
pub const BLUE_BIAS = 0x0D1B;
pub const ALPHA_SCALE = 0x0D1C;
pub const ALPHA_BIAS = 0x0D1D;
pub const DEPTH_SCALE = 0x0D1E;
pub const DEPTH_BIAS = 0x0D1F;
pub const MAX_EVAL_ORDER = 0x0D30;
pub const MAX_LIGHTS = 0x0D31;
pub const MAX_CLIP_PLANES = 0x0D32;
pub const MAX_PIXEL_MAP_TABLE = 0x0D34;
pub const MAX_ATTRIB_STACK_DEPTH = 0x0D35;
pub const MAX_MODELVIEW_STACK_DEPTH = 0x0D36;
pub const MAX_NAME_STACK_DEPTH = 0x0D37;
pub const MAX_PROJECTION_STACK_DEPTH = 0x0D38;
pub const MAX_TEXTURE_STACK_DEPTH = 0x0D39;
pub const INDEX_BITS = 0x0D51;
pub const RED_BITS = 0x0D52;
pub const GREEN_BITS = 0x0D53;
pub const BLUE_BITS = 0x0D54;
pub const ALPHA_BITS = 0x0D55;
pub const DEPTH_BITS = 0x0D56;
pub const STENCIL_BITS = 0x0D57;
pub const ACCUM_RED_BITS = 0x0D58;
pub const ACCUM_GREEN_BITS = 0x0D59;
pub const ACCUM_BLUE_BITS = 0x0D5A;
pub const ACCUM_ALPHA_BITS = 0x0D5B;
pub const NAME_STACK_DEPTH = 0x0D70;
pub const AUTO_NORMAL = 0x0D80;
pub const MAP1_COLOR_4 = 0x0D90;
pub const MAP1_INDEX = 0x0D91;
pub const MAP1_NORMAL = 0x0D92;
pub const MAP1_TEXTURE_COORD_1 = 0x0D93;
pub const MAP1_TEXTURE_COORD_2 = 0x0D94;
pub const MAP1_TEXTURE_COORD_3 = 0x0D95;
pub const MAP1_TEXTURE_COORD_4 = 0x0D96;
pub const MAP1_VERTEX_3 = 0x0D97;
pub const MAP1_VERTEX_4 = 0x0D98;
pub const MAP2_COLOR_4 = 0x0DB0;
pub const MAP2_INDEX = 0x0DB1;
pub const MAP2_NORMAL = 0x0DB2;
pub const MAP2_TEXTURE_COORD_1 = 0x0DB3;
pub const MAP2_TEXTURE_COORD_2 = 0x0DB4;
pub const MAP2_TEXTURE_COORD_3 = 0x0DB5;
pub const MAP2_TEXTURE_COORD_4 = 0x0DB6;
pub const MAP2_VERTEX_3 = 0x0DB7;
pub const MAP2_VERTEX_4 = 0x0DB8;
pub const MAP1_GRID_DOMAIN = 0x0DD0;
pub const MAP1_GRID_SEGMENTS = 0x0DD1;
pub const MAP2_GRID_DOMAIN = 0x0DD2;
pub const MAP2_GRID_SEGMENTS = 0x0DD3;
pub const TEXTURE_COMPONENTS = 0x1003;
pub const TEXTURE_BORDER = 0x1005;
pub const AMBIENT = 0x1200;
pub const DIFFUSE = 0x1201;
pub const SPECULAR = 0x1202;
pub const POSITION = 0x1203;
pub const SPOT_DIRECTION = 0x1204;
pub const SPOT_EXPONENT = 0x1205;
pub const SPOT_CUTOFF = 0x1206;
pub const CONSTANT_ATTENUATION = 0x1207;
pub const LINEAR_ATTENUATION = 0x1208;
pub const QUADRATIC_ATTENUATION = 0x1209;
pub const COMPILE = 0x1300;
pub const COMPILE_AND_EXECUTE = 0x1301;
pub const @"2_BYTES" = 0x1407;
pub const @"3_BYTES" = 0x1408;
pub const @"4_BYTES" = 0x1409;
pub const EMISSION = 0x1600;
pub const SHININESS = 0x1601;
pub const AMBIENT_AND_DIFFUSE = 0x1602;
pub const COLOR_INDEXES = 0x1603;
pub const MODELVIEW = 0x1700;
pub const PROJECTION = 0x1701;
pub const COLOR_INDEX = 0x1900;
pub const LUMINANCE = 0x1909;
pub const LUMINANCE_ALPHA = 0x190A;
pub const BITMAP = 0x1A00;
pub const RENDER = 0x1C00;
pub const FEEDBACK = 0x1C01;
pub const SELECT = 0x1C02;
pub const FLAT = 0x1D00;
pub const SMOOTH = 0x1D01;
pub const S = 0x2000;
pub const T = 0x2001;
pub const R = 0x2002;
pub const Q = 0x2003;
pub const MODULATE = 0x2100;
pub const DECAL = 0x2101;
pub const TEXTURE_ENV_MODE = 0x2200;
pub const TEXTURE_ENV_COLOR = 0x2201;
pub const TEXTURE_ENV = 0x2300;
pub const EYE_LINEAR = 0x2400;
pub const OBJECT_LINEAR = 0x2401;
pub const SPHERE_MAP = 0x2402;
pub const TEXTURE_GEN_MODE = 0x2500;
pub const OBJECT_PLANE = 0x2501;
pub const EYE_PLANE = 0x2502;
pub const CLAMP = 0x2900;
pub const CLIP_PLANE0 = 0x3000;
pub const CLIP_PLANE1 = 0x3001;
pub const CLIP_PLANE2 = 0x3002;
pub const CLIP_PLANE3 = 0x3003;
pub const CLIP_PLANE4 = 0x3004;
pub const CLIP_PLANE5 = 0x3005;
pub const LIGHT0 = 0x4000;
pub const LIGHT1 = 0x4001;
pub const LIGHT2 = 0x4002;
pub const LIGHT3 = 0x4003;
pub const LIGHT4 = 0x4004;
pub const LIGHT5 = 0x4005;
pub const LIGHT6 = 0x4006;
pub const LIGHT7 = 0x4007;
pub const COLOR_LOGIC_OP = 0x0BF2;
pub const POLYGON_OFFSET_UNITS = 0x2A00;
pub const POLYGON_OFFSET_POINT = 0x2A01;
pub const POLYGON_OFFSET_LINE = 0x2A02;
pub const POLYGON_OFFSET_FILL = 0x8037;
pub const POLYGON_OFFSET_FACTOR = 0x8038;
pub const TEXTURE_BINDING_1D = 0x8068;
pub const TEXTURE_BINDING_2D = 0x8069;
pub const TEXTURE_INTERNAL_FORMAT = 0x1003;
pub const TEXTURE_RED_SIZE = 0x805C;
pub const TEXTURE_GREEN_SIZE = 0x805D;
pub const TEXTURE_BLUE_SIZE = 0x805E;
pub const TEXTURE_ALPHA_SIZE = 0x805F;
pub const DOUBLE = 0x140A;
pub const PROXY_TEXTURE_1D = 0x8063;
pub const PROXY_TEXTURE_2D = 0x8064;
pub const R3_G3_B2 = 0x2A10;
pub const RGB4 = 0x804F;
pub const RGB5 = 0x8050;
pub const RGB8 = 0x8051;
pub const RGB10 = 0x8052;
pub const RGB12 = 0x8053;
pub const RGB16 = 0x8054;
pub const RGBA2 = 0x8055;
pub const RGBA4 = 0x8056;
pub const RGB5_A1 = 0x8057;
pub const RGBA8 = 0x8058;
pub const RGB10_A2 = 0x8059;
pub const RGBA12 = 0x805A;
pub const RGBA16 = 0x805B;
pub const CLIENT_PIXEL_STORE_BIT = 0x00000001;
pub const CLIENT_VERTEX_ARRAY_BIT = 0x00000002;
pub const CLIENT_ALL_ATTRIB_BITS = 0xFFFFFFFF;
pub const VERTEX_ARRAY_POINTER = 0x808E;
pub const NORMAL_ARRAY_POINTER = 0x808F;
pub const COLOR_ARRAY_POINTER = 0x8090;
pub const INDEX_ARRAY_POINTER = 0x8091;
pub const TEXTURE_COORD_ARRAY_POINTER = 0x8092;
pub const EDGE_FLAG_ARRAY_POINTER = 0x8093;
pub const FEEDBACK_BUFFER_POINTER = 0x0DF0;
pub const SELECTION_BUFFER_POINTER = 0x0DF3;
pub const CLIENT_ATTRIB_STACK_DEPTH = 0x0BB1;
pub const INDEX_LOGIC_OP = 0x0BF1;
pub const MAX_CLIENT_ATTRIB_STACK_DEPTH = 0x0D3B;
pub const FEEDBACK_BUFFER_SIZE = 0x0DF1;
pub const FEEDBACK_BUFFER_TYPE = 0x0DF2;
pub const SELECTION_BUFFER_SIZE = 0x0DF4;
pub const VERTEX_ARRAY = 0x8074;
pub const NORMAL_ARRAY = 0x8075;
pub const COLOR_ARRAY = 0x8076;
pub const INDEX_ARRAY = 0x8077;
pub const TEXTURE_COORD_ARRAY = 0x8078;
pub const EDGE_FLAG_ARRAY = 0x8079;
pub const VERTEX_ARRAY_SIZE = 0x807A;
pub const VERTEX_ARRAY_TYPE = 0x807B;
pub const VERTEX_ARRAY_STRIDE = 0x807C;
pub const NORMAL_ARRAY_TYPE = 0x807E;
pub const NORMAL_ARRAY_STRIDE = 0x807F;
pub const COLOR_ARRAY_SIZE = 0x8081;
pub const COLOR_ARRAY_TYPE = 0x8082;
pub const COLOR_ARRAY_STRIDE = 0x8083;
pub const INDEX_ARRAY_TYPE = 0x8085;
pub const INDEX_ARRAY_STRIDE = 0x8086;
pub const TEXTURE_COORD_ARRAY_SIZE = 0x8088;
pub const TEXTURE_COORD_ARRAY_TYPE = 0x8089;
pub const TEXTURE_COORD_ARRAY_STRIDE = 0x808A;
pub const EDGE_FLAG_ARRAY_STRIDE = 0x808C;
pub const TEXTURE_LUMINANCE_SIZE = 0x8060;
pub const TEXTURE_INTENSITY_SIZE = 0x8061;
pub const TEXTURE_PRIORITY = 0x8066;
pub const TEXTURE_RESIDENT = 0x8067;
pub const ALPHA4 = 0x803B;
pub const ALPHA8 = 0x803C;
pub const ALPHA12 = 0x803D;
pub const ALPHA16 = 0x803E;
pub const LUMINANCE4 = 0x803F;
pub const LUMINANCE8 = 0x8040;
pub const LUMINANCE12 = 0x8041;
pub const LUMINANCE16 = 0x8042;
pub const LUMINANCE4_ALPHA4 = 0x8043;
pub const LUMINANCE6_ALPHA2 = 0x8044;
pub const LUMINANCE8_ALPHA8 = 0x8045;
pub const LUMINANCE12_ALPHA4 = 0x8046;
pub const LUMINANCE12_ALPHA12 = 0x8047;
pub const LUMINANCE16_ALPHA16 = 0x8048;
pub const INTENSITY = 0x8049;
pub const INTENSITY4 = 0x804A;
pub const INTENSITY8 = 0x804B;
pub const INTENSITY12 = 0x804C;
pub const INTENSITY16 = 0x804D;
pub const V2F = 0x2A20;
pub const V3F = 0x2A21;
pub const C4UB_V2F = 0x2A22;
pub const C4UB_V3F = 0x2A23;
pub const C3F_V3F = 0x2A24;
pub const N3F_V3F = 0x2A25;
pub const C4F_N3F_V3F = 0x2A26;
pub const T2F_V3F = 0x2A27;
pub const T4F_V4F = 0x2A28;
pub const T2F_C4UB_V3F = 0x2A29;
pub const T2F_C3F_V3F = 0x2A2A;
pub const T2F_N3F_V3F = 0x2A2B;
pub const T2F_C4F_N3F_V3F = 0x2A2C;
pub const T4F_C4F_N3F_V4F = 0x2A2D;
pub const UNSIGNED_BYTE_3_3_2 = 0x8032;
pub const UNSIGNED_SHORT_4_4_4_4 = 0x8033;
pub const UNSIGNED_SHORT_5_5_5_1 = 0x8034;
pub const UNSIGNED_INT_8_8_8_8 = 0x8035;
pub const UNSIGNED_INT_10_10_10_2 = 0x8036;
pub const TEXTURE_BINDING_3D = 0x806A;
pub const PACK_SKIP_IMAGES = 0x806B;
pub const PACK_IMAGE_HEIGHT = 0x806C;
pub const UNPACK_SKIP_IMAGES = 0x806D;
pub const UNPACK_IMAGE_HEIGHT = 0x806E;
pub const TEXTURE_3D = 0x806F;
pub const PROXY_TEXTURE_3D = 0x8070;
pub const TEXTURE_DEPTH = 0x8071;
pub const TEXTURE_WRAP_R = 0x8072;
pub const MAX_3D_TEXTURE_SIZE = 0x8073;
pub const UNSIGNED_BYTE_2_3_3_REV = 0x8362;
pub const UNSIGNED_SHORT_5_6_5 = 0x8363;
pub const UNSIGNED_SHORT_5_6_5_REV = 0x8364;
pub const UNSIGNED_SHORT_4_4_4_4_REV = 0x8365;
pub const UNSIGNED_SHORT_1_5_5_5_REV = 0x8366;
pub const UNSIGNED_INT_8_8_8_8_REV = 0x8367;
pub const UNSIGNED_INT_2_10_10_10_REV = 0x8368;
pub const BGR = 0x80E0;
pub const BGRA = 0x80E1;
pub const MAX_ELEMENTS_VERTICES = 0x80E8;
pub const MAX_ELEMENTS_INDICES = 0x80E9;
pub const CLAMP_TO_EDGE = 0x812F;
pub const TEXTURE_MIN_LOD = 0x813A;
pub const TEXTURE_MAX_LOD = 0x813B;
pub const TEXTURE_BASE_LEVEL = 0x813C;
pub const TEXTURE_MAX_LEVEL = 0x813D;
pub const SMOOTH_POINT_SIZE_RANGE = 0x0B12;
pub const SMOOTH_POINT_SIZE_GRANULARITY = 0x0B13;
pub const SMOOTH_LINE_WIDTH_RANGE = 0x0B22;
pub const SMOOTH_LINE_WIDTH_GRANULARITY = 0x0B23;
pub const ALIASED_LINE_WIDTH_RANGE = 0x846E;
pub const RESCALE_NORMAL = 0x803A;
pub const LIGHT_MODEL_COLOR_CONTROL = 0x81F8;
pub const SINGLE_COLOR = 0x81F9;
pub const SEPARATE_SPECULAR_COLOR = 0x81FA;
pub const ALIASED_POINT_SIZE_RANGE = 0x846D;
pub const TEXTURE0 = 0x84C0;
pub const TEXTURE1 = 0x84C1;
pub const TEXTURE2 = 0x84C2;
pub const TEXTURE3 = 0x84C3;
pub const TEXTURE4 = 0x84C4;
pub const TEXTURE5 = 0x84C5;
pub const TEXTURE6 = 0x84C6;
pub const TEXTURE7 = 0x84C7;
pub const TEXTURE8 = 0x84C8;
pub const TEXTURE9 = 0x84C9;
pub const TEXTURE10 = 0x84CA;
pub const TEXTURE11 = 0x84CB;
pub const TEXTURE12 = 0x84CC;
pub const TEXTURE13 = 0x84CD;
pub const TEXTURE14 = 0x84CE;
pub const TEXTURE15 = 0x84CF;
pub const TEXTURE16 = 0x84D0;
pub const TEXTURE17 = 0x84D1;
pub const TEXTURE18 = 0x84D2;
pub const TEXTURE19 = 0x84D3;
pub const TEXTURE20 = 0x84D4;
pub const TEXTURE21 = 0x84D5;
pub const TEXTURE22 = 0x84D6;
pub const TEXTURE23 = 0x84D7;
pub const TEXTURE24 = 0x84D8;
pub const TEXTURE25 = 0x84D9;
pub const TEXTURE26 = 0x84DA;
pub const TEXTURE27 = 0x84DB;
pub const TEXTURE28 = 0x84DC;
pub const TEXTURE29 = 0x84DD;
pub const TEXTURE30 = 0x84DE;
pub const TEXTURE31 = 0x84DF;
pub const ACTIVE_TEXTURE = 0x84E0;
pub const MULTISAMPLE = 0x809D;
pub const SAMPLE_ALPHA_TO_COVERAGE = 0x809E;
pub const SAMPLE_ALPHA_TO_ONE = 0x809F;
pub const SAMPLE_COVERAGE = 0x80A0;
pub const SAMPLE_BUFFERS = 0x80A8;
pub const SAMPLES = 0x80A9;
pub const SAMPLE_COVERAGE_VALUE = 0x80AA;
pub const SAMPLE_COVERAGE_INVERT = 0x80AB;
pub const TEXTURE_CUBE_MAP = 0x8513;
pub const TEXTURE_BINDING_CUBE_MAP = 0x8514;
pub const TEXTURE_CUBE_MAP_POSITIVE_X = 0x8515;
pub const TEXTURE_CUBE_MAP_NEGATIVE_X = 0x8516;
pub const TEXTURE_CUBE_MAP_POSITIVE_Y = 0x8517;
pub const TEXTURE_CUBE_MAP_NEGATIVE_Y = 0x8518;
pub const TEXTURE_CUBE_MAP_POSITIVE_Z = 0x8519;
pub const TEXTURE_CUBE_MAP_NEGATIVE_Z = 0x851A;
pub const PROXY_TEXTURE_CUBE_MAP = 0x851B;
pub const MAX_CUBE_MAP_TEXTURE_SIZE = 0x851C;
pub const COMPRESSED_RGB = 0x84ED;
pub const COMPRESSED_RGBA = 0x84EE;
pub const TEXTURE_COMPRESSION_HINT = 0x84EF;
pub const TEXTURE_COMPRESSED_IMAGE_SIZE = 0x86A0;
pub const TEXTURE_COMPRESSED = 0x86A1;
pub const NUM_COMPRESSED_TEXTURE_FORMATS = 0x86A2;
pub const COMPRESSED_TEXTURE_FORMATS = 0x86A3;
pub const CLAMP_TO_BORDER = 0x812D;
pub const CLIENT_ACTIVE_TEXTURE = 0x84E1;
pub const MAX_TEXTURE_UNITS = 0x84E2;
pub const TRANSPOSE_MODELVIEW_MATRIX = 0x84E3;
pub const TRANSPOSE_PROJECTION_MATRIX = 0x84E4;
pub const TRANSPOSE_TEXTURE_MATRIX = 0x84E5;
pub const TRANSPOSE_COLOR_MATRIX = 0x84E6;
pub const MULTISAMPLE_BIT = 0x20000000;
pub const NORMAL_MAP = 0x8511;
pub const REFLECTION_MAP = 0x8512;
pub const COMPRESSED_ALPHA = 0x84E9;
pub const COMPRESSED_LUMINANCE = 0x84EA;
pub const COMPRESSED_LUMINANCE_ALPHA = 0x84EB;
pub const COMPRESSED_INTENSITY = 0x84EC;
pub const COMBINE = 0x8570;
pub const COMBINE_RGB = 0x8571;
pub const COMBINE_ALPHA = 0x8572;
pub const SOURCE0_RGB = 0x8580;
pub const SOURCE1_RGB = 0x8581;
pub const SOURCE2_RGB = 0x8582;
pub const SOURCE0_ALPHA = 0x8588;
pub const SOURCE1_ALPHA = 0x8589;
pub const SOURCE2_ALPHA = 0x858A;
pub const OPERAND0_RGB = 0x8590;
pub const OPERAND1_RGB = 0x8591;
pub const OPERAND2_RGB = 0x8592;
pub const OPERAND0_ALPHA = 0x8598;
pub const OPERAND1_ALPHA = 0x8599;
pub const OPERAND2_ALPHA = 0x859A;
pub const RGB_SCALE = 0x8573;
pub const ADD_SIGNED = 0x8574;
pub const INTERPOLATE = 0x8575;
pub const SUBTRACT = 0x84E7;
pub const CONSTANT = 0x8576;
pub const PRIMARY_COLOR = 0x8577;
pub const PREVIOUS = 0x8578;
pub const DOT3_RGB = 0x86AE;
pub const DOT3_RGBA = 0x86AF;
pub const BLEND_DST_RGB = 0x80C8;
pub const BLEND_SRC_RGB = 0x80C9;
pub const BLEND_DST_ALPHA = 0x80CA;
pub const BLEND_SRC_ALPHA = 0x80CB;
pub const POINT_FADE_THRESHOLD_SIZE = 0x8128;
pub const DEPTH_COMPONENT16 = 0x81A5;
pub const DEPTH_COMPONENT24 = 0x81A6;
pub const DEPTH_COMPONENT32 = 0x81A7;
pub const MIRRORED_REPEAT = 0x8370;
pub const MAX_TEXTURE_LOD_BIAS = 0x84FD;
pub const TEXTURE_LOD_BIAS = 0x8501;
pub const INCR_WRAP = 0x8507;
pub const DECR_WRAP = 0x8508;
pub const TEXTURE_DEPTH_SIZE = 0x884A;
pub const TEXTURE_COMPARE_MODE = 0x884C;
pub const TEXTURE_COMPARE_FUNC = 0x884D;
pub const POINT_SIZE_MIN = 0x8126;
pub const POINT_SIZE_MAX = 0x8127;
pub const POINT_DISTANCE_ATTENUATION = 0x8129;
pub const GENERATE_MIPMAP = 0x8191;
pub const GENERATE_MIPMAP_HINT = 0x8192;
pub const FOG_COORDINATE_SOURCE = 0x8450;
pub const FOG_COORDINATE = 0x8451;
pub const FRAGMENT_DEPTH = 0x8452;
pub const CURRENT_FOG_COORDINATE = 0x8453;
pub const FOG_COORDINATE_ARRAY_TYPE = 0x8454;
pub const FOG_COORDINATE_ARRAY_STRIDE = 0x8455;
pub const FOG_COORDINATE_ARRAY_POINTER = 0x8456;
pub const FOG_COORDINATE_ARRAY = 0x8457;
pub const COLOR_SUM = 0x8458;
pub const CURRENT_SECONDARY_COLOR = 0x8459;
pub const SECONDARY_COLOR_ARRAY_SIZE = 0x845A;
pub const SECONDARY_COLOR_ARRAY_TYPE = 0x845B;
pub const SECONDARY_COLOR_ARRAY_STRIDE = 0x845C;
pub const SECONDARY_COLOR_ARRAY_POINTER = 0x845D;
pub const SECONDARY_COLOR_ARRAY = 0x845E;
pub const TEXTURE_FILTER_CONTROL = 0x8500;
pub const DEPTH_TEXTURE_MODE = 0x884B;
pub const COMPARE_R_TO_TEXTURE = 0x884E;
pub const BLEND_COLOR = 0x8005;
pub const BLEND_EQUATION = 0x8009;
pub const CONSTANT_COLOR = 0x8001;
pub const ONE_MINUS_CONSTANT_COLOR = 0x8002;
pub const CONSTANT_ALPHA = 0x8003;
pub const ONE_MINUS_CONSTANT_ALPHA = 0x8004;
pub const FUNC_ADD = 0x8006;
pub const FUNC_REVERSE_SUBTRACT = 0x800B;
pub const FUNC_SUBTRACT = 0x800A;
pub const MIN = 0x8007;
pub const MAX = 0x8008;
pub const BUFFER_SIZE = 0x8764;
pub const BUFFER_USAGE = 0x8765;
pub const QUERY_COUNTER_BITS = 0x8864;
pub const CURRENT_QUERY = 0x8865;
pub const QUERY_RESULT = 0x8866;
pub const QUERY_RESULT_AVAILABLE = 0x8867;
pub const ARRAY_BUFFER = 0x8892;
pub const ELEMENT_ARRAY_BUFFER = 0x8893;
pub const ARRAY_BUFFER_BINDING = 0x8894;
pub const ELEMENT_ARRAY_BUFFER_BINDING = 0x8895;
pub const VERTEX_ATTRIB_ARRAY_BUFFER_BINDING = 0x889F;
pub const READ_ONLY = 0x88B8;
pub const WRITE_ONLY = 0x88B9;
pub const READ_WRITE = 0x88BA;
pub const BUFFER_ACCESS = 0x88BB;
pub const BUFFER_MAPPED = 0x88BC;
pub const BUFFER_MAP_POINTER = 0x88BD;
pub const STREAM_DRAW = 0x88E0;
pub const STREAM_READ = 0x88E1;
pub const STREAM_COPY = 0x88E2;
pub const STATIC_DRAW = 0x88E4;
pub const STATIC_READ = 0x88E5;
pub const STATIC_COPY = 0x88E6;
pub const DYNAMIC_DRAW = 0x88E8;
pub const DYNAMIC_READ = 0x88E9;
pub const DYNAMIC_COPY = 0x88EA;
pub const SAMPLES_PASSED = 0x8914;
pub const SRC1_ALPHA = 0x8589;
pub const VERTEX_ARRAY_BUFFER_BINDING = 0x8896;
pub const NORMAL_ARRAY_BUFFER_BINDING = 0x8897;
pub const COLOR_ARRAY_BUFFER_BINDING = 0x8898;
pub const INDEX_ARRAY_BUFFER_BINDING = 0x8899;
pub const TEXTURE_COORD_ARRAY_BUFFER_BINDING = 0x889A;
pub const EDGE_FLAG_ARRAY_BUFFER_BINDING = 0x889B;
pub const SECONDARY_COLOR_ARRAY_BUFFER_BINDING = 0x889C;
pub const FOG_COORDINATE_ARRAY_BUFFER_BINDING = 0x889D;
pub const WEIGHT_ARRAY_BUFFER_BINDING = 0x889E;
pub const FOG_COORD_SRC = 0x8450;
pub const FOG_COORD = 0x8451;
pub const CURRENT_FOG_COORD = 0x8453;
pub const FOG_COORD_ARRAY_TYPE = 0x8454;
pub const FOG_COORD_ARRAY_STRIDE = 0x8455;
pub const FOG_COORD_ARRAY_POINTER = 0x8456;
pub const FOG_COORD_ARRAY = 0x8457;
pub const FOG_COORD_ARRAY_BUFFER_BINDING = 0x889D;
pub const SRC0_RGB = 0x8580;
pub const SRC1_RGB = 0x8581;
pub const SRC2_RGB = 0x8582;
pub const SRC0_ALPHA = 0x8588;
pub const SRC2_ALPHA = 0x858A;
pub const BLEND_EQUATION_RGB = 0x8009;
pub const VERTEX_ATTRIB_ARRAY_ENABLED = 0x8622;
pub const VERTEX_ATTRIB_ARRAY_SIZE = 0x8623;
pub const VERTEX_ATTRIB_ARRAY_STRIDE = 0x8624;
pub const VERTEX_ATTRIB_ARRAY_TYPE = 0x8625;
pub const CURRENT_VERTEX_ATTRIB = 0x8626;
pub const VERTEX_PROGRAM_POINT_SIZE = 0x8642;
pub const VERTEX_ATTRIB_ARRAY_POINTER = 0x8645;
pub const STENCIL_BACK_FUNC = 0x8800;
pub const STENCIL_BACK_FAIL = 0x8801;
pub const STENCIL_BACK_PASS_DEPTH_FAIL = 0x8802;
pub const STENCIL_BACK_PASS_DEPTH_PASS = 0x8803;
pub const MAX_DRAW_BUFFERS = 0x8824;
pub const DRAW_BUFFER0 = 0x8825;
pub const DRAW_BUFFER1 = 0x8826;
pub const DRAW_BUFFER2 = 0x8827;
pub const DRAW_BUFFER3 = 0x8828;
pub const DRAW_BUFFER4 = 0x8829;
pub const DRAW_BUFFER5 = 0x882A;
pub const DRAW_BUFFER6 = 0x882B;
pub const DRAW_BUFFER7 = 0x882C;
pub const DRAW_BUFFER8 = 0x882D;
pub const DRAW_BUFFER9 = 0x882E;
pub const DRAW_BUFFER10 = 0x882F;
pub const DRAW_BUFFER11 = 0x8830;
pub const DRAW_BUFFER12 = 0x8831;
pub const DRAW_BUFFER13 = 0x8832;
pub const DRAW_BUFFER14 = 0x8833;
pub const DRAW_BUFFER15 = 0x8834;
pub const BLEND_EQUATION_ALPHA = 0x883D;
pub const MAX_VERTEX_ATTRIBS = 0x8869;
pub const VERTEX_ATTRIB_ARRAY_NORMALIZED = 0x886A;
pub const MAX_TEXTURE_IMAGE_UNITS = 0x8872;
pub const FRAGMENT_SHADER = 0x8B30;
pub const VERTEX_SHADER = 0x8B31;
pub const MAX_FRAGMENT_UNIFORM_COMPONENTS = 0x8B49;
pub const MAX_VERTEX_UNIFORM_COMPONENTS = 0x8B4A;
pub const MAX_VARYING_FLOATS = 0x8B4B;
pub const MAX_VERTEX_TEXTURE_IMAGE_UNITS = 0x8B4C;
pub const MAX_COMBINED_TEXTURE_IMAGE_UNITS = 0x8B4D;
pub const SHADER_TYPE = 0x8B4F;
pub const FLOAT_VEC2 = 0x8B50;
pub const FLOAT_VEC3 = 0x8B51;
pub const FLOAT_VEC4 = 0x8B52;
pub const INT_VEC2 = 0x8B53;
pub const INT_VEC3 = 0x8B54;
pub const INT_VEC4 = 0x8B55;
pub const BOOL = 0x8B56;
pub const BOOL_VEC2 = 0x8B57;
pub const BOOL_VEC3 = 0x8B58;
pub const BOOL_VEC4 = 0x8B59;
pub const FLOAT_MAT2 = 0x8B5A;
pub const FLOAT_MAT3 = 0x8B5B;
pub const FLOAT_MAT4 = 0x8B5C;
pub const SAMPLER_1D = 0x8B5D;
pub const SAMPLER_2D = 0x8B5E;
pub const SAMPLER_3D = 0x8B5F;
pub const SAMPLER_CUBE = 0x8B60;
pub const SAMPLER_1D_SHADOW = 0x8B61;
pub const SAMPLER_2D_SHADOW = 0x8B62;
pub const DELETE_STATUS = 0x8B80;
pub const COMPILE_STATUS = 0x8B81;
pub const LINK_STATUS = 0x8B82;
pub const VALIDATE_STATUS = 0x8B83;
pub const INFO_LOG_LENGTH = 0x8B84;
pub const ATTACHED_SHADERS = 0x8B85;
pub const ACTIVE_UNIFORMS = 0x8B86;
pub const ACTIVE_UNIFORM_MAX_LENGTH = 0x8B87;
pub const SHADER_SOURCE_LENGTH = 0x8B88;
pub const ACTIVE_ATTRIBUTES = 0x8B89;
pub const ACTIVE_ATTRIBUTE_MAX_LENGTH = 0x8B8A;
pub const FRAGMENT_SHADER_DERIVATIVE_HINT = 0x8B8B;
pub const SHADING_LANGUAGE_VERSION = 0x8B8C;
pub const CURRENT_PROGRAM = 0x8B8D;
pub const POINT_SPRITE_COORD_ORIGIN = 0x8CA0;
pub const LOWER_LEFT = 0x8CA1;
pub const UPPER_LEFT = 0x8CA2;
pub const STENCIL_BACK_REF = 0x8CA3;
pub const STENCIL_BACK_VALUE_MASK = 0x8CA4;
pub const STENCIL_BACK_WRITEMASK = 0x8CA5;
pub const VERTEX_PROGRAM_TWO_SIDE = 0x8643;
pub const POINT_SPRITE = 0x8861;
pub const COORD_REPLACE = 0x8862;
pub const MAX_TEXTURE_COORDS = 0x8871;
pub const PIXEL_PACK_BUFFER = 0x88EB;
pub const PIXEL_UNPACK_BUFFER = 0x88EC;
pub const PIXEL_PACK_BUFFER_BINDING = 0x88ED;
pub const PIXEL_UNPACK_BUFFER_BINDING = 0x88EF;
pub const FLOAT_MAT2x3 = 0x8B65;
pub const FLOAT_MAT2x4 = 0x8B66;
pub const FLOAT_MAT3x2 = 0x8B67;
pub const FLOAT_MAT3x4 = 0x8B68;
pub const FLOAT_MAT4x2 = 0x8B69;
pub const FLOAT_MAT4x3 = 0x8B6A;
pub const SRGB = 0x8C40;
pub const SRGB8 = 0x8C41;
pub const SRGB_ALPHA = 0x8C42;
pub const SRGB8_ALPHA8 = 0x8C43;
pub const COMPRESSED_SRGB = 0x8C48;
pub const COMPRESSED_SRGB_ALPHA = 0x8C49;
pub const CURRENT_RASTER_SECONDARY_COLOR = 0x845F;
pub const SLUMINANCE_ALPHA = 0x8C44;
pub const SLUMINANCE8_ALPHA8 = 0x8C45;
pub const SLUMINANCE = 0x8C46;
pub const SLUMINANCE8 = 0x8C47;
pub const COMPRESSED_SLUMINANCE = 0x8C4A;
pub const COMPRESSED_SLUMINANCE_ALPHA = 0x8C4B;

pub fn cullFace(_mode: GLenum) callconv(.C) void {
    return @call(.always_tail, function_pointers.glCullFace, .{_mode});
}

pub fn frontFace(_mode: GLenum) callconv(.C) void {
    return @call(.always_tail, function_pointers.glFrontFace, .{_mode});
}

pub fn hint(_target: GLenum, _mode: GLenum) callconv(.C) void {
    return @call(.always_tail, function_pointers.glHint, .{ _target, _mode });
}

pub fn lineWidth(_width: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glLineWidth, .{_width});
}

pub fn pointSize(_size: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glPointSize, .{_size});
}

pub fn polygonMode(_face: GLenum, _mode: GLenum) callconv(.C) void {
    return @call(.always_tail, function_pointers.glPolygonMode, .{ _face, _mode });
}

pub fn scissor(_x: GLint, _y: GLint, _width: GLsizei, _height: GLsizei) callconv(.C) void {
    return @call(.always_tail, function_pointers.glScissor, .{ _x, _y, _width, _height });
}

pub fn texParameterf(_target: GLenum, _pname: GLenum, _param: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glTexParameterf, .{ _target, _pname, _param });
}

pub fn texParameterfv(_target: GLenum, _pname: GLenum, _params: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glTexParameterfv, .{ _target, _pname, _params });
}

pub fn texParameteri(_target: GLenum, _pname: GLenum, _param: GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glTexParameteri, .{ _target, _pname, _param });
}

pub fn texParameteriv(_target: GLenum, _pname: GLenum, _params: [*c]const GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glTexParameteriv, .{ _target, _pname, _params });
}

pub fn texImage1D(_target: GLenum, _level: GLint, _internalformat: GLint, _width: GLsizei, _border: GLint, _format: GLenum, _type: GLenum, _pixels: ?*const anyopaque) callconv(.C) void {
    return @call(.always_tail, function_pointers.glTexImage1D, .{ _target, _level, _internalformat, _width, _border, _format, _type, _pixels });
}

pub fn texImage2D(_target: GLenum, _level: GLint, _internalformat: GLint, _width: GLsizei, _height: GLsizei, _border: GLint, _format: GLenum, _type: GLenum, _pixels: ?*const anyopaque) callconv(.C) void {
    return @call(.always_tail, function_pointers.glTexImage2D, .{ _target, _level, _internalformat, _width, _height, _border, _format, _type, _pixels });
}

pub fn drawBuffer(_buf: GLenum) callconv(.C) void {
    return @call(.always_tail, function_pointers.glDrawBuffer, .{_buf});
}

pub fn clear(_mask: GLbitfield) callconv(.C) void {
    return @call(.always_tail, function_pointers.glClear, .{_mask});
}

pub fn clearColor(_red: GLfloat, _green: GLfloat, _blue: GLfloat, _alpha: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glClearColor, .{ _red, _green, _blue, _alpha });
}

pub fn clearStencil(_s: GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glClearStencil, .{_s});
}

pub fn clearDepth(_depth: GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glClearDepth, .{_depth});
}

pub fn stencilMask(_mask: GLuint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glStencilMask, .{_mask});
}

pub fn colorMask(_red: GLboolean, _green: GLboolean, _blue: GLboolean, _alpha: GLboolean) callconv(.C) void {
    return @call(.always_tail, function_pointers.glColorMask, .{ _red, _green, _blue, _alpha });
}

pub fn depthMask(_flag: GLboolean) callconv(.C) void {
    return @call(.always_tail, function_pointers.glDepthMask, .{_flag});
}

pub fn disable(_cap: GLenum) callconv(.C) void {
    return @call(.always_tail, function_pointers.glDisable, .{_cap});
}

pub fn enable(_cap: GLenum) callconv(.C) void {
    return @call(.always_tail, function_pointers.glEnable, .{_cap});
}

pub fn finish() callconv(.C) void {
    return @call(.always_tail, function_pointers.glFinish, .{});
}

pub fn flush() callconv(.C) void {
    return @call(.always_tail, function_pointers.glFlush, .{});
}

pub fn blendFunc(_sfactor: GLenum, _dfactor: GLenum) callconv(.C) void {
    return @call(.always_tail, function_pointers.glBlendFunc, .{ _sfactor, _dfactor });
}

pub fn logicOp(_opcode: GLenum) callconv(.C) void {
    return @call(.always_tail, function_pointers.glLogicOp, .{_opcode});
}

pub fn stencilFunc(_func: GLenum, _ref: GLint, _mask: GLuint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glStencilFunc, .{ _func, _ref, _mask });
}

pub fn stencilOp(_fail: GLenum, _zfail: GLenum, _zpass: GLenum) callconv(.C) void {
    return @call(.always_tail, function_pointers.glStencilOp, .{ _fail, _zfail, _zpass });
}

pub fn depthFunc(_func: GLenum) callconv(.C) void {
    return @call(.always_tail, function_pointers.glDepthFunc, .{_func});
}

pub fn pixelStoref(_pname: GLenum, _param: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glPixelStoref, .{ _pname, _param });
}

pub fn pixelStorei(_pname: GLenum, _param: GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glPixelStorei, .{ _pname, _param });
}

pub fn readBuffer(_src: GLenum) callconv(.C) void {
    return @call(.always_tail, function_pointers.glReadBuffer, .{_src});
}

pub fn readPixels(_x: GLint, _y: GLint, _width: GLsizei, _height: GLsizei, _format: GLenum, _type: GLenum, _pixels: ?*anyopaque) callconv(.C) void {
    return @call(.always_tail, function_pointers.glReadPixels, .{ _x, _y, _width, _height, _format, _type, _pixels });
}

pub fn getBooleanv(_pname: GLenum, _data: [*c]GLboolean) callconv(.C) void {
    return @call(.always_tail, function_pointers.glGetBooleanv, .{ _pname, _data });
}

pub fn getDoublev(_pname: GLenum, _data: [*c]GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glGetDoublev, .{ _pname, _data });
}

pub fn getError() callconv(.C) GLenum {
    return @call(.always_tail, function_pointers.glGetError, .{});
}

pub fn getFloatv(_pname: GLenum, _data: [*c]GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glGetFloatv, .{ _pname, _data });
}

pub fn getIntegerv(_pname: GLenum, _data: [*c]GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glGetIntegerv, .{ _pname, _data });
}

pub fn getString(_name: GLenum) callconv(.C) ?[*:0]const GLubyte {
    return @call(.always_tail, function_pointers.glGetString, .{_name});
}

pub fn getTexImage(_target: GLenum, _level: GLint, _format: GLenum, _type: GLenum, _pixels: ?*anyopaque) callconv(.C) void {
    return @call(.always_tail, function_pointers.glGetTexImage, .{ _target, _level, _format, _type, _pixels });
}

pub fn getTexParameterfv(_target: GLenum, _pname: GLenum, _params: [*c]GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glGetTexParameterfv, .{ _target, _pname, _params });
}

pub fn getTexParameteriv(_target: GLenum, _pname: GLenum, _params: [*c]GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glGetTexParameteriv, .{ _target, _pname, _params });
}

pub fn getTexLevelParameterfv(_target: GLenum, _level: GLint, _pname: GLenum, _params: [*c]GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glGetTexLevelParameterfv, .{ _target, _level, _pname, _params });
}

pub fn getTexLevelParameteriv(_target: GLenum, _level: GLint, _pname: GLenum, _params: [*c]GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glGetTexLevelParameteriv, .{ _target, _level, _pname, _params });
}

pub fn isEnabled(_cap: GLenum) callconv(.C) GLboolean {
    return @call(.always_tail, function_pointers.glIsEnabled, .{_cap});
}

pub fn depthRange(_n: GLdouble, _f: GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glDepthRange, .{ _n, _f });
}

pub fn viewport(_x: GLint, _y: GLint, _width: GLsizei, _height: GLsizei) callconv(.C) void {
    return @call(.always_tail, function_pointers.glViewport, .{ _x, _y, _width, _height });
}

pub fn newList(_list: GLuint, _mode: GLenum) callconv(.C) void {
    return @call(.always_tail, function_pointers.glNewList, .{ _list, _mode });
}

pub fn endList() callconv(.C) void {
    return @call(.always_tail, function_pointers.glEndList, .{});
}

pub fn callList(_list: GLuint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glCallList, .{_list});
}

pub fn callLists(_n: GLsizei, _type: GLenum, _lists: ?*const anyopaque) callconv(.C) void {
    return @call(.always_tail, function_pointers.glCallLists, .{ _n, _type, _lists });
}

pub fn deleteLists(_list: GLuint, _range: GLsizei) callconv(.C) void {
    return @call(.always_tail, function_pointers.glDeleteLists, .{ _list, _range });
}

pub fn genLists(_range: GLsizei) callconv(.C) GLuint {
    return @call(.always_tail, function_pointers.glGenLists, .{_range});
}

pub fn listBase(_base: GLuint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glListBase, .{_base});
}

pub fn begin(_mode: GLenum) callconv(.C) void {
    return @call(.always_tail, function_pointers.glBegin, .{_mode});
}

pub fn bitmap(_width: GLsizei, _height: GLsizei, _xorig: GLfloat, _yorig: GLfloat, _xmove: GLfloat, _ymove: GLfloat, _bitmap: ?[*:0]const GLubyte) callconv(.C) void {
    return @call(.always_tail, function_pointers.glBitmap, .{ _width, _height, _xorig, _yorig, _xmove, _ymove, _bitmap });
}

pub fn color3b(_red: GLbyte, _green: GLbyte, _blue: GLbyte) callconv(.C) void {
    return @call(.always_tail, function_pointers.glColor3b, .{ _red, _green, _blue });
}

pub fn color3bv(_v: [*c]const GLbyte) callconv(.C) void {
    return @call(.always_tail, function_pointers.glColor3bv, .{_v});
}

pub fn color3d(_red: GLdouble, _green: GLdouble, _blue: GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glColor3d, .{ _red, _green, _blue });
}

pub fn color3dv(_v: [*c]const GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glColor3dv, .{_v});
}

pub fn color3f(_red: GLfloat, _green: GLfloat, _blue: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glColor3f, .{ _red, _green, _blue });
}

pub fn color3fv(_v: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glColor3fv, .{_v});
}

pub fn color3i(_red: GLint, _green: GLint, _blue: GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glColor3i, .{ _red, _green, _blue });
}

pub fn color3iv(_v: [*c]const GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glColor3iv, .{_v});
}

pub fn color3s(_red: GLshort, _green: GLshort, _blue: GLshort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glColor3s, .{ _red, _green, _blue });
}

pub fn color3sv(_v: [*c]const GLshort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glColor3sv, .{_v});
}

pub fn color3ub(_red: GLubyte, _green: GLubyte, _blue: GLubyte) callconv(.C) void {
    return @call(.always_tail, function_pointers.glColor3ub, .{ _red, _green, _blue });
}

pub fn color3ubv(_v: ?[*:0]const GLubyte) callconv(.C) void {
    return @call(.always_tail, function_pointers.glColor3ubv, .{_v});
}

pub fn color3ui(_red: GLuint, _green: GLuint, _blue: GLuint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glColor3ui, .{ _red, _green, _blue });
}

pub fn color3uiv(_v: [*c]const GLuint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glColor3uiv, .{_v});
}

pub fn color3us(_red: GLushort, _green: GLushort, _blue: GLushort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glColor3us, .{ _red, _green, _blue });
}

pub fn color3usv(_v: [*c]const GLushort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glColor3usv, .{_v});
}

pub fn color4b(_red: GLbyte, _green: GLbyte, _blue: GLbyte, _alpha: GLbyte) callconv(.C) void {
    return @call(.always_tail, function_pointers.glColor4b, .{ _red, _green, _blue, _alpha });
}

pub fn color4bv(_v: [*c]const GLbyte) callconv(.C) void {
    return @call(.always_tail, function_pointers.glColor4bv, .{_v});
}

pub fn color4d(_red: GLdouble, _green: GLdouble, _blue: GLdouble, _alpha: GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glColor4d, .{ _red, _green, _blue, _alpha });
}

pub fn color4dv(_v: [*c]const GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glColor4dv, .{_v});
}

pub fn color4f(_red: GLfloat, _green: GLfloat, _blue: GLfloat, _alpha: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glColor4f, .{ _red, _green, _blue, _alpha });
}

pub fn color4fv(_v: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glColor4fv, .{_v});
}

pub fn color4i(_red: GLint, _green: GLint, _blue: GLint, _alpha: GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glColor4i, .{ _red, _green, _blue, _alpha });
}

pub fn color4iv(_v: [*c]const GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glColor4iv, .{_v});
}

pub fn color4s(_red: GLshort, _green: GLshort, _blue: GLshort, _alpha: GLshort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glColor4s, .{ _red, _green, _blue, _alpha });
}

pub fn color4sv(_v: [*c]const GLshort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glColor4sv, .{_v});
}

pub fn color4ub(_red: GLubyte, _green: GLubyte, _blue: GLubyte, _alpha: GLubyte) callconv(.C) void {
    return @call(.always_tail, function_pointers.glColor4ub, .{ _red, _green, _blue, _alpha });
}

pub fn color4ubv(_v: ?[*:0]const GLubyte) callconv(.C) void {
    return @call(.always_tail, function_pointers.glColor4ubv, .{_v});
}

pub fn color4ui(_red: GLuint, _green: GLuint, _blue: GLuint, _alpha: GLuint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glColor4ui, .{ _red, _green, _blue, _alpha });
}

pub fn color4uiv(_v: [*c]const GLuint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glColor4uiv, .{_v});
}

pub fn color4us(_red: GLushort, _green: GLushort, _blue: GLushort, _alpha: GLushort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glColor4us, .{ _red, _green, _blue, _alpha });
}

pub fn color4usv(_v: [*c]const GLushort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glColor4usv, .{_v});
}

pub fn edgeFlag(_flag: GLboolean) callconv(.C) void {
    return @call(.always_tail, function_pointers.glEdgeFlag, .{_flag});
}

pub fn edgeFlagv(_flag: [*c]const GLboolean) callconv(.C) void {
    return @call(.always_tail, function_pointers.glEdgeFlagv, .{_flag});
}

pub fn end() callconv(.C) void {
    return @call(.always_tail, function_pointers.glEnd, .{});
}

pub fn indexd(_c: GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glIndexd, .{_c});
}

pub fn indexdv(_c: [*c]const GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glIndexdv, .{_c});
}

pub fn indexf(_c: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glIndexf, .{_c});
}

pub fn indexfv(_c: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glIndexfv, .{_c});
}

pub fn indexi(_c: GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glIndexi, .{_c});
}

pub fn indexiv(_c: [*c]const GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glIndexiv, .{_c});
}

pub fn indexs(_c: GLshort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glIndexs, .{_c});
}

pub fn indexsv(_c: [*c]const GLshort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glIndexsv, .{_c});
}

pub fn normal3b(_nx: GLbyte, _ny: GLbyte, _nz: GLbyte) callconv(.C) void {
    return @call(.always_tail, function_pointers.glNormal3b, .{ _nx, _ny, _nz });
}

pub fn normal3bv(_v: [*c]const GLbyte) callconv(.C) void {
    return @call(.always_tail, function_pointers.glNormal3bv, .{_v});
}

pub fn normal3d(_nx: GLdouble, _ny: GLdouble, _nz: GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glNormal3d, .{ _nx, _ny, _nz });
}

pub fn normal3dv(_v: [*c]const GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glNormal3dv, .{_v});
}

pub fn normal3f(_nx: GLfloat, _ny: GLfloat, _nz: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glNormal3f, .{ _nx, _ny, _nz });
}

pub fn normal3fv(_v: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glNormal3fv, .{_v});
}

pub fn normal3i(_nx: GLint, _ny: GLint, _nz: GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glNormal3i, .{ _nx, _ny, _nz });
}

pub fn normal3iv(_v: [*c]const GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glNormal3iv, .{_v});
}

pub fn normal3s(_nx: GLshort, _ny: GLshort, _nz: GLshort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glNormal3s, .{ _nx, _ny, _nz });
}

pub fn normal3sv(_v: [*c]const GLshort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glNormal3sv, .{_v});
}

pub fn rasterPos2d(_x: GLdouble, _y: GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glRasterPos2d, .{ _x, _y });
}

pub fn rasterPos2dv(_v: [*c]const GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glRasterPos2dv, .{_v});
}

pub fn rasterPos2f(_x: GLfloat, _y: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glRasterPos2f, .{ _x, _y });
}

pub fn rasterPos2fv(_v: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glRasterPos2fv, .{_v});
}

pub fn rasterPos2i(_x: GLint, _y: GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glRasterPos2i, .{ _x, _y });
}

pub fn rasterPos2iv(_v: [*c]const GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glRasterPos2iv, .{_v});
}

pub fn rasterPos2s(_x: GLshort, _y: GLshort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glRasterPos2s, .{ _x, _y });
}

pub fn rasterPos2sv(_v: [*c]const GLshort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glRasterPos2sv, .{_v});
}

pub fn rasterPos3d(_x: GLdouble, _y: GLdouble, _z: GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glRasterPos3d, .{ _x, _y, _z });
}

pub fn rasterPos3dv(_v: [*c]const GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glRasterPos3dv, .{_v});
}

pub fn rasterPos3f(_x: GLfloat, _y: GLfloat, _z: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glRasterPos3f, .{ _x, _y, _z });
}

pub fn rasterPos3fv(_v: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glRasterPos3fv, .{_v});
}

pub fn rasterPos3i(_x: GLint, _y: GLint, _z: GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glRasterPos3i, .{ _x, _y, _z });
}

pub fn rasterPos3iv(_v: [*c]const GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glRasterPos3iv, .{_v});
}

pub fn rasterPos3s(_x: GLshort, _y: GLshort, _z: GLshort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glRasterPos3s, .{ _x, _y, _z });
}

pub fn rasterPos3sv(_v: [*c]const GLshort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glRasterPos3sv, .{_v});
}

pub fn rasterPos4d(_x: GLdouble, _y: GLdouble, _z: GLdouble, _w: GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glRasterPos4d, .{ _x, _y, _z, _w });
}

pub fn rasterPos4dv(_v: [*c]const GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glRasterPos4dv, .{_v});
}

pub fn rasterPos4f(_x: GLfloat, _y: GLfloat, _z: GLfloat, _w: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glRasterPos4f, .{ _x, _y, _z, _w });
}

pub fn rasterPos4fv(_v: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glRasterPos4fv, .{_v});
}

pub fn rasterPos4i(_x: GLint, _y: GLint, _z: GLint, _w: GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glRasterPos4i, .{ _x, _y, _z, _w });
}

pub fn rasterPos4iv(_v: [*c]const GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glRasterPos4iv, .{_v});
}

pub fn rasterPos4s(_x: GLshort, _y: GLshort, _z: GLshort, _w: GLshort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glRasterPos4s, .{ _x, _y, _z, _w });
}

pub fn rasterPos4sv(_v: [*c]const GLshort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glRasterPos4sv, .{_v});
}

pub fn rectd(_x1: GLdouble, _y1: GLdouble, _x2: GLdouble, _y2: GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glRectd, .{ _x1, _y1, _x2, _y2 });
}

pub fn rectdv(_v1: [*c]const GLdouble, _v2: [*c]const GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glRectdv, .{ _v1, _v2 });
}

pub fn rectf(_x1: GLfloat, _y1: GLfloat, _x2: GLfloat, _y2: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glRectf, .{ _x1, _y1, _x2, _y2 });
}

pub fn rectfv(_v1: [*c]const GLfloat, _v2: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glRectfv, .{ _v1, _v2 });
}

pub fn recti(_x1: GLint, _y1: GLint, _x2: GLint, _y2: GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glRecti, .{ _x1, _y1, _x2, _y2 });
}

pub fn rectiv(_v1: [*c]const GLint, _v2: [*c]const GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glRectiv, .{ _v1, _v2 });
}

pub fn rects(_x1: GLshort, _y1: GLshort, _x2: GLshort, _y2: GLshort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glRects, .{ _x1, _y1, _x2, _y2 });
}

pub fn rectsv(_v1: [*c]const GLshort, _v2: [*c]const GLshort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glRectsv, .{ _v1, _v2 });
}

pub fn texCoord1d(_s: GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glTexCoord1d, .{_s});
}

pub fn texCoord1dv(_v: [*c]const GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glTexCoord1dv, .{_v});
}

pub fn texCoord1f(_s: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glTexCoord1f, .{_s});
}

pub fn texCoord1fv(_v: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glTexCoord1fv, .{_v});
}

pub fn texCoord1i(_s: GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glTexCoord1i, .{_s});
}

pub fn texCoord1iv(_v: [*c]const GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glTexCoord1iv, .{_v});
}

pub fn texCoord1s(_s: GLshort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glTexCoord1s, .{_s});
}

pub fn texCoord1sv(_v: [*c]const GLshort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glTexCoord1sv, .{_v});
}

pub fn texCoord2d(_s: GLdouble, _t: GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glTexCoord2d, .{ _s, _t });
}

pub fn texCoord2dv(_v: [*c]const GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glTexCoord2dv, .{_v});
}

pub fn texCoord2f(_s: GLfloat, _t: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glTexCoord2f, .{ _s, _t });
}

pub fn texCoord2fv(_v: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glTexCoord2fv, .{_v});
}

pub fn texCoord2i(_s: GLint, _t: GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glTexCoord2i, .{ _s, _t });
}

pub fn texCoord2iv(_v: [*c]const GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glTexCoord2iv, .{_v});
}

pub fn texCoord2s(_s: GLshort, _t: GLshort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glTexCoord2s, .{ _s, _t });
}

pub fn texCoord2sv(_v: [*c]const GLshort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glTexCoord2sv, .{_v});
}

pub fn texCoord3d(_s: GLdouble, _t: GLdouble, _r: GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glTexCoord3d, .{ _s, _t, _r });
}

pub fn texCoord3dv(_v: [*c]const GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glTexCoord3dv, .{_v});
}

pub fn texCoord3f(_s: GLfloat, _t: GLfloat, _r: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glTexCoord3f, .{ _s, _t, _r });
}

pub fn texCoord3fv(_v: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glTexCoord3fv, .{_v});
}

pub fn texCoord3i(_s: GLint, _t: GLint, _r: GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glTexCoord3i, .{ _s, _t, _r });
}

pub fn texCoord3iv(_v: [*c]const GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glTexCoord3iv, .{_v});
}

pub fn texCoord3s(_s: GLshort, _t: GLshort, _r: GLshort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glTexCoord3s, .{ _s, _t, _r });
}

pub fn texCoord3sv(_v: [*c]const GLshort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glTexCoord3sv, .{_v});
}

pub fn texCoord4d(_s: GLdouble, _t: GLdouble, _r: GLdouble, _q: GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glTexCoord4d, .{ _s, _t, _r, _q });
}

pub fn texCoord4dv(_v: [*c]const GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glTexCoord4dv, .{_v});
}

pub fn texCoord4f(_s: GLfloat, _t: GLfloat, _r: GLfloat, _q: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glTexCoord4f, .{ _s, _t, _r, _q });
}

pub fn texCoord4fv(_v: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glTexCoord4fv, .{_v});
}

pub fn texCoord4i(_s: GLint, _t: GLint, _r: GLint, _q: GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glTexCoord4i, .{ _s, _t, _r, _q });
}

pub fn texCoord4iv(_v: [*c]const GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glTexCoord4iv, .{_v});
}

pub fn texCoord4s(_s: GLshort, _t: GLshort, _r: GLshort, _q: GLshort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glTexCoord4s, .{ _s, _t, _r, _q });
}

pub fn texCoord4sv(_v: [*c]const GLshort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glTexCoord4sv, .{_v});
}

pub fn vertex2d(_x: GLdouble, _y: GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertex2d, .{ _x, _y });
}

pub fn vertex2dv(_v: [*c]const GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertex2dv, .{_v});
}

pub fn vertex2f(_x: GLfloat, _y: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertex2f, .{ _x, _y });
}

pub fn vertex2fv(_v: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertex2fv, .{_v});
}

pub fn vertex2i(_x: GLint, _y: GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertex2i, .{ _x, _y });
}

pub fn vertex2iv(_v: [*c]const GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertex2iv, .{_v});
}

pub fn vertex2s(_x: GLshort, _y: GLshort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertex2s, .{ _x, _y });
}

pub fn vertex2sv(_v: [*c]const GLshort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertex2sv, .{_v});
}

pub fn vertex3d(_x: GLdouble, _y: GLdouble, _z: GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertex3d, .{ _x, _y, _z });
}

pub fn vertex3dv(_v: [*c]const GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertex3dv, .{_v});
}

pub fn vertex3f(_x: GLfloat, _y: GLfloat, _z: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertex3f, .{ _x, _y, _z });
}

pub fn vertex3fv(_v: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertex3fv, .{_v});
}

pub fn vertex3i(_x: GLint, _y: GLint, _z: GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertex3i, .{ _x, _y, _z });
}

pub fn vertex3iv(_v: [*c]const GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertex3iv, .{_v});
}

pub fn vertex3s(_x: GLshort, _y: GLshort, _z: GLshort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertex3s, .{ _x, _y, _z });
}

pub fn vertex3sv(_v: [*c]const GLshort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertex3sv, .{_v});
}

pub fn vertex4d(_x: GLdouble, _y: GLdouble, _z: GLdouble, _w: GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertex4d, .{ _x, _y, _z, _w });
}

pub fn vertex4dv(_v: [*c]const GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertex4dv, .{_v});
}

pub fn vertex4f(_x: GLfloat, _y: GLfloat, _z: GLfloat, _w: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertex4f, .{ _x, _y, _z, _w });
}

pub fn vertex4fv(_v: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertex4fv, .{_v});
}

pub fn vertex4i(_x: GLint, _y: GLint, _z: GLint, _w: GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertex4i, .{ _x, _y, _z, _w });
}

pub fn vertex4iv(_v: [*c]const GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertex4iv, .{_v});
}

pub fn vertex4s(_x: GLshort, _y: GLshort, _z: GLshort, _w: GLshort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertex4s, .{ _x, _y, _z, _w });
}

pub fn vertex4sv(_v: [*c]const GLshort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertex4sv, .{_v});
}

pub fn clipPlane(_plane: GLenum, _equation: [*c]const GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glClipPlane, .{ _plane, _equation });
}

pub fn colorMaterial(_face: GLenum, _mode: GLenum) callconv(.C) void {
    return @call(.always_tail, function_pointers.glColorMaterial, .{ _face, _mode });
}

pub fn fogf(_pname: GLenum, _param: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glFogf, .{ _pname, _param });
}

pub fn fogfv(_pname: GLenum, _params: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glFogfv, .{ _pname, _params });
}

pub fn fogi(_pname: GLenum, _param: GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glFogi, .{ _pname, _param });
}

pub fn fogiv(_pname: GLenum, _params: [*c]const GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glFogiv, .{ _pname, _params });
}

pub fn lightf(_light: GLenum, _pname: GLenum, _param: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glLightf, .{ _light, _pname, _param });
}

pub fn lightfv(_light: GLenum, _pname: GLenum, _params: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glLightfv, .{ _light, _pname, _params });
}

pub fn lighti(_light: GLenum, _pname: GLenum, _param: GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glLighti, .{ _light, _pname, _param });
}

pub fn lightiv(_light: GLenum, _pname: GLenum, _params: [*c]const GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glLightiv, .{ _light, _pname, _params });
}

pub fn lightModelf(_pname: GLenum, _param: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glLightModelf, .{ _pname, _param });
}

pub fn lightModelfv(_pname: GLenum, _params: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glLightModelfv, .{ _pname, _params });
}

pub fn lightModeli(_pname: GLenum, _param: GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glLightModeli, .{ _pname, _param });
}

pub fn lightModeliv(_pname: GLenum, _params: [*c]const GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glLightModeliv, .{ _pname, _params });
}

pub fn lineStipple(_factor: GLint, _pattern: GLushort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glLineStipple, .{ _factor, _pattern });
}

pub fn materialf(_face: GLenum, _pname: GLenum, _param: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glMaterialf, .{ _face, _pname, _param });
}

pub fn materialfv(_face: GLenum, _pname: GLenum, _params: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glMaterialfv, .{ _face, _pname, _params });
}

pub fn materiali(_face: GLenum, _pname: GLenum, _param: GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glMateriali, .{ _face, _pname, _param });
}

pub fn materialiv(_face: GLenum, _pname: GLenum, _params: [*c]const GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glMaterialiv, .{ _face, _pname, _params });
}

pub fn polygonStipple(_mask: ?[*:0]const GLubyte) callconv(.C) void {
    return @call(.always_tail, function_pointers.glPolygonStipple, .{_mask});
}

pub fn shadeModel(_mode: GLenum) callconv(.C) void {
    return @call(.always_tail, function_pointers.glShadeModel, .{_mode});
}

pub fn texEnvf(_target: GLenum, _pname: GLenum, _param: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glTexEnvf, .{ _target, _pname, _param });
}

pub fn texEnvfv(_target: GLenum, _pname: GLenum, _params: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glTexEnvfv, .{ _target, _pname, _params });
}

pub fn texEnvi(_target: GLenum, _pname: GLenum, _param: GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glTexEnvi, .{ _target, _pname, _param });
}

pub fn texEnviv(_target: GLenum, _pname: GLenum, _params: [*c]const GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glTexEnviv, .{ _target, _pname, _params });
}

pub fn texGend(_coord: GLenum, _pname: GLenum, _param: GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glTexGend, .{ _coord, _pname, _param });
}

pub fn texGendv(_coord: GLenum, _pname: GLenum, _params: [*c]const GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glTexGendv, .{ _coord, _pname, _params });
}

pub fn texGenf(_coord: GLenum, _pname: GLenum, _param: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glTexGenf, .{ _coord, _pname, _param });
}

pub fn texGenfv(_coord: GLenum, _pname: GLenum, _params: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glTexGenfv, .{ _coord, _pname, _params });
}

pub fn texGeni(_coord: GLenum, _pname: GLenum, _param: GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glTexGeni, .{ _coord, _pname, _param });
}

pub fn texGeniv(_coord: GLenum, _pname: GLenum, _params: [*c]const GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glTexGeniv, .{ _coord, _pname, _params });
}

pub fn feedbackBuffer(_size: GLsizei, _type: GLenum, _buffer: [*c]GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glFeedbackBuffer, .{ _size, _type, _buffer });
}

pub fn selectBuffer(_size: GLsizei, _buffer: [*c]GLuint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glSelectBuffer, .{ _size, _buffer });
}

pub fn renderMode(_mode: GLenum) callconv(.C) GLint {
    return @call(.always_tail, function_pointers.glRenderMode, .{_mode});
}

pub fn initNames() callconv(.C) void {
    return @call(.always_tail, function_pointers.glInitNames, .{});
}

pub fn loadName(_name: GLuint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glLoadName, .{_name});
}

pub fn passThrough(_token: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glPassThrough, .{_token});
}

pub fn popName() callconv(.C) void {
    return @call(.always_tail, function_pointers.glPopName, .{});
}

pub fn pushName(_name: GLuint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glPushName, .{_name});
}

pub fn clearAccum(_red: GLfloat, _green: GLfloat, _blue: GLfloat, _alpha: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glClearAccum, .{ _red, _green, _blue, _alpha });
}

pub fn clearIndex(_c: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glClearIndex, .{_c});
}

pub fn indexMask(_mask: GLuint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glIndexMask, .{_mask});
}

pub fn accum(_op: GLenum, _value: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glAccum, .{ _op, _value });
}

pub fn popAttrib() callconv(.C) void {
    return @call(.always_tail, function_pointers.glPopAttrib, .{});
}

pub fn pushAttrib(_mask: GLbitfield) callconv(.C) void {
    return @call(.always_tail, function_pointers.glPushAttrib, .{_mask});
}

pub fn map1d(_target: GLenum, _u1: GLdouble, _u2: GLdouble, _stride: GLint, _order: GLint, _points: [*c]const GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glMap1d, .{ _target, _u1, _u2, _stride, _order, _points });
}

pub fn map1f(_target: GLenum, _u1: GLfloat, _u2: GLfloat, _stride: GLint, _order: GLint, _points: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glMap1f, .{ _target, _u1, _u2, _stride, _order, _points });
}

pub fn map2d(_target: GLenum, _u1: GLdouble, _u2: GLdouble, _ustride: GLint, _uorder: GLint, _v1: GLdouble, _v2: GLdouble, _vstride: GLint, _vorder: GLint, _points: [*c]const GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glMap2d, .{ _target, _u1, _u2, _ustride, _uorder, _v1, _v2, _vstride, _vorder, _points });
}

pub fn map2f(_target: GLenum, _u1: GLfloat, _u2: GLfloat, _ustride: GLint, _uorder: GLint, _v1: GLfloat, _v2: GLfloat, _vstride: GLint, _vorder: GLint, _points: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glMap2f, .{ _target, _u1, _u2, _ustride, _uorder, _v1, _v2, _vstride, _vorder, _points });
}

pub fn mapGrid1d(_un: GLint, _u1: GLdouble, _u2: GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glMapGrid1d, .{ _un, _u1, _u2 });
}

pub fn mapGrid1f(_un: GLint, _u1: GLfloat, _u2: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glMapGrid1f, .{ _un, _u1, _u2 });
}

pub fn mapGrid2d(_un: GLint, _u1: GLdouble, _u2: GLdouble, _vn: GLint, _v1: GLdouble, _v2: GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glMapGrid2d, .{ _un, _u1, _u2, _vn, _v1, _v2 });
}

pub fn mapGrid2f(_un: GLint, _u1: GLfloat, _u2: GLfloat, _vn: GLint, _v1: GLfloat, _v2: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glMapGrid2f, .{ _un, _u1, _u2, _vn, _v1, _v2 });
}

pub fn evalCoord1d(_u: GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glEvalCoord1d, .{_u});
}

pub fn evalCoord1dv(_u: [*c]const GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glEvalCoord1dv, .{_u});
}

pub fn evalCoord1f(_u: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glEvalCoord1f, .{_u});
}

pub fn evalCoord1fv(_u: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glEvalCoord1fv, .{_u});
}

pub fn evalCoord2d(_u: GLdouble, _v: GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glEvalCoord2d, .{ _u, _v });
}

pub fn evalCoord2dv(_u: [*c]const GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glEvalCoord2dv, .{_u});
}

pub fn evalCoord2f(_u: GLfloat, _v: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glEvalCoord2f, .{ _u, _v });
}

pub fn evalCoord2fv(_u: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glEvalCoord2fv, .{_u});
}

pub fn evalMesh1(_mode: GLenum, _i1: GLint, _i2: GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glEvalMesh1, .{ _mode, _i1, _i2 });
}

pub fn evalPoint1(_i: GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glEvalPoint1, .{_i});
}

pub fn evalMesh2(_mode: GLenum, _i1: GLint, _i2: GLint, _j1: GLint, _j2: GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glEvalMesh2, .{ _mode, _i1, _i2, _j1, _j2 });
}

pub fn evalPoint2(_i: GLint, _j: GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glEvalPoint2, .{ _i, _j });
}

pub fn alphaFunc(_func: GLenum, _ref: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glAlphaFunc, .{ _func, _ref });
}

pub fn pixelZoom(_xfactor: GLfloat, _yfactor: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glPixelZoom, .{ _xfactor, _yfactor });
}

pub fn pixelTransferf(_pname: GLenum, _param: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glPixelTransferf, .{ _pname, _param });
}

pub fn pixelTransferi(_pname: GLenum, _param: GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glPixelTransferi, .{ _pname, _param });
}

pub fn pixelMapfv(_map: GLenum, _mapsize: GLsizei, _values: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glPixelMapfv, .{ _map, _mapsize, _values });
}

pub fn pixelMapuiv(_map: GLenum, _mapsize: GLsizei, _values: [*c]const GLuint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glPixelMapuiv, .{ _map, _mapsize, _values });
}

pub fn pixelMapusv(_map: GLenum, _mapsize: GLsizei, _values: [*c]const GLushort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glPixelMapusv, .{ _map, _mapsize, _values });
}

pub fn copyPixels(_x: GLint, _y: GLint, _width: GLsizei, _height: GLsizei, _type: GLenum) callconv(.C) void {
    return @call(.always_tail, function_pointers.glCopyPixels, .{ _x, _y, _width, _height, _type });
}

pub fn drawPixels(_width: GLsizei, _height: GLsizei, _format: GLenum, _type: GLenum, _pixels: ?*const anyopaque) callconv(.C) void {
    return @call(.always_tail, function_pointers.glDrawPixels, .{ _width, _height, _format, _type, _pixels });
}

pub fn getClipPlane(_plane: GLenum, _equation: [*c]GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glGetClipPlane, .{ _plane, _equation });
}

pub fn getLightfv(_light: GLenum, _pname: GLenum, _params: [*c]GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glGetLightfv, .{ _light, _pname, _params });
}

pub fn getLightiv(_light: GLenum, _pname: GLenum, _params: [*c]GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glGetLightiv, .{ _light, _pname, _params });
}

pub fn getMapdv(_target: GLenum, _query: GLenum, _v: [*c]GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glGetMapdv, .{ _target, _query, _v });
}

pub fn getMapfv(_target: GLenum, _query: GLenum, _v: [*c]GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glGetMapfv, .{ _target, _query, _v });
}

pub fn getMapiv(_target: GLenum, _query: GLenum, _v: [*c]GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glGetMapiv, .{ _target, _query, _v });
}

pub fn getMaterialfv(_face: GLenum, _pname: GLenum, _params: [*c]GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glGetMaterialfv, .{ _face, _pname, _params });
}

pub fn getMaterialiv(_face: GLenum, _pname: GLenum, _params: [*c]GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glGetMaterialiv, .{ _face, _pname, _params });
}

pub fn getPixelMapfv(_map: GLenum, _values: [*c]GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glGetPixelMapfv, .{ _map, _values });
}

pub fn getPixelMapuiv(_map: GLenum, _values: [*c]GLuint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glGetPixelMapuiv, .{ _map, _values });
}

pub fn getPixelMapusv(_map: GLenum, _values: [*c]GLushort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glGetPixelMapusv, .{ _map, _values });
}

pub fn getPolygonStipple(_mask: [*c]GLubyte) callconv(.C) void {
    return @call(.always_tail, function_pointers.glGetPolygonStipple, .{_mask});
}

pub fn getTexEnvfv(_target: GLenum, _pname: GLenum, _params: [*c]GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glGetTexEnvfv, .{ _target, _pname, _params });
}

pub fn getTexEnviv(_target: GLenum, _pname: GLenum, _params: [*c]GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glGetTexEnviv, .{ _target, _pname, _params });
}

pub fn getTexGendv(_coord: GLenum, _pname: GLenum, _params: [*c]GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glGetTexGendv, .{ _coord, _pname, _params });
}

pub fn getTexGenfv(_coord: GLenum, _pname: GLenum, _params: [*c]GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glGetTexGenfv, .{ _coord, _pname, _params });
}

pub fn getTexGeniv(_coord: GLenum, _pname: GLenum, _params: [*c]GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glGetTexGeniv, .{ _coord, _pname, _params });
}

pub fn isList(_list: GLuint) callconv(.C) GLboolean {
    return @call(.always_tail, function_pointers.glIsList, .{_list});
}

pub fn frustum(_left: GLdouble, _right: GLdouble, _bottom: GLdouble, _top: GLdouble, _zNear: GLdouble, _zFar: GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glFrustum, .{ _left, _right, _bottom, _top, _zNear, _zFar });
}

pub fn loadIdentity() callconv(.C) void {
    return @call(.always_tail, function_pointers.glLoadIdentity, .{});
}

pub fn loadMatrixf(_m: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glLoadMatrixf, .{_m});
}

pub fn loadMatrixd(_m: [*c]const GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glLoadMatrixd, .{_m});
}

pub fn matrixMode(_mode: GLenum) callconv(.C) void {
    return @call(.always_tail, function_pointers.glMatrixMode, .{_mode});
}

pub fn multMatrixf(_m: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glMultMatrixf, .{_m});
}

pub fn multMatrixd(_m: [*c]const GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glMultMatrixd, .{_m});
}

pub fn ortho(_left: GLdouble, _right: GLdouble, _bottom: GLdouble, _top: GLdouble, _zNear: GLdouble, _zFar: GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glOrtho, .{ _left, _right, _bottom, _top, _zNear, _zFar });
}

pub fn popMatrix() callconv(.C) void {
    return @call(.always_tail, function_pointers.glPopMatrix, .{});
}

pub fn pushMatrix() callconv(.C) void {
    return @call(.always_tail, function_pointers.glPushMatrix, .{});
}

pub fn rotated(_angle: GLdouble, _x: GLdouble, _y: GLdouble, _z: GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glRotated, .{ _angle, _x, _y, _z });
}

pub fn rotatef(_angle: GLfloat, _x: GLfloat, _y: GLfloat, _z: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glRotatef, .{ _angle, _x, _y, _z });
}

pub fn scaled(_x: GLdouble, _y: GLdouble, _z: GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glScaled, .{ _x, _y, _z });
}

pub fn scalef(_x: GLfloat, _y: GLfloat, _z: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glScalef, .{ _x, _y, _z });
}

pub fn translated(_x: GLdouble, _y: GLdouble, _z: GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glTranslated, .{ _x, _y, _z });
}

pub fn translatef(_x: GLfloat, _y: GLfloat, _z: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glTranslatef, .{ _x, _y, _z });
}

pub fn drawArrays(_mode: GLenum, _first: GLint, _count: GLsizei) callconv(.C) void {
    return @call(.always_tail, function_pointers.glDrawArrays, .{ _mode, _first, _count });
}

pub fn drawElements(_mode: GLenum, _count: GLsizei, _type: GLenum, _indices: ?*const anyopaque) callconv(.C) void {
    return @call(.always_tail, function_pointers.glDrawElements, .{ _mode, _count, _type, _indices });
}

pub fn getPointerv(_pname: GLenum, _params: ?*?*anyopaque) callconv(.C) void {
    return @call(.always_tail, function_pointers.glGetPointerv, .{ _pname, _params });
}

pub fn polygonOffset(_factor: GLfloat, _units: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glPolygonOffset, .{ _factor, _units });
}

pub fn copyTexImage1D(_target: GLenum, _level: GLint, _internalformat: GLenum, _x: GLint, _y: GLint, _width: GLsizei, _border: GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glCopyTexImage1D, .{ _target, _level, _internalformat, _x, _y, _width, _border });
}

pub fn copyTexImage2D(_target: GLenum, _level: GLint, _internalformat: GLenum, _x: GLint, _y: GLint, _width: GLsizei, _height: GLsizei, _border: GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glCopyTexImage2D, .{ _target, _level, _internalformat, _x, _y, _width, _height, _border });
}

pub fn copyTexSubImage1D(_target: GLenum, _level: GLint, _xoffset: GLint, _x: GLint, _y: GLint, _width: GLsizei) callconv(.C) void {
    return @call(.always_tail, function_pointers.glCopyTexSubImage1D, .{ _target, _level, _xoffset, _x, _y, _width });
}

pub fn copyTexSubImage2D(_target: GLenum, _level: GLint, _xoffset: GLint, _yoffset: GLint, _x: GLint, _y: GLint, _width: GLsizei, _height: GLsizei) callconv(.C) void {
    return @call(.always_tail, function_pointers.glCopyTexSubImage2D, .{ _target, _level, _xoffset, _yoffset, _x, _y, _width, _height });
}

pub fn texSubImage1D(_target: GLenum, _level: GLint, _xoffset: GLint, _width: GLsizei, _format: GLenum, _type: GLenum, _pixels: ?*const anyopaque) callconv(.C) void {
    return @call(.always_tail, function_pointers.glTexSubImage1D, .{ _target, _level, _xoffset, _width, _format, _type, _pixels });
}

pub fn texSubImage2D(_target: GLenum, _level: GLint, _xoffset: GLint, _yoffset: GLint, _width: GLsizei, _height: GLsizei, _format: GLenum, _type: GLenum, _pixels: ?*const anyopaque) callconv(.C) void {
    return @call(.always_tail, function_pointers.glTexSubImage2D, .{ _target, _level, _xoffset, _yoffset, _width, _height, _format, _type, _pixels });
}

pub fn bindTexture(_target: GLenum, _texture: GLuint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glBindTexture, .{ _target, _texture });
}

pub fn deleteTextures(_n: GLsizei, _textures: [*c]const GLuint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glDeleteTextures, .{ _n, _textures });
}

pub fn genTextures(_n: GLsizei, _textures: [*c]GLuint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glGenTextures, .{ _n, _textures });
}

pub fn isTexture(_texture: GLuint) callconv(.C) GLboolean {
    return @call(.always_tail, function_pointers.glIsTexture, .{_texture});
}

pub fn arrayElement(_i: GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glArrayElement, .{_i});
}

pub fn colorPointer(_size: GLint, _type: GLenum, _stride: GLsizei, _pointer: ?*const anyopaque) callconv(.C) void {
    return @call(.always_tail, function_pointers.glColorPointer, .{ _size, _type, _stride, _pointer });
}

pub fn disableClientState(_array: GLenum) callconv(.C) void {
    return @call(.always_tail, function_pointers.glDisableClientState, .{_array});
}

pub fn edgeFlagPointer(_stride: GLsizei, _pointer: ?*const anyopaque) callconv(.C) void {
    return @call(.always_tail, function_pointers.glEdgeFlagPointer, .{ _stride, _pointer });
}

pub fn enableClientState(_array: GLenum) callconv(.C) void {
    return @call(.always_tail, function_pointers.glEnableClientState, .{_array});
}

pub fn indexPointer(_type: GLenum, _stride: GLsizei, _pointer: ?*const anyopaque) callconv(.C) void {
    return @call(.always_tail, function_pointers.glIndexPointer, .{ _type, _stride, _pointer });
}

pub fn interleavedArrays(_format: GLenum, _stride: GLsizei, _pointer: ?*const anyopaque) callconv(.C) void {
    return @call(.always_tail, function_pointers.glInterleavedArrays, .{ _format, _stride, _pointer });
}

pub fn normalPointer(_type: GLenum, _stride: GLsizei, _pointer: ?*const anyopaque) callconv(.C) void {
    return @call(.always_tail, function_pointers.glNormalPointer, .{ _type, _stride, _pointer });
}

pub fn texCoordPointer(_size: GLint, _type: GLenum, _stride: GLsizei, _pointer: ?*const anyopaque) callconv(.C) void {
    return @call(.always_tail, function_pointers.glTexCoordPointer, .{ _size, _type, _stride, _pointer });
}

pub fn vertexPointer(_size: GLint, _type: GLenum, _stride: GLsizei, _pointer: ?*const anyopaque) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertexPointer, .{ _size, _type, _stride, _pointer });
}

pub fn areTexturesResident(_n: GLsizei, _textures: [*c]const GLuint, _residences: [*c]GLboolean) callconv(.C) GLboolean {
    return @call(.always_tail, function_pointers.glAreTexturesResident, .{ _n, _textures, _residences });
}

pub fn prioritizeTextures(_n: GLsizei, _textures: [*c]const GLuint, _priorities: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glPrioritizeTextures, .{ _n, _textures, _priorities });
}

pub fn indexub(_c: GLubyte) callconv(.C) void {
    return @call(.always_tail, function_pointers.glIndexub, .{_c});
}

pub fn indexubv(_c: ?[*:0]const GLubyte) callconv(.C) void {
    return @call(.always_tail, function_pointers.glIndexubv, .{_c});
}

pub fn popClientAttrib() callconv(.C) void {
    return @call(.always_tail, function_pointers.glPopClientAttrib, .{});
}

pub fn pushClientAttrib(_mask: GLbitfield) callconv(.C) void {
    return @call(.always_tail, function_pointers.glPushClientAttrib, .{_mask});
}

pub fn drawRangeElements(_mode: GLenum, _start: GLuint, _end: GLuint, _count: GLsizei, _type: GLenum, _indices: ?*const anyopaque) callconv(.C) void {
    return @call(.always_tail, function_pointers.glDrawRangeElements, .{ _mode, _start, _end, _count, _type, _indices });
}

pub fn texImage3D(_target: GLenum, _level: GLint, _internalformat: GLint, _width: GLsizei, _height: GLsizei, _depth: GLsizei, _border: GLint, _format: GLenum, _type: GLenum, _pixels: ?*const anyopaque) callconv(.C) void {
    return @call(.always_tail, function_pointers.glTexImage3D, .{ _target, _level, _internalformat, _width, _height, _depth, _border, _format, _type, _pixels });
}

pub fn texSubImage3D(_target: GLenum, _level: GLint, _xoffset: GLint, _yoffset: GLint, _zoffset: GLint, _width: GLsizei, _height: GLsizei, _depth: GLsizei, _format: GLenum, _type: GLenum, _pixels: ?*const anyopaque) callconv(.C) void {
    return @call(.always_tail, function_pointers.glTexSubImage3D, .{ _target, _level, _xoffset, _yoffset, _zoffset, _width, _height, _depth, _format, _type, _pixels });
}

pub fn copyTexSubImage3D(_target: GLenum, _level: GLint, _xoffset: GLint, _yoffset: GLint, _zoffset: GLint, _x: GLint, _y: GLint, _width: GLsizei, _height: GLsizei) callconv(.C) void {
    return @call(.always_tail, function_pointers.glCopyTexSubImage3D, .{ _target, _level, _xoffset, _yoffset, _zoffset, _x, _y, _width, _height });
}

pub fn activeTexture(_texture: GLenum) callconv(.C) void {
    return @call(.always_tail, function_pointers.glActiveTexture, .{_texture});
}

pub fn sampleCoverage(_value: GLfloat, _invert: GLboolean) callconv(.C) void {
    return @call(.always_tail, function_pointers.glSampleCoverage, .{ _value, _invert });
}

pub fn compressedTexImage3D(_target: GLenum, _level: GLint, _internalformat: GLenum, _width: GLsizei, _height: GLsizei, _depth: GLsizei, _border: GLint, _imageSize: GLsizei, _data: ?*const anyopaque) callconv(.C) void {
    return @call(.always_tail, function_pointers.glCompressedTexImage3D, .{ _target, _level, _internalformat, _width, _height, _depth, _border, _imageSize, _data });
}

pub fn compressedTexImage2D(_target: GLenum, _level: GLint, _internalformat: GLenum, _width: GLsizei, _height: GLsizei, _border: GLint, _imageSize: GLsizei, _data: ?*const anyopaque) callconv(.C) void {
    return @call(.always_tail, function_pointers.glCompressedTexImage2D, .{ _target, _level, _internalformat, _width, _height, _border, _imageSize, _data });
}

pub fn compressedTexImage1D(_target: GLenum, _level: GLint, _internalformat: GLenum, _width: GLsizei, _border: GLint, _imageSize: GLsizei, _data: ?*const anyopaque) callconv(.C) void {
    return @call(.always_tail, function_pointers.glCompressedTexImage1D, .{ _target, _level, _internalformat, _width, _border, _imageSize, _data });
}

pub fn compressedTexSubImage3D(_target: GLenum, _level: GLint, _xoffset: GLint, _yoffset: GLint, _zoffset: GLint, _width: GLsizei, _height: GLsizei, _depth: GLsizei, _format: GLenum, _imageSize: GLsizei, _data: ?*const anyopaque) callconv(.C) void {
    return @call(.always_tail, function_pointers.glCompressedTexSubImage3D, .{ _target, _level, _xoffset, _yoffset, _zoffset, _width, _height, _depth, _format, _imageSize, _data });
}

pub fn compressedTexSubImage2D(_target: GLenum, _level: GLint, _xoffset: GLint, _yoffset: GLint, _width: GLsizei, _height: GLsizei, _format: GLenum, _imageSize: GLsizei, _data: ?*const anyopaque) callconv(.C) void {
    return @call(.always_tail, function_pointers.glCompressedTexSubImage2D, .{ _target, _level, _xoffset, _yoffset, _width, _height, _format, _imageSize, _data });
}

pub fn compressedTexSubImage1D(_target: GLenum, _level: GLint, _xoffset: GLint, _width: GLsizei, _format: GLenum, _imageSize: GLsizei, _data: ?*const anyopaque) callconv(.C) void {
    return @call(.always_tail, function_pointers.glCompressedTexSubImage1D, .{ _target, _level, _xoffset, _width, _format, _imageSize, _data });
}

pub fn getCompressedTexImage(_target: GLenum, _level: GLint, _img: ?*anyopaque) callconv(.C) void {
    return @call(.always_tail, function_pointers.glGetCompressedTexImage, .{ _target, _level, _img });
}

pub fn clientActiveTexture(_texture: GLenum) callconv(.C) void {
    return @call(.always_tail, function_pointers.glClientActiveTexture, .{_texture});
}

pub fn multiTexCoord1d(_target: GLenum, _s: GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glMultiTexCoord1d, .{ _target, _s });
}

pub fn multiTexCoord1dv(_target: GLenum, _v: [*c]const GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glMultiTexCoord1dv, .{ _target, _v });
}

pub fn multiTexCoord1f(_target: GLenum, _s: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glMultiTexCoord1f, .{ _target, _s });
}

pub fn multiTexCoord1fv(_target: GLenum, _v: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glMultiTexCoord1fv, .{ _target, _v });
}

pub fn multiTexCoord1i(_target: GLenum, _s: GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glMultiTexCoord1i, .{ _target, _s });
}

pub fn multiTexCoord1iv(_target: GLenum, _v: [*c]const GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glMultiTexCoord1iv, .{ _target, _v });
}

pub fn multiTexCoord1s(_target: GLenum, _s: GLshort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glMultiTexCoord1s, .{ _target, _s });
}

pub fn multiTexCoord1sv(_target: GLenum, _v: [*c]const GLshort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glMultiTexCoord1sv, .{ _target, _v });
}

pub fn multiTexCoord2d(_target: GLenum, _s: GLdouble, _t: GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glMultiTexCoord2d, .{ _target, _s, _t });
}

pub fn multiTexCoord2dv(_target: GLenum, _v: [*c]const GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glMultiTexCoord2dv, .{ _target, _v });
}

pub fn multiTexCoord2f(_target: GLenum, _s: GLfloat, _t: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glMultiTexCoord2f, .{ _target, _s, _t });
}

pub fn multiTexCoord2fv(_target: GLenum, _v: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glMultiTexCoord2fv, .{ _target, _v });
}

pub fn multiTexCoord2i(_target: GLenum, _s: GLint, _t: GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glMultiTexCoord2i, .{ _target, _s, _t });
}

pub fn multiTexCoord2iv(_target: GLenum, _v: [*c]const GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glMultiTexCoord2iv, .{ _target, _v });
}

pub fn multiTexCoord2s(_target: GLenum, _s: GLshort, _t: GLshort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glMultiTexCoord2s, .{ _target, _s, _t });
}

pub fn multiTexCoord2sv(_target: GLenum, _v: [*c]const GLshort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glMultiTexCoord2sv, .{ _target, _v });
}

pub fn multiTexCoord3d(_target: GLenum, _s: GLdouble, _t: GLdouble, _r: GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glMultiTexCoord3d, .{ _target, _s, _t, _r });
}

pub fn multiTexCoord3dv(_target: GLenum, _v: [*c]const GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glMultiTexCoord3dv, .{ _target, _v });
}

pub fn multiTexCoord3f(_target: GLenum, _s: GLfloat, _t: GLfloat, _r: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glMultiTexCoord3f, .{ _target, _s, _t, _r });
}

pub fn multiTexCoord3fv(_target: GLenum, _v: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glMultiTexCoord3fv, .{ _target, _v });
}

pub fn multiTexCoord3i(_target: GLenum, _s: GLint, _t: GLint, _r: GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glMultiTexCoord3i, .{ _target, _s, _t, _r });
}

pub fn multiTexCoord3iv(_target: GLenum, _v: [*c]const GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glMultiTexCoord3iv, .{ _target, _v });
}

pub fn multiTexCoord3s(_target: GLenum, _s: GLshort, _t: GLshort, _r: GLshort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glMultiTexCoord3s, .{ _target, _s, _t, _r });
}

pub fn multiTexCoord3sv(_target: GLenum, _v: [*c]const GLshort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glMultiTexCoord3sv, .{ _target, _v });
}

pub fn multiTexCoord4d(_target: GLenum, _s: GLdouble, _t: GLdouble, _r: GLdouble, _q: GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glMultiTexCoord4d, .{ _target, _s, _t, _r, _q });
}

pub fn multiTexCoord4dv(_target: GLenum, _v: [*c]const GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glMultiTexCoord4dv, .{ _target, _v });
}

pub fn multiTexCoord4f(_target: GLenum, _s: GLfloat, _t: GLfloat, _r: GLfloat, _q: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glMultiTexCoord4f, .{ _target, _s, _t, _r, _q });
}

pub fn multiTexCoord4fv(_target: GLenum, _v: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glMultiTexCoord4fv, .{ _target, _v });
}

pub fn multiTexCoord4i(_target: GLenum, _s: GLint, _t: GLint, _r: GLint, _q: GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glMultiTexCoord4i, .{ _target, _s, _t, _r, _q });
}

pub fn multiTexCoord4iv(_target: GLenum, _v: [*c]const GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glMultiTexCoord4iv, .{ _target, _v });
}

pub fn multiTexCoord4s(_target: GLenum, _s: GLshort, _t: GLshort, _r: GLshort, _q: GLshort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glMultiTexCoord4s, .{ _target, _s, _t, _r, _q });
}

pub fn multiTexCoord4sv(_target: GLenum, _v: [*c]const GLshort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glMultiTexCoord4sv, .{ _target, _v });
}

pub fn loadTransposeMatrixf(_m: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glLoadTransposeMatrixf, .{_m});
}

pub fn loadTransposeMatrixd(_m: [*c]const GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glLoadTransposeMatrixd, .{_m});
}

pub fn multTransposeMatrixf(_m: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glMultTransposeMatrixf, .{_m});
}

pub fn multTransposeMatrixd(_m: [*c]const GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glMultTransposeMatrixd, .{_m});
}

pub fn blendFuncSeparate(_sfactorRGB: GLenum, _dfactorRGB: GLenum, _sfactorAlpha: GLenum, _dfactorAlpha: GLenum) callconv(.C) void {
    return @call(.always_tail, function_pointers.glBlendFuncSeparate, .{ _sfactorRGB, _dfactorRGB, _sfactorAlpha, _dfactorAlpha });
}

pub fn multiDrawArrays(_mode: GLenum, _first: [*c]const GLint, _count: [*c]const GLsizei, _drawcount: GLsizei) callconv(.C) void {
    return @call(.always_tail, function_pointers.glMultiDrawArrays, .{ _mode, _first, _count, _drawcount });
}

pub fn multiDrawElements(_mode: GLenum, _count: [*c]const GLsizei, _type: GLenum, _indices: [*c]const ?*const anyopaque, _drawcount: GLsizei) callconv(.C) void {
    return @call(.always_tail, function_pointers.glMultiDrawElements, .{ _mode, _count, _type, _indices, _drawcount });
}

pub fn pointParameterf(_pname: GLenum, _param: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glPointParameterf, .{ _pname, _param });
}

pub fn pointParameterfv(_pname: GLenum, _params: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glPointParameterfv, .{ _pname, _params });
}

pub fn pointParameteri(_pname: GLenum, _param: GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glPointParameteri, .{ _pname, _param });
}

pub fn pointParameteriv(_pname: GLenum, _params: [*c]const GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glPointParameteriv, .{ _pname, _params });
}

pub fn fogCoordf(_coord: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glFogCoordf, .{_coord});
}

pub fn fogCoordfv(_coord: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glFogCoordfv, .{_coord});
}

pub fn fogCoordd(_coord: GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glFogCoordd, .{_coord});
}

pub fn fogCoorddv(_coord: [*c]const GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glFogCoorddv, .{_coord});
}

pub fn fogCoordPointer(_type: GLenum, _stride: GLsizei, _pointer: ?*const anyopaque) callconv(.C) void {
    return @call(.always_tail, function_pointers.glFogCoordPointer, .{ _type, _stride, _pointer });
}

pub fn secondaryColor3b(_red: GLbyte, _green: GLbyte, _blue: GLbyte) callconv(.C) void {
    return @call(.always_tail, function_pointers.glSecondaryColor3b, .{ _red, _green, _blue });
}

pub fn secondaryColor3bv(_v: [*c]const GLbyte) callconv(.C) void {
    return @call(.always_tail, function_pointers.glSecondaryColor3bv, .{_v});
}

pub fn secondaryColor3d(_red: GLdouble, _green: GLdouble, _blue: GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glSecondaryColor3d, .{ _red, _green, _blue });
}

pub fn secondaryColor3dv(_v: [*c]const GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glSecondaryColor3dv, .{_v});
}

pub fn secondaryColor3f(_red: GLfloat, _green: GLfloat, _blue: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glSecondaryColor3f, .{ _red, _green, _blue });
}

pub fn secondaryColor3fv(_v: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glSecondaryColor3fv, .{_v});
}

pub fn secondaryColor3i(_red: GLint, _green: GLint, _blue: GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glSecondaryColor3i, .{ _red, _green, _blue });
}

pub fn secondaryColor3iv(_v: [*c]const GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glSecondaryColor3iv, .{_v});
}

pub fn secondaryColor3s(_red: GLshort, _green: GLshort, _blue: GLshort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glSecondaryColor3s, .{ _red, _green, _blue });
}

pub fn secondaryColor3sv(_v: [*c]const GLshort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glSecondaryColor3sv, .{_v});
}

pub fn secondaryColor3ub(_red: GLubyte, _green: GLubyte, _blue: GLubyte) callconv(.C) void {
    return @call(.always_tail, function_pointers.glSecondaryColor3ub, .{ _red, _green, _blue });
}

pub fn secondaryColor3ubv(_v: ?[*:0]const GLubyte) callconv(.C) void {
    return @call(.always_tail, function_pointers.glSecondaryColor3ubv, .{_v});
}

pub fn secondaryColor3ui(_red: GLuint, _green: GLuint, _blue: GLuint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glSecondaryColor3ui, .{ _red, _green, _blue });
}

pub fn secondaryColor3uiv(_v: [*c]const GLuint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glSecondaryColor3uiv, .{_v});
}

pub fn secondaryColor3us(_red: GLushort, _green: GLushort, _blue: GLushort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glSecondaryColor3us, .{ _red, _green, _blue });
}

pub fn secondaryColor3usv(_v: [*c]const GLushort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glSecondaryColor3usv, .{_v});
}

pub fn secondaryColorPointer(_size: GLint, _type: GLenum, _stride: GLsizei, _pointer: ?*const anyopaque) callconv(.C) void {
    return @call(.always_tail, function_pointers.glSecondaryColorPointer, .{ _size, _type, _stride, _pointer });
}

pub fn windowPos2d(_x: GLdouble, _y: GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glWindowPos2d, .{ _x, _y });
}

pub fn windowPos2dv(_v: [*c]const GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glWindowPos2dv, .{_v});
}

pub fn windowPos2f(_x: GLfloat, _y: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glWindowPos2f, .{ _x, _y });
}

pub fn windowPos2fv(_v: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glWindowPos2fv, .{_v});
}

pub fn windowPos2i(_x: GLint, _y: GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glWindowPos2i, .{ _x, _y });
}

pub fn windowPos2iv(_v: [*c]const GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glWindowPos2iv, .{_v});
}

pub fn windowPos2s(_x: GLshort, _y: GLshort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glWindowPos2s, .{ _x, _y });
}

pub fn windowPos2sv(_v: [*c]const GLshort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glWindowPos2sv, .{_v});
}

pub fn windowPos3d(_x: GLdouble, _y: GLdouble, _z: GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glWindowPos3d, .{ _x, _y, _z });
}

pub fn windowPos3dv(_v: [*c]const GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glWindowPos3dv, .{_v});
}

pub fn windowPos3f(_x: GLfloat, _y: GLfloat, _z: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glWindowPos3f, .{ _x, _y, _z });
}

pub fn windowPos3fv(_v: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glWindowPos3fv, .{_v});
}

pub fn windowPos3i(_x: GLint, _y: GLint, _z: GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glWindowPos3i, .{ _x, _y, _z });
}

pub fn windowPos3iv(_v: [*c]const GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glWindowPos3iv, .{_v});
}

pub fn windowPos3s(_x: GLshort, _y: GLshort, _z: GLshort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glWindowPos3s, .{ _x, _y, _z });
}

pub fn windowPos3sv(_v: [*c]const GLshort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glWindowPos3sv, .{_v});
}

pub fn blendColor(_red: GLfloat, _green: GLfloat, _blue: GLfloat, _alpha: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glBlendColor, .{ _red, _green, _blue, _alpha });
}

pub fn blendEquation(_mode: GLenum) callconv(.C) void {
    return @call(.always_tail, function_pointers.glBlendEquation, .{_mode});
}

pub fn genQueries(_n: GLsizei, _ids: [*c]GLuint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glGenQueries, .{ _n, _ids });
}

pub fn deleteQueries(_n: GLsizei, _ids: [*c]const GLuint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glDeleteQueries, .{ _n, _ids });
}

pub fn isQuery(_id: GLuint) callconv(.C) GLboolean {
    return @call(.always_tail, function_pointers.glIsQuery, .{_id});
}

pub fn beginQuery(_target: GLenum, _id: GLuint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glBeginQuery, .{ _target, _id });
}

pub fn endQuery(_target: GLenum) callconv(.C) void {
    return @call(.always_tail, function_pointers.glEndQuery, .{_target});
}

pub fn getQueryiv(_target: GLenum, _pname: GLenum, _params: [*c]GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glGetQueryiv, .{ _target, _pname, _params });
}

pub fn getQueryObjectiv(_id: GLuint, _pname: GLenum, _params: [*c]GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glGetQueryObjectiv, .{ _id, _pname, _params });
}

pub fn getQueryObjectuiv(_id: GLuint, _pname: GLenum, _params: [*c]GLuint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glGetQueryObjectuiv, .{ _id, _pname, _params });
}

pub fn bindBuffer(_target: GLenum, _buffer: GLuint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glBindBuffer, .{ _target, _buffer });
}

pub fn deleteBuffers(_n: GLsizei, _buffers: [*c]const GLuint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glDeleteBuffers, .{ _n, _buffers });
}

pub fn genBuffers(_n: GLsizei, _buffers: [*c]GLuint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glGenBuffers, .{ _n, _buffers });
}

pub fn isBuffer(_buffer: GLuint) callconv(.C) GLboolean {
    return @call(.always_tail, function_pointers.glIsBuffer, .{_buffer});
}

pub fn bufferData(_target: GLenum, _size: GLsizeiptr, _data: ?*const anyopaque, _usage: GLenum) callconv(.C) void {
    return @call(.always_tail, function_pointers.glBufferData, .{ _target, _size, _data, _usage });
}

pub fn bufferSubData(_target: GLenum, _offset: GLintptr, _size: GLsizeiptr, _data: ?*const anyopaque) callconv(.C) void {
    return @call(.always_tail, function_pointers.glBufferSubData, .{ _target, _offset, _size, _data });
}

pub fn getBufferSubData(_target: GLenum, _offset: GLintptr, _size: GLsizeiptr, _data: ?*anyopaque) callconv(.C) void {
    return @call(.always_tail, function_pointers.glGetBufferSubData, .{ _target, _offset, _size, _data });
}

pub fn mapBuffer(_target: GLenum, _access: GLenum) callconv(.C) ?*anyopaque {
    return @call(.always_tail, function_pointers.glMapBuffer, .{ _target, _access });
}

pub fn unmapBuffer(_target: GLenum) callconv(.C) GLboolean {
    return @call(.always_tail, function_pointers.glUnmapBuffer, .{_target});
}

pub fn getBufferParameteriv(_target: GLenum, _pname: GLenum, _params: [*c]GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glGetBufferParameteriv, .{ _target, _pname, _params });
}

pub fn getBufferPointerv(_target: GLenum, _pname: GLenum, _params: ?*?*anyopaque) callconv(.C) void {
    return @call(.always_tail, function_pointers.glGetBufferPointerv, .{ _target, _pname, _params });
}

pub fn blendEquationSeparate(_modeRGB: GLenum, _modeAlpha: GLenum) callconv(.C) void {
    return @call(.always_tail, function_pointers.glBlendEquationSeparate, .{ _modeRGB, _modeAlpha });
}

pub fn drawBuffers(_n: GLsizei, _bufs: [*c]const GLenum) callconv(.C) void {
    return @call(.always_tail, function_pointers.glDrawBuffers, .{ _n, _bufs });
}

pub fn stencilOpSeparate(_face: GLenum, _sfail: GLenum, _dpfail: GLenum, _dppass: GLenum) callconv(.C) void {
    return @call(.always_tail, function_pointers.glStencilOpSeparate, .{ _face, _sfail, _dpfail, _dppass });
}

pub fn stencilFuncSeparate(_face: GLenum, _func: GLenum, _ref: GLint, _mask: GLuint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glStencilFuncSeparate, .{ _face, _func, _ref, _mask });
}

pub fn stencilMaskSeparate(_face: GLenum, _mask: GLuint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glStencilMaskSeparate, .{ _face, _mask });
}

pub fn attachShader(_program: GLuint, _shader: GLuint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glAttachShader, .{ _program, _shader });
}

pub fn bindAttribLocation(_program: GLuint, _index: GLuint, _name: [*c]const GLchar) callconv(.C) void {
    return @call(.always_tail, function_pointers.glBindAttribLocation, .{ _program, _index, _name });
}

pub fn compileShader(_shader: GLuint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glCompileShader, .{_shader});
}

pub fn createProgram() callconv(.C) GLuint {
    return @call(.always_tail, function_pointers.glCreateProgram, .{});
}

pub fn createShader(_type: GLenum) callconv(.C) GLuint {
    return @call(.always_tail, function_pointers.glCreateShader, .{_type});
}

pub fn deleteProgram(_program: GLuint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glDeleteProgram, .{_program});
}

pub fn deleteShader(_shader: GLuint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glDeleteShader, .{_shader});
}

pub fn detachShader(_program: GLuint, _shader: GLuint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glDetachShader, .{ _program, _shader });
}

pub fn disableVertexAttribArray(_index: GLuint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glDisableVertexAttribArray, .{_index});
}

pub fn enableVertexAttribArray(_index: GLuint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glEnableVertexAttribArray, .{_index});
}

pub fn getActiveAttrib(_program: GLuint, _index: GLuint, _bufSize: GLsizei, _length: [*c]GLsizei, _size: [*c]GLint, _type: [*c]GLenum, _name: [*c]GLchar) callconv(.C) void {
    return @call(.always_tail, function_pointers.glGetActiveAttrib, .{ _program, _index, _bufSize, _length, _size, _type, _name });
}

pub fn getActiveUniform(_program: GLuint, _index: GLuint, _bufSize: GLsizei, _length: [*c]GLsizei, _size: [*c]GLint, _type: [*c]GLenum, _name: [*c]GLchar) callconv(.C) void {
    return @call(.always_tail, function_pointers.glGetActiveUniform, .{ _program, _index, _bufSize, _length, _size, _type, _name });
}

pub fn getAttachedShaders(_program: GLuint, _maxCount: GLsizei, _count: [*c]GLsizei, _shaders: [*c]GLuint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glGetAttachedShaders, .{ _program, _maxCount, _count, _shaders });
}

pub fn getAttribLocation(_program: GLuint, _name: [*c]const GLchar) callconv(.C) GLint {
    return @call(.always_tail, function_pointers.glGetAttribLocation, .{ _program, _name });
}

pub fn getProgramiv(_program: GLuint, _pname: GLenum, _params: [*c]GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glGetProgramiv, .{ _program, _pname, _params });
}

pub fn getProgramInfoLog(_program: GLuint, _bufSize: GLsizei, _length: [*c]GLsizei, _infoLog: [*c]GLchar) callconv(.C) void {
    return @call(.always_tail, function_pointers.glGetProgramInfoLog, .{ _program, _bufSize, _length, _infoLog });
}

pub fn getShaderiv(_shader: GLuint, _pname: GLenum, _params: [*c]GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glGetShaderiv, .{ _shader, _pname, _params });
}

pub fn getShaderInfoLog(_shader: GLuint, _bufSize: GLsizei, _length: [*c]GLsizei, _infoLog: [*c]GLchar) callconv(.C) void {
    return @call(.always_tail, function_pointers.glGetShaderInfoLog, .{ _shader, _bufSize, _length, _infoLog });
}

pub fn getShaderSource(_shader: GLuint, _bufSize: GLsizei, _length: [*c]GLsizei, _source: [*c]GLchar) callconv(.C) void {
    return @call(.always_tail, function_pointers.glGetShaderSource, .{ _shader, _bufSize, _length, _source });
}

pub fn getUniformLocation(_program: GLuint, _name: [*c]const GLchar) callconv(.C) GLint {
    return @call(.always_tail, function_pointers.glGetUniformLocation, .{ _program, _name });
}

pub fn getUniformfv(_program: GLuint, _location: GLint, _params: [*c]GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glGetUniformfv, .{ _program, _location, _params });
}

pub fn getUniformiv(_program: GLuint, _location: GLint, _params: [*c]GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glGetUniformiv, .{ _program, _location, _params });
}

pub fn getVertexAttribdv(_index: GLuint, _pname: GLenum, _params: [*c]GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glGetVertexAttribdv, .{ _index, _pname, _params });
}

pub fn getVertexAttribfv(_index: GLuint, _pname: GLenum, _params: [*c]GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glGetVertexAttribfv, .{ _index, _pname, _params });
}

pub fn getVertexAttribiv(_index: GLuint, _pname: GLenum, _params: [*c]GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glGetVertexAttribiv, .{ _index, _pname, _params });
}

pub fn getVertexAttribPointerv(_index: GLuint, _pname: GLenum, _pointer: ?*?*anyopaque) callconv(.C) void {
    return @call(.always_tail, function_pointers.glGetVertexAttribPointerv, .{ _index, _pname, _pointer });
}

pub fn isProgram(_program: GLuint) callconv(.C) GLboolean {
    return @call(.always_tail, function_pointers.glIsProgram, .{_program});
}

pub fn isShader(_shader: GLuint) callconv(.C) GLboolean {
    return @call(.always_tail, function_pointers.glIsShader, .{_shader});
}

pub fn linkProgram(_program: GLuint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glLinkProgram, .{_program});
}

pub fn shaderSource(_shader: GLuint, _count: GLsizei, _string: [*c]const [*c]const GLchar, _length: [*c]const GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glShaderSource, .{ _shader, _count, _string, _length });
}

pub fn useProgram(_program: GLuint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glUseProgram, .{_program});
}

pub fn uniform1f(_location: GLint, _v0: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glUniform1f, .{ _location, _v0 });
}

pub fn uniform2f(_location: GLint, _v0: GLfloat, _v1: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glUniform2f, .{ _location, _v0, _v1 });
}

pub fn uniform3f(_location: GLint, _v0: GLfloat, _v1: GLfloat, _v2: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glUniform3f, .{ _location, _v0, _v1, _v2 });
}

pub fn uniform4f(_location: GLint, _v0: GLfloat, _v1: GLfloat, _v2: GLfloat, _v3: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glUniform4f, .{ _location, _v0, _v1, _v2, _v3 });
}

pub fn uniform1i(_location: GLint, _v0: GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glUniform1i, .{ _location, _v0 });
}

pub fn uniform2i(_location: GLint, _v0: GLint, _v1: GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glUniform2i, .{ _location, _v0, _v1 });
}

pub fn uniform3i(_location: GLint, _v0: GLint, _v1: GLint, _v2: GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glUniform3i, .{ _location, _v0, _v1, _v2 });
}

pub fn uniform4i(_location: GLint, _v0: GLint, _v1: GLint, _v2: GLint, _v3: GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glUniform4i, .{ _location, _v0, _v1, _v2, _v3 });
}

pub fn uniform1fv(_location: GLint, _count: GLsizei, _value: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glUniform1fv, .{ _location, _count, _value });
}

pub fn uniform2fv(_location: GLint, _count: GLsizei, _value: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glUniform2fv, .{ _location, _count, _value });
}

pub fn uniform3fv(_location: GLint, _count: GLsizei, _value: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glUniform3fv, .{ _location, _count, _value });
}

pub fn uniform4fv(_location: GLint, _count: GLsizei, _value: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glUniform4fv, .{ _location, _count, _value });
}

pub fn uniform1iv(_location: GLint, _count: GLsizei, _value: [*c]const GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glUniform1iv, .{ _location, _count, _value });
}

pub fn uniform2iv(_location: GLint, _count: GLsizei, _value: [*c]const GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glUniform2iv, .{ _location, _count, _value });
}

pub fn uniform3iv(_location: GLint, _count: GLsizei, _value: [*c]const GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glUniform3iv, .{ _location, _count, _value });
}

pub fn uniform4iv(_location: GLint, _count: GLsizei, _value: [*c]const GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glUniform4iv, .{ _location, _count, _value });
}

pub fn uniformMatrix2fv(_location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glUniformMatrix2fv, .{ _location, _count, _transpose, _value });
}

pub fn uniformMatrix3fv(_location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glUniformMatrix3fv, .{ _location, _count, _transpose, _value });
}

pub fn uniformMatrix4fv(_location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glUniformMatrix4fv, .{ _location, _count, _transpose, _value });
}

pub fn validateProgram(_program: GLuint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glValidateProgram, .{_program});
}

pub fn vertexAttrib1d(_index: GLuint, _x: GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertexAttrib1d, .{ _index, _x });
}

pub fn vertexAttrib1dv(_index: GLuint, _v: [*c]const GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertexAttrib1dv, .{ _index, _v });
}

pub fn vertexAttrib1f(_index: GLuint, _x: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertexAttrib1f, .{ _index, _x });
}

pub fn vertexAttrib1fv(_index: GLuint, _v: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertexAttrib1fv, .{ _index, _v });
}

pub fn vertexAttrib1s(_index: GLuint, _x: GLshort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertexAttrib1s, .{ _index, _x });
}

pub fn vertexAttrib1sv(_index: GLuint, _v: [*c]const GLshort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertexAttrib1sv, .{ _index, _v });
}

pub fn vertexAttrib2d(_index: GLuint, _x: GLdouble, _y: GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertexAttrib2d, .{ _index, _x, _y });
}

pub fn vertexAttrib2dv(_index: GLuint, _v: [*c]const GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertexAttrib2dv, .{ _index, _v });
}

pub fn vertexAttrib2f(_index: GLuint, _x: GLfloat, _y: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertexAttrib2f, .{ _index, _x, _y });
}

pub fn vertexAttrib2fv(_index: GLuint, _v: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertexAttrib2fv, .{ _index, _v });
}

pub fn vertexAttrib2s(_index: GLuint, _x: GLshort, _y: GLshort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertexAttrib2s, .{ _index, _x, _y });
}

pub fn vertexAttrib2sv(_index: GLuint, _v: [*c]const GLshort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertexAttrib2sv, .{ _index, _v });
}

pub fn vertexAttrib3d(_index: GLuint, _x: GLdouble, _y: GLdouble, _z: GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertexAttrib3d, .{ _index, _x, _y, _z });
}

pub fn vertexAttrib3dv(_index: GLuint, _v: [*c]const GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertexAttrib3dv, .{ _index, _v });
}

pub fn vertexAttrib3f(_index: GLuint, _x: GLfloat, _y: GLfloat, _z: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertexAttrib3f, .{ _index, _x, _y, _z });
}

pub fn vertexAttrib3fv(_index: GLuint, _v: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertexAttrib3fv, .{ _index, _v });
}

pub fn vertexAttrib3s(_index: GLuint, _x: GLshort, _y: GLshort, _z: GLshort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertexAttrib3s, .{ _index, _x, _y, _z });
}

pub fn vertexAttrib3sv(_index: GLuint, _v: [*c]const GLshort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertexAttrib3sv, .{ _index, _v });
}

pub fn vertexAttrib4Nbv(_index: GLuint, _v: [*c]const GLbyte) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertexAttrib4Nbv, .{ _index, _v });
}

pub fn vertexAttrib4Niv(_index: GLuint, _v: [*c]const GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertexAttrib4Niv, .{ _index, _v });
}

pub fn vertexAttrib4Nsv(_index: GLuint, _v: [*c]const GLshort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertexAttrib4Nsv, .{ _index, _v });
}

pub fn vertexAttrib4Nub(_index: GLuint, _x: GLubyte, _y: GLubyte, _z: GLubyte, _w: GLubyte) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertexAttrib4Nub, .{ _index, _x, _y, _z, _w });
}

pub fn vertexAttrib4Nubv(_index: GLuint, _v: ?[*:0]const GLubyte) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertexAttrib4Nubv, .{ _index, _v });
}

pub fn vertexAttrib4Nuiv(_index: GLuint, _v: [*c]const GLuint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertexAttrib4Nuiv, .{ _index, _v });
}

pub fn vertexAttrib4Nusv(_index: GLuint, _v: [*c]const GLushort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertexAttrib4Nusv, .{ _index, _v });
}

pub fn vertexAttrib4bv(_index: GLuint, _v: [*c]const GLbyte) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertexAttrib4bv, .{ _index, _v });
}

pub fn vertexAttrib4d(_index: GLuint, _x: GLdouble, _y: GLdouble, _z: GLdouble, _w: GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertexAttrib4d, .{ _index, _x, _y, _z, _w });
}

pub fn vertexAttrib4dv(_index: GLuint, _v: [*c]const GLdouble) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertexAttrib4dv, .{ _index, _v });
}

pub fn vertexAttrib4f(_index: GLuint, _x: GLfloat, _y: GLfloat, _z: GLfloat, _w: GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertexAttrib4f, .{ _index, _x, _y, _z, _w });
}

pub fn vertexAttrib4fv(_index: GLuint, _v: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertexAttrib4fv, .{ _index, _v });
}

pub fn vertexAttrib4iv(_index: GLuint, _v: [*c]const GLint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertexAttrib4iv, .{ _index, _v });
}

pub fn vertexAttrib4s(_index: GLuint, _x: GLshort, _y: GLshort, _z: GLshort, _w: GLshort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertexAttrib4s, .{ _index, _x, _y, _z, _w });
}

pub fn vertexAttrib4sv(_index: GLuint, _v: [*c]const GLshort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertexAttrib4sv, .{ _index, _v });
}

pub fn vertexAttrib4ubv(_index: GLuint, _v: ?[*:0]const GLubyte) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertexAttrib4ubv, .{ _index, _v });
}

pub fn vertexAttrib4uiv(_index: GLuint, _v: [*c]const GLuint) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertexAttrib4uiv, .{ _index, _v });
}

pub fn vertexAttrib4usv(_index: GLuint, _v: [*c]const GLushort) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertexAttrib4usv, .{ _index, _v });
}

pub fn vertexAttribPointer(_index: GLuint, _size: GLint, _type: GLenum, _normalized: GLboolean, _stride: GLsizei, _pointer: ?*const anyopaque) callconv(.C) void {
    return @call(.always_tail, function_pointers.glVertexAttribPointer, .{ _index, _size, _type, _normalized, _stride, _pointer });
}

pub fn uniformMatrix2x3fv(_location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glUniformMatrix2x3fv, .{ _location, _count, _transpose, _value });
}

pub fn uniformMatrix3x2fv(_location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glUniformMatrix3x2fv, .{ _location, _count, _transpose, _value });
}

pub fn uniformMatrix2x4fv(_location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glUniformMatrix2x4fv, .{ _location, _count, _transpose, _value });
}

pub fn uniformMatrix4x2fv(_location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glUniformMatrix4x2fv, .{ _location, _count, _transpose, _value });
}

pub fn uniformMatrix3x4fv(_location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glUniformMatrix3x4fv, .{ _location, _count, _transpose, _value });
}

pub fn uniformMatrix4x3fv(_location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLfloat) callconv(.C) void {
    return @call(.always_tail, function_pointers.glUniformMatrix4x3fv, .{ _location, _count, _transpose, _value });
}
// Extensions:

// Loader API:
pub fn load(load_ctx: anytype, get_proc_address: fn (@TypeOf(load_ctx), [:0]const u8) ?FunctionPointer) !void {
    var success = true;
    if (get_proc_address(load_ctx, "glCullFace")) |proc| {
        function_pointers.glCullFace = @ptrCast(proc);
    } else {
        log.err("entry point glCullFace not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glFrontFace")) |proc| {
        function_pointers.glFrontFace = @ptrCast(proc);
    } else {
        log.err("entry point glFrontFace not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glHint")) |proc| {
        function_pointers.glHint = @ptrCast(proc);
    } else {
        log.err("entry point glHint not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glLineWidth")) |proc| {
        function_pointers.glLineWidth = @ptrCast(proc);
    } else {
        log.err("entry point glLineWidth not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glPointSize")) |proc| {
        function_pointers.glPointSize = @ptrCast(proc);
    } else {
        log.err("entry point glPointSize not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glPolygonMode")) |proc| {
        function_pointers.glPolygonMode = @ptrCast(proc);
    } else {
        log.err("entry point glPolygonMode not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glScissor")) |proc| {
        function_pointers.glScissor = @ptrCast(proc);
    } else {
        log.err("entry point glScissor not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glTexParameterf")) |proc| {
        function_pointers.glTexParameterf = @ptrCast(proc);
    } else {
        log.err("entry point glTexParameterf not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glTexParameterfv")) |proc| {
        function_pointers.glTexParameterfv = @ptrCast(proc);
    } else {
        log.err("entry point glTexParameterfv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glTexParameteri")) |proc| {
        function_pointers.glTexParameteri = @ptrCast(proc);
    } else {
        log.err("entry point glTexParameteri not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glTexParameteriv")) |proc| {
        function_pointers.glTexParameteriv = @ptrCast(proc);
    } else {
        log.err("entry point glTexParameteriv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glTexImage1D")) |proc| {
        function_pointers.glTexImage1D = @ptrCast(proc);
    } else {
        log.err("entry point glTexImage1D not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glTexImage2D")) |proc| {
        function_pointers.glTexImage2D = @ptrCast(proc);
    } else {
        log.err("entry point glTexImage2D not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glDrawBuffer")) |proc| {
        function_pointers.glDrawBuffer = @ptrCast(proc);
    } else {
        log.err("entry point glDrawBuffer not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glClear")) |proc| {
        function_pointers.glClear = @ptrCast(proc);
    } else {
        log.err("entry point glClear not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glClearColor")) |proc| {
        function_pointers.glClearColor = @ptrCast(proc);
    } else {
        log.err("entry point glClearColor not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glClearStencil")) |proc| {
        function_pointers.glClearStencil = @ptrCast(proc);
    } else {
        log.err("entry point glClearStencil not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glClearDepth")) |proc| {
        function_pointers.glClearDepth = @ptrCast(proc);
    } else {
        log.err("entry point glClearDepth not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glStencilMask")) |proc| {
        function_pointers.glStencilMask = @ptrCast(proc);
    } else {
        log.err("entry point glStencilMask not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glColorMask")) |proc| {
        function_pointers.glColorMask = @ptrCast(proc);
    } else {
        log.err("entry point glColorMask not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glDepthMask")) |proc| {
        function_pointers.glDepthMask = @ptrCast(proc);
    } else {
        log.err("entry point glDepthMask not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glDisable")) |proc| {
        function_pointers.glDisable = @ptrCast(proc);
    } else {
        log.err("entry point glDisable not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glEnable")) |proc| {
        function_pointers.glEnable = @ptrCast(proc);
    } else {
        log.err("entry point glEnable not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glFinish")) |proc| {
        function_pointers.glFinish = @ptrCast(proc);
    } else {
        log.err("entry point glFinish not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glFlush")) |proc| {
        function_pointers.glFlush = @ptrCast(proc);
    } else {
        log.err("entry point glFlush not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glBlendFunc")) |proc| {
        function_pointers.glBlendFunc = @ptrCast(proc);
    } else {
        log.err("entry point glBlendFunc not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glLogicOp")) |proc| {
        function_pointers.glLogicOp = @ptrCast(proc);
    } else {
        log.err("entry point glLogicOp not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glStencilFunc")) |proc| {
        function_pointers.glStencilFunc = @ptrCast(proc);
    } else {
        log.err("entry point glStencilFunc not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glStencilOp")) |proc| {
        function_pointers.glStencilOp = @ptrCast(proc);
    } else {
        log.err("entry point glStencilOp not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glDepthFunc")) |proc| {
        function_pointers.glDepthFunc = @ptrCast(proc);
    } else {
        log.err("entry point glDepthFunc not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glPixelStoref")) |proc| {
        function_pointers.glPixelStoref = @ptrCast(proc);
    } else {
        log.err("entry point glPixelStoref not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glPixelStorei")) |proc| {
        function_pointers.glPixelStorei = @ptrCast(proc);
    } else {
        log.err("entry point glPixelStorei not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glReadBuffer")) |proc| {
        function_pointers.glReadBuffer = @ptrCast(proc);
    } else {
        log.err("entry point glReadBuffer not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glReadPixels")) |proc| {
        function_pointers.glReadPixels = @ptrCast(proc);
    } else {
        log.err("entry point glReadPixels not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGetBooleanv")) |proc| {
        function_pointers.glGetBooleanv = @ptrCast(proc);
    } else {
        log.err("entry point glGetBooleanv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGetDoublev")) |proc| {
        function_pointers.glGetDoublev = @ptrCast(proc);
    } else {
        log.err("entry point glGetDoublev not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGetError")) |proc| {
        function_pointers.glGetError = @ptrCast(proc);
    } else {
        log.err("entry point glGetError not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGetFloatv")) |proc| {
        function_pointers.glGetFloatv = @ptrCast(proc);
    } else {
        log.err("entry point glGetFloatv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGetIntegerv")) |proc| {
        function_pointers.glGetIntegerv = @ptrCast(proc);
    } else {
        log.err("entry point glGetIntegerv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGetString")) |proc| {
        function_pointers.glGetString = @ptrCast(proc);
    } else {
        log.err("entry point glGetString not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGetTexImage")) |proc| {
        function_pointers.glGetTexImage = @ptrCast(proc);
    } else {
        log.err("entry point glGetTexImage not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGetTexParameterfv")) |proc| {
        function_pointers.glGetTexParameterfv = @ptrCast(proc);
    } else {
        log.err("entry point glGetTexParameterfv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGetTexParameteriv")) |proc| {
        function_pointers.glGetTexParameteriv = @ptrCast(proc);
    } else {
        log.err("entry point glGetTexParameteriv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGetTexLevelParameterfv")) |proc| {
        function_pointers.glGetTexLevelParameterfv = @ptrCast(proc);
    } else {
        log.err("entry point glGetTexLevelParameterfv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGetTexLevelParameteriv")) |proc| {
        function_pointers.glGetTexLevelParameteriv = @ptrCast(proc);
    } else {
        log.err("entry point glGetTexLevelParameteriv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glIsEnabled")) |proc| {
        function_pointers.glIsEnabled = @ptrCast(proc);
    } else {
        log.err("entry point glIsEnabled not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glDepthRange")) |proc| {
        function_pointers.glDepthRange = @ptrCast(proc);
    } else {
        log.err("entry point glDepthRange not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glViewport")) |proc| {
        function_pointers.glViewport = @ptrCast(proc);
    } else {
        log.err("entry point glViewport not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glNewList")) |proc| {
        function_pointers.glNewList = @ptrCast(proc);
    } else {
        log.err("entry point glNewList not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glEndList")) |proc| {
        function_pointers.glEndList = @ptrCast(proc);
    } else {
        log.err("entry point glEndList not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glCallList")) |proc| {
        function_pointers.glCallList = @ptrCast(proc);
    } else {
        log.err("entry point glCallList not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glCallLists")) |proc| {
        function_pointers.glCallLists = @ptrCast(proc);
    } else {
        log.err("entry point glCallLists not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glDeleteLists")) |proc| {
        function_pointers.glDeleteLists = @ptrCast(proc);
    } else {
        log.err("entry point glDeleteLists not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGenLists")) |proc| {
        function_pointers.glGenLists = @ptrCast(proc);
    } else {
        log.err("entry point glGenLists not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glListBase")) |proc| {
        function_pointers.glListBase = @ptrCast(proc);
    } else {
        log.err("entry point glListBase not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glBegin")) |proc| {
        function_pointers.glBegin = @ptrCast(proc);
    } else {
        log.err("entry point glBegin not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glBitmap")) |proc| {
        function_pointers.glBitmap = @ptrCast(proc);
    } else {
        log.err("entry point glBitmap not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glColor3b")) |proc| {
        function_pointers.glColor3b = @ptrCast(proc);
    } else {
        log.err("entry point glColor3b not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glColor3bv")) |proc| {
        function_pointers.glColor3bv = @ptrCast(proc);
    } else {
        log.err("entry point glColor3bv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glColor3d")) |proc| {
        function_pointers.glColor3d = @ptrCast(proc);
    } else {
        log.err("entry point glColor3d not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glColor3dv")) |proc| {
        function_pointers.glColor3dv = @ptrCast(proc);
    } else {
        log.err("entry point glColor3dv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glColor3f")) |proc| {
        function_pointers.glColor3f = @ptrCast(proc);
    } else {
        log.err("entry point glColor3f not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glColor3fv")) |proc| {
        function_pointers.glColor3fv = @ptrCast(proc);
    } else {
        log.err("entry point glColor3fv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glColor3i")) |proc| {
        function_pointers.glColor3i = @ptrCast(proc);
    } else {
        log.err("entry point glColor3i not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glColor3iv")) |proc| {
        function_pointers.glColor3iv = @ptrCast(proc);
    } else {
        log.err("entry point glColor3iv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glColor3s")) |proc| {
        function_pointers.glColor3s = @ptrCast(proc);
    } else {
        log.err("entry point glColor3s not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glColor3sv")) |proc| {
        function_pointers.glColor3sv = @ptrCast(proc);
    } else {
        log.err("entry point glColor3sv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glColor3ub")) |proc| {
        function_pointers.glColor3ub = @ptrCast(proc);
    } else {
        log.err("entry point glColor3ub not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glColor3ubv")) |proc| {
        function_pointers.glColor3ubv = @ptrCast(proc);
    } else {
        log.err("entry point glColor3ubv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glColor3ui")) |proc| {
        function_pointers.glColor3ui = @ptrCast(proc);
    } else {
        log.err("entry point glColor3ui not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glColor3uiv")) |proc| {
        function_pointers.glColor3uiv = @ptrCast(proc);
    } else {
        log.err("entry point glColor3uiv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glColor3us")) |proc| {
        function_pointers.glColor3us = @ptrCast(proc);
    } else {
        log.err("entry point glColor3us not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glColor3usv")) |proc| {
        function_pointers.glColor3usv = @ptrCast(proc);
    } else {
        log.err("entry point glColor3usv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glColor4b")) |proc| {
        function_pointers.glColor4b = @ptrCast(proc);
    } else {
        log.err("entry point glColor4b not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glColor4bv")) |proc| {
        function_pointers.glColor4bv = @ptrCast(proc);
    } else {
        log.err("entry point glColor4bv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glColor4d")) |proc| {
        function_pointers.glColor4d = @ptrCast(proc);
    } else {
        log.err("entry point glColor4d not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glColor4dv")) |proc| {
        function_pointers.glColor4dv = @ptrCast(proc);
    } else {
        log.err("entry point glColor4dv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glColor4f")) |proc| {
        function_pointers.glColor4f = @ptrCast(proc);
    } else {
        log.err("entry point glColor4f not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glColor4fv")) |proc| {
        function_pointers.glColor4fv = @ptrCast(proc);
    } else {
        log.err("entry point glColor4fv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glColor4i")) |proc| {
        function_pointers.glColor4i = @ptrCast(proc);
    } else {
        log.err("entry point glColor4i not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glColor4iv")) |proc| {
        function_pointers.glColor4iv = @ptrCast(proc);
    } else {
        log.err("entry point glColor4iv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glColor4s")) |proc| {
        function_pointers.glColor4s = @ptrCast(proc);
    } else {
        log.err("entry point glColor4s not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glColor4sv")) |proc| {
        function_pointers.glColor4sv = @ptrCast(proc);
    } else {
        log.err("entry point glColor4sv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glColor4ub")) |proc| {
        function_pointers.glColor4ub = @ptrCast(proc);
    } else {
        log.err("entry point glColor4ub not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glColor4ubv")) |proc| {
        function_pointers.glColor4ubv = @ptrCast(proc);
    } else {
        log.err("entry point glColor4ubv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glColor4ui")) |proc| {
        function_pointers.glColor4ui = @ptrCast(proc);
    } else {
        log.err("entry point glColor4ui not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glColor4uiv")) |proc| {
        function_pointers.glColor4uiv = @ptrCast(proc);
    } else {
        log.err("entry point glColor4uiv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glColor4us")) |proc| {
        function_pointers.glColor4us = @ptrCast(proc);
    } else {
        log.err("entry point glColor4us not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glColor4usv")) |proc| {
        function_pointers.glColor4usv = @ptrCast(proc);
    } else {
        log.err("entry point glColor4usv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glEdgeFlag")) |proc| {
        function_pointers.glEdgeFlag = @ptrCast(proc);
    } else {
        log.err("entry point glEdgeFlag not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glEdgeFlagv")) |proc| {
        function_pointers.glEdgeFlagv = @ptrCast(proc);
    } else {
        log.err("entry point glEdgeFlagv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glEnd")) |proc| {
        function_pointers.glEnd = @ptrCast(proc);
    } else {
        log.err("entry point glEnd not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glIndexd")) |proc| {
        function_pointers.glIndexd = @ptrCast(proc);
    } else {
        log.err("entry point glIndexd not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glIndexdv")) |proc| {
        function_pointers.glIndexdv = @ptrCast(proc);
    } else {
        log.err("entry point glIndexdv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glIndexf")) |proc| {
        function_pointers.glIndexf = @ptrCast(proc);
    } else {
        log.err("entry point glIndexf not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glIndexfv")) |proc| {
        function_pointers.glIndexfv = @ptrCast(proc);
    } else {
        log.err("entry point glIndexfv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glIndexi")) |proc| {
        function_pointers.glIndexi = @ptrCast(proc);
    } else {
        log.err("entry point glIndexi not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glIndexiv")) |proc| {
        function_pointers.glIndexiv = @ptrCast(proc);
    } else {
        log.err("entry point glIndexiv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glIndexs")) |proc| {
        function_pointers.glIndexs = @ptrCast(proc);
    } else {
        log.err("entry point glIndexs not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glIndexsv")) |proc| {
        function_pointers.glIndexsv = @ptrCast(proc);
    } else {
        log.err("entry point glIndexsv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glNormal3b")) |proc| {
        function_pointers.glNormal3b = @ptrCast(proc);
    } else {
        log.err("entry point glNormal3b not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glNormal3bv")) |proc| {
        function_pointers.glNormal3bv = @ptrCast(proc);
    } else {
        log.err("entry point glNormal3bv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glNormal3d")) |proc| {
        function_pointers.glNormal3d = @ptrCast(proc);
    } else {
        log.err("entry point glNormal3d not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glNormal3dv")) |proc| {
        function_pointers.glNormal3dv = @ptrCast(proc);
    } else {
        log.err("entry point glNormal3dv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glNormal3f")) |proc| {
        function_pointers.glNormal3f = @ptrCast(proc);
    } else {
        log.err("entry point glNormal3f not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glNormal3fv")) |proc| {
        function_pointers.glNormal3fv = @ptrCast(proc);
    } else {
        log.err("entry point glNormal3fv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glNormal3i")) |proc| {
        function_pointers.glNormal3i = @ptrCast(proc);
    } else {
        log.err("entry point glNormal3i not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glNormal3iv")) |proc| {
        function_pointers.glNormal3iv = @ptrCast(proc);
    } else {
        log.err("entry point glNormal3iv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glNormal3s")) |proc| {
        function_pointers.glNormal3s = @ptrCast(proc);
    } else {
        log.err("entry point glNormal3s not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glNormal3sv")) |proc| {
        function_pointers.glNormal3sv = @ptrCast(proc);
    } else {
        log.err("entry point glNormal3sv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glRasterPos2d")) |proc| {
        function_pointers.glRasterPos2d = @ptrCast(proc);
    } else {
        log.err("entry point glRasterPos2d not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glRasterPos2dv")) |proc| {
        function_pointers.glRasterPos2dv = @ptrCast(proc);
    } else {
        log.err("entry point glRasterPos2dv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glRasterPos2f")) |proc| {
        function_pointers.glRasterPos2f = @ptrCast(proc);
    } else {
        log.err("entry point glRasterPos2f not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glRasterPos2fv")) |proc| {
        function_pointers.glRasterPos2fv = @ptrCast(proc);
    } else {
        log.err("entry point glRasterPos2fv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glRasterPos2i")) |proc| {
        function_pointers.glRasterPos2i = @ptrCast(proc);
    } else {
        log.err("entry point glRasterPos2i not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glRasterPos2iv")) |proc| {
        function_pointers.glRasterPos2iv = @ptrCast(proc);
    } else {
        log.err("entry point glRasterPos2iv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glRasterPos2s")) |proc| {
        function_pointers.glRasterPos2s = @ptrCast(proc);
    } else {
        log.err("entry point glRasterPos2s not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glRasterPos2sv")) |proc| {
        function_pointers.glRasterPos2sv = @ptrCast(proc);
    } else {
        log.err("entry point glRasterPos2sv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glRasterPos3d")) |proc| {
        function_pointers.glRasterPos3d = @ptrCast(proc);
    } else {
        log.err("entry point glRasterPos3d not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glRasterPos3dv")) |proc| {
        function_pointers.glRasterPos3dv = @ptrCast(proc);
    } else {
        log.err("entry point glRasterPos3dv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glRasterPos3f")) |proc| {
        function_pointers.glRasterPos3f = @ptrCast(proc);
    } else {
        log.err("entry point glRasterPos3f not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glRasterPos3fv")) |proc| {
        function_pointers.glRasterPos3fv = @ptrCast(proc);
    } else {
        log.err("entry point glRasterPos3fv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glRasterPos3i")) |proc| {
        function_pointers.glRasterPos3i = @ptrCast(proc);
    } else {
        log.err("entry point glRasterPos3i not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glRasterPos3iv")) |proc| {
        function_pointers.glRasterPos3iv = @ptrCast(proc);
    } else {
        log.err("entry point glRasterPos3iv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glRasterPos3s")) |proc| {
        function_pointers.glRasterPos3s = @ptrCast(proc);
    } else {
        log.err("entry point glRasterPos3s not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glRasterPos3sv")) |proc| {
        function_pointers.glRasterPos3sv = @ptrCast(proc);
    } else {
        log.err("entry point glRasterPos3sv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glRasterPos4d")) |proc| {
        function_pointers.glRasterPos4d = @ptrCast(proc);
    } else {
        log.err("entry point glRasterPos4d not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glRasterPos4dv")) |proc| {
        function_pointers.glRasterPos4dv = @ptrCast(proc);
    } else {
        log.err("entry point glRasterPos4dv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glRasterPos4f")) |proc| {
        function_pointers.glRasterPos4f = @ptrCast(proc);
    } else {
        log.err("entry point glRasterPos4f not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glRasterPos4fv")) |proc| {
        function_pointers.glRasterPos4fv = @ptrCast(proc);
    } else {
        log.err("entry point glRasterPos4fv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glRasterPos4i")) |proc| {
        function_pointers.glRasterPos4i = @ptrCast(proc);
    } else {
        log.err("entry point glRasterPos4i not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glRasterPos4iv")) |proc| {
        function_pointers.glRasterPos4iv = @ptrCast(proc);
    } else {
        log.err("entry point glRasterPos4iv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glRasterPos4s")) |proc| {
        function_pointers.glRasterPos4s = @ptrCast(proc);
    } else {
        log.err("entry point glRasterPos4s not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glRasterPos4sv")) |proc| {
        function_pointers.glRasterPos4sv = @ptrCast(proc);
    } else {
        log.err("entry point glRasterPos4sv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glRectd")) |proc| {
        function_pointers.glRectd = @ptrCast(proc);
    } else {
        log.err("entry point glRectd not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glRectdv")) |proc| {
        function_pointers.glRectdv = @ptrCast(proc);
    } else {
        log.err("entry point glRectdv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glRectf")) |proc| {
        function_pointers.glRectf = @ptrCast(proc);
    } else {
        log.err("entry point glRectf not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glRectfv")) |proc| {
        function_pointers.glRectfv = @ptrCast(proc);
    } else {
        log.err("entry point glRectfv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glRecti")) |proc| {
        function_pointers.glRecti = @ptrCast(proc);
    } else {
        log.err("entry point glRecti not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glRectiv")) |proc| {
        function_pointers.glRectiv = @ptrCast(proc);
    } else {
        log.err("entry point glRectiv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glRects")) |proc| {
        function_pointers.glRects = @ptrCast(proc);
    } else {
        log.err("entry point glRects not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glRectsv")) |proc| {
        function_pointers.glRectsv = @ptrCast(proc);
    } else {
        log.err("entry point glRectsv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glTexCoord1d")) |proc| {
        function_pointers.glTexCoord1d = @ptrCast(proc);
    } else {
        log.err("entry point glTexCoord1d not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glTexCoord1dv")) |proc| {
        function_pointers.glTexCoord1dv = @ptrCast(proc);
    } else {
        log.err("entry point glTexCoord1dv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glTexCoord1f")) |proc| {
        function_pointers.glTexCoord1f = @ptrCast(proc);
    } else {
        log.err("entry point glTexCoord1f not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glTexCoord1fv")) |proc| {
        function_pointers.glTexCoord1fv = @ptrCast(proc);
    } else {
        log.err("entry point glTexCoord1fv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glTexCoord1i")) |proc| {
        function_pointers.glTexCoord1i = @ptrCast(proc);
    } else {
        log.err("entry point glTexCoord1i not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glTexCoord1iv")) |proc| {
        function_pointers.glTexCoord1iv = @ptrCast(proc);
    } else {
        log.err("entry point glTexCoord1iv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glTexCoord1s")) |proc| {
        function_pointers.glTexCoord1s = @ptrCast(proc);
    } else {
        log.err("entry point glTexCoord1s not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glTexCoord1sv")) |proc| {
        function_pointers.glTexCoord1sv = @ptrCast(proc);
    } else {
        log.err("entry point glTexCoord1sv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glTexCoord2d")) |proc| {
        function_pointers.glTexCoord2d = @ptrCast(proc);
    } else {
        log.err("entry point glTexCoord2d not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glTexCoord2dv")) |proc| {
        function_pointers.glTexCoord2dv = @ptrCast(proc);
    } else {
        log.err("entry point glTexCoord2dv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glTexCoord2f")) |proc| {
        function_pointers.glTexCoord2f = @ptrCast(proc);
    } else {
        log.err("entry point glTexCoord2f not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glTexCoord2fv")) |proc| {
        function_pointers.glTexCoord2fv = @ptrCast(proc);
    } else {
        log.err("entry point glTexCoord2fv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glTexCoord2i")) |proc| {
        function_pointers.glTexCoord2i = @ptrCast(proc);
    } else {
        log.err("entry point glTexCoord2i not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glTexCoord2iv")) |proc| {
        function_pointers.glTexCoord2iv = @ptrCast(proc);
    } else {
        log.err("entry point glTexCoord2iv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glTexCoord2s")) |proc| {
        function_pointers.glTexCoord2s = @ptrCast(proc);
    } else {
        log.err("entry point glTexCoord2s not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glTexCoord2sv")) |proc| {
        function_pointers.glTexCoord2sv = @ptrCast(proc);
    } else {
        log.err("entry point glTexCoord2sv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glTexCoord3d")) |proc| {
        function_pointers.glTexCoord3d = @ptrCast(proc);
    } else {
        log.err("entry point glTexCoord3d not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glTexCoord3dv")) |proc| {
        function_pointers.glTexCoord3dv = @ptrCast(proc);
    } else {
        log.err("entry point glTexCoord3dv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glTexCoord3f")) |proc| {
        function_pointers.glTexCoord3f = @ptrCast(proc);
    } else {
        log.err("entry point glTexCoord3f not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glTexCoord3fv")) |proc| {
        function_pointers.glTexCoord3fv = @ptrCast(proc);
    } else {
        log.err("entry point glTexCoord3fv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glTexCoord3i")) |proc| {
        function_pointers.glTexCoord3i = @ptrCast(proc);
    } else {
        log.err("entry point glTexCoord3i not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glTexCoord3iv")) |proc| {
        function_pointers.glTexCoord3iv = @ptrCast(proc);
    } else {
        log.err("entry point glTexCoord3iv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glTexCoord3s")) |proc| {
        function_pointers.glTexCoord3s = @ptrCast(proc);
    } else {
        log.err("entry point glTexCoord3s not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glTexCoord3sv")) |proc| {
        function_pointers.glTexCoord3sv = @ptrCast(proc);
    } else {
        log.err("entry point glTexCoord3sv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glTexCoord4d")) |proc| {
        function_pointers.glTexCoord4d = @ptrCast(proc);
    } else {
        log.err("entry point glTexCoord4d not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glTexCoord4dv")) |proc| {
        function_pointers.glTexCoord4dv = @ptrCast(proc);
    } else {
        log.err("entry point glTexCoord4dv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glTexCoord4f")) |proc| {
        function_pointers.glTexCoord4f = @ptrCast(proc);
    } else {
        log.err("entry point glTexCoord4f not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glTexCoord4fv")) |proc| {
        function_pointers.glTexCoord4fv = @ptrCast(proc);
    } else {
        log.err("entry point glTexCoord4fv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glTexCoord4i")) |proc| {
        function_pointers.glTexCoord4i = @ptrCast(proc);
    } else {
        log.err("entry point glTexCoord4i not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glTexCoord4iv")) |proc| {
        function_pointers.glTexCoord4iv = @ptrCast(proc);
    } else {
        log.err("entry point glTexCoord4iv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glTexCoord4s")) |proc| {
        function_pointers.glTexCoord4s = @ptrCast(proc);
    } else {
        log.err("entry point glTexCoord4s not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glTexCoord4sv")) |proc| {
        function_pointers.glTexCoord4sv = @ptrCast(proc);
    } else {
        log.err("entry point glTexCoord4sv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertex2d")) |proc| {
        function_pointers.glVertex2d = @ptrCast(proc);
    } else {
        log.err("entry point glVertex2d not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertex2dv")) |proc| {
        function_pointers.glVertex2dv = @ptrCast(proc);
    } else {
        log.err("entry point glVertex2dv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertex2f")) |proc| {
        function_pointers.glVertex2f = @ptrCast(proc);
    } else {
        log.err("entry point glVertex2f not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertex2fv")) |proc| {
        function_pointers.glVertex2fv = @ptrCast(proc);
    } else {
        log.err("entry point glVertex2fv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertex2i")) |proc| {
        function_pointers.glVertex2i = @ptrCast(proc);
    } else {
        log.err("entry point glVertex2i not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertex2iv")) |proc| {
        function_pointers.glVertex2iv = @ptrCast(proc);
    } else {
        log.err("entry point glVertex2iv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertex2s")) |proc| {
        function_pointers.glVertex2s = @ptrCast(proc);
    } else {
        log.err("entry point glVertex2s not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertex2sv")) |proc| {
        function_pointers.glVertex2sv = @ptrCast(proc);
    } else {
        log.err("entry point glVertex2sv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertex3d")) |proc| {
        function_pointers.glVertex3d = @ptrCast(proc);
    } else {
        log.err("entry point glVertex3d not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertex3dv")) |proc| {
        function_pointers.glVertex3dv = @ptrCast(proc);
    } else {
        log.err("entry point glVertex3dv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertex3f")) |proc| {
        function_pointers.glVertex3f = @ptrCast(proc);
    } else {
        log.err("entry point glVertex3f not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertex3fv")) |proc| {
        function_pointers.glVertex3fv = @ptrCast(proc);
    } else {
        log.err("entry point glVertex3fv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertex3i")) |proc| {
        function_pointers.glVertex3i = @ptrCast(proc);
    } else {
        log.err("entry point glVertex3i not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertex3iv")) |proc| {
        function_pointers.glVertex3iv = @ptrCast(proc);
    } else {
        log.err("entry point glVertex3iv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertex3s")) |proc| {
        function_pointers.glVertex3s = @ptrCast(proc);
    } else {
        log.err("entry point glVertex3s not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertex3sv")) |proc| {
        function_pointers.glVertex3sv = @ptrCast(proc);
    } else {
        log.err("entry point glVertex3sv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertex4d")) |proc| {
        function_pointers.glVertex4d = @ptrCast(proc);
    } else {
        log.err("entry point glVertex4d not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertex4dv")) |proc| {
        function_pointers.glVertex4dv = @ptrCast(proc);
    } else {
        log.err("entry point glVertex4dv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertex4f")) |proc| {
        function_pointers.glVertex4f = @ptrCast(proc);
    } else {
        log.err("entry point glVertex4f not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertex4fv")) |proc| {
        function_pointers.glVertex4fv = @ptrCast(proc);
    } else {
        log.err("entry point glVertex4fv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertex4i")) |proc| {
        function_pointers.glVertex4i = @ptrCast(proc);
    } else {
        log.err("entry point glVertex4i not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertex4iv")) |proc| {
        function_pointers.glVertex4iv = @ptrCast(proc);
    } else {
        log.err("entry point glVertex4iv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertex4s")) |proc| {
        function_pointers.glVertex4s = @ptrCast(proc);
    } else {
        log.err("entry point glVertex4s not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertex4sv")) |proc| {
        function_pointers.glVertex4sv = @ptrCast(proc);
    } else {
        log.err("entry point glVertex4sv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glClipPlane")) |proc| {
        function_pointers.glClipPlane = @ptrCast(proc);
    } else {
        log.err("entry point glClipPlane not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glColorMaterial")) |proc| {
        function_pointers.glColorMaterial = @ptrCast(proc);
    } else {
        log.err("entry point glColorMaterial not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glFogf")) |proc| {
        function_pointers.glFogf = @ptrCast(proc);
    } else {
        log.err("entry point glFogf not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glFogfv")) |proc| {
        function_pointers.glFogfv = @ptrCast(proc);
    } else {
        log.err("entry point glFogfv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glFogi")) |proc| {
        function_pointers.glFogi = @ptrCast(proc);
    } else {
        log.err("entry point glFogi not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glFogiv")) |proc| {
        function_pointers.glFogiv = @ptrCast(proc);
    } else {
        log.err("entry point glFogiv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glLightf")) |proc| {
        function_pointers.glLightf = @ptrCast(proc);
    } else {
        log.err("entry point glLightf not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glLightfv")) |proc| {
        function_pointers.glLightfv = @ptrCast(proc);
    } else {
        log.err("entry point glLightfv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glLighti")) |proc| {
        function_pointers.glLighti = @ptrCast(proc);
    } else {
        log.err("entry point glLighti not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glLightiv")) |proc| {
        function_pointers.glLightiv = @ptrCast(proc);
    } else {
        log.err("entry point glLightiv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glLightModelf")) |proc| {
        function_pointers.glLightModelf = @ptrCast(proc);
    } else {
        log.err("entry point glLightModelf not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glLightModelfv")) |proc| {
        function_pointers.glLightModelfv = @ptrCast(proc);
    } else {
        log.err("entry point glLightModelfv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glLightModeli")) |proc| {
        function_pointers.glLightModeli = @ptrCast(proc);
    } else {
        log.err("entry point glLightModeli not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glLightModeliv")) |proc| {
        function_pointers.glLightModeliv = @ptrCast(proc);
    } else {
        log.err("entry point glLightModeliv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glLineStipple")) |proc| {
        function_pointers.glLineStipple = @ptrCast(proc);
    } else {
        log.err("entry point glLineStipple not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glMaterialf")) |proc| {
        function_pointers.glMaterialf = @ptrCast(proc);
    } else {
        log.err("entry point glMaterialf not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glMaterialfv")) |proc| {
        function_pointers.glMaterialfv = @ptrCast(proc);
    } else {
        log.err("entry point glMaterialfv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glMateriali")) |proc| {
        function_pointers.glMateriali = @ptrCast(proc);
    } else {
        log.err("entry point glMateriali not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glMaterialiv")) |proc| {
        function_pointers.glMaterialiv = @ptrCast(proc);
    } else {
        log.err("entry point glMaterialiv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glPolygonStipple")) |proc| {
        function_pointers.glPolygonStipple = @ptrCast(proc);
    } else {
        log.err("entry point glPolygonStipple not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glShadeModel")) |proc| {
        function_pointers.glShadeModel = @ptrCast(proc);
    } else {
        log.err("entry point glShadeModel not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glTexEnvf")) |proc| {
        function_pointers.glTexEnvf = @ptrCast(proc);
    } else {
        log.err("entry point glTexEnvf not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glTexEnvfv")) |proc| {
        function_pointers.glTexEnvfv = @ptrCast(proc);
    } else {
        log.err("entry point glTexEnvfv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glTexEnvi")) |proc| {
        function_pointers.glTexEnvi = @ptrCast(proc);
    } else {
        log.err("entry point glTexEnvi not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glTexEnviv")) |proc| {
        function_pointers.glTexEnviv = @ptrCast(proc);
    } else {
        log.err("entry point glTexEnviv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glTexGend")) |proc| {
        function_pointers.glTexGend = @ptrCast(proc);
    } else {
        log.err("entry point glTexGend not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glTexGendv")) |proc| {
        function_pointers.glTexGendv = @ptrCast(proc);
    } else {
        log.err("entry point glTexGendv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glTexGenf")) |proc| {
        function_pointers.glTexGenf = @ptrCast(proc);
    } else {
        log.err("entry point glTexGenf not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glTexGenfv")) |proc| {
        function_pointers.glTexGenfv = @ptrCast(proc);
    } else {
        log.err("entry point glTexGenfv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glTexGeni")) |proc| {
        function_pointers.glTexGeni = @ptrCast(proc);
    } else {
        log.err("entry point glTexGeni not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glTexGeniv")) |proc| {
        function_pointers.glTexGeniv = @ptrCast(proc);
    } else {
        log.err("entry point glTexGeniv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glFeedbackBuffer")) |proc| {
        function_pointers.glFeedbackBuffer = @ptrCast(proc);
    } else {
        log.err("entry point glFeedbackBuffer not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glSelectBuffer")) |proc| {
        function_pointers.glSelectBuffer = @ptrCast(proc);
    } else {
        log.err("entry point glSelectBuffer not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glRenderMode")) |proc| {
        function_pointers.glRenderMode = @ptrCast(proc);
    } else {
        log.err("entry point glRenderMode not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glInitNames")) |proc| {
        function_pointers.glInitNames = @ptrCast(proc);
    } else {
        log.err("entry point glInitNames not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glLoadName")) |proc| {
        function_pointers.glLoadName = @ptrCast(proc);
    } else {
        log.err("entry point glLoadName not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glPassThrough")) |proc| {
        function_pointers.glPassThrough = @ptrCast(proc);
    } else {
        log.err("entry point glPassThrough not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glPopName")) |proc| {
        function_pointers.glPopName = @ptrCast(proc);
    } else {
        log.err("entry point glPopName not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glPushName")) |proc| {
        function_pointers.glPushName = @ptrCast(proc);
    } else {
        log.err("entry point glPushName not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glClearAccum")) |proc| {
        function_pointers.glClearAccum = @ptrCast(proc);
    } else {
        log.err("entry point glClearAccum not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glClearIndex")) |proc| {
        function_pointers.glClearIndex = @ptrCast(proc);
    } else {
        log.err("entry point glClearIndex not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glIndexMask")) |proc| {
        function_pointers.glIndexMask = @ptrCast(proc);
    } else {
        log.err("entry point glIndexMask not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glAccum")) |proc| {
        function_pointers.glAccum = @ptrCast(proc);
    } else {
        log.err("entry point glAccum not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glPopAttrib")) |proc| {
        function_pointers.glPopAttrib = @ptrCast(proc);
    } else {
        log.err("entry point glPopAttrib not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glPushAttrib")) |proc| {
        function_pointers.glPushAttrib = @ptrCast(proc);
    } else {
        log.err("entry point glPushAttrib not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glMap1d")) |proc| {
        function_pointers.glMap1d = @ptrCast(proc);
    } else {
        log.err("entry point glMap1d not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glMap1f")) |proc| {
        function_pointers.glMap1f = @ptrCast(proc);
    } else {
        log.err("entry point glMap1f not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glMap2d")) |proc| {
        function_pointers.glMap2d = @ptrCast(proc);
    } else {
        log.err("entry point glMap2d not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glMap2f")) |proc| {
        function_pointers.glMap2f = @ptrCast(proc);
    } else {
        log.err("entry point glMap2f not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glMapGrid1d")) |proc| {
        function_pointers.glMapGrid1d = @ptrCast(proc);
    } else {
        log.err("entry point glMapGrid1d not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glMapGrid1f")) |proc| {
        function_pointers.glMapGrid1f = @ptrCast(proc);
    } else {
        log.err("entry point glMapGrid1f not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glMapGrid2d")) |proc| {
        function_pointers.glMapGrid2d = @ptrCast(proc);
    } else {
        log.err("entry point glMapGrid2d not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glMapGrid2f")) |proc| {
        function_pointers.glMapGrid2f = @ptrCast(proc);
    } else {
        log.err("entry point glMapGrid2f not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glEvalCoord1d")) |proc| {
        function_pointers.glEvalCoord1d = @ptrCast(proc);
    } else {
        log.err("entry point glEvalCoord1d not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glEvalCoord1dv")) |proc| {
        function_pointers.glEvalCoord1dv = @ptrCast(proc);
    } else {
        log.err("entry point glEvalCoord1dv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glEvalCoord1f")) |proc| {
        function_pointers.glEvalCoord1f = @ptrCast(proc);
    } else {
        log.err("entry point glEvalCoord1f not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glEvalCoord1fv")) |proc| {
        function_pointers.glEvalCoord1fv = @ptrCast(proc);
    } else {
        log.err("entry point glEvalCoord1fv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glEvalCoord2d")) |proc| {
        function_pointers.glEvalCoord2d = @ptrCast(proc);
    } else {
        log.err("entry point glEvalCoord2d not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glEvalCoord2dv")) |proc| {
        function_pointers.glEvalCoord2dv = @ptrCast(proc);
    } else {
        log.err("entry point glEvalCoord2dv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glEvalCoord2f")) |proc| {
        function_pointers.glEvalCoord2f = @ptrCast(proc);
    } else {
        log.err("entry point glEvalCoord2f not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glEvalCoord2fv")) |proc| {
        function_pointers.glEvalCoord2fv = @ptrCast(proc);
    } else {
        log.err("entry point glEvalCoord2fv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glEvalMesh1")) |proc| {
        function_pointers.glEvalMesh1 = @ptrCast(proc);
    } else {
        log.err("entry point glEvalMesh1 not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glEvalPoint1")) |proc| {
        function_pointers.glEvalPoint1 = @ptrCast(proc);
    } else {
        log.err("entry point glEvalPoint1 not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glEvalMesh2")) |proc| {
        function_pointers.glEvalMesh2 = @ptrCast(proc);
    } else {
        log.err("entry point glEvalMesh2 not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glEvalPoint2")) |proc| {
        function_pointers.glEvalPoint2 = @ptrCast(proc);
    } else {
        log.err("entry point glEvalPoint2 not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glAlphaFunc")) |proc| {
        function_pointers.glAlphaFunc = @ptrCast(proc);
    } else {
        log.err("entry point glAlphaFunc not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glPixelZoom")) |proc| {
        function_pointers.glPixelZoom = @ptrCast(proc);
    } else {
        log.err("entry point glPixelZoom not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glPixelTransferf")) |proc| {
        function_pointers.glPixelTransferf = @ptrCast(proc);
    } else {
        log.err("entry point glPixelTransferf not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glPixelTransferi")) |proc| {
        function_pointers.glPixelTransferi = @ptrCast(proc);
    } else {
        log.err("entry point glPixelTransferi not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glPixelMapfv")) |proc| {
        function_pointers.glPixelMapfv = @ptrCast(proc);
    } else {
        log.err("entry point glPixelMapfv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glPixelMapuiv")) |proc| {
        function_pointers.glPixelMapuiv = @ptrCast(proc);
    } else {
        log.err("entry point glPixelMapuiv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glPixelMapusv")) |proc| {
        function_pointers.glPixelMapusv = @ptrCast(proc);
    } else {
        log.err("entry point glPixelMapusv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glCopyPixels")) |proc| {
        function_pointers.glCopyPixels = @ptrCast(proc);
    } else {
        log.err("entry point glCopyPixels not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glDrawPixels")) |proc| {
        function_pointers.glDrawPixels = @ptrCast(proc);
    } else {
        log.err("entry point glDrawPixels not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGetClipPlane")) |proc| {
        function_pointers.glGetClipPlane = @ptrCast(proc);
    } else {
        log.err("entry point glGetClipPlane not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGetLightfv")) |proc| {
        function_pointers.glGetLightfv = @ptrCast(proc);
    } else {
        log.err("entry point glGetLightfv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGetLightiv")) |proc| {
        function_pointers.glGetLightiv = @ptrCast(proc);
    } else {
        log.err("entry point glGetLightiv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGetMapdv")) |proc| {
        function_pointers.glGetMapdv = @ptrCast(proc);
    } else {
        log.err("entry point glGetMapdv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGetMapfv")) |proc| {
        function_pointers.glGetMapfv = @ptrCast(proc);
    } else {
        log.err("entry point glGetMapfv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGetMapiv")) |proc| {
        function_pointers.glGetMapiv = @ptrCast(proc);
    } else {
        log.err("entry point glGetMapiv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGetMaterialfv")) |proc| {
        function_pointers.glGetMaterialfv = @ptrCast(proc);
    } else {
        log.err("entry point glGetMaterialfv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGetMaterialiv")) |proc| {
        function_pointers.glGetMaterialiv = @ptrCast(proc);
    } else {
        log.err("entry point glGetMaterialiv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGetPixelMapfv")) |proc| {
        function_pointers.glGetPixelMapfv = @ptrCast(proc);
    } else {
        log.err("entry point glGetPixelMapfv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGetPixelMapuiv")) |proc| {
        function_pointers.glGetPixelMapuiv = @ptrCast(proc);
    } else {
        log.err("entry point glGetPixelMapuiv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGetPixelMapusv")) |proc| {
        function_pointers.glGetPixelMapusv = @ptrCast(proc);
    } else {
        log.err("entry point glGetPixelMapusv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGetPolygonStipple")) |proc| {
        function_pointers.glGetPolygonStipple = @ptrCast(proc);
    } else {
        log.err("entry point glGetPolygonStipple not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGetTexEnvfv")) |proc| {
        function_pointers.glGetTexEnvfv = @ptrCast(proc);
    } else {
        log.err("entry point glGetTexEnvfv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGetTexEnviv")) |proc| {
        function_pointers.glGetTexEnviv = @ptrCast(proc);
    } else {
        log.err("entry point glGetTexEnviv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGetTexGendv")) |proc| {
        function_pointers.glGetTexGendv = @ptrCast(proc);
    } else {
        log.err("entry point glGetTexGendv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGetTexGenfv")) |proc| {
        function_pointers.glGetTexGenfv = @ptrCast(proc);
    } else {
        log.err("entry point glGetTexGenfv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGetTexGeniv")) |proc| {
        function_pointers.glGetTexGeniv = @ptrCast(proc);
    } else {
        log.err("entry point glGetTexGeniv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glIsList")) |proc| {
        function_pointers.glIsList = @ptrCast(proc);
    } else {
        log.err("entry point glIsList not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glFrustum")) |proc| {
        function_pointers.glFrustum = @ptrCast(proc);
    } else {
        log.err("entry point glFrustum not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glLoadIdentity")) |proc| {
        function_pointers.glLoadIdentity = @ptrCast(proc);
    } else {
        log.err("entry point glLoadIdentity not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glLoadMatrixf")) |proc| {
        function_pointers.glLoadMatrixf = @ptrCast(proc);
    } else {
        log.err("entry point glLoadMatrixf not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glLoadMatrixd")) |proc| {
        function_pointers.glLoadMatrixd = @ptrCast(proc);
    } else {
        log.err("entry point glLoadMatrixd not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glMatrixMode")) |proc| {
        function_pointers.glMatrixMode = @ptrCast(proc);
    } else {
        log.err("entry point glMatrixMode not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glMultMatrixf")) |proc| {
        function_pointers.glMultMatrixf = @ptrCast(proc);
    } else {
        log.err("entry point glMultMatrixf not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glMultMatrixd")) |proc| {
        function_pointers.glMultMatrixd = @ptrCast(proc);
    } else {
        log.err("entry point glMultMatrixd not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glOrtho")) |proc| {
        function_pointers.glOrtho = @ptrCast(proc);
    } else {
        log.err("entry point glOrtho not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glPopMatrix")) |proc| {
        function_pointers.glPopMatrix = @ptrCast(proc);
    } else {
        log.err("entry point glPopMatrix not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glPushMatrix")) |proc| {
        function_pointers.glPushMatrix = @ptrCast(proc);
    } else {
        log.err("entry point glPushMatrix not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glRotated")) |proc| {
        function_pointers.glRotated = @ptrCast(proc);
    } else {
        log.err("entry point glRotated not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glRotatef")) |proc| {
        function_pointers.glRotatef = @ptrCast(proc);
    } else {
        log.err("entry point glRotatef not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glScaled")) |proc| {
        function_pointers.glScaled = @ptrCast(proc);
    } else {
        log.err("entry point glScaled not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glScalef")) |proc| {
        function_pointers.glScalef = @ptrCast(proc);
    } else {
        log.err("entry point glScalef not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glTranslated")) |proc| {
        function_pointers.glTranslated = @ptrCast(proc);
    } else {
        log.err("entry point glTranslated not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glTranslatef")) |proc| {
        function_pointers.glTranslatef = @ptrCast(proc);
    } else {
        log.err("entry point glTranslatef not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glDrawArrays")) |proc| {
        function_pointers.glDrawArrays = @ptrCast(proc);
    } else {
        log.err("entry point glDrawArrays not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glDrawElements")) |proc| {
        function_pointers.glDrawElements = @ptrCast(proc);
    } else {
        log.err("entry point glDrawElements not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGetPointerv")) |proc| {
        function_pointers.glGetPointerv = @ptrCast(proc);
    } else {
        log.err("entry point glGetPointerv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glPolygonOffset")) |proc| {
        function_pointers.glPolygonOffset = @ptrCast(proc);
    } else {
        log.err("entry point glPolygonOffset not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glCopyTexImage1D")) |proc| {
        function_pointers.glCopyTexImage1D = @ptrCast(proc);
    } else {
        log.err("entry point glCopyTexImage1D not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glCopyTexImage2D")) |proc| {
        function_pointers.glCopyTexImage2D = @ptrCast(proc);
    } else {
        log.err("entry point glCopyTexImage2D not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glCopyTexSubImage1D")) |proc| {
        function_pointers.glCopyTexSubImage1D = @ptrCast(proc);
    } else {
        log.err("entry point glCopyTexSubImage1D not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glCopyTexSubImage2D")) |proc| {
        function_pointers.glCopyTexSubImage2D = @ptrCast(proc);
    } else {
        log.err("entry point glCopyTexSubImage2D not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glTexSubImage1D")) |proc| {
        function_pointers.glTexSubImage1D = @ptrCast(proc);
    } else {
        log.err("entry point glTexSubImage1D not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glTexSubImage2D")) |proc| {
        function_pointers.glTexSubImage2D = @ptrCast(proc);
    } else {
        log.err("entry point glTexSubImage2D not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glBindTexture")) |proc| {
        function_pointers.glBindTexture = @ptrCast(proc);
    } else {
        log.err("entry point glBindTexture not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glDeleteTextures")) |proc| {
        function_pointers.glDeleteTextures = @ptrCast(proc);
    } else {
        log.err("entry point glDeleteTextures not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGenTextures")) |proc| {
        function_pointers.glGenTextures = @ptrCast(proc);
    } else {
        log.err("entry point glGenTextures not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glIsTexture")) |proc| {
        function_pointers.glIsTexture = @ptrCast(proc);
    } else {
        log.err("entry point glIsTexture not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glArrayElement")) |proc| {
        function_pointers.glArrayElement = @ptrCast(proc);
    } else {
        log.err("entry point glArrayElement not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glColorPointer")) |proc| {
        function_pointers.glColorPointer = @ptrCast(proc);
    } else {
        log.err("entry point glColorPointer not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glDisableClientState")) |proc| {
        function_pointers.glDisableClientState = @ptrCast(proc);
    } else {
        log.err("entry point glDisableClientState not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glEdgeFlagPointer")) |proc| {
        function_pointers.glEdgeFlagPointer = @ptrCast(proc);
    } else {
        log.err("entry point glEdgeFlagPointer not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glEnableClientState")) |proc| {
        function_pointers.glEnableClientState = @ptrCast(proc);
    } else {
        log.err("entry point glEnableClientState not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glIndexPointer")) |proc| {
        function_pointers.glIndexPointer = @ptrCast(proc);
    } else {
        log.err("entry point glIndexPointer not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glInterleavedArrays")) |proc| {
        function_pointers.glInterleavedArrays = @ptrCast(proc);
    } else {
        log.err("entry point glInterleavedArrays not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glNormalPointer")) |proc| {
        function_pointers.glNormalPointer = @ptrCast(proc);
    } else {
        log.err("entry point glNormalPointer not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glTexCoordPointer")) |proc| {
        function_pointers.glTexCoordPointer = @ptrCast(proc);
    } else {
        log.err("entry point glTexCoordPointer not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertexPointer")) |proc| {
        function_pointers.glVertexPointer = @ptrCast(proc);
    } else {
        log.err("entry point glVertexPointer not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glAreTexturesResident")) |proc| {
        function_pointers.glAreTexturesResident = @ptrCast(proc);
    } else {
        log.err("entry point glAreTexturesResident not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glPrioritizeTextures")) |proc| {
        function_pointers.glPrioritizeTextures = @ptrCast(proc);
    } else {
        log.err("entry point glPrioritizeTextures not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glIndexub")) |proc| {
        function_pointers.glIndexub = @ptrCast(proc);
    } else {
        log.err("entry point glIndexub not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glIndexubv")) |proc| {
        function_pointers.glIndexubv = @ptrCast(proc);
    } else {
        log.err("entry point glIndexubv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glPopClientAttrib")) |proc| {
        function_pointers.glPopClientAttrib = @ptrCast(proc);
    } else {
        log.err("entry point glPopClientAttrib not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glPushClientAttrib")) |proc| {
        function_pointers.glPushClientAttrib = @ptrCast(proc);
    } else {
        log.err("entry point glPushClientAttrib not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glDrawRangeElements")) |proc| {
        function_pointers.glDrawRangeElements = @ptrCast(proc);
    } else {
        log.err("entry point glDrawRangeElements not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glTexImage3D")) |proc| {
        function_pointers.glTexImage3D = @ptrCast(proc);
    } else {
        log.err("entry point glTexImage3D not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glTexSubImage3D")) |proc| {
        function_pointers.glTexSubImage3D = @ptrCast(proc);
    } else {
        log.err("entry point glTexSubImage3D not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glCopyTexSubImage3D")) |proc| {
        function_pointers.glCopyTexSubImage3D = @ptrCast(proc);
    } else {
        log.err("entry point glCopyTexSubImage3D not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glActiveTexture")) |proc| {
        function_pointers.glActiveTexture = @ptrCast(proc);
    } else {
        log.err("entry point glActiveTexture not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glSampleCoverage")) |proc| {
        function_pointers.glSampleCoverage = @ptrCast(proc);
    } else {
        log.err("entry point glSampleCoverage not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glCompressedTexImage3D")) |proc| {
        function_pointers.glCompressedTexImage3D = @ptrCast(proc);
    } else {
        log.err("entry point glCompressedTexImage3D not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glCompressedTexImage2D")) |proc| {
        function_pointers.glCompressedTexImage2D = @ptrCast(proc);
    } else {
        log.err("entry point glCompressedTexImage2D not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glCompressedTexImage1D")) |proc| {
        function_pointers.glCompressedTexImage1D = @ptrCast(proc);
    } else {
        log.err("entry point glCompressedTexImage1D not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glCompressedTexSubImage3D")) |proc| {
        function_pointers.glCompressedTexSubImage3D = @ptrCast(proc);
    } else {
        log.err("entry point glCompressedTexSubImage3D not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glCompressedTexSubImage2D")) |proc| {
        function_pointers.glCompressedTexSubImage2D = @ptrCast(proc);
    } else {
        log.err("entry point glCompressedTexSubImage2D not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glCompressedTexSubImage1D")) |proc| {
        function_pointers.glCompressedTexSubImage1D = @ptrCast(proc);
    } else {
        log.err("entry point glCompressedTexSubImage1D not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGetCompressedTexImage")) |proc| {
        function_pointers.glGetCompressedTexImage = @ptrCast(proc);
    } else {
        log.err("entry point glGetCompressedTexImage not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glClientActiveTexture")) |proc| {
        function_pointers.glClientActiveTexture = @ptrCast(proc);
    } else {
        log.err("entry point glClientActiveTexture not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glMultiTexCoord1d")) |proc| {
        function_pointers.glMultiTexCoord1d = @ptrCast(proc);
    } else {
        log.err("entry point glMultiTexCoord1d not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glMultiTexCoord1dv")) |proc| {
        function_pointers.glMultiTexCoord1dv = @ptrCast(proc);
    } else {
        log.err("entry point glMultiTexCoord1dv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glMultiTexCoord1f")) |proc| {
        function_pointers.glMultiTexCoord1f = @ptrCast(proc);
    } else {
        log.err("entry point glMultiTexCoord1f not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glMultiTexCoord1fv")) |proc| {
        function_pointers.glMultiTexCoord1fv = @ptrCast(proc);
    } else {
        log.err("entry point glMultiTexCoord1fv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glMultiTexCoord1i")) |proc| {
        function_pointers.glMultiTexCoord1i = @ptrCast(proc);
    } else {
        log.err("entry point glMultiTexCoord1i not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glMultiTexCoord1iv")) |proc| {
        function_pointers.glMultiTexCoord1iv = @ptrCast(proc);
    } else {
        log.err("entry point glMultiTexCoord1iv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glMultiTexCoord1s")) |proc| {
        function_pointers.glMultiTexCoord1s = @ptrCast(proc);
    } else {
        log.err("entry point glMultiTexCoord1s not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glMultiTexCoord1sv")) |proc| {
        function_pointers.glMultiTexCoord1sv = @ptrCast(proc);
    } else {
        log.err("entry point glMultiTexCoord1sv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glMultiTexCoord2d")) |proc| {
        function_pointers.glMultiTexCoord2d = @ptrCast(proc);
    } else {
        log.err("entry point glMultiTexCoord2d not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glMultiTexCoord2dv")) |proc| {
        function_pointers.glMultiTexCoord2dv = @ptrCast(proc);
    } else {
        log.err("entry point glMultiTexCoord2dv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glMultiTexCoord2f")) |proc| {
        function_pointers.glMultiTexCoord2f = @ptrCast(proc);
    } else {
        log.err("entry point glMultiTexCoord2f not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glMultiTexCoord2fv")) |proc| {
        function_pointers.glMultiTexCoord2fv = @ptrCast(proc);
    } else {
        log.err("entry point glMultiTexCoord2fv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glMultiTexCoord2i")) |proc| {
        function_pointers.glMultiTexCoord2i = @ptrCast(proc);
    } else {
        log.err("entry point glMultiTexCoord2i not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glMultiTexCoord2iv")) |proc| {
        function_pointers.glMultiTexCoord2iv = @ptrCast(proc);
    } else {
        log.err("entry point glMultiTexCoord2iv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glMultiTexCoord2s")) |proc| {
        function_pointers.glMultiTexCoord2s = @ptrCast(proc);
    } else {
        log.err("entry point glMultiTexCoord2s not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glMultiTexCoord2sv")) |proc| {
        function_pointers.glMultiTexCoord2sv = @ptrCast(proc);
    } else {
        log.err("entry point glMultiTexCoord2sv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glMultiTexCoord3d")) |proc| {
        function_pointers.glMultiTexCoord3d = @ptrCast(proc);
    } else {
        log.err("entry point glMultiTexCoord3d not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glMultiTexCoord3dv")) |proc| {
        function_pointers.glMultiTexCoord3dv = @ptrCast(proc);
    } else {
        log.err("entry point glMultiTexCoord3dv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glMultiTexCoord3f")) |proc| {
        function_pointers.glMultiTexCoord3f = @ptrCast(proc);
    } else {
        log.err("entry point glMultiTexCoord3f not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glMultiTexCoord3fv")) |proc| {
        function_pointers.glMultiTexCoord3fv = @ptrCast(proc);
    } else {
        log.err("entry point glMultiTexCoord3fv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glMultiTexCoord3i")) |proc| {
        function_pointers.glMultiTexCoord3i = @ptrCast(proc);
    } else {
        log.err("entry point glMultiTexCoord3i not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glMultiTexCoord3iv")) |proc| {
        function_pointers.glMultiTexCoord3iv = @ptrCast(proc);
    } else {
        log.err("entry point glMultiTexCoord3iv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glMultiTexCoord3s")) |proc| {
        function_pointers.glMultiTexCoord3s = @ptrCast(proc);
    } else {
        log.err("entry point glMultiTexCoord3s not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glMultiTexCoord3sv")) |proc| {
        function_pointers.glMultiTexCoord3sv = @ptrCast(proc);
    } else {
        log.err("entry point glMultiTexCoord3sv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glMultiTexCoord4d")) |proc| {
        function_pointers.glMultiTexCoord4d = @ptrCast(proc);
    } else {
        log.err("entry point glMultiTexCoord4d not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glMultiTexCoord4dv")) |proc| {
        function_pointers.glMultiTexCoord4dv = @ptrCast(proc);
    } else {
        log.err("entry point glMultiTexCoord4dv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glMultiTexCoord4f")) |proc| {
        function_pointers.glMultiTexCoord4f = @ptrCast(proc);
    } else {
        log.err("entry point glMultiTexCoord4f not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glMultiTexCoord4fv")) |proc| {
        function_pointers.glMultiTexCoord4fv = @ptrCast(proc);
    } else {
        log.err("entry point glMultiTexCoord4fv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glMultiTexCoord4i")) |proc| {
        function_pointers.glMultiTexCoord4i = @ptrCast(proc);
    } else {
        log.err("entry point glMultiTexCoord4i not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glMultiTexCoord4iv")) |proc| {
        function_pointers.glMultiTexCoord4iv = @ptrCast(proc);
    } else {
        log.err("entry point glMultiTexCoord4iv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glMultiTexCoord4s")) |proc| {
        function_pointers.glMultiTexCoord4s = @ptrCast(proc);
    } else {
        log.err("entry point glMultiTexCoord4s not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glMultiTexCoord4sv")) |proc| {
        function_pointers.glMultiTexCoord4sv = @ptrCast(proc);
    } else {
        log.err("entry point glMultiTexCoord4sv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glLoadTransposeMatrixf")) |proc| {
        function_pointers.glLoadTransposeMatrixf = @ptrCast(proc);
    } else {
        log.err("entry point glLoadTransposeMatrixf not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glLoadTransposeMatrixd")) |proc| {
        function_pointers.glLoadTransposeMatrixd = @ptrCast(proc);
    } else {
        log.err("entry point glLoadTransposeMatrixd not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glMultTransposeMatrixf")) |proc| {
        function_pointers.glMultTransposeMatrixf = @ptrCast(proc);
    } else {
        log.err("entry point glMultTransposeMatrixf not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glMultTransposeMatrixd")) |proc| {
        function_pointers.glMultTransposeMatrixd = @ptrCast(proc);
    } else {
        log.err("entry point glMultTransposeMatrixd not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glBlendFuncSeparate")) |proc| {
        function_pointers.glBlendFuncSeparate = @ptrCast(proc);
    } else {
        log.err("entry point glBlendFuncSeparate not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glMultiDrawArrays")) |proc| {
        function_pointers.glMultiDrawArrays = @ptrCast(proc);
    } else {
        log.err("entry point glMultiDrawArrays not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glMultiDrawElements")) |proc| {
        function_pointers.glMultiDrawElements = @ptrCast(proc);
    } else {
        log.err("entry point glMultiDrawElements not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glPointParameterf")) |proc| {
        function_pointers.glPointParameterf = @ptrCast(proc);
    } else {
        log.err("entry point glPointParameterf not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glPointParameterfv")) |proc| {
        function_pointers.glPointParameterfv = @ptrCast(proc);
    } else {
        log.err("entry point glPointParameterfv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glPointParameteri")) |proc| {
        function_pointers.glPointParameteri = @ptrCast(proc);
    } else {
        log.err("entry point glPointParameteri not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glPointParameteriv")) |proc| {
        function_pointers.glPointParameteriv = @ptrCast(proc);
    } else {
        log.err("entry point glPointParameteriv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glFogCoordf")) |proc| {
        function_pointers.glFogCoordf = @ptrCast(proc);
    } else {
        log.err("entry point glFogCoordf not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glFogCoordfv")) |proc| {
        function_pointers.glFogCoordfv = @ptrCast(proc);
    } else {
        log.err("entry point glFogCoordfv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glFogCoordd")) |proc| {
        function_pointers.glFogCoordd = @ptrCast(proc);
    } else {
        log.err("entry point glFogCoordd not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glFogCoorddv")) |proc| {
        function_pointers.glFogCoorddv = @ptrCast(proc);
    } else {
        log.err("entry point glFogCoorddv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glFogCoordPointer")) |proc| {
        function_pointers.glFogCoordPointer = @ptrCast(proc);
    } else {
        log.err("entry point glFogCoordPointer not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glSecondaryColor3b")) |proc| {
        function_pointers.glSecondaryColor3b = @ptrCast(proc);
    } else {
        log.err("entry point glSecondaryColor3b not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glSecondaryColor3bv")) |proc| {
        function_pointers.glSecondaryColor3bv = @ptrCast(proc);
    } else {
        log.err("entry point glSecondaryColor3bv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glSecondaryColor3d")) |proc| {
        function_pointers.glSecondaryColor3d = @ptrCast(proc);
    } else {
        log.err("entry point glSecondaryColor3d not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glSecondaryColor3dv")) |proc| {
        function_pointers.glSecondaryColor3dv = @ptrCast(proc);
    } else {
        log.err("entry point glSecondaryColor3dv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glSecondaryColor3f")) |proc| {
        function_pointers.glSecondaryColor3f = @ptrCast(proc);
    } else {
        log.err("entry point glSecondaryColor3f not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glSecondaryColor3fv")) |proc| {
        function_pointers.glSecondaryColor3fv = @ptrCast(proc);
    } else {
        log.err("entry point glSecondaryColor3fv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glSecondaryColor3i")) |proc| {
        function_pointers.glSecondaryColor3i = @ptrCast(proc);
    } else {
        log.err("entry point glSecondaryColor3i not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glSecondaryColor3iv")) |proc| {
        function_pointers.glSecondaryColor3iv = @ptrCast(proc);
    } else {
        log.err("entry point glSecondaryColor3iv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glSecondaryColor3s")) |proc| {
        function_pointers.glSecondaryColor3s = @ptrCast(proc);
    } else {
        log.err("entry point glSecondaryColor3s not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glSecondaryColor3sv")) |proc| {
        function_pointers.glSecondaryColor3sv = @ptrCast(proc);
    } else {
        log.err("entry point glSecondaryColor3sv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glSecondaryColor3ub")) |proc| {
        function_pointers.glSecondaryColor3ub = @ptrCast(proc);
    } else {
        log.err("entry point glSecondaryColor3ub not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glSecondaryColor3ubv")) |proc| {
        function_pointers.glSecondaryColor3ubv = @ptrCast(proc);
    } else {
        log.err("entry point glSecondaryColor3ubv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glSecondaryColor3ui")) |proc| {
        function_pointers.glSecondaryColor3ui = @ptrCast(proc);
    } else {
        log.err("entry point glSecondaryColor3ui not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glSecondaryColor3uiv")) |proc| {
        function_pointers.glSecondaryColor3uiv = @ptrCast(proc);
    } else {
        log.err("entry point glSecondaryColor3uiv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glSecondaryColor3us")) |proc| {
        function_pointers.glSecondaryColor3us = @ptrCast(proc);
    } else {
        log.err("entry point glSecondaryColor3us not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glSecondaryColor3usv")) |proc| {
        function_pointers.glSecondaryColor3usv = @ptrCast(proc);
    } else {
        log.err("entry point glSecondaryColor3usv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glSecondaryColorPointer")) |proc| {
        function_pointers.glSecondaryColorPointer = @ptrCast(proc);
    } else {
        log.err("entry point glSecondaryColorPointer not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glWindowPos2d")) |proc| {
        function_pointers.glWindowPos2d = @ptrCast(proc);
    } else {
        log.err("entry point glWindowPos2d not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glWindowPos2dv")) |proc| {
        function_pointers.glWindowPos2dv = @ptrCast(proc);
    } else {
        log.err("entry point glWindowPos2dv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glWindowPos2f")) |proc| {
        function_pointers.glWindowPos2f = @ptrCast(proc);
    } else {
        log.err("entry point glWindowPos2f not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glWindowPos2fv")) |proc| {
        function_pointers.glWindowPos2fv = @ptrCast(proc);
    } else {
        log.err("entry point glWindowPos2fv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glWindowPos2i")) |proc| {
        function_pointers.glWindowPos2i = @ptrCast(proc);
    } else {
        log.err("entry point glWindowPos2i not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glWindowPos2iv")) |proc| {
        function_pointers.glWindowPos2iv = @ptrCast(proc);
    } else {
        log.err("entry point glWindowPos2iv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glWindowPos2s")) |proc| {
        function_pointers.glWindowPos2s = @ptrCast(proc);
    } else {
        log.err("entry point glWindowPos2s not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glWindowPos2sv")) |proc| {
        function_pointers.glWindowPos2sv = @ptrCast(proc);
    } else {
        log.err("entry point glWindowPos2sv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glWindowPos3d")) |proc| {
        function_pointers.glWindowPos3d = @ptrCast(proc);
    } else {
        log.err("entry point glWindowPos3d not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glWindowPos3dv")) |proc| {
        function_pointers.glWindowPos3dv = @ptrCast(proc);
    } else {
        log.err("entry point glWindowPos3dv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glWindowPos3f")) |proc| {
        function_pointers.glWindowPos3f = @ptrCast(proc);
    } else {
        log.err("entry point glWindowPos3f not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glWindowPos3fv")) |proc| {
        function_pointers.glWindowPos3fv = @ptrCast(proc);
    } else {
        log.err("entry point glWindowPos3fv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glWindowPos3i")) |proc| {
        function_pointers.glWindowPos3i = @ptrCast(proc);
    } else {
        log.err("entry point glWindowPos3i not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glWindowPos3iv")) |proc| {
        function_pointers.glWindowPos3iv = @ptrCast(proc);
    } else {
        log.err("entry point glWindowPos3iv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glWindowPos3s")) |proc| {
        function_pointers.glWindowPos3s = @ptrCast(proc);
    } else {
        log.err("entry point glWindowPos3s not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glWindowPos3sv")) |proc| {
        function_pointers.glWindowPos3sv = @ptrCast(proc);
    } else {
        log.err("entry point glWindowPos3sv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glBlendColor")) |proc| {
        function_pointers.glBlendColor = @ptrCast(proc);
    } else {
        log.err("entry point glBlendColor not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glBlendEquation")) |proc| {
        function_pointers.glBlendEquation = @ptrCast(proc);
    } else {
        log.err("entry point glBlendEquation not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGenQueries")) |proc| {
        function_pointers.glGenQueries = @ptrCast(proc);
    } else {
        log.err("entry point glGenQueries not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glDeleteQueries")) |proc| {
        function_pointers.glDeleteQueries = @ptrCast(proc);
    } else {
        log.err("entry point glDeleteQueries not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glIsQuery")) |proc| {
        function_pointers.glIsQuery = @ptrCast(proc);
    } else {
        log.err("entry point glIsQuery not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glBeginQuery")) |proc| {
        function_pointers.glBeginQuery = @ptrCast(proc);
    } else {
        log.err("entry point glBeginQuery not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glEndQuery")) |proc| {
        function_pointers.glEndQuery = @ptrCast(proc);
    } else {
        log.err("entry point glEndQuery not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGetQueryiv")) |proc| {
        function_pointers.glGetQueryiv = @ptrCast(proc);
    } else {
        log.err("entry point glGetQueryiv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGetQueryObjectiv")) |proc| {
        function_pointers.glGetQueryObjectiv = @ptrCast(proc);
    } else {
        log.err("entry point glGetQueryObjectiv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGetQueryObjectuiv")) |proc| {
        function_pointers.glGetQueryObjectuiv = @ptrCast(proc);
    } else {
        log.err("entry point glGetQueryObjectuiv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glBindBuffer")) |proc| {
        function_pointers.glBindBuffer = @ptrCast(proc);
    } else {
        log.err("entry point glBindBuffer not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glDeleteBuffers")) |proc| {
        function_pointers.glDeleteBuffers = @ptrCast(proc);
    } else {
        log.err("entry point glDeleteBuffers not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGenBuffers")) |proc| {
        function_pointers.glGenBuffers = @ptrCast(proc);
    } else {
        log.err("entry point glGenBuffers not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glIsBuffer")) |proc| {
        function_pointers.glIsBuffer = @ptrCast(proc);
    } else {
        log.err("entry point glIsBuffer not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glBufferData")) |proc| {
        function_pointers.glBufferData = @ptrCast(proc);
    } else {
        log.err("entry point glBufferData not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glBufferSubData")) |proc| {
        function_pointers.glBufferSubData = @ptrCast(proc);
    } else {
        log.err("entry point glBufferSubData not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGetBufferSubData")) |proc| {
        function_pointers.glGetBufferSubData = @ptrCast(proc);
    } else {
        log.err("entry point glGetBufferSubData not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glMapBuffer")) |proc| {
        function_pointers.glMapBuffer = @ptrCast(proc);
    } else {
        log.err("entry point glMapBuffer not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glUnmapBuffer")) |proc| {
        function_pointers.glUnmapBuffer = @ptrCast(proc);
    } else {
        log.err("entry point glUnmapBuffer not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGetBufferParameteriv")) |proc| {
        function_pointers.glGetBufferParameteriv = @ptrCast(proc);
    } else {
        log.err("entry point glGetBufferParameteriv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGetBufferPointerv")) |proc| {
        function_pointers.glGetBufferPointerv = @ptrCast(proc);
    } else {
        log.err("entry point glGetBufferPointerv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glBlendEquationSeparate")) |proc| {
        function_pointers.glBlendEquationSeparate = @ptrCast(proc);
    } else {
        log.err("entry point glBlendEquationSeparate not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glDrawBuffers")) |proc| {
        function_pointers.glDrawBuffers = @ptrCast(proc);
    } else {
        log.err("entry point glDrawBuffers not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glStencilOpSeparate")) |proc| {
        function_pointers.glStencilOpSeparate = @ptrCast(proc);
    } else {
        log.err("entry point glStencilOpSeparate not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glStencilFuncSeparate")) |proc| {
        function_pointers.glStencilFuncSeparate = @ptrCast(proc);
    } else {
        log.err("entry point glStencilFuncSeparate not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glStencilMaskSeparate")) |proc| {
        function_pointers.glStencilMaskSeparate = @ptrCast(proc);
    } else {
        log.err("entry point glStencilMaskSeparate not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glAttachShader")) |proc| {
        function_pointers.glAttachShader = @ptrCast(proc);
    } else {
        log.err("entry point glAttachShader not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glBindAttribLocation")) |proc| {
        function_pointers.glBindAttribLocation = @ptrCast(proc);
    } else {
        log.err("entry point glBindAttribLocation not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glCompileShader")) |proc| {
        function_pointers.glCompileShader = @ptrCast(proc);
    } else {
        log.err("entry point glCompileShader not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glCreateProgram")) |proc| {
        function_pointers.glCreateProgram = @ptrCast(proc);
    } else {
        log.err("entry point glCreateProgram not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glCreateShader")) |proc| {
        function_pointers.glCreateShader = @ptrCast(proc);
    } else {
        log.err("entry point glCreateShader not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glDeleteProgram")) |proc| {
        function_pointers.glDeleteProgram = @ptrCast(proc);
    } else {
        log.err("entry point glDeleteProgram not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glDeleteShader")) |proc| {
        function_pointers.glDeleteShader = @ptrCast(proc);
    } else {
        log.err("entry point glDeleteShader not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glDetachShader")) |proc| {
        function_pointers.glDetachShader = @ptrCast(proc);
    } else {
        log.err("entry point glDetachShader not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glDisableVertexAttribArray")) |proc| {
        function_pointers.glDisableVertexAttribArray = @ptrCast(proc);
    } else {
        log.err("entry point glDisableVertexAttribArray not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glEnableVertexAttribArray")) |proc| {
        function_pointers.glEnableVertexAttribArray = @ptrCast(proc);
    } else {
        log.err("entry point glEnableVertexAttribArray not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGetActiveAttrib")) |proc| {
        function_pointers.glGetActiveAttrib = @ptrCast(proc);
    } else {
        log.err("entry point glGetActiveAttrib not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGetActiveUniform")) |proc| {
        function_pointers.glGetActiveUniform = @ptrCast(proc);
    } else {
        log.err("entry point glGetActiveUniform not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGetAttachedShaders")) |proc| {
        function_pointers.glGetAttachedShaders = @ptrCast(proc);
    } else {
        log.err("entry point glGetAttachedShaders not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGetAttribLocation")) |proc| {
        function_pointers.glGetAttribLocation = @ptrCast(proc);
    } else {
        log.err("entry point glGetAttribLocation not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGetProgramiv")) |proc| {
        function_pointers.glGetProgramiv = @ptrCast(proc);
    } else {
        log.err("entry point glGetProgramiv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGetProgramInfoLog")) |proc| {
        function_pointers.glGetProgramInfoLog = @ptrCast(proc);
    } else {
        log.err("entry point glGetProgramInfoLog not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGetShaderiv")) |proc| {
        function_pointers.glGetShaderiv = @ptrCast(proc);
    } else {
        log.err("entry point glGetShaderiv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGetShaderInfoLog")) |proc| {
        function_pointers.glGetShaderInfoLog = @ptrCast(proc);
    } else {
        log.err("entry point glGetShaderInfoLog not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGetShaderSource")) |proc| {
        function_pointers.glGetShaderSource = @ptrCast(proc);
    } else {
        log.err("entry point glGetShaderSource not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGetUniformLocation")) |proc| {
        function_pointers.glGetUniformLocation = @ptrCast(proc);
    } else {
        log.err("entry point glGetUniformLocation not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGetUniformfv")) |proc| {
        function_pointers.glGetUniformfv = @ptrCast(proc);
    } else {
        log.err("entry point glGetUniformfv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGetUniformiv")) |proc| {
        function_pointers.glGetUniformiv = @ptrCast(proc);
    } else {
        log.err("entry point glGetUniformiv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGetVertexAttribdv")) |proc| {
        function_pointers.glGetVertexAttribdv = @ptrCast(proc);
    } else {
        log.err("entry point glGetVertexAttribdv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGetVertexAttribfv")) |proc| {
        function_pointers.glGetVertexAttribfv = @ptrCast(proc);
    } else {
        log.err("entry point glGetVertexAttribfv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGetVertexAttribiv")) |proc| {
        function_pointers.glGetVertexAttribiv = @ptrCast(proc);
    } else {
        log.err("entry point glGetVertexAttribiv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glGetVertexAttribPointerv")) |proc| {
        function_pointers.glGetVertexAttribPointerv = @ptrCast(proc);
    } else {
        log.err("entry point glGetVertexAttribPointerv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glIsProgram")) |proc| {
        function_pointers.glIsProgram = @ptrCast(proc);
    } else {
        log.err("entry point glIsProgram not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glIsShader")) |proc| {
        function_pointers.glIsShader = @ptrCast(proc);
    } else {
        log.err("entry point glIsShader not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glLinkProgram")) |proc| {
        function_pointers.glLinkProgram = @ptrCast(proc);
    } else {
        log.err("entry point glLinkProgram not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glShaderSource")) |proc| {
        function_pointers.glShaderSource = @ptrCast(proc);
    } else {
        log.err("entry point glShaderSource not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glUseProgram")) |proc| {
        function_pointers.glUseProgram = @ptrCast(proc);
    } else {
        log.err("entry point glUseProgram not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glUniform1f")) |proc| {
        function_pointers.glUniform1f = @ptrCast(proc);
    } else {
        log.err("entry point glUniform1f not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glUniform2f")) |proc| {
        function_pointers.glUniform2f = @ptrCast(proc);
    } else {
        log.err("entry point glUniform2f not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glUniform3f")) |proc| {
        function_pointers.glUniform3f = @ptrCast(proc);
    } else {
        log.err("entry point glUniform3f not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glUniform4f")) |proc| {
        function_pointers.glUniform4f = @ptrCast(proc);
    } else {
        log.err("entry point glUniform4f not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glUniform1i")) |proc| {
        function_pointers.glUniform1i = @ptrCast(proc);
    } else {
        log.err("entry point glUniform1i not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glUniform2i")) |proc| {
        function_pointers.glUniform2i = @ptrCast(proc);
    } else {
        log.err("entry point glUniform2i not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glUniform3i")) |proc| {
        function_pointers.glUniform3i = @ptrCast(proc);
    } else {
        log.err("entry point glUniform3i not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glUniform4i")) |proc| {
        function_pointers.glUniform4i = @ptrCast(proc);
    } else {
        log.err("entry point glUniform4i not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glUniform1fv")) |proc| {
        function_pointers.glUniform1fv = @ptrCast(proc);
    } else {
        log.err("entry point glUniform1fv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glUniform2fv")) |proc| {
        function_pointers.glUniform2fv = @ptrCast(proc);
    } else {
        log.err("entry point glUniform2fv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glUniform3fv")) |proc| {
        function_pointers.glUniform3fv = @ptrCast(proc);
    } else {
        log.err("entry point glUniform3fv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glUniform4fv")) |proc| {
        function_pointers.glUniform4fv = @ptrCast(proc);
    } else {
        log.err("entry point glUniform4fv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glUniform1iv")) |proc| {
        function_pointers.glUniform1iv = @ptrCast(proc);
    } else {
        log.err("entry point glUniform1iv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glUniform2iv")) |proc| {
        function_pointers.glUniform2iv = @ptrCast(proc);
    } else {
        log.err("entry point glUniform2iv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glUniform3iv")) |proc| {
        function_pointers.glUniform3iv = @ptrCast(proc);
    } else {
        log.err("entry point glUniform3iv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glUniform4iv")) |proc| {
        function_pointers.glUniform4iv = @ptrCast(proc);
    } else {
        log.err("entry point glUniform4iv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glUniformMatrix2fv")) |proc| {
        function_pointers.glUniformMatrix2fv = @ptrCast(proc);
    } else {
        log.err("entry point glUniformMatrix2fv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glUniformMatrix3fv")) |proc| {
        function_pointers.glUniformMatrix3fv = @ptrCast(proc);
    } else {
        log.err("entry point glUniformMatrix3fv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glUniformMatrix4fv")) |proc| {
        function_pointers.glUniformMatrix4fv = @ptrCast(proc);
    } else {
        log.err("entry point glUniformMatrix4fv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glValidateProgram")) |proc| {
        function_pointers.glValidateProgram = @ptrCast(proc);
    } else {
        log.err("entry point glValidateProgram not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertexAttrib1d")) |proc| {
        function_pointers.glVertexAttrib1d = @ptrCast(proc);
    } else {
        log.err("entry point glVertexAttrib1d not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertexAttrib1dv")) |proc| {
        function_pointers.glVertexAttrib1dv = @ptrCast(proc);
    } else {
        log.err("entry point glVertexAttrib1dv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertexAttrib1f")) |proc| {
        function_pointers.glVertexAttrib1f = @ptrCast(proc);
    } else {
        log.err("entry point glVertexAttrib1f not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertexAttrib1fv")) |proc| {
        function_pointers.glVertexAttrib1fv = @ptrCast(proc);
    } else {
        log.err("entry point glVertexAttrib1fv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertexAttrib1s")) |proc| {
        function_pointers.glVertexAttrib1s = @ptrCast(proc);
    } else {
        log.err("entry point glVertexAttrib1s not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertexAttrib1sv")) |proc| {
        function_pointers.glVertexAttrib1sv = @ptrCast(proc);
    } else {
        log.err("entry point glVertexAttrib1sv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertexAttrib2d")) |proc| {
        function_pointers.glVertexAttrib2d = @ptrCast(proc);
    } else {
        log.err("entry point glVertexAttrib2d not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertexAttrib2dv")) |proc| {
        function_pointers.glVertexAttrib2dv = @ptrCast(proc);
    } else {
        log.err("entry point glVertexAttrib2dv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertexAttrib2f")) |proc| {
        function_pointers.glVertexAttrib2f = @ptrCast(proc);
    } else {
        log.err("entry point glVertexAttrib2f not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertexAttrib2fv")) |proc| {
        function_pointers.glVertexAttrib2fv = @ptrCast(proc);
    } else {
        log.err("entry point glVertexAttrib2fv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertexAttrib2s")) |proc| {
        function_pointers.glVertexAttrib2s = @ptrCast(proc);
    } else {
        log.err("entry point glVertexAttrib2s not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertexAttrib2sv")) |proc| {
        function_pointers.glVertexAttrib2sv = @ptrCast(proc);
    } else {
        log.err("entry point glVertexAttrib2sv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertexAttrib3d")) |proc| {
        function_pointers.glVertexAttrib3d = @ptrCast(proc);
    } else {
        log.err("entry point glVertexAttrib3d not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertexAttrib3dv")) |proc| {
        function_pointers.glVertexAttrib3dv = @ptrCast(proc);
    } else {
        log.err("entry point glVertexAttrib3dv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertexAttrib3f")) |proc| {
        function_pointers.glVertexAttrib3f = @ptrCast(proc);
    } else {
        log.err("entry point glVertexAttrib3f not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertexAttrib3fv")) |proc| {
        function_pointers.glVertexAttrib3fv = @ptrCast(proc);
    } else {
        log.err("entry point glVertexAttrib3fv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertexAttrib3s")) |proc| {
        function_pointers.glVertexAttrib3s = @ptrCast(proc);
    } else {
        log.err("entry point glVertexAttrib3s not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertexAttrib3sv")) |proc| {
        function_pointers.glVertexAttrib3sv = @ptrCast(proc);
    } else {
        log.err("entry point glVertexAttrib3sv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertexAttrib4Nbv")) |proc| {
        function_pointers.glVertexAttrib4Nbv = @ptrCast(proc);
    } else {
        log.err("entry point glVertexAttrib4Nbv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertexAttrib4Niv")) |proc| {
        function_pointers.glVertexAttrib4Niv = @ptrCast(proc);
    } else {
        log.err("entry point glVertexAttrib4Niv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertexAttrib4Nsv")) |proc| {
        function_pointers.glVertexAttrib4Nsv = @ptrCast(proc);
    } else {
        log.err("entry point glVertexAttrib4Nsv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertexAttrib4Nub")) |proc| {
        function_pointers.glVertexAttrib4Nub = @ptrCast(proc);
    } else {
        log.err("entry point glVertexAttrib4Nub not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertexAttrib4Nubv")) |proc| {
        function_pointers.glVertexAttrib4Nubv = @ptrCast(proc);
    } else {
        log.err("entry point glVertexAttrib4Nubv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertexAttrib4Nuiv")) |proc| {
        function_pointers.glVertexAttrib4Nuiv = @ptrCast(proc);
    } else {
        log.err("entry point glVertexAttrib4Nuiv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertexAttrib4Nusv")) |proc| {
        function_pointers.glVertexAttrib4Nusv = @ptrCast(proc);
    } else {
        log.err("entry point glVertexAttrib4Nusv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertexAttrib4bv")) |proc| {
        function_pointers.glVertexAttrib4bv = @ptrCast(proc);
    } else {
        log.err("entry point glVertexAttrib4bv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertexAttrib4d")) |proc| {
        function_pointers.glVertexAttrib4d = @ptrCast(proc);
    } else {
        log.err("entry point glVertexAttrib4d not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertexAttrib4dv")) |proc| {
        function_pointers.glVertexAttrib4dv = @ptrCast(proc);
    } else {
        log.err("entry point glVertexAttrib4dv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertexAttrib4f")) |proc| {
        function_pointers.glVertexAttrib4f = @ptrCast(proc);
    } else {
        log.err("entry point glVertexAttrib4f not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertexAttrib4fv")) |proc| {
        function_pointers.glVertexAttrib4fv = @ptrCast(proc);
    } else {
        log.err("entry point glVertexAttrib4fv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertexAttrib4iv")) |proc| {
        function_pointers.glVertexAttrib4iv = @ptrCast(proc);
    } else {
        log.err("entry point glVertexAttrib4iv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertexAttrib4s")) |proc| {
        function_pointers.glVertexAttrib4s = @ptrCast(proc);
    } else {
        log.err("entry point glVertexAttrib4s not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertexAttrib4sv")) |proc| {
        function_pointers.glVertexAttrib4sv = @ptrCast(proc);
    } else {
        log.err("entry point glVertexAttrib4sv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertexAttrib4ubv")) |proc| {
        function_pointers.glVertexAttrib4ubv = @ptrCast(proc);
    } else {
        log.err("entry point glVertexAttrib4ubv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertexAttrib4uiv")) |proc| {
        function_pointers.glVertexAttrib4uiv = @ptrCast(proc);
    } else {
        log.err("entry point glVertexAttrib4uiv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertexAttrib4usv")) |proc| {
        function_pointers.glVertexAttrib4usv = @ptrCast(proc);
    } else {
        log.err("entry point glVertexAttrib4usv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glVertexAttribPointer")) |proc| {
        function_pointers.glVertexAttribPointer = @ptrCast(proc);
    } else {
        log.err("entry point glVertexAttribPointer not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glUniformMatrix2x3fv")) |proc| {
        function_pointers.glUniformMatrix2x3fv = @ptrCast(proc);
    } else {
        log.err("entry point glUniformMatrix2x3fv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glUniformMatrix3x2fv")) |proc| {
        function_pointers.glUniformMatrix3x2fv = @ptrCast(proc);
    } else {
        log.err("entry point glUniformMatrix3x2fv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glUniformMatrix2x4fv")) |proc| {
        function_pointers.glUniformMatrix2x4fv = @ptrCast(proc);
    } else {
        log.err("entry point glUniformMatrix2x4fv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glUniformMatrix4x2fv")) |proc| {
        function_pointers.glUniformMatrix4x2fv = @ptrCast(proc);
    } else {
        log.err("entry point glUniformMatrix4x2fv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glUniformMatrix3x4fv")) |proc| {
        function_pointers.glUniformMatrix3x4fv = @ptrCast(proc);
    } else {
        log.err("entry point glUniformMatrix3x4fv not found!", .{});
        success = false;
    }
    if (get_proc_address(load_ctx, "glUniformMatrix4x3fv")) |proc| {
        function_pointers.glUniformMatrix4x3fv = @ptrCast(proc);
    } else {
        log.err("entry point glUniformMatrix4x3fv not found!", .{});
        success = false;
    }
    if (!success)
        return error.EntryPointNotFound;
}

const function_signatures = struct {
    const glCullFace = fn (_mode: GLenum) callconv(.C) void;
    const glFrontFace = fn (_mode: GLenum) callconv(.C) void;
    const glHint = fn (_target: GLenum, _mode: GLenum) callconv(.C) void;
    const glLineWidth = fn (_width: GLfloat) callconv(.C) void;
    const glPointSize = fn (_size: GLfloat) callconv(.C) void;
    const glPolygonMode = fn (_face: GLenum, _mode: GLenum) callconv(.C) void;
    const glScissor = fn (_x: GLint, _y: GLint, _width: GLsizei, _height: GLsizei) callconv(.C) void;
    const glTexParameterf = fn (_target: GLenum, _pname: GLenum, _param: GLfloat) callconv(.C) void;
    const glTexParameterfv = fn (_target: GLenum, _pname: GLenum, _params: [*c]const GLfloat) callconv(.C) void;
    const glTexParameteri = fn (_target: GLenum, _pname: GLenum, _param: GLint) callconv(.C) void;
    const glTexParameteriv = fn (_target: GLenum, _pname: GLenum, _params: [*c]const GLint) callconv(.C) void;
    const glTexImage1D = fn (_target: GLenum, _level: GLint, _internalformat: GLint, _width: GLsizei, _border: GLint, _format: GLenum, _type: GLenum, _pixels: ?*const anyopaque) callconv(.C) void;
    const glTexImage2D = fn (_target: GLenum, _level: GLint, _internalformat: GLint, _width: GLsizei, _height: GLsizei, _border: GLint, _format: GLenum, _type: GLenum, _pixels: ?*const anyopaque) callconv(.C) void;
    const glDrawBuffer = fn (_buf: GLenum) callconv(.C) void;
    const glClear = fn (_mask: GLbitfield) callconv(.C) void;
    const glClearColor = fn (_red: GLfloat, _green: GLfloat, _blue: GLfloat, _alpha: GLfloat) callconv(.C) void;
    const glClearStencil = fn (_s: GLint) callconv(.C) void;
    const glClearDepth = fn (_depth: GLdouble) callconv(.C) void;
    const glStencilMask = fn (_mask: GLuint) callconv(.C) void;
    const glColorMask = fn (_red: GLboolean, _green: GLboolean, _blue: GLboolean, _alpha: GLboolean) callconv(.C) void;
    const glDepthMask = fn (_flag: GLboolean) callconv(.C) void;
    const glDisable = fn (_cap: GLenum) callconv(.C) void;
    const glEnable = fn (_cap: GLenum) callconv(.C) void;
    const glFinish = fn () callconv(.C) void;
    const glFlush = fn () callconv(.C) void;
    const glBlendFunc = fn (_sfactor: GLenum, _dfactor: GLenum) callconv(.C) void;
    const glLogicOp = fn (_opcode: GLenum) callconv(.C) void;
    const glStencilFunc = fn (_func: GLenum, _ref: GLint, _mask: GLuint) callconv(.C) void;
    const glStencilOp = fn (_fail: GLenum, _zfail: GLenum, _zpass: GLenum) callconv(.C) void;
    const glDepthFunc = fn (_func: GLenum) callconv(.C) void;
    const glPixelStoref = fn (_pname: GLenum, _param: GLfloat) callconv(.C) void;
    const glPixelStorei = fn (_pname: GLenum, _param: GLint) callconv(.C) void;
    const glReadBuffer = fn (_src: GLenum) callconv(.C) void;
    const glReadPixels = fn (_x: GLint, _y: GLint, _width: GLsizei, _height: GLsizei, _format: GLenum, _type: GLenum, _pixels: ?*anyopaque) callconv(.C) void;
    const glGetBooleanv = fn (_pname: GLenum, _data: [*c]GLboolean) callconv(.C) void;
    const glGetDoublev = fn (_pname: GLenum, _data: [*c]GLdouble) callconv(.C) void;
    const glGetError = fn () callconv(.C) GLenum;
    const glGetFloatv = fn (_pname: GLenum, _data: [*c]GLfloat) callconv(.C) void;
    const glGetIntegerv = fn (_pname: GLenum, _data: [*c]GLint) callconv(.C) void;
    const glGetString = fn (_name: GLenum) callconv(.C) ?[*:0]const GLubyte;
    const glGetTexImage = fn (_target: GLenum, _level: GLint, _format: GLenum, _type: GLenum, _pixels: ?*anyopaque) callconv(.C) void;
    const glGetTexParameterfv = fn (_target: GLenum, _pname: GLenum, _params: [*c]GLfloat) callconv(.C) void;
    const glGetTexParameteriv = fn (_target: GLenum, _pname: GLenum, _params: [*c]GLint) callconv(.C) void;
    const glGetTexLevelParameterfv = fn (_target: GLenum, _level: GLint, _pname: GLenum, _params: [*c]GLfloat) callconv(.C) void;
    const glGetTexLevelParameteriv = fn (_target: GLenum, _level: GLint, _pname: GLenum, _params: [*c]GLint) callconv(.C) void;
    const glIsEnabled = fn (_cap: GLenum) callconv(.C) GLboolean;
    const glDepthRange = fn (_n: GLdouble, _f: GLdouble) callconv(.C) void;
    const glViewport = fn (_x: GLint, _y: GLint, _width: GLsizei, _height: GLsizei) callconv(.C) void;
    const glNewList = fn (_list: GLuint, _mode: GLenum) callconv(.C) void;
    const glEndList = fn () callconv(.C) void;
    const glCallList = fn (_list: GLuint) callconv(.C) void;
    const glCallLists = fn (_n: GLsizei, _type: GLenum, _lists: ?*const anyopaque) callconv(.C) void;
    const glDeleteLists = fn (_list: GLuint, _range: GLsizei) callconv(.C) void;
    const glGenLists = fn (_range: GLsizei) callconv(.C) GLuint;
    const glListBase = fn (_base: GLuint) callconv(.C) void;
    const glBegin = fn (_mode: GLenum) callconv(.C) void;
    const glBitmap = fn (_width: GLsizei, _height: GLsizei, _xorig: GLfloat, _yorig: GLfloat, _xmove: GLfloat, _ymove: GLfloat, _bitmap: ?[*:0]const GLubyte) callconv(.C) void;
    const glColor3b = fn (_red: GLbyte, _green: GLbyte, _blue: GLbyte) callconv(.C) void;
    const glColor3bv = fn (_v: [*c]const GLbyte) callconv(.C) void;
    const glColor3d = fn (_red: GLdouble, _green: GLdouble, _blue: GLdouble) callconv(.C) void;
    const glColor3dv = fn (_v: [*c]const GLdouble) callconv(.C) void;
    const glColor3f = fn (_red: GLfloat, _green: GLfloat, _blue: GLfloat) callconv(.C) void;
    const glColor3fv = fn (_v: [*c]const GLfloat) callconv(.C) void;
    const glColor3i = fn (_red: GLint, _green: GLint, _blue: GLint) callconv(.C) void;
    const glColor3iv = fn (_v: [*c]const GLint) callconv(.C) void;
    const glColor3s = fn (_red: GLshort, _green: GLshort, _blue: GLshort) callconv(.C) void;
    const glColor3sv = fn (_v: [*c]const GLshort) callconv(.C) void;
    const glColor3ub = fn (_red: GLubyte, _green: GLubyte, _blue: GLubyte) callconv(.C) void;
    const glColor3ubv = fn (_v: ?[*:0]const GLubyte) callconv(.C) void;
    const glColor3ui = fn (_red: GLuint, _green: GLuint, _blue: GLuint) callconv(.C) void;
    const glColor3uiv = fn (_v: [*c]const GLuint) callconv(.C) void;
    const glColor3us = fn (_red: GLushort, _green: GLushort, _blue: GLushort) callconv(.C) void;
    const glColor3usv = fn (_v: [*c]const GLushort) callconv(.C) void;
    const glColor4b = fn (_red: GLbyte, _green: GLbyte, _blue: GLbyte, _alpha: GLbyte) callconv(.C) void;
    const glColor4bv = fn (_v: [*c]const GLbyte) callconv(.C) void;
    const glColor4d = fn (_red: GLdouble, _green: GLdouble, _blue: GLdouble, _alpha: GLdouble) callconv(.C) void;
    const glColor4dv = fn (_v: [*c]const GLdouble) callconv(.C) void;
    const glColor4f = fn (_red: GLfloat, _green: GLfloat, _blue: GLfloat, _alpha: GLfloat) callconv(.C) void;
    const glColor4fv = fn (_v: [*c]const GLfloat) callconv(.C) void;
    const glColor4i = fn (_red: GLint, _green: GLint, _blue: GLint, _alpha: GLint) callconv(.C) void;
    const glColor4iv = fn (_v: [*c]const GLint) callconv(.C) void;
    const glColor4s = fn (_red: GLshort, _green: GLshort, _blue: GLshort, _alpha: GLshort) callconv(.C) void;
    const glColor4sv = fn (_v: [*c]const GLshort) callconv(.C) void;
    const glColor4ub = fn (_red: GLubyte, _green: GLubyte, _blue: GLubyte, _alpha: GLubyte) callconv(.C) void;
    const glColor4ubv = fn (_v: ?[*:0]const GLubyte) callconv(.C) void;
    const glColor4ui = fn (_red: GLuint, _green: GLuint, _blue: GLuint, _alpha: GLuint) callconv(.C) void;
    const glColor4uiv = fn (_v: [*c]const GLuint) callconv(.C) void;
    const glColor4us = fn (_red: GLushort, _green: GLushort, _blue: GLushort, _alpha: GLushort) callconv(.C) void;
    const glColor4usv = fn (_v: [*c]const GLushort) callconv(.C) void;
    const glEdgeFlag = fn (_flag: GLboolean) callconv(.C) void;
    const glEdgeFlagv = fn (_flag: [*c]const GLboolean) callconv(.C) void;
    const glEnd = fn () callconv(.C) void;
    const glIndexd = fn (_c: GLdouble) callconv(.C) void;
    const glIndexdv = fn (_c: [*c]const GLdouble) callconv(.C) void;
    const glIndexf = fn (_c: GLfloat) callconv(.C) void;
    const glIndexfv = fn (_c: [*c]const GLfloat) callconv(.C) void;
    const glIndexi = fn (_c: GLint) callconv(.C) void;
    const glIndexiv = fn (_c: [*c]const GLint) callconv(.C) void;
    const glIndexs = fn (_c: GLshort) callconv(.C) void;
    const glIndexsv = fn (_c: [*c]const GLshort) callconv(.C) void;
    const glNormal3b = fn (_nx: GLbyte, _ny: GLbyte, _nz: GLbyte) callconv(.C) void;
    const glNormal3bv = fn (_v: [*c]const GLbyte) callconv(.C) void;
    const glNormal3d = fn (_nx: GLdouble, _ny: GLdouble, _nz: GLdouble) callconv(.C) void;
    const glNormal3dv = fn (_v: [*c]const GLdouble) callconv(.C) void;
    const glNormal3f = fn (_nx: GLfloat, _ny: GLfloat, _nz: GLfloat) callconv(.C) void;
    const glNormal3fv = fn (_v: [*c]const GLfloat) callconv(.C) void;
    const glNormal3i = fn (_nx: GLint, _ny: GLint, _nz: GLint) callconv(.C) void;
    const glNormal3iv = fn (_v: [*c]const GLint) callconv(.C) void;
    const glNormal3s = fn (_nx: GLshort, _ny: GLshort, _nz: GLshort) callconv(.C) void;
    const glNormal3sv = fn (_v: [*c]const GLshort) callconv(.C) void;
    const glRasterPos2d = fn (_x: GLdouble, _y: GLdouble) callconv(.C) void;
    const glRasterPos2dv = fn (_v: [*c]const GLdouble) callconv(.C) void;
    const glRasterPos2f = fn (_x: GLfloat, _y: GLfloat) callconv(.C) void;
    const glRasterPos2fv = fn (_v: [*c]const GLfloat) callconv(.C) void;
    const glRasterPos2i = fn (_x: GLint, _y: GLint) callconv(.C) void;
    const glRasterPos2iv = fn (_v: [*c]const GLint) callconv(.C) void;
    const glRasterPos2s = fn (_x: GLshort, _y: GLshort) callconv(.C) void;
    const glRasterPos2sv = fn (_v: [*c]const GLshort) callconv(.C) void;
    const glRasterPos3d = fn (_x: GLdouble, _y: GLdouble, _z: GLdouble) callconv(.C) void;
    const glRasterPos3dv = fn (_v: [*c]const GLdouble) callconv(.C) void;
    const glRasterPos3f = fn (_x: GLfloat, _y: GLfloat, _z: GLfloat) callconv(.C) void;
    const glRasterPos3fv = fn (_v: [*c]const GLfloat) callconv(.C) void;
    const glRasterPos3i = fn (_x: GLint, _y: GLint, _z: GLint) callconv(.C) void;
    const glRasterPos3iv = fn (_v: [*c]const GLint) callconv(.C) void;
    const glRasterPos3s = fn (_x: GLshort, _y: GLshort, _z: GLshort) callconv(.C) void;
    const glRasterPos3sv = fn (_v: [*c]const GLshort) callconv(.C) void;
    const glRasterPos4d = fn (_x: GLdouble, _y: GLdouble, _z: GLdouble, _w: GLdouble) callconv(.C) void;
    const glRasterPos4dv = fn (_v: [*c]const GLdouble) callconv(.C) void;
    const glRasterPos4f = fn (_x: GLfloat, _y: GLfloat, _z: GLfloat, _w: GLfloat) callconv(.C) void;
    const glRasterPos4fv = fn (_v: [*c]const GLfloat) callconv(.C) void;
    const glRasterPos4i = fn (_x: GLint, _y: GLint, _z: GLint, _w: GLint) callconv(.C) void;
    const glRasterPos4iv = fn (_v: [*c]const GLint) callconv(.C) void;
    const glRasterPos4s = fn (_x: GLshort, _y: GLshort, _z: GLshort, _w: GLshort) callconv(.C) void;
    const glRasterPos4sv = fn (_v: [*c]const GLshort) callconv(.C) void;
    const glRectd = fn (_x1: GLdouble, _y1: GLdouble, _x2: GLdouble, _y2: GLdouble) callconv(.C) void;
    const glRectdv = fn (_v1: [*c]const GLdouble, _v2: [*c]const GLdouble) callconv(.C) void;
    const glRectf = fn (_x1: GLfloat, _y1: GLfloat, _x2: GLfloat, _y2: GLfloat) callconv(.C) void;
    const glRectfv = fn (_v1: [*c]const GLfloat, _v2: [*c]const GLfloat) callconv(.C) void;
    const glRecti = fn (_x1: GLint, _y1: GLint, _x2: GLint, _y2: GLint) callconv(.C) void;
    const glRectiv = fn (_v1: [*c]const GLint, _v2: [*c]const GLint) callconv(.C) void;
    const glRects = fn (_x1: GLshort, _y1: GLshort, _x2: GLshort, _y2: GLshort) callconv(.C) void;
    const glRectsv = fn (_v1: [*c]const GLshort, _v2: [*c]const GLshort) callconv(.C) void;
    const glTexCoord1d = fn (_s: GLdouble) callconv(.C) void;
    const glTexCoord1dv = fn (_v: [*c]const GLdouble) callconv(.C) void;
    const glTexCoord1f = fn (_s: GLfloat) callconv(.C) void;
    const glTexCoord1fv = fn (_v: [*c]const GLfloat) callconv(.C) void;
    const glTexCoord1i = fn (_s: GLint) callconv(.C) void;
    const glTexCoord1iv = fn (_v: [*c]const GLint) callconv(.C) void;
    const glTexCoord1s = fn (_s: GLshort) callconv(.C) void;
    const glTexCoord1sv = fn (_v: [*c]const GLshort) callconv(.C) void;
    const glTexCoord2d = fn (_s: GLdouble, _t: GLdouble) callconv(.C) void;
    const glTexCoord2dv = fn (_v: [*c]const GLdouble) callconv(.C) void;
    const glTexCoord2f = fn (_s: GLfloat, _t: GLfloat) callconv(.C) void;
    const glTexCoord2fv = fn (_v: [*c]const GLfloat) callconv(.C) void;
    const glTexCoord2i = fn (_s: GLint, _t: GLint) callconv(.C) void;
    const glTexCoord2iv = fn (_v: [*c]const GLint) callconv(.C) void;
    const glTexCoord2s = fn (_s: GLshort, _t: GLshort) callconv(.C) void;
    const glTexCoord2sv = fn (_v: [*c]const GLshort) callconv(.C) void;
    const glTexCoord3d = fn (_s: GLdouble, _t: GLdouble, _r: GLdouble) callconv(.C) void;
    const glTexCoord3dv = fn (_v: [*c]const GLdouble) callconv(.C) void;
    const glTexCoord3f = fn (_s: GLfloat, _t: GLfloat, _r: GLfloat) callconv(.C) void;
    const glTexCoord3fv = fn (_v: [*c]const GLfloat) callconv(.C) void;
    const glTexCoord3i = fn (_s: GLint, _t: GLint, _r: GLint) callconv(.C) void;
    const glTexCoord3iv = fn (_v: [*c]const GLint) callconv(.C) void;
    const glTexCoord3s = fn (_s: GLshort, _t: GLshort, _r: GLshort) callconv(.C) void;
    const glTexCoord3sv = fn (_v: [*c]const GLshort) callconv(.C) void;
    const glTexCoord4d = fn (_s: GLdouble, _t: GLdouble, _r: GLdouble, _q: GLdouble) callconv(.C) void;
    const glTexCoord4dv = fn (_v: [*c]const GLdouble) callconv(.C) void;
    const glTexCoord4f = fn (_s: GLfloat, _t: GLfloat, _r: GLfloat, _q: GLfloat) callconv(.C) void;
    const glTexCoord4fv = fn (_v: [*c]const GLfloat) callconv(.C) void;
    const glTexCoord4i = fn (_s: GLint, _t: GLint, _r: GLint, _q: GLint) callconv(.C) void;
    const glTexCoord4iv = fn (_v: [*c]const GLint) callconv(.C) void;
    const glTexCoord4s = fn (_s: GLshort, _t: GLshort, _r: GLshort, _q: GLshort) callconv(.C) void;
    const glTexCoord4sv = fn (_v: [*c]const GLshort) callconv(.C) void;
    const glVertex2d = fn (_x: GLdouble, _y: GLdouble) callconv(.C) void;
    const glVertex2dv = fn (_v: [*c]const GLdouble) callconv(.C) void;
    const glVertex2f = fn (_x: GLfloat, _y: GLfloat) callconv(.C) void;
    const glVertex2fv = fn (_v: [*c]const GLfloat) callconv(.C) void;
    const glVertex2i = fn (_x: GLint, _y: GLint) callconv(.C) void;
    const glVertex2iv = fn (_v: [*c]const GLint) callconv(.C) void;
    const glVertex2s = fn (_x: GLshort, _y: GLshort) callconv(.C) void;
    const glVertex2sv = fn (_v: [*c]const GLshort) callconv(.C) void;
    const glVertex3d = fn (_x: GLdouble, _y: GLdouble, _z: GLdouble) callconv(.C) void;
    const glVertex3dv = fn (_v: [*c]const GLdouble) callconv(.C) void;
    const glVertex3f = fn (_x: GLfloat, _y: GLfloat, _z: GLfloat) callconv(.C) void;
    const glVertex3fv = fn (_v: [*c]const GLfloat) callconv(.C) void;
    const glVertex3i = fn (_x: GLint, _y: GLint, _z: GLint) callconv(.C) void;
    const glVertex3iv = fn (_v: [*c]const GLint) callconv(.C) void;
    const glVertex3s = fn (_x: GLshort, _y: GLshort, _z: GLshort) callconv(.C) void;
    const glVertex3sv = fn (_v: [*c]const GLshort) callconv(.C) void;
    const glVertex4d = fn (_x: GLdouble, _y: GLdouble, _z: GLdouble, _w: GLdouble) callconv(.C) void;
    const glVertex4dv = fn (_v: [*c]const GLdouble) callconv(.C) void;
    const glVertex4f = fn (_x: GLfloat, _y: GLfloat, _z: GLfloat, _w: GLfloat) callconv(.C) void;
    const glVertex4fv = fn (_v: [*c]const GLfloat) callconv(.C) void;
    const glVertex4i = fn (_x: GLint, _y: GLint, _z: GLint, _w: GLint) callconv(.C) void;
    const glVertex4iv = fn (_v: [*c]const GLint) callconv(.C) void;
    const glVertex4s = fn (_x: GLshort, _y: GLshort, _z: GLshort, _w: GLshort) callconv(.C) void;
    const glVertex4sv = fn (_v: [*c]const GLshort) callconv(.C) void;
    const glClipPlane = fn (_plane: GLenum, _equation: [*c]const GLdouble) callconv(.C) void;
    const glColorMaterial = fn (_face: GLenum, _mode: GLenum) callconv(.C) void;
    const glFogf = fn (_pname: GLenum, _param: GLfloat) callconv(.C) void;
    const glFogfv = fn (_pname: GLenum, _params: [*c]const GLfloat) callconv(.C) void;
    const glFogi = fn (_pname: GLenum, _param: GLint) callconv(.C) void;
    const glFogiv = fn (_pname: GLenum, _params: [*c]const GLint) callconv(.C) void;
    const glLightf = fn (_light: GLenum, _pname: GLenum, _param: GLfloat) callconv(.C) void;
    const glLightfv = fn (_light: GLenum, _pname: GLenum, _params: [*c]const GLfloat) callconv(.C) void;
    const glLighti = fn (_light: GLenum, _pname: GLenum, _param: GLint) callconv(.C) void;
    const glLightiv = fn (_light: GLenum, _pname: GLenum, _params: [*c]const GLint) callconv(.C) void;
    const glLightModelf = fn (_pname: GLenum, _param: GLfloat) callconv(.C) void;
    const glLightModelfv = fn (_pname: GLenum, _params: [*c]const GLfloat) callconv(.C) void;
    const glLightModeli = fn (_pname: GLenum, _param: GLint) callconv(.C) void;
    const glLightModeliv = fn (_pname: GLenum, _params: [*c]const GLint) callconv(.C) void;
    const glLineStipple = fn (_factor: GLint, _pattern: GLushort) callconv(.C) void;
    const glMaterialf = fn (_face: GLenum, _pname: GLenum, _param: GLfloat) callconv(.C) void;
    const glMaterialfv = fn (_face: GLenum, _pname: GLenum, _params: [*c]const GLfloat) callconv(.C) void;
    const glMateriali = fn (_face: GLenum, _pname: GLenum, _param: GLint) callconv(.C) void;
    const glMaterialiv = fn (_face: GLenum, _pname: GLenum, _params: [*c]const GLint) callconv(.C) void;
    const glPolygonStipple = fn (_mask: ?[*:0]const GLubyte) callconv(.C) void;
    const glShadeModel = fn (_mode: GLenum) callconv(.C) void;
    const glTexEnvf = fn (_target: GLenum, _pname: GLenum, _param: GLfloat) callconv(.C) void;
    const glTexEnvfv = fn (_target: GLenum, _pname: GLenum, _params: [*c]const GLfloat) callconv(.C) void;
    const glTexEnvi = fn (_target: GLenum, _pname: GLenum, _param: GLint) callconv(.C) void;
    const glTexEnviv = fn (_target: GLenum, _pname: GLenum, _params: [*c]const GLint) callconv(.C) void;
    const glTexGend = fn (_coord: GLenum, _pname: GLenum, _param: GLdouble) callconv(.C) void;
    const glTexGendv = fn (_coord: GLenum, _pname: GLenum, _params: [*c]const GLdouble) callconv(.C) void;
    const glTexGenf = fn (_coord: GLenum, _pname: GLenum, _param: GLfloat) callconv(.C) void;
    const glTexGenfv = fn (_coord: GLenum, _pname: GLenum, _params: [*c]const GLfloat) callconv(.C) void;
    const glTexGeni = fn (_coord: GLenum, _pname: GLenum, _param: GLint) callconv(.C) void;
    const glTexGeniv = fn (_coord: GLenum, _pname: GLenum, _params: [*c]const GLint) callconv(.C) void;
    const glFeedbackBuffer = fn (_size: GLsizei, _type: GLenum, _buffer: [*c]GLfloat) callconv(.C) void;
    const glSelectBuffer = fn (_size: GLsizei, _buffer: [*c]GLuint) callconv(.C) void;
    const glRenderMode = fn (_mode: GLenum) callconv(.C) GLint;
    const glInitNames = fn () callconv(.C) void;
    const glLoadName = fn (_name: GLuint) callconv(.C) void;
    const glPassThrough = fn (_token: GLfloat) callconv(.C) void;
    const glPopName = fn () callconv(.C) void;
    const glPushName = fn (_name: GLuint) callconv(.C) void;
    const glClearAccum = fn (_red: GLfloat, _green: GLfloat, _blue: GLfloat, _alpha: GLfloat) callconv(.C) void;
    const glClearIndex = fn (_c: GLfloat) callconv(.C) void;
    const glIndexMask = fn (_mask: GLuint) callconv(.C) void;
    const glAccum = fn (_op: GLenum, _value: GLfloat) callconv(.C) void;
    const glPopAttrib = fn () callconv(.C) void;
    const glPushAttrib = fn (_mask: GLbitfield) callconv(.C) void;
    const glMap1d = fn (_target: GLenum, _u1: GLdouble, _u2: GLdouble, _stride: GLint, _order: GLint, _points: [*c]const GLdouble) callconv(.C) void;
    const glMap1f = fn (_target: GLenum, _u1: GLfloat, _u2: GLfloat, _stride: GLint, _order: GLint, _points: [*c]const GLfloat) callconv(.C) void;
    const glMap2d = fn (_target: GLenum, _u1: GLdouble, _u2: GLdouble, _ustride: GLint, _uorder: GLint, _v1: GLdouble, _v2: GLdouble, _vstride: GLint, _vorder: GLint, _points: [*c]const GLdouble) callconv(.C) void;
    const glMap2f = fn (_target: GLenum, _u1: GLfloat, _u2: GLfloat, _ustride: GLint, _uorder: GLint, _v1: GLfloat, _v2: GLfloat, _vstride: GLint, _vorder: GLint, _points: [*c]const GLfloat) callconv(.C) void;
    const glMapGrid1d = fn (_un: GLint, _u1: GLdouble, _u2: GLdouble) callconv(.C) void;
    const glMapGrid1f = fn (_un: GLint, _u1: GLfloat, _u2: GLfloat) callconv(.C) void;
    const glMapGrid2d = fn (_un: GLint, _u1: GLdouble, _u2: GLdouble, _vn: GLint, _v1: GLdouble, _v2: GLdouble) callconv(.C) void;
    const glMapGrid2f = fn (_un: GLint, _u1: GLfloat, _u2: GLfloat, _vn: GLint, _v1: GLfloat, _v2: GLfloat) callconv(.C) void;
    const glEvalCoord1d = fn (_u: GLdouble) callconv(.C) void;
    const glEvalCoord1dv = fn (_u: [*c]const GLdouble) callconv(.C) void;
    const glEvalCoord1f = fn (_u: GLfloat) callconv(.C) void;
    const glEvalCoord1fv = fn (_u: [*c]const GLfloat) callconv(.C) void;
    const glEvalCoord2d = fn (_u: GLdouble, _v: GLdouble) callconv(.C) void;
    const glEvalCoord2dv = fn (_u: [*c]const GLdouble) callconv(.C) void;
    const glEvalCoord2f = fn (_u: GLfloat, _v: GLfloat) callconv(.C) void;
    const glEvalCoord2fv = fn (_u: [*c]const GLfloat) callconv(.C) void;
    const glEvalMesh1 = fn (_mode: GLenum, _i1: GLint, _i2: GLint) callconv(.C) void;
    const glEvalPoint1 = fn (_i: GLint) callconv(.C) void;
    const glEvalMesh2 = fn (_mode: GLenum, _i1: GLint, _i2: GLint, _j1: GLint, _j2: GLint) callconv(.C) void;
    const glEvalPoint2 = fn (_i: GLint, _j: GLint) callconv(.C) void;
    const glAlphaFunc = fn (_func: GLenum, _ref: GLfloat) callconv(.C) void;
    const glPixelZoom = fn (_xfactor: GLfloat, _yfactor: GLfloat) callconv(.C) void;
    const glPixelTransferf = fn (_pname: GLenum, _param: GLfloat) callconv(.C) void;
    const glPixelTransferi = fn (_pname: GLenum, _param: GLint) callconv(.C) void;
    const glPixelMapfv = fn (_map: GLenum, _mapsize: GLsizei, _values: [*c]const GLfloat) callconv(.C) void;
    const glPixelMapuiv = fn (_map: GLenum, _mapsize: GLsizei, _values: [*c]const GLuint) callconv(.C) void;
    const glPixelMapusv = fn (_map: GLenum, _mapsize: GLsizei, _values: [*c]const GLushort) callconv(.C) void;
    const glCopyPixels = fn (_x: GLint, _y: GLint, _width: GLsizei, _height: GLsizei, _type: GLenum) callconv(.C) void;
    const glDrawPixels = fn (_width: GLsizei, _height: GLsizei, _format: GLenum, _type: GLenum, _pixels: ?*const anyopaque) callconv(.C) void;
    const glGetClipPlane = fn (_plane: GLenum, _equation: [*c]GLdouble) callconv(.C) void;
    const glGetLightfv = fn (_light: GLenum, _pname: GLenum, _params: [*c]GLfloat) callconv(.C) void;
    const glGetLightiv = fn (_light: GLenum, _pname: GLenum, _params: [*c]GLint) callconv(.C) void;
    const glGetMapdv = fn (_target: GLenum, _query: GLenum, _v: [*c]GLdouble) callconv(.C) void;
    const glGetMapfv = fn (_target: GLenum, _query: GLenum, _v: [*c]GLfloat) callconv(.C) void;
    const glGetMapiv = fn (_target: GLenum, _query: GLenum, _v: [*c]GLint) callconv(.C) void;
    const glGetMaterialfv = fn (_face: GLenum, _pname: GLenum, _params: [*c]GLfloat) callconv(.C) void;
    const glGetMaterialiv = fn (_face: GLenum, _pname: GLenum, _params: [*c]GLint) callconv(.C) void;
    const glGetPixelMapfv = fn (_map: GLenum, _values: [*c]GLfloat) callconv(.C) void;
    const glGetPixelMapuiv = fn (_map: GLenum, _values: [*c]GLuint) callconv(.C) void;
    const glGetPixelMapusv = fn (_map: GLenum, _values: [*c]GLushort) callconv(.C) void;
    const glGetPolygonStipple = fn (_mask: [*c]GLubyte) callconv(.C) void;
    const glGetTexEnvfv = fn (_target: GLenum, _pname: GLenum, _params: [*c]GLfloat) callconv(.C) void;
    const glGetTexEnviv = fn (_target: GLenum, _pname: GLenum, _params: [*c]GLint) callconv(.C) void;
    const glGetTexGendv = fn (_coord: GLenum, _pname: GLenum, _params: [*c]GLdouble) callconv(.C) void;
    const glGetTexGenfv = fn (_coord: GLenum, _pname: GLenum, _params: [*c]GLfloat) callconv(.C) void;
    const glGetTexGeniv = fn (_coord: GLenum, _pname: GLenum, _params: [*c]GLint) callconv(.C) void;
    const glIsList = fn (_list: GLuint) callconv(.C) GLboolean;
    const glFrustum = fn (_left: GLdouble, _right: GLdouble, _bottom: GLdouble, _top: GLdouble, _zNear: GLdouble, _zFar: GLdouble) callconv(.C) void;
    const glLoadIdentity = fn () callconv(.C) void;
    const glLoadMatrixf = fn (_m: [*c]const GLfloat) callconv(.C) void;
    const glLoadMatrixd = fn (_m: [*c]const GLdouble) callconv(.C) void;
    const glMatrixMode = fn (_mode: GLenum) callconv(.C) void;
    const glMultMatrixf = fn (_m: [*c]const GLfloat) callconv(.C) void;
    const glMultMatrixd = fn (_m: [*c]const GLdouble) callconv(.C) void;
    const glOrtho = fn (_left: GLdouble, _right: GLdouble, _bottom: GLdouble, _top: GLdouble, _zNear: GLdouble, _zFar: GLdouble) callconv(.C) void;
    const glPopMatrix = fn () callconv(.C) void;
    const glPushMatrix = fn () callconv(.C) void;
    const glRotated = fn (_angle: GLdouble, _x: GLdouble, _y: GLdouble, _z: GLdouble) callconv(.C) void;
    const glRotatef = fn (_angle: GLfloat, _x: GLfloat, _y: GLfloat, _z: GLfloat) callconv(.C) void;
    const glScaled = fn (_x: GLdouble, _y: GLdouble, _z: GLdouble) callconv(.C) void;
    const glScalef = fn (_x: GLfloat, _y: GLfloat, _z: GLfloat) callconv(.C) void;
    const glTranslated = fn (_x: GLdouble, _y: GLdouble, _z: GLdouble) callconv(.C) void;
    const glTranslatef = fn (_x: GLfloat, _y: GLfloat, _z: GLfloat) callconv(.C) void;
    const glDrawArrays = fn (_mode: GLenum, _first: GLint, _count: GLsizei) callconv(.C) void;
    const glDrawElements = fn (_mode: GLenum, _count: GLsizei, _type: GLenum, _indices: ?*const anyopaque) callconv(.C) void;
    const glGetPointerv = fn (_pname: GLenum, _params: ?*?*anyopaque) callconv(.C) void;
    const glPolygonOffset = fn (_factor: GLfloat, _units: GLfloat) callconv(.C) void;
    const glCopyTexImage1D = fn (_target: GLenum, _level: GLint, _internalformat: GLenum, _x: GLint, _y: GLint, _width: GLsizei, _border: GLint) callconv(.C) void;
    const glCopyTexImage2D = fn (_target: GLenum, _level: GLint, _internalformat: GLenum, _x: GLint, _y: GLint, _width: GLsizei, _height: GLsizei, _border: GLint) callconv(.C) void;
    const glCopyTexSubImage1D = fn (_target: GLenum, _level: GLint, _xoffset: GLint, _x: GLint, _y: GLint, _width: GLsizei) callconv(.C) void;
    const glCopyTexSubImage2D = fn (_target: GLenum, _level: GLint, _xoffset: GLint, _yoffset: GLint, _x: GLint, _y: GLint, _width: GLsizei, _height: GLsizei) callconv(.C) void;
    const glTexSubImage1D = fn (_target: GLenum, _level: GLint, _xoffset: GLint, _width: GLsizei, _format: GLenum, _type: GLenum, _pixels: ?*const anyopaque) callconv(.C) void;
    const glTexSubImage2D = fn (_target: GLenum, _level: GLint, _xoffset: GLint, _yoffset: GLint, _width: GLsizei, _height: GLsizei, _format: GLenum, _type: GLenum, _pixels: ?*const anyopaque) callconv(.C) void;
    const glBindTexture = fn (_target: GLenum, _texture: GLuint) callconv(.C) void;
    const glDeleteTextures = fn (_n: GLsizei, _textures: [*c]const GLuint) callconv(.C) void;
    const glGenTextures = fn (_n: GLsizei, _textures: [*c]GLuint) callconv(.C) void;
    const glIsTexture = fn (_texture: GLuint) callconv(.C) GLboolean;
    const glArrayElement = fn (_i: GLint) callconv(.C) void;
    const glColorPointer = fn (_size: GLint, _type: GLenum, _stride: GLsizei, _pointer: ?*const anyopaque) callconv(.C) void;
    const glDisableClientState = fn (_array: GLenum) callconv(.C) void;
    const glEdgeFlagPointer = fn (_stride: GLsizei, _pointer: ?*const anyopaque) callconv(.C) void;
    const glEnableClientState = fn (_array: GLenum) callconv(.C) void;
    const glIndexPointer = fn (_type: GLenum, _stride: GLsizei, _pointer: ?*const anyopaque) callconv(.C) void;
    const glInterleavedArrays = fn (_format: GLenum, _stride: GLsizei, _pointer: ?*const anyopaque) callconv(.C) void;
    const glNormalPointer = fn (_type: GLenum, _stride: GLsizei, _pointer: ?*const anyopaque) callconv(.C) void;
    const glTexCoordPointer = fn (_size: GLint, _type: GLenum, _stride: GLsizei, _pointer: ?*const anyopaque) callconv(.C) void;
    const glVertexPointer = fn (_size: GLint, _type: GLenum, _stride: GLsizei, _pointer: ?*const anyopaque) callconv(.C) void;
    const glAreTexturesResident = fn (_n: GLsizei, _textures: [*c]const GLuint, _residences: [*c]GLboolean) callconv(.C) GLboolean;
    const glPrioritizeTextures = fn (_n: GLsizei, _textures: [*c]const GLuint, _priorities: [*c]const GLfloat) callconv(.C) void;
    const glIndexub = fn (_c: GLubyte) callconv(.C) void;
    const glIndexubv = fn (_c: ?[*:0]const GLubyte) callconv(.C) void;
    const glPopClientAttrib = fn () callconv(.C) void;
    const glPushClientAttrib = fn (_mask: GLbitfield) callconv(.C) void;
    const glDrawRangeElements = fn (_mode: GLenum, _start: GLuint, _end: GLuint, _count: GLsizei, _type: GLenum, _indices: ?*const anyopaque) callconv(.C) void;
    const glTexImage3D = fn (_target: GLenum, _level: GLint, _internalformat: GLint, _width: GLsizei, _height: GLsizei, _depth: GLsizei, _border: GLint, _format: GLenum, _type: GLenum, _pixels: ?*const anyopaque) callconv(.C) void;
    const glTexSubImage3D = fn (_target: GLenum, _level: GLint, _xoffset: GLint, _yoffset: GLint, _zoffset: GLint, _width: GLsizei, _height: GLsizei, _depth: GLsizei, _format: GLenum, _type: GLenum, _pixels: ?*const anyopaque) callconv(.C) void;
    const glCopyTexSubImage3D = fn (_target: GLenum, _level: GLint, _xoffset: GLint, _yoffset: GLint, _zoffset: GLint, _x: GLint, _y: GLint, _width: GLsizei, _height: GLsizei) callconv(.C) void;
    const glActiveTexture = fn (_texture: GLenum) callconv(.C) void;
    const glSampleCoverage = fn (_value: GLfloat, _invert: GLboolean) callconv(.C) void;
    const glCompressedTexImage3D = fn (_target: GLenum, _level: GLint, _internalformat: GLenum, _width: GLsizei, _height: GLsizei, _depth: GLsizei, _border: GLint, _imageSize: GLsizei, _data: ?*const anyopaque) callconv(.C) void;
    const glCompressedTexImage2D = fn (_target: GLenum, _level: GLint, _internalformat: GLenum, _width: GLsizei, _height: GLsizei, _border: GLint, _imageSize: GLsizei, _data: ?*const anyopaque) callconv(.C) void;
    const glCompressedTexImage1D = fn (_target: GLenum, _level: GLint, _internalformat: GLenum, _width: GLsizei, _border: GLint, _imageSize: GLsizei, _data: ?*const anyopaque) callconv(.C) void;
    const glCompressedTexSubImage3D = fn (_target: GLenum, _level: GLint, _xoffset: GLint, _yoffset: GLint, _zoffset: GLint, _width: GLsizei, _height: GLsizei, _depth: GLsizei, _format: GLenum, _imageSize: GLsizei, _data: ?*const anyopaque) callconv(.C) void;
    const glCompressedTexSubImage2D = fn (_target: GLenum, _level: GLint, _xoffset: GLint, _yoffset: GLint, _width: GLsizei, _height: GLsizei, _format: GLenum, _imageSize: GLsizei, _data: ?*const anyopaque) callconv(.C) void;
    const glCompressedTexSubImage1D = fn (_target: GLenum, _level: GLint, _xoffset: GLint, _width: GLsizei, _format: GLenum, _imageSize: GLsizei, _data: ?*const anyopaque) callconv(.C) void;
    const glGetCompressedTexImage = fn (_target: GLenum, _level: GLint, _img: ?*anyopaque) callconv(.C) void;
    const glClientActiveTexture = fn (_texture: GLenum) callconv(.C) void;
    const glMultiTexCoord1d = fn (_target: GLenum, _s: GLdouble) callconv(.C) void;
    const glMultiTexCoord1dv = fn (_target: GLenum, _v: [*c]const GLdouble) callconv(.C) void;
    const glMultiTexCoord1f = fn (_target: GLenum, _s: GLfloat) callconv(.C) void;
    const glMultiTexCoord1fv = fn (_target: GLenum, _v: [*c]const GLfloat) callconv(.C) void;
    const glMultiTexCoord1i = fn (_target: GLenum, _s: GLint) callconv(.C) void;
    const glMultiTexCoord1iv = fn (_target: GLenum, _v: [*c]const GLint) callconv(.C) void;
    const glMultiTexCoord1s = fn (_target: GLenum, _s: GLshort) callconv(.C) void;
    const glMultiTexCoord1sv = fn (_target: GLenum, _v: [*c]const GLshort) callconv(.C) void;
    const glMultiTexCoord2d = fn (_target: GLenum, _s: GLdouble, _t: GLdouble) callconv(.C) void;
    const glMultiTexCoord2dv = fn (_target: GLenum, _v: [*c]const GLdouble) callconv(.C) void;
    const glMultiTexCoord2f = fn (_target: GLenum, _s: GLfloat, _t: GLfloat) callconv(.C) void;
    const glMultiTexCoord2fv = fn (_target: GLenum, _v: [*c]const GLfloat) callconv(.C) void;
    const glMultiTexCoord2i = fn (_target: GLenum, _s: GLint, _t: GLint) callconv(.C) void;
    const glMultiTexCoord2iv = fn (_target: GLenum, _v: [*c]const GLint) callconv(.C) void;
    const glMultiTexCoord2s = fn (_target: GLenum, _s: GLshort, _t: GLshort) callconv(.C) void;
    const glMultiTexCoord2sv = fn (_target: GLenum, _v: [*c]const GLshort) callconv(.C) void;
    const glMultiTexCoord3d = fn (_target: GLenum, _s: GLdouble, _t: GLdouble, _r: GLdouble) callconv(.C) void;
    const glMultiTexCoord3dv = fn (_target: GLenum, _v: [*c]const GLdouble) callconv(.C) void;
    const glMultiTexCoord3f = fn (_target: GLenum, _s: GLfloat, _t: GLfloat, _r: GLfloat) callconv(.C) void;
    const glMultiTexCoord3fv = fn (_target: GLenum, _v: [*c]const GLfloat) callconv(.C) void;
    const glMultiTexCoord3i = fn (_target: GLenum, _s: GLint, _t: GLint, _r: GLint) callconv(.C) void;
    const glMultiTexCoord3iv = fn (_target: GLenum, _v: [*c]const GLint) callconv(.C) void;
    const glMultiTexCoord3s = fn (_target: GLenum, _s: GLshort, _t: GLshort, _r: GLshort) callconv(.C) void;
    const glMultiTexCoord3sv = fn (_target: GLenum, _v: [*c]const GLshort) callconv(.C) void;
    const glMultiTexCoord4d = fn (_target: GLenum, _s: GLdouble, _t: GLdouble, _r: GLdouble, _q: GLdouble) callconv(.C) void;
    const glMultiTexCoord4dv = fn (_target: GLenum, _v: [*c]const GLdouble) callconv(.C) void;
    const glMultiTexCoord4f = fn (_target: GLenum, _s: GLfloat, _t: GLfloat, _r: GLfloat, _q: GLfloat) callconv(.C) void;
    const glMultiTexCoord4fv = fn (_target: GLenum, _v: [*c]const GLfloat) callconv(.C) void;
    const glMultiTexCoord4i = fn (_target: GLenum, _s: GLint, _t: GLint, _r: GLint, _q: GLint) callconv(.C) void;
    const glMultiTexCoord4iv = fn (_target: GLenum, _v: [*c]const GLint) callconv(.C) void;
    const glMultiTexCoord4s = fn (_target: GLenum, _s: GLshort, _t: GLshort, _r: GLshort, _q: GLshort) callconv(.C) void;
    const glMultiTexCoord4sv = fn (_target: GLenum, _v: [*c]const GLshort) callconv(.C) void;
    const glLoadTransposeMatrixf = fn (_m: [*c]const GLfloat) callconv(.C) void;
    const glLoadTransposeMatrixd = fn (_m: [*c]const GLdouble) callconv(.C) void;
    const glMultTransposeMatrixf = fn (_m: [*c]const GLfloat) callconv(.C) void;
    const glMultTransposeMatrixd = fn (_m: [*c]const GLdouble) callconv(.C) void;
    const glBlendFuncSeparate = fn (_sfactorRGB: GLenum, _dfactorRGB: GLenum, _sfactorAlpha: GLenum, _dfactorAlpha: GLenum) callconv(.C) void;
    const glMultiDrawArrays = fn (_mode: GLenum, _first: [*c]const GLint, _count: [*c]const GLsizei, _drawcount: GLsizei) callconv(.C) void;
    const glMultiDrawElements = fn (_mode: GLenum, _count: [*c]const GLsizei, _type: GLenum, _indices: [*c]const ?*const anyopaque, _drawcount: GLsizei) callconv(.C) void;
    const glPointParameterf = fn (_pname: GLenum, _param: GLfloat) callconv(.C) void;
    const glPointParameterfv = fn (_pname: GLenum, _params: [*c]const GLfloat) callconv(.C) void;
    const glPointParameteri = fn (_pname: GLenum, _param: GLint) callconv(.C) void;
    const glPointParameteriv = fn (_pname: GLenum, _params: [*c]const GLint) callconv(.C) void;
    const glFogCoordf = fn (_coord: GLfloat) callconv(.C) void;
    const glFogCoordfv = fn (_coord: [*c]const GLfloat) callconv(.C) void;
    const glFogCoordd = fn (_coord: GLdouble) callconv(.C) void;
    const glFogCoorddv = fn (_coord: [*c]const GLdouble) callconv(.C) void;
    const glFogCoordPointer = fn (_type: GLenum, _stride: GLsizei, _pointer: ?*const anyopaque) callconv(.C) void;
    const glSecondaryColor3b = fn (_red: GLbyte, _green: GLbyte, _blue: GLbyte) callconv(.C) void;
    const glSecondaryColor3bv = fn (_v: [*c]const GLbyte) callconv(.C) void;
    const glSecondaryColor3d = fn (_red: GLdouble, _green: GLdouble, _blue: GLdouble) callconv(.C) void;
    const glSecondaryColor3dv = fn (_v: [*c]const GLdouble) callconv(.C) void;
    const glSecondaryColor3f = fn (_red: GLfloat, _green: GLfloat, _blue: GLfloat) callconv(.C) void;
    const glSecondaryColor3fv = fn (_v: [*c]const GLfloat) callconv(.C) void;
    const glSecondaryColor3i = fn (_red: GLint, _green: GLint, _blue: GLint) callconv(.C) void;
    const glSecondaryColor3iv = fn (_v: [*c]const GLint) callconv(.C) void;
    const glSecondaryColor3s = fn (_red: GLshort, _green: GLshort, _blue: GLshort) callconv(.C) void;
    const glSecondaryColor3sv = fn (_v: [*c]const GLshort) callconv(.C) void;
    const glSecondaryColor3ub = fn (_red: GLubyte, _green: GLubyte, _blue: GLubyte) callconv(.C) void;
    const glSecondaryColor3ubv = fn (_v: ?[*:0]const GLubyte) callconv(.C) void;
    const glSecondaryColor3ui = fn (_red: GLuint, _green: GLuint, _blue: GLuint) callconv(.C) void;
    const glSecondaryColor3uiv = fn (_v: [*c]const GLuint) callconv(.C) void;
    const glSecondaryColor3us = fn (_red: GLushort, _green: GLushort, _blue: GLushort) callconv(.C) void;
    const glSecondaryColor3usv = fn (_v: [*c]const GLushort) callconv(.C) void;
    const glSecondaryColorPointer = fn (_size: GLint, _type: GLenum, _stride: GLsizei, _pointer: ?*const anyopaque) callconv(.C) void;
    const glWindowPos2d = fn (_x: GLdouble, _y: GLdouble) callconv(.C) void;
    const glWindowPos2dv = fn (_v: [*c]const GLdouble) callconv(.C) void;
    const glWindowPos2f = fn (_x: GLfloat, _y: GLfloat) callconv(.C) void;
    const glWindowPos2fv = fn (_v: [*c]const GLfloat) callconv(.C) void;
    const glWindowPos2i = fn (_x: GLint, _y: GLint) callconv(.C) void;
    const glWindowPos2iv = fn (_v: [*c]const GLint) callconv(.C) void;
    const glWindowPos2s = fn (_x: GLshort, _y: GLshort) callconv(.C) void;
    const glWindowPos2sv = fn (_v: [*c]const GLshort) callconv(.C) void;
    const glWindowPos3d = fn (_x: GLdouble, _y: GLdouble, _z: GLdouble) callconv(.C) void;
    const glWindowPos3dv = fn (_v: [*c]const GLdouble) callconv(.C) void;
    const glWindowPos3f = fn (_x: GLfloat, _y: GLfloat, _z: GLfloat) callconv(.C) void;
    const glWindowPos3fv = fn (_v: [*c]const GLfloat) callconv(.C) void;
    const glWindowPos3i = fn (_x: GLint, _y: GLint, _z: GLint) callconv(.C) void;
    const glWindowPos3iv = fn (_v: [*c]const GLint) callconv(.C) void;
    const glWindowPos3s = fn (_x: GLshort, _y: GLshort, _z: GLshort) callconv(.C) void;
    const glWindowPos3sv = fn (_v: [*c]const GLshort) callconv(.C) void;
    const glBlendColor = fn (_red: GLfloat, _green: GLfloat, _blue: GLfloat, _alpha: GLfloat) callconv(.C) void;
    const glBlendEquation = fn (_mode: GLenum) callconv(.C) void;
    const glGenQueries = fn (_n: GLsizei, _ids: [*c]GLuint) callconv(.C) void;
    const glDeleteQueries = fn (_n: GLsizei, _ids: [*c]const GLuint) callconv(.C) void;
    const glIsQuery = fn (_id: GLuint) callconv(.C) GLboolean;
    const glBeginQuery = fn (_target: GLenum, _id: GLuint) callconv(.C) void;
    const glEndQuery = fn (_target: GLenum) callconv(.C) void;
    const glGetQueryiv = fn (_target: GLenum, _pname: GLenum, _params: [*c]GLint) callconv(.C) void;
    const glGetQueryObjectiv = fn (_id: GLuint, _pname: GLenum, _params: [*c]GLint) callconv(.C) void;
    const glGetQueryObjectuiv = fn (_id: GLuint, _pname: GLenum, _params: [*c]GLuint) callconv(.C) void;
    const glBindBuffer = fn (_target: GLenum, _buffer: GLuint) callconv(.C) void;
    const glDeleteBuffers = fn (_n: GLsizei, _buffers: [*c]const GLuint) callconv(.C) void;
    const glGenBuffers = fn (_n: GLsizei, _buffers: [*c]GLuint) callconv(.C) void;
    const glIsBuffer = fn (_buffer: GLuint) callconv(.C) GLboolean;
    const glBufferData = fn (_target: GLenum, _size: GLsizeiptr, _data: ?*const anyopaque, _usage: GLenum) callconv(.C) void;
    const glBufferSubData = fn (_target: GLenum, _offset: GLintptr, _size: GLsizeiptr, _data: ?*const anyopaque) callconv(.C) void;
    const glGetBufferSubData = fn (_target: GLenum, _offset: GLintptr, _size: GLsizeiptr, _data: ?*anyopaque) callconv(.C) void;
    const glMapBuffer = fn (_target: GLenum, _access: GLenum) callconv(.C) ?*anyopaque;
    const glUnmapBuffer = fn (_target: GLenum) callconv(.C) GLboolean;
    const glGetBufferParameteriv = fn (_target: GLenum, _pname: GLenum, _params: [*c]GLint) callconv(.C) void;
    const glGetBufferPointerv = fn (_target: GLenum, _pname: GLenum, _params: ?*?*anyopaque) callconv(.C) void;
    const glBlendEquationSeparate = fn (_modeRGB: GLenum, _modeAlpha: GLenum) callconv(.C) void;
    const glDrawBuffers = fn (_n: GLsizei, _bufs: [*c]const GLenum) callconv(.C) void;
    const glStencilOpSeparate = fn (_face: GLenum, _sfail: GLenum, _dpfail: GLenum, _dppass: GLenum) callconv(.C) void;
    const glStencilFuncSeparate = fn (_face: GLenum, _func: GLenum, _ref: GLint, _mask: GLuint) callconv(.C) void;
    const glStencilMaskSeparate = fn (_face: GLenum, _mask: GLuint) callconv(.C) void;
    const glAttachShader = fn (_program: GLuint, _shader: GLuint) callconv(.C) void;
    const glBindAttribLocation = fn (_program: GLuint, _index: GLuint, _name: [*c]const GLchar) callconv(.C) void;
    const glCompileShader = fn (_shader: GLuint) callconv(.C) void;
    const glCreateProgram = fn () callconv(.C) GLuint;
    const glCreateShader = fn (_type: GLenum) callconv(.C) GLuint;
    const glDeleteProgram = fn (_program: GLuint) callconv(.C) void;
    const glDeleteShader = fn (_shader: GLuint) callconv(.C) void;
    const glDetachShader = fn (_program: GLuint, _shader: GLuint) callconv(.C) void;
    const glDisableVertexAttribArray = fn (_index: GLuint) callconv(.C) void;
    const glEnableVertexAttribArray = fn (_index: GLuint) callconv(.C) void;
    const glGetActiveAttrib = fn (_program: GLuint, _index: GLuint, _bufSize: GLsizei, _length: [*c]GLsizei, _size: [*c]GLint, _type: [*c]GLenum, _name: [*c]GLchar) callconv(.C) void;
    const glGetActiveUniform = fn (_program: GLuint, _index: GLuint, _bufSize: GLsizei, _length: [*c]GLsizei, _size: [*c]GLint, _type: [*c]GLenum, _name: [*c]GLchar) callconv(.C) void;
    const glGetAttachedShaders = fn (_program: GLuint, _maxCount: GLsizei, _count: [*c]GLsizei, _shaders: [*c]GLuint) callconv(.C) void;
    const glGetAttribLocation = fn (_program: GLuint, _name: [*c]const GLchar) callconv(.C) GLint;
    const glGetProgramiv = fn (_program: GLuint, _pname: GLenum, _params: [*c]GLint) callconv(.C) void;
    const glGetProgramInfoLog = fn (_program: GLuint, _bufSize: GLsizei, _length: [*c]GLsizei, _infoLog: [*c]GLchar) callconv(.C) void;
    const glGetShaderiv = fn (_shader: GLuint, _pname: GLenum, _params: [*c]GLint) callconv(.C) void;
    const glGetShaderInfoLog = fn (_shader: GLuint, _bufSize: GLsizei, _length: [*c]GLsizei, _infoLog: [*c]GLchar) callconv(.C) void;
    const glGetShaderSource = fn (_shader: GLuint, _bufSize: GLsizei, _length: [*c]GLsizei, _source: [*c]GLchar) callconv(.C) void;
    const glGetUniformLocation = fn (_program: GLuint, _name: [*c]const GLchar) callconv(.C) GLint;
    const glGetUniformfv = fn (_program: GLuint, _location: GLint, _params: [*c]GLfloat) callconv(.C) void;
    const glGetUniformiv = fn (_program: GLuint, _location: GLint, _params: [*c]GLint) callconv(.C) void;
    const glGetVertexAttribdv = fn (_index: GLuint, _pname: GLenum, _params: [*c]GLdouble) callconv(.C) void;
    const glGetVertexAttribfv = fn (_index: GLuint, _pname: GLenum, _params: [*c]GLfloat) callconv(.C) void;
    const glGetVertexAttribiv = fn (_index: GLuint, _pname: GLenum, _params: [*c]GLint) callconv(.C) void;
    const glGetVertexAttribPointerv = fn (_index: GLuint, _pname: GLenum, _pointer: ?*?*anyopaque) callconv(.C) void;
    const glIsProgram = fn (_program: GLuint) callconv(.C) GLboolean;
    const glIsShader = fn (_shader: GLuint) callconv(.C) GLboolean;
    const glLinkProgram = fn (_program: GLuint) callconv(.C) void;
    const glShaderSource = fn (_shader: GLuint, _count: GLsizei, _string: [*c]const [*c]const GLchar, _length: [*c]const GLint) callconv(.C) void;
    const glUseProgram = fn (_program: GLuint) callconv(.C) void;
    const glUniform1f = fn (_location: GLint, _v0: GLfloat) callconv(.C) void;
    const glUniform2f = fn (_location: GLint, _v0: GLfloat, _v1: GLfloat) callconv(.C) void;
    const glUniform3f = fn (_location: GLint, _v0: GLfloat, _v1: GLfloat, _v2: GLfloat) callconv(.C) void;
    const glUniform4f = fn (_location: GLint, _v0: GLfloat, _v1: GLfloat, _v2: GLfloat, _v3: GLfloat) callconv(.C) void;
    const glUniform1i = fn (_location: GLint, _v0: GLint) callconv(.C) void;
    const glUniform2i = fn (_location: GLint, _v0: GLint, _v1: GLint) callconv(.C) void;
    const glUniform3i = fn (_location: GLint, _v0: GLint, _v1: GLint, _v2: GLint) callconv(.C) void;
    const glUniform4i = fn (_location: GLint, _v0: GLint, _v1: GLint, _v2: GLint, _v3: GLint) callconv(.C) void;
    const glUniform1fv = fn (_location: GLint, _count: GLsizei, _value: [*c]const GLfloat) callconv(.C) void;
    const glUniform2fv = fn (_location: GLint, _count: GLsizei, _value: [*c]const GLfloat) callconv(.C) void;
    const glUniform3fv = fn (_location: GLint, _count: GLsizei, _value: [*c]const GLfloat) callconv(.C) void;
    const glUniform4fv = fn (_location: GLint, _count: GLsizei, _value: [*c]const GLfloat) callconv(.C) void;
    const glUniform1iv = fn (_location: GLint, _count: GLsizei, _value: [*c]const GLint) callconv(.C) void;
    const glUniform2iv = fn (_location: GLint, _count: GLsizei, _value: [*c]const GLint) callconv(.C) void;
    const glUniform3iv = fn (_location: GLint, _count: GLsizei, _value: [*c]const GLint) callconv(.C) void;
    const glUniform4iv = fn (_location: GLint, _count: GLsizei, _value: [*c]const GLint) callconv(.C) void;
    const glUniformMatrix2fv = fn (_location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLfloat) callconv(.C) void;
    const glUniformMatrix3fv = fn (_location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLfloat) callconv(.C) void;
    const glUniformMatrix4fv = fn (_location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLfloat) callconv(.C) void;
    const glValidateProgram = fn (_program: GLuint) callconv(.C) void;
    const glVertexAttrib1d = fn (_index: GLuint, _x: GLdouble) callconv(.C) void;
    const glVertexAttrib1dv = fn (_index: GLuint, _v: [*c]const GLdouble) callconv(.C) void;
    const glVertexAttrib1f = fn (_index: GLuint, _x: GLfloat) callconv(.C) void;
    const glVertexAttrib1fv = fn (_index: GLuint, _v: [*c]const GLfloat) callconv(.C) void;
    const glVertexAttrib1s = fn (_index: GLuint, _x: GLshort) callconv(.C) void;
    const glVertexAttrib1sv = fn (_index: GLuint, _v: [*c]const GLshort) callconv(.C) void;
    const glVertexAttrib2d = fn (_index: GLuint, _x: GLdouble, _y: GLdouble) callconv(.C) void;
    const glVertexAttrib2dv = fn (_index: GLuint, _v: [*c]const GLdouble) callconv(.C) void;
    const glVertexAttrib2f = fn (_index: GLuint, _x: GLfloat, _y: GLfloat) callconv(.C) void;
    const glVertexAttrib2fv = fn (_index: GLuint, _v: [*c]const GLfloat) callconv(.C) void;
    const glVertexAttrib2s = fn (_index: GLuint, _x: GLshort, _y: GLshort) callconv(.C) void;
    const glVertexAttrib2sv = fn (_index: GLuint, _v: [*c]const GLshort) callconv(.C) void;
    const glVertexAttrib3d = fn (_index: GLuint, _x: GLdouble, _y: GLdouble, _z: GLdouble) callconv(.C) void;
    const glVertexAttrib3dv = fn (_index: GLuint, _v: [*c]const GLdouble) callconv(.C) void;
    const glVertexAttrib3f = fn (_index: GLuint, _x: GLfloat, _y: GLfloat, _z: GLfloat) callconv(.C) void;
    const glVertexAttrib3fv = fn (_index: GLuint, _v: [*c]const GLfloat) callconv(.C) void;
    const glVertexAttrib3s = fn (_index: GLuint, _x: GLshort, _y: GLshort, _z: GLshort) callconv(.C) void;
    const glVertexAttrib3sv = fn (_index: GLuint, _v: [*c]const GLshort) callconv(.C) void;
    const glVertexAttrib4Nbv = fn (_index: GLuint, _v: [*c]const GLbyte) callconv(.C) void;
    const glVertexAttrib4Niv = fn (_index: GLuint, _v: [*c]const GLint) callconv(.C) void;
    const glVertexAttrib4Nsv = fn (_index: GLuint, _v: [*c]const GLshort) callconv(.C) void;
    const glVertexAttrib4Nub = fn (_index: GLuint, _x: GLubyte, _y: GLubyte, _z: GLubyte, _w: GLubyte) callconv(.C) void;
    const glVertexAttrib4Nubv = fn (_index: GLuint, _v: ?[*:0]const GLubyte) callconv(.C) void;
    const glVertexAttrib4Nuiv = fn (_index: GLuint, _v: [*c]const GLuint) callconv(.C) void;
    const glVertexAttrib4Nusv = fn (_index: GLuint, _v: [*c]const GLushort) callconv(.C) void;
    const glVertexAttrib4bv = fn (_index: GLuint, _v: [*c]const GLbyte) callconv(.C) void;
    const glVertexAttrib4d = fn (_index: GLuint, _x: GLdouble, _y: GLdouble, _z: GLdouble, _w: GLdouble) callconv(.C) void;
    const glVertexAttrib4dv = fn (_index: GLuint, _v: [*c]const GLdouble) callconv(.C) void;
    const glVertexAttrib4f = fn (_index: GLuint, _x: GLfloat, _y: GLfloat, _z: GLfloat, _w: GLfloat) callconv(.C) void;
    const glVertexAttrib4fv = fn (_index: GLuint, _v: [*c]const GLfloat) callconv(.C) void;
    const glVertexAttrib4iv = fn (_index: GLuint, _v: [*c]const GLint) callconv(.C) void;
    const glVertexAttrib4s = fn (_index: GLuint, _x: GLshort, _y: GLshort, _z: GLshort, _w: GLshort) callconv(.C) void;
    const glVertexAttrib4sv = fn (_index: GLuint, _v: [*c]const GLshort) callconv(.C) void;
    const glVertexAttrib4ubv = fn (_index: GLuint, _v: ?[*:0]const GLubyte) callconv(.C) void;
    const glVertexAttrib4uiv = fn (_index: GLuint, _v: [*c]const GLuint) callconv(.C) void;
    const glVertexAttrib4usv = fn (_index: GLuint, _v: [*c]const GLushort) callconv(.C) void;
    const glVertexAttribPointer = fn (_index: GLuint, _size: GLint, _type: GLenum, _normalized: GLboolean, _stride: GLsizei, _pointer: ?*const anyopaque) callconv(.C) void;
    const glUniformMatrix2x3fv = fn (_location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLfloat) callconv(.C) void;
    const glUniformMatrix3x2fv = fn (_location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLfloat) callconv(.C) void;
    const glUniformMatrix2x4fv = fn (_location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLfloat) callconv(.C) void;
    const glUniformMatrix4x2fv = fn (_location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLfloat) callconv(.C) void;
    const glUniformMatrix3x4fv = fn (_location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLfloat) callconv(.C) void;
    const glUniformMatrix4x3fv = fn (_location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLfloat) callconv(.C) void;
};

const function_pointers = struct {
    var glCullFace: *const function_signatures.glCullFace = undefined;
    var glFrontFace: *const function_signatures.glFrontFace = undefined;
    var glHint: *const function_signatures.glHint = undefined;
    var glLineWidth: *const function_signatures.glLineWidth = undefined;
    var glPointSize: *const function_signatures.glPointSize = undefined;
    var glPolygonMode: *const function_signatures.glPolygonMode = undefined;
    var glScissor: *const function_signatures.glScissor = undefined;
    var glTexParameterf: *const function_signatures.glTexParameterf = undefined;
    var glTexParameterfv: *const function_signatures.glTexParameterfv = undefined;
    var glTexParameteri: *const function_signatures.glTexParameteri = undefined;
    var glTexParameteriv: *const function_signatures.glTexParameteriv = undefined;
    var glTexImage1D: *const function_signatures.glTexImage1D = undefined;
    var glTexImage2D: *const function_signatures.glTexImage2D = undefined;
    var glDrawBuffer: *const function_signatures.glDrawBuffer = undefined;
    var glClear: *const function_signatures.glClear = undefined;
    var glClearColor: *const function_signatures.glClearColor = undefined;
    var glClearStencil: *const function_signatures.glClearStencil = undefined;
    var glClearDepth: *const function_signatures.glClearDepth = undefined;
    var glStencilMask: *const function_signatures.glStencilMask = undefined;
    var glColorMask: *const function_signatures.glColorMask = undefined;
    var glDepthMask: *const function_signatures.glDepthMask = undefined;
    var glDisable: *const function_signatures.glDisable = undefined;
    var glEnable: *const function_signatures.glEnable = undefined;
    var glFinish: *const function_signatures.glFinish = undefined;
    var glFlush: *const function_signatures.glFlush = undefined;
    var glBlendFunc: *const function_signatures.glBlendFunc = undefined;
    var glLogicOp: *const function_signatures.glLogicOp = undefined;
    var glStencilFunc: *const function_signatures.glStencilFunc = undefined;
    var glStencilOp: *const function_signatures.glStencilOp = undefined;
    var glDepthFunc: *const function_signatures.glDepthFunc = undefined;
    var glPixelStoref: *const function_signatures.glPixelStoref = undefined;
    var glPixelStorei: *const function_signatures.glPixelStorei = undefined;
    var glReadBuffer: *const function_signatures.glReadBuffer = undefined;
    var glReadPixels: *const function_signatures.glReadPixels = undefined;
    var glGetBooleanv: *const function_signatures.glGetBooleanv = undefined;
    var glGetDoublev: *const function_signatures.glGetDoublev = undefined;
    var glGetError: *const function_signatures.glGetError = undefined;
    var glGetFloatv: *const function_signatures.glGetFloatv = undefined;
    var glGetIntegerv: *const function_signatures.glGetIntegerv = undefined;
    var glGetString: *const function_signatures.glGetString = undefined;
    var glGetTexImage: *const function_signatures.glGetTexImage = undefined;
    var glGetTexParameterfv: *const function_signatures.glGetTexParameterfv = undefined;
    var glGetTexParameteriv: *const function_signatures.glGetTexParameteriv = undefined;
    var glGetTexLevelParameterfv: *const function_signatures.glGetTexLevelParameterfv = undefined;
    var glGetTexLevelParameteriv: *const function_signatures.glGetTexLevelParameteriv = undefined;
    var glIsEnabled: *const function_signatures.glIsEnabled = undefined;
    var glDepthRange: *const function_signatures.glDepthRange = undefined;
    var glViewport: *const function_signatures.glViewport = undefined;
    var glNewList: *const function_signatures.glNewList = undefined;
    var glEndList: *const function_signatures.glEndList = undefined;
    var glCallList: *const function_signatures.glCallList = undefined;
    var glCallLists: *const function_signatures.glCallLists = undefined;
    var glDeleteLists: *const function_signatures.glDeleteLists = undefined;
    var glGenLists: *const function_signatures.glGenLists = undefined;
    var glListBase: *const function_signatures.glListBase = undefined;
    var glBegin: *const function_signatures.glBegin = undefined;
    var glBitmap: *const function_signatures.glBitmap = undefined;
    var glColor3b: *const function_signatures.glColor3b = undefined;
    var glColor3bv: *const function_signatures.glColor3bv = undefined;
    var glColor3d: *const function_signatures.glColor3d = undefined;
    var glColor3dv: *const function_signatures.glColor3dv = undefined;
    var glColor3f: *const function_signatures.glColor3f = undefined;
    var glColor3fv: *const function_signatures.glColor3fv = undefined;
    var glColor3i: *const function_signatures.glColor3i = undefined;
    var glColor3iv: *const function_signatures.glColor3iv = undefined;
    var glColor3s: *const function_signatures.glColor3s = undefined;
    var glColor3sv: *const function_signatures.glColor3sv = undefined;
    var glColor3ub: *const function_signatures.glColor3ub = undefined;
    var glColor3ubv: *const function_signatures.glColor3ubv = undefined;
    var glColor3ui: *const function_signatures.glColor3ui = undefined;
    var glColor3uiv: *const function_signatures.glColor3uiv = undefined;
    var glColor3us: *const function_signatures.glColor3us = undefined;
    var glColor3usv: *const function_signatures.glColor3usv = undefined;
    var glColor4b: *const function_signatures.glColor4b = undefined;
    var glColor4bv: *const function_signatures.glColor4bv = undefined;
    var glColor4d: *const function_signatures.glColor4d = undefined;
    var glColor4dv: *const function_signatures.glColor4dv = undefined;
    var glColor4f: *const function_signatures.glColor4f = undefined;
    var glColor4fv: *const function_signatures.glColor4fv = undefined;
    var glColor4i: *const function_signatures.glColor4i = undefined;
    var glColor4iv: *const function_signatures.glColor4iv = undefined;
    var glColor4s: *const function_signatures.glColor4s = undefined;
    var glColor4sv: *const function_signatures.glColor4sv = undefined;
    var glColor4ub: *const function_signatures.glColor4ub = undefined;
    var glColor4ubv: *const function_signatures.glColor4ubv = undefined;
    var glColor4ui: *const function_signatures.glColor4ui = undefined;
    var glColor4uiv: *const function_signatures.glColor4uiv = undefined;
    var glColor4us: *const function_signatures.glColor4us = undefined;
    var glColor4usv: *const function_signatures.glColor4usv = undefined;
    var glEdgeFlag: *const function_signatures.glEdgeFlag = undefined;
    var glEdgeFlagv: *const function_signatures.glEdgeFlagv = undefined;
    var glEnd: *const function_signatures.glEnd = undefined;
    var glIndexd: *const function_signatures.glIndexd = undefined;
    var glIndexdv: *const function_signatures.glIndexdv = undefined;
    var glIndexf: *const function_signatures.glIndexf = undefined;
    var glIndexfv: *const function_signatures.glIndexfv = undefined;
    var glIndexi: *const function_signatures.glIndexi = undefined;
    var glIndexiv: *const function_signatures.glIndexiv = undefined;
    var glIndexs: *const function_signatures.glIndexs = undefined;
    var glIndexsv: *const function_signatures.glIndexsv = undefined;
    var glNormal3b: *const function_signatures.glNormal3b = undefined;
    var glNormal3bv: *const function_signatures.glNormal3bv = undefined;
    var glNormal3d: *const function_signatures.glNormal3d = undefined;
    var glNormal3dv: *const function_signatures.glNormal3dv = undefined;
    var glNormal3f: *const function_signatures.glNormal3f = undefined;
    var glNormal3fv: *const function_signatures.glNormal3fv = undefined;
    var glNormal3i: *const function_signatures.glNormal3i = undefined;
    var glNormal3iv: *const function_signatures.glNormal3iv = undefined;
    var glNormal3s: *const function_signatures.glNormal3s = undefined;
    var glNormal3sv: *const function_signatures.glNormal3sv = undefined;
    var glRasterPos2d: *const function_signatures.glRasterPos2d = undefined;
    var glRasterPos2dv: *const function_signatures.glRasterPos2dv = undefined;
    var glRasterPos2f: *const function_signatures.glRasterPos2f = undefined;
    var glRasterPos2fv: *const function_signatures.glRasterPos2fv = undefined;
    var glRasterPos2i: *const function_signatures.glRasterPos2i = undefined;
    var glRasterPos2iv: *const function_signatures.glRasterPos2iv = undefined;
    var glRasterPos2s: *const function_signatures.glRasterPos2s = undefined;
    var glRasterPos2sv: *const function_signatures.glRasterPos2sv = undefined;
    var glRasterPos3d: *const function_signatures.glRasterPos3d = undefined;
    var glRasterPos3dv: *const function_signatures.glRasterPos3dv = undefined;
    var glRasterPos3f: *const function_signatures.glRasterPos3f = undefined;
    var glRasterPos3fv: *const function_signatures.glRasterPos3fv = undefined;
    var glRasterPos3i: *const function_signatures.glRasterPos3i = undefined;
    var glRasterPos3iv: *const function_signatures.glRasterPos3iv = undefined;
    var glRasterPos3s: *const function_signatures.glRasterPos3s = undefined;
    var glRasterPos3sv: *const function_signatures.glRasterPos3sv = undefined;
    var glRasterPos4d: *const function_signatures.glRasterPos4d = undefined;
    var glRasterPos4dv: *const function_signatures.glRasterPos4dv = undefined;
    var glRasterPos4f: *const function_signatures.glRasterPos4f = undefined;
    var glRasterPos4fv: *const function_signatures.glRasterPos4fv = undefined;
    var glRasterPos4i: *const function_signatures.glRasterPos4i = undefined;
    var glRasterPos4iv: *const function_signatures.glRasterPos4iv = undefined;
    var glRasterPos4s: *const function_signatures.glRasterPos4s = undefined;
    var glRasterPos4sv: *const function_signatures.glRasterPos4sv = undefined;
    var glRectd: *const function_signatures.glRectd = undefined;
    var glRectdv: *const function_signatures.glRectdv = undefined;
    var glRectf: *const function_signatures.glRectf = undefined;
    var glRectfv: *const function_signatures.glRectfv = undefined;
    var glRecti: *const function_signatures.glRecti = undefined;
    var glRectiv: *const function_signatures.glRectiv = undefined;
    var glRects: *const function_signatures.glRects = undefined;
    var glRectsv: *const function_signatures.glRectsv = undefined;
    var glTexCoord1d: *const function_signatures.glTexCoord1d = undefined;
    var glTexCoord1dv: *const function_signatures.glTexCoord1dv = undefined;
    var glTexCoord1f: *const function_signatures.glTexCoord1f = undefined;
    var glTexCoord1fv: *const function_signatures.glTexCoord1fv = undefined;
    var glTexCoord1i: *const function_signatures.glTexCoord1i = undefined;
    var glTexCoord1iv: *const function_signatures.glTexCoord1iv = undefined;
    var glTexCoord1s: *const function_signatures.glTexCoord1s = undefined;
    var glTexCoord1sv: *const function_signatures.glTexCoord1sv = undefined;
    var glTexCoord2d: *const function_signatures.glTexCoord2d = undefined;
    var glTexCoord2dv: *const function_signatures.glTexCoord2dv = undefined;
    var glTexCoord2f: *const function_signatures.glTexCoord2f = undefined;
    var glTexCoord2fv: *const function_signatures.glTexCoord2fv = undefined;
    var glTexCoord2i: *const function_signatures.glTexCoord2i = undefined;
    var glTexCoord2iv: *const function_signatures.glTexCoord2iv = undefined;
    var glTexCoord2s: *const function_signatures.glTexCoord2s = undefined;
    var glTexCoord2sv: *const function_signatures.glTexCoord2sv = undefined;
    var glTexCoord3d: *const function_signatures.glTexCoord3d = undefined;
    var glTexCoord3dv: *const function_signatures.glTexCoord3dv = undefined;
    var glTexCoord3f: *const function_signatures.glTexCoord3f = undefined;
    var glTexCoord3fv: *const function_signatures.glTexCoord3fv = undefined;
    var glTexCoord3i: *const function_signatures.glTexCoord3i = undefined;
    var glTexCoord3iv: *const function_signatures.glTexCoord3iv = undefined;
    var glTexCoord3s: *const function_signatures.glTexCoord3s = undefined;
    var glTexCoord3sv: *const function_signatures.glTexCoord3sv = undefined;
    var glTexCoord4d: *const function_signatures.glTexCoord4d = undefined;
    var glTexCoord4dv: *const function_signatures.glTexCoord4dv = undefined;
    var glTexCoord4f: *const function_signatures.glTexCoord4f = undefined;
    var glTexCoord4fv: *const function_signatures.glTexCoord4fv = undefined;
    var glTexCoord4i: *const function_signatures.glTexCoord4i = undefined;
    var glTexCoord4iv: *const function_signatures.glTexCoord4iv = undefined;
    var glTexCoord4s: *const function_signatures.glTexCoord4s = undefined;
    var glTexCoord4sv: *const function_signatures.glTexCoord4sv = undefined;
    var glVertex2d: *const function_signatures.glVertex2d = undefined;
    var glVertex2dv: *const function_signatures.glVertex2dv = undefined;
    var glVertex2f: *const function_signatures.glVertex2f = undefined;
    var glVertex2fv: *const function_signatures.glVertex2fv = undefined;
    var glVertex2i: *const function_signatures.glVertex2i = undefined;
    var glVertex2iv: *const function_signatures.glVertex2iv = undefined;
    var glVertex2s: *const function_signatures.glVertex2s = undefined;
    var glVertex2sv: *const function_signatures.glVertex2sv = undefined;
    var glVertex3d: *const function_signatures.glVertex3d = undefined;
    var glVertex3dv: *const function_signatures.glVertex3dv = undefined;
    var glVertex3f: *const function_signatures.glVertex3f = undefined;
    var glVertex3fv: *const function_signatures.glVertex3fv = undefined;
    var glVertex3i: *const function_signatures.glVertex3i = undefined;
    var glVertex3iv: *const function_signatures.glVertex3iv = undefined;
    var glVertex3s: *const function_signatures.glVertex3s = undefined;
    var glVertex3sv: *const function_signatures.glVertex3sv = undefined;
    var glVertex4d: *const function_signatures.glVertex4d = undefined;
    var glVertex4dv: *const function_signatures.glVertex4dv = undefined;
    var glVertex4f: *const function_signatures.glVertex4f = undefined;
    var glVertex4fv: *const function_signatures.glVertex4fv = undefined;
    var glVertex4i: *const function_signatures.glVertex4i = undefined;
    var glVertex4iv: *const function_signatures.glVertex4iv = undefined;
    var glVertex4s: *const function_signatures.glVertex4s = undefined;
    var glVertex4sv: *const function_signatures.glVertex4sv = undefined;
    var glClipPlane: *const function_signatures.glClipPlane = undefined;
    var glColorMaterial: *const function_signatures.glColorMaterial = undefined;
    var glFogf: *const function_signatures.glFogf = undefined;
    var glFogfv: *const function_signatures.glFogfv = undefined;
    var glFogi: *const function_signatures.glFogi = undefined;
    var glFogiv: *const function_signatures.glFogiv = undefined;
    var glLightf: *const function_signatures.glLightf = undefined;
    var glLightfv: *const function_signatures.glLightfv = undefined;
    var glLighti: *const function_signatures.glLighti = undefined;
    var glLightiv: *const function_signatures.glLightiv = undefined;
    var glLightModelf: *const function_signatures.glLightModelf = undefined;
    var glLightModelfv: *const function_signatures.glLightModelfv = undefined;
    var glLightModeli: *const function_signatures.glLightModeli = undefined;
    var glLightModeliv: *const function_signatures.glLightModeliv = undefined;
    var glLineStipple: *const function_signatures.glLineStipple = undefined;
    var glMaterialf: *const function_signatures.glMaterialf = undefined;
    var glMaterialfv: *const function_signatures.glMaterialfv = undefined;
    var glMateriali: *const function_signatures.glMateriali = undefined;
    var glMaterialiv: *const function_signatures.glMaterialiv = undefined;
    var glPolygonStipple: *const function_signatures.glPolygonStipple = undefined;
    var glShadeModel: *const function_signatures.glShadeModel = undefined;
    var glTexEnvf: *const function_signatures.glTexEnvf = undefined;
    var glTexEnvfv: *const function_signatures.glTexEnvfv = undefined;
    var glTexEnvi: *const function_signatures.glTexEnvi = undefined;
    var glTexEnviv: *const function_signatures.glTexEnviv = undefined;
    var glTexGend: *const function_signatures.glTexGend = undefined;
    var glTexGendv: *const function_signatures.glTexGendv = undefined;
    var glTexGenf: *const function_signatures.glTexGenf = undefined;
    var glTexGenfv: *const function_signatures.glTexGenfv = undefined;
    var glTexGeni: *const function_signatures.glTexGeni = undefined;
    var glTexGeniv: *const function_signatures.glTexGeniv = undefined;
    var glFeedbackBuffer: *const function_signatures.glFeedbackBuffer = undefined;
    var glSelectBuffer: *const function_signatures.glSelectBuffer = undefined;
    var glRenderMode: *const function_signatures.glRenderMode = undefined;
    var glInitNames: *const function_signatures.glInitNames = undefined;
    var glLoadName: *const function_signatures.glLoadName = undefined;
    var glPassThrough: *const function_signatures.glPassThrough = undefined;
    var glPopName: *const function_signatures.glPopName = undefined;
    var glPushName: *const function_signatures.glPushName = undefined;
    var glClearAccum: *const function_signatures.glClearAccum = undefined;
    var glClearIndex: *const function_signatures.glClearIndex = undefined;
    var glIndexMask: *const function_signatures.glIndexMask = undefined;
    var glAccum: *const function_signatures.glAccum = undefined;
    var glPopAttrib: *const function_signatures.glPopAttrib = undefined;
    var glPushAttrib: *const function_signatures.glPushAttrib = undefined;
    var glMap1d: *const function_signatures.glMap1d = undefined;
    var glMap1f: *const function_signatures.glMap1f = undefined;
    var glMap2d: *const function_signatures.glMap2d = undefined;
    var glMap2f: *const function_signatures.glMap2f = undefined;
    var glMapGrid1d: *const function_signatures.glMapGrid1d = undefined;
    var glMapGrid1f: *const function_signatures.glMapGrid1f = undefined;
    var glMapGrid2d: *const function_signatures.glMapGrid2d = undefined;
    var glMapGrid2f: *const function_signatures.glMapGrid2f = undefined;
    var glEvalCoord1d: *const function_signatures.glEvalCoord1d = undefined;
    var glEvalCoord1dv: *const function_signatures.glEvalCoord1dv = undefined;
    var glEvalCoord1f: *const function_signatures.glEvalCoord1f = undefined;
    var glEvalCoord1fv: *const function_signatures.glEvalCoord1fv = undefined;
    var glEvalCoord2d: *const function_signatures.glEvalCoord2d = undefined;
    var glEvalCoord2dv: *const function_signatures.glEvalCoord2dv = undefined;
    var glEvalCoord2f: *const function_signatures.glEvalCoord2f = undefined;
    var glEvalCoord2fv: *const function_signatures.glEvalCoord2fv = undefined;
    var glEvalMesh1: *const function_signatures.glEvalMesh1 = undefined;
    var glEvalPoint1: *const function_signatures.glEvalPoint1 = undefined;
    var glEvalMesh2: *const function_signatures.glEvalMesh2 = undefined;
    var glEvalPoint2: *const function_signatures.glEvalPoint2 = undefined;
    var glAlphaFunc: *const function_signatures.glAlphaFunc = undefined;
    var glPixelZoom: *const function_signatures.glPixelZoom = undefined;
    var glPixelTransferf: *const function_signatures.glPixelTransferf = undefined;
    var glPixelTransferi: *const function_signatures.glPixelTransferi = undefined;
    var glPixelMapfv: *const function_signatures.glPixelMapfv = undefined;
    var glPixelMapuiv: *const function_signatures.glPixelMapuiv = undefined;
    var glPixelMapusv: *const function_signatures.glPixelMapusv = undefined;
    var glCopyPixels: *const function_signatures.glCopyPixels = undefined;
    var glDrawPixels: *const function_signatures.glDrawPixels = undefined;
    var glGetClipPlane: *const function_signatures.glGetClipPlane = undefined;
    var glGetLightfv: *const function_signatures.glGetLightfv = undefined;
    var glGetLightiv: *const function_signatures.glGetLightiv = undefined;
    var glGetMapdv: *const function_signatures.glGetMapdv = undefined;
    var glGetMapfv: *const function_signatures.glGetMapfv = undefined;
    var glGetMapiv: *const function_signatures.glGetMapiv = undefined;
    var glGetMaterialfv: *const function_signatures.glGetMaterialfv = undefined;
    var glGetMaterialiv: *const function_signatures.glGetMaterialiv = undefined;
    var glGetPixelMapfv: *const function_signatures.glGetPixelMapfv = undefined;
    var glGetPixelMapuiv: *const function_signatures.glGetPixelMapuiv = undefined;
    var glGetPixelMapusv: *const function_signatures.glGetPixelMapusv = undefined;
    var glGetPolygonStipple: *const function_signatures.glGetPolygonStipple = undefined;
    var glGetTexEnvfv: *const function_signatures.glGetTexEnvfv = undefined;
    var glGetTexEnviv: *const function_signatures.glGetTexEnviv = undefined;
    var glGetTexGendv: *const function_signatures.glGetTexGendv = undefined;
    var glGetTexGenfv: *const function_signatures.glGetTexGenfv = undefined;
    var glGetTexGeniv: *const function_signatures.glGetTexGeniv = undefined;
    var glIsList: *const function_signatures.glIsList = undefined;
    var glFrustum: *const function_signatures.glFrustum = undefined;
    var glLoadIdentity: *const function_signatures.glLoadIdentity = undefined;
    var glLoadMatrixf: *const function_signatures.glLoadMatrixf = undefined;
    var glLoadMatrixd: *const function_signatures.glLoadMatrixd = undefined;
    var glMatrixMode: *const function_signatures.glMatrixMode = undefined;
    var glMultMatrixf: *const function_signatures.glMultMatrixf = undefined;
    var glMultMatrixd: *const function_signatures.glMultMatrixd = undefined;
    var glOrtho: *const function_signatures.glOrtho = undefined;
    var glPopMatrix: *const function_signatures.glPopMatrix = undefined;
    var glPushMatrix: *const function_signatures.glPushMatrix = undefined;
    var glRotated: *const function_signatures.glRotated = undefined;
    var glRotatef: *const function_signatures.glRotatef = undefined;
    var glScaled: *const function_signatures.glScaled = undefined;
    var glScalef: *const function_signatures.glScalef = undefined;
    var glTranslated: *const function_signatures.glTranslated = undefined;
    var glTranslatef: *const function_signatures.glTranslatef = undefined;
    var glDrawArrays: *const function_signatures.glDrawArrays = undefined;
    var glDrawElements: *const function_signatures.glDrawElements = undefined;
    var glGetPointerv: *const function_signatures.glGetPointerv = undefined;
    var glPolygonOffset: *const function_signatures.glPolygonOffset = undefined;
    var glCopyTexImage1D: *const function_signatures.glCopyTexImage1D = undefined;
    var glCopyTexImage2D: *const function_signatures.glCopyTexImage2D = undefined;
    var glCopyTexSubImage1D: *const function_signatures.glCopyTexSubImage1D = undefined;
    var glCopyTexSubImage2D: *const function_signatures.glCopyTexSubImage2D = undefined;
    var glTexSubImage1D: *const function_signatures.glTexSubImage1D = undefined;
    var glTexSubImage2D: *const function_signatures.glTexSubImage2D = undefined;
    var glBindTexture: *const function_signatures.glBindTexture = undefined;
    var glDeleteTextures: *const function_signatures.glDeleteTextures = undefined;
    var glGenTextures: *const function_signatures.glGenTextures = undefined;
    var glIsTexture: *const function_signatures.glIsTexture = undefined;
    var glArrayElement: *const function_signatures.glArrayElement = undefined;
    var glColorPointer: *const function_signatures.glColorPointer = undefined;
    var glDisableClientState: *const function_signatures.glDisableClientState = undefined;
    var glEdgeFlagPointer: *const function_signatures.glEdgeFlagPointer = undefined;
    var glEnableClientState: *const function_signatures.glEnableClientState = undefined;
    var glIndexPointer: *const function_signatures.glIndexPointer = undefined;
    var glInterleavedArrays: *const function_signatures.glInterleavedArrays = undefined;
    var glNormalPointer: *const function_signatures.glNormalPointer = undefined;
    var glTexCoordPointer: *const function_signatures.glTexCoordPointer = undefined;
    var glVertexPointer: *const function_signatures.glVertexPointer = undefined;
    var glAreTexturesResident: *const function_signatures.glAreTexturesResident = undefined;
    var glPrioritizeTextures: *const function_signatures.glPrioritizeTextures = undefined;
    var glIndexub: *const function_signatures.glIndexub = undefined;
    var glIndexubv: *const function_signatures.glIndexubv = undefined;
    var glPopClientAttrib: *const function_signatures.glPopClientAttrib = undefined;
    var glPushClientAttrib: *const function_signatures.glPushClientAttrib = undefined;
    var glDrawRangeElements: *const function_signatures.glDrawRangeElements = undefined;
    var glTexImage3D: *const function_signatures.glTexImage3D = undefined;
    var glTexSubImage3D: *const function_signatures.glTexSubImage3D = undefined;
    var glCopyTexSubImage3D: *const function_signatures.glCopyTexSubImage3D = undefined;
    var glActiveTexture: *const function_signatures.glActiveTexture = undefined;
    var glSampleCoverage: *const function_signatures.glSampleCoverage = undefined;
    var glCompressedTexImage3D: *const function_signatures.glCompressedTexImage3D = undefined;
    var glCompressedTexImage2D: *const function_signatures.glCompressedTexImage2D = undefined;
    var glCompressedTexImage1D: *const function_signatures.glCompressedTexImage1D = undefined;
    var glCompressedTexSubImage3D: *const function_signatures.glCompressedTexSubImage3D = undefined;
    var glCompressedTexSubImage2D: *const function_signatures.glCompressedTexSubImage2D = undefined;
    var glCompressedTexSubImage1D: *const function_signatures.glCompressedTexSubImage1D = undefined;
    var glGetCompressedTexImage: *const function_signatures.glGetCompressedTexImage = undefined;
    var glClientActiveTexture: *const function_signatures.glClientActiveTexture = undefined;
    var glMultiTexCoord1d: *const function_signatures.glMultiTexCoord1d = undefined;
    var glMultiTexCoord1dv: *const function_signatures.glMultiTexCoord1dv = undefined;
    var glMultiTexCoord1f: *const function_signatures.glMultiTexCoord1f = undefined;
    var glMultiTexCoord1fv: *const function_signatures.glMultiTexCoord1fv = undefined;
    var glMultiTexCoord1i: *const function_signatures.glMultiTexCoord1i = undefined;
    var glMultiTexCoord1iv: *const function_signatures.glMultiTexCoord1iv = undefined;
    var glMultiTexCoord1s: *const function_signatures.glMultiTexCoord1s = undefined;
    var glMultiTexCoord1sv: *const function_signatures.glMultiTexCoord1sv = undefined;
    var glMultiTexCoord2d: *const function_signatures.glMultiTexCoord2d = undefined;
    var glMultiTexCoord2dv: *const function_signatures.glMultiTexCoord2dv = undefined;
    var glMultiTexCoord2f: *const function_signatures.glMultiTexCoord2f = undefined;
    var glMultiTexCoord2fv: *const function_signatures.glMultiTexCoord2fv = undefined;
    var glMultiTexCoord2i: *const function_signatures.glMultiTexCoord2i = undefined;
    var glMultiTexCoord2iv: *const function_signatures.glMultiTexCoord2iv = undefined;
    var glMultiTexCoord2s: *const function_signatures.glMultiTexCoord2s = undefined;
    var glMultiTexCoord2sv: *const function_signatures.glMultiTexCoord2sv = undefined;
    var glMultiTexCoord3d: *const function_signatures.glMultiTexCoord3d = undefined;
    var glMultiTexCoord3dv: *const function_signatures.glMultiTexCoord3dv = undefined;
    var glMultiTexCoord3f: *const function_signatures.glMultiTexCoord3f = undefined;
    var glMultiTexCoord3fv: *const function_signatures.glMultiTexCoord3fv = undefined;
    var glMultiTexCoord3i: *const function_signatures.glMultiTexCoord3i = undefined;
    var glMultiTexCoord3iv: *const function_signatures.glMultiTexCoord3iv = undefined;
    var glMultiTexCoord3s: *const function_signatures.glMultiTexCoord3s = undefined;
    var glMultiTexCoord3sv: *const function_signatures.glMultiTexCoord3sv = undefined;
    var glMultiTexCoord4d: *const function_signatures.glMultiTexCoord4d = undefined;
    var glMultiTexCoord4dv: *const function_signatures.glMultiTexCoord4dv = undefined;
    var glMultiTexCoord4f: *const function_signatures.glMultiTexCoord4f = undefined;
    var glMultiTexCoord4fv: *const function_signatures.glMultiTexCoord4fv = undefined;
    var glMultiTexCoord4i: *const function_signatures.glMultiTexCoord4i = undefined;
    var glMultiTexCoord4iv: *const function_signatures.glMultiTexCoord4iv = undefined;
    var glMultiTexCoord4s: *const function_signatures.glMultiTexCoord4s = undefined;
    var glMultiTexCoord4sv: *const function_signatures.glMultiTexCoord4sv = undefined;
    var glLoadTransposeMatrixf: *const function_signatures.glLoadTransposeMatrixf = undefined;
    var glLoadTransposeMatrixd: *const function_signatures.glLoadTransposeMatrixd = undefined;
    var glMultTransposeMatrixf: *const function_signatures.glMultTransposeMatrixf = undefined;
    var glMultTransposeMatrixd: *const function_signatures.glMultTransposeMatrixd = undefined;
    var glBlendFuncSeparate: *const function_signatures.glBlendFuncSeparate = undefined;
    var glMultiDrawArrays: *const function_signatures.glMultiDrawArrays = undefined;
    var glMultiDrawElements: *const function_signatures.glMultiDrawElements = undefined;
    var glPointParameterf: *const function_signatures.glPointParameterf = undefined;
    var glPointParameterfv: *const function_signatures.glPointParameterfv = undefined;
    var glPointParameteri: *const function_signatures.glPointParameteri = undefined;
    var glPointParameteriv: *const function_signatures.glPointParameteriv = undefined;
    var glFogCoordf: *const function_signatures.glFogCoordf = undefined;
    var glFogCoordfv: *const function_signatures.glFogCoordfv = undefined;
    var glFogCoordd: *const function_signatures.glFogCoordd = undefined;
    var glFogCoorddv: *const function_signatures.glFogCoorddv = undefined;
    var glFogCoordPointer: *const function_signatures.glFogCoordPointer = undefined;
    var glSecondaryColor3b: *const function_signatures.glSecondaryColor3b = undefined;
    var glSecondaryColor3bv: *const function_signatures.glSecondaryColor3bv = undefined;
    var glSecondaryColor3d: *const function_signatures.glSecondaryColor3d = undefined;
    var glSecondaryColor3dv: *const function_signatures.glSecondaryColor3dv = undefined;
    var glSecondaryColor3f: *const function_signatures.glSecondaryColor3f = undefined;
    var glSecondaryColor3fv: *const function_signatures.glSecondaryColor3fv = undefined;
    var glSecondaryColor3i: *const function_signatures.glSecondaryColor3i = undefined;
    var glSecondaryColor3iv: *const function_signatures.glSecondaryColor3iv = undefined;
    var glSecondaryColor3s: *const function_signatures.glSecondaryColor3s = undefined;
    var glSecondaryColor3sv: *const function_signatures.glSecondaryColor3sv = undefined;
    var glSecondaryColor3ub: *const function_signatures.glSecondaryColor3ub = undefined;
    var glSecondaryColor3ubv: *const function_signatures.glSecondaryColor3ubv = undefined;
    var glSecondaryColor3ui: *const function_signatures.glSecondaryColor3ui = undefined;
    var glSecondaryColor3uiv: *const function_signatures.glSecondaryColor3uiv = undefined;
    var glSecondaryColor3us: *const function_signatures.glSecondaryColor3us = undefined;
    var glSecondaryColor3usv: *const function_signatures.glSecondaryColor3usv = undefined;
    var glSecondaryColorPointer: *const function_signatures.glSecondaryColorPointer = undefined;
    var glWindowPos2d: *const function_signatures.glWindowPos2d = undefined;
    var glWindowPos2dv: *const function_signatures.glWindowPos2dv = undefined;
    var glWindowPos2f: *const function_signatures.glWindowPos2f = undefined;
    var glWindowPos2fv: *const function_signatures.glWindowPos2fv = undefined;
    var glWindowPos2i: *const function_signatures.glWindowPos2i = undefined;
    var glWindowPos2iv: *const function_signatures.glWindowPos2iv = undefined;
    var glWindowPos2s: *const function_signatures.glWindowPos2s = undefined;
    var glWindowPos2sv: *const function_signatures.glWindowPos2sv = undefined;
    var glWindowPos3d: *const function_signatures.glWindowPos3d = undefined;
    var glWindowPos3dv: *const function_signatures.glWindowPos3dv = undefined;
    var glWindowPos3f: *const function_signatures.glWindowPos3f = undefined;
    var glWindowPos3fv: *const function_signatures.glWindowPos3fv = undefined;
    var glWindowPos3i: *const function_signatures.glWindowPos3i = undefined;
    var glWindowPos3iv: *const function_signatures.glWindowPos3iv = undefined;
    var glWindowPos3s: *const function_signatures.glWindowPos3s = undefined;
    var glWindowPos3sv: *const function_signatures.glWindowPos3sv = undefined;
    var glBlendColor: *const function_signatures.glBlendColor = undefined;
    var glBlendEquation: *const function_signatures.glBlendEquation = undefined;
    var glGenQueries: *const function_signatures.glGenQueries = undefined;
    var glDeleteQueries: *const function_signatures.glDeleteQueries = undefined;
    var glIsQuery: *const function_signatures.glIsQuery = undefined;
    var glBeginQuery: *const function_signatures.glBeginQuery = undefined;
    var glEndQuery: *const function_signatures.glEndQuery = undefined;
    var glGetQueryiv: *const function_signatures.glGetQueryiv = undefined;
    var glGetQueryObjectiv: *const function_signatures.glGetQueryObjectiv = undefined;
    var glGetQueryObjectuiv: *const function_signatures.glGetQueryObjectuiv = undefined;
    var glBindBuffer: *const function_signatures.glBindBuffer = undefined;
    var glDeleteBuffers: *const function_signatures.glDeleteBuffers = undefined;
    var glGenBuffers: *const function_signatures.glGenBuffers = undefined;
    var glIsBuffer: *const function_signatures.glIsBuffer = undefined;
    var glBufferData: *const function_signatures.glBufferData = undefined;
    var glBufferSubData: *const function_signatures.glBufferSubData = undefined;
    var glGetBufferSubData: *const function_signatures.glGetBufferSubData = undefined;
    var glMapBuffer: *const function_signatures.glMapBuffer = undefined;
    var glUnmapBuffer: *const function_signatures.glUnmapBuffer = undefined;
    var glGetBufferParameteriv: *const function_signatures.glGetBufferParameteriv = undefined;
    var glGetBufferPointerv: *const function_signatures.glGetBufferPointerv = undefined;
    var glBlendEquationSeparate: *const function_signatures.glBlendEquationSeparate = undefined;
    var glDrawBuffers: *const function_signatures.glDrawBuffers = undefined;
    var glStencilOpSeparate: *const function_signatures.glStencilOpSeparate = undefined;
    var glStencilFuncSeparate: *const function_signatures.glStencilFuncSeparate = undefined;
    var glStencilMaskSeparate: *const function_signatures.glStencilMaskSeparate = undefined;
    var glAttachShader: *const function_signatures.glAttachShader = undefined;
    var glBindAttribLocation: *const function_signatures.glBindAttribLocation = undefined;
    var glCompileShader: *const function_signatures.glCompileShader = undefined;
    var glCreateProgram: *const function_signatures.glCreateProgram = undefined;
    var glCreateShader: *const function_signatures.glCreateShader = undefined;
    var glDeleteProgram: *const function_signatures.glDeleteProgram = undefined;
    var glDeleteShader: *const function_signatures.glDeleteShader = undefined;
    var glDetachShader: *const function_signatures.glDetachShader = undefined;
    var glDisableVertexAttribArray: *const function_signatures.glDisableVertexAttribArray = undefined;
    var glEnableVertexAttribArray: *const function_signatures.glEnableVertexAttribArray = undefined;
    var glGetActiveAttrib: *const function_signatures.glGetActiveAttrib = undefined;
    var glGetActiveUniform: *const function_signatures.glGetActiveUniform = undefined;
    var glGetAttachedShaders: *const function_signatures.glGetAttachedShaders = undefined;
    var glGetAttribLocation: *const function_signatures.glGetAttribLocation = undefined;
    var glGetProgramiv: *const function_signatures.glGetProgramiv = undefined;
    var glGetProgramInfoLog: *const function_signatures.glGetProgramInfoLog = undefined;
    var glGetShaderiv: *const function_signatures.glGetShaderiv = undefined;
    var glGetShaderInfoLog: *const function_signatures.glGetShaderInfoLog = undefined;
    var glGetShaderSource: *const function_signatures.glGetShaderSource = undefined;
    var glGetUniformLocation: *const function_signatures.glGetUniformLocation = undefined;
    var glGetUniformfv: *const function_signatures.glGetUniformfv = undefined;
    var glGetUniformiv: *const function_signatures.glGetUniformiv = undefined;
    var glGetVertexAttribdv: *const function_signatures.glGetVertexAttribdv = undefined;
    var glGetVertexAttribfv: *const function_signatures.glGetVertexAttribfv = undefined;
    var glGetVertexAttribiv: *const function_signatures.glGetVertexAttribiv = undefined;
    var glGetVertexAttribPointerv: *const function_signatures.glGetVertexAttribPointerv = undefined;
    var glIsProgram: *const function_signatures.glIsProgram = undefined;
    var glIsShader: *const function_signatures.glIsShader = undefined;
    var glLinkProgram: *const function_signatures.glLinkProgram = undefined;
    var glShaderSource: *const function_signatures.glShaderSource = undefined;
    var glUseProgram: *const function_signatures.glUseProgram = undefined;
    var glUniform1f: *const function_signatures.glUniform1f = undefined;
    var glUniform2f: *const function_signatures.glUniform2f = undefined;
    var glUniform3f: *const function_signatures.glUniform3f = undefined;
    var glUniform4f: *const function_signatures.glUniform4f = undefined;
    var glUniform1i: *const function_signatures.glUniform1i = undefined;
    var glUniform2i: *const function_signatures.glUniform2i = undefined;
    var glUniform3i: *const function_signatures.glUniform3i = undefined;
    var glUniform4i: *const function_signatures.glUniform4i = undefined;
    var glUniform1fv: *const function_signatures.glUniform1fv = undefined;
    var glUniform2fv: *const function_signatures.glUniform2fv = undefined;
    var glUniform3fv: *const function_signatures.glUniform3fv = undefined;
    var glUniform4fv: *const function_signatures.glUniform4fv = undefined;
    var glUniform1iv: *const function_signatures.glUniform1iv = undefined;
    var glUniform2iv: *const function_signatures.glUniform2iv = undefined;
    var glUniform3iv: *const function_signatures.glUniform3iv = undefined;
    var glUniform4iv: *const function_signatures.glUniform4iv = undefined;
    var glUniformMatrix2fv: *const function_signatures.glUniformMatrix2fv = undefined;
    var glUniformMatrix3fv: *const function_signatures.glUniformMatrix3fv = undefined;
    var glUniformMatrix4fv: *const function_signatures.glUniformMatrix4fv = undefined;
    var glValidateProgram: *const function_signatures.glValidateProgram = undefined;
    var glVertexAttrib1d: *const function_signatures.glVertexAttrib1d = undefined;
    var glVertexAttrib1dv: *const function_signatures.glVertexAttrib1dv = undefined;
    var glVertexAttrib1f: *const function_signatures.glVertexAttrib1f = undefined;
    var glVertexAttrib1fv: *const function_signatures.glVertexAttrib1fv = undefined;
    var glVertexAttrib1s: *const function_signatures.glVertexAttrib1s = undefined;
    var glVertexAttrib1sv: *const function_signatures.glVertexAttrib1sv = undefined;
    var glVertexAttrib2d: *const function_signatures.glVertexAttrib2d = undefined;
    var glVertexAttrib2dv: *const function_signatures.glVertexAttrib2dv = undefined;
    var glVertexAttrib2f: *const function_signatures.glVertexAttrib2f = undefined;
    var glVertexAttrib2fv: *const function_signatures.glVertexAttrib2fv = undefined;
    var glVertexAttrib2s: *const function_signatures.glVertexAttrib2s = undefined;
    var glVertexAttrib2sv: *const function_signatures.glVertexAttrib2sv = undefined;
    var glVertexAttrib3d: *const function_signatures.glVertexAttrib3d = undefined;
    var glVertexAttrib3dv: *const function_signatures.glVertexAttrib3dv = undefined;
    var glVertexAttrib3f: *const function_signatures.glVertexAttrib3f = undefined;
    var glVertexAttrib3fv: *const function_signatures.glVertexAttrib3fv = undefined;
    var glVertexAttrib3s: *const function_signatures.glVertexAttrib3s = undefined;
    var glVertexAttrib3sv: *const function_signatures.glVertexAttrib3sv = undefined;
    var glVertexAttrib4Nbv: *const function_signatures.glVertexAttrib4Nbv = undefined;
    var glVertexAttrib4Niv: *const function_signatures.glVertexAttrib4Niv = undefined;
    var glVertexAttrib4Nsv: *const function_signatures.glVertexAttrib4Nsv = undefined;
    var glVertexAttrib4Nub: *const function_signatures.glVertexAttrib4Nub = undefined;
    var glVertexAttrib4Nubv: *const function_signatures.glVertexAttrib4Nubv = undefined;
    var glVertexAttrib4Nuiv: *const function_signatures.glVertexAttrib4Nuiv = undefined;
    var glVertexAttrib4Nusv: *const function_signatures.glVertexAttrib4Nusv = undefined;
    var glVertexAttrib4bv: *const function_signatures.glVertexAttrib4bv = undefined;
    var glVertexAttrib4d: *const function_signatures.glVertexAttrib4d = undefined;
    var glVertexAttrib4dv: *const function_signatures.glVertexAttrib4dv = undefined;
    var glVertexAttrib4f: *const function_signatures.glVertexAttrib4f = undefined;
    var glVertexAttrib4fv: *const function_signatures.glVertexAttrib4fv = undefined;
    var glVertexAttrib4iv: *const function_signatures.glVertexAttrib4iv = undefined;
    var glVertexAttrib4s: *const function_signatures.glVertexAttrib4s = undefined;
    var glVertexAttrib4sv: *const function_signatures.glVertexAttrib4sv = undefined;
    var glVertexAttrib4ubv: *const function_signatures.glVertexAttrib4ubv = undefined;
    var glVertexAttrib4uiv: *const function_signatures.glVertexAttrib4uiv = undefined;
    var glVertexAttrib4usv: *const function_signatures.glVertexAttrib4usv = undefined;
    var glVertexAttribPointer: *const function_signatures.glVertexAttribPointer = undefined;
    var glUniformMatrix2x3fv: *const function_signatures.glUniformMatrix2x3fv = undefined;
    var glUniformMatrix3x2fv: *const function_signatures.glUniformMatrix3x2fv = undefined;
    var glUniformMatrix2x4fv: *const function_signatures.glUniformMatrix2x4fv = undefined;
    var glUniformMatrix4x2fv: *const function_signatures.glUniformMatrix4x2fv = undefined;
    var glUniformMatrix3x4fv: *const function_signatures.glUniformMatrix3x4fv = undefined;
    var glUniformMatrix4x3fv: *const function_signatures.glUniformMatrix4x3fv = undefined;
};

test {
    _ = load;
    @setEvalBranchQuota(100_000); // Yes, this is necessary. OpenGL gets quite large!
    std.testing.refAllDecls(@This());
}
