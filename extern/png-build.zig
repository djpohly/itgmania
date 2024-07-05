pub const name = "png";
pub const copyfrom = .{
    .@"extern/libpng/pnglibconf.h" = "extern/libpng/scripts/pnglibconf.h.prebuilt",
};
pub const src = .{
    "extern/libpng/png.c",
    "extern/libpng/pngerror.c",
    "extern/libpng/pngget.c",
    "extern/libpng/pngmem.c",
    "extern/libpng/pngpread.c",
    "extern/libpng/pngread.c",
    "extern/libpng/pngrio.c",
    "extern/libpng/pngrtran.c",
    "extern/libpng/pngrutil.c",
    "extern/libpng/pngset.c",
    "extern/libpng/pngtest.c",
    "extern/libpng/pngtrans.c",
    "extern/libpng/pngwio.c",
    "extern/libpng/pngwrite.c",
    "extern/libpng/pngwtran.c",
    "extern/libpng/pngwutil.c",
};
pub const include = .{
    "extern/libpng",
};
pub const define = .{
    .PNG_ARM_NEON_OPT = "0",
    .PNG_INTEL_SSE_OPT = "0",
};
