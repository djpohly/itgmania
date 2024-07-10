pub const name = "vorbisfile";
pub const config = .{
    .@"ogg/config_types.h" = "extern/config.ogg.types.in.h",
};
pub const src = .{
    "extern/vorbis/lib/vorbisfile.c",
};
pub const include = .{
    "extern/vorbis/include",
    "extern/ogg/include",
};
