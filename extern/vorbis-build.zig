pub const name = "vorbis";
pub const config = .{
    .@"ogg/config_types.h" = "extern/config.ogg.types.in.h",
};
pub const src = .{
    "extern/vorbis/lib/analysis.c",
    "extern/vorbis/lib/bitrate.c",
    "extern/vorbis/lib/block.c",
    "extern/vorbis/lib/codebook.c",
    "extern/vorbis/lib/envelope.c",
    "extern/vorbis/lib/floor0.c",
    "extern/vorbis/lib/floor1.c",
    "extern/vorbis/lib/info.c",
    "extern/vorbis/lib/lookup.c",
    "extern/vorbis/lib/lpc.c",
    "extern/vorbis/lib/lsp.c",
    "extern/vorbis/lib/mapping0.c",
    "extern/vorbis/lib/mdct.c",
    "extern/vorbis/lib/psy.c",
    "extern/vorbis/lib/registry.c",
    "extern/vorbis/lib/res0.c",
    "extern/vorbis/lib/sharedbook.c",
    "extern/vorbis/lib/smallft.c",
    "extern/vorbis/lib/synthesis.c",
    "extern/vorbis/lib/vorbisenc.c",
    "extern/vorbis/lib/window.c",
};
pub const include = .{
    "extern/vorbis/include",
    "extern/vorbis/lib",
    "extern/ogg/include",
};
