pub const name = "z";
pub const c_std = "c90";
pub const src = .{
    "extern/zlib/adler32.c",
    "extern/zlib/compress.c",
    "extern/zlib/crc32.c",
    "extern/zlib/deflate.c",
    "extern/zlib/gzclose.c",
    "extern/zlib/gzlib.c",
    "extern/zlib/gzread.c",
    "extern/zlib/gzwrite.c",
    "extern/zlib/infback.c",
    "extern/zlib/inffast.c",
    "extern/zlib/inflate.c",
    "extern/zlib/inftrees.c",
    "extern/zlib/trees.c",
    "extern/zlib/uncompr.c",
    "extern/zlib/zutil.c",
};
pub const include = .{
    "extern/zlib",
};
