pub const name = "mad";
pub const config = "extern/config.mad.in.h";
pub const src = .{
    "extern/libmad/bit.c",
    "extern/libmad/decoder.c",
    "extern/libmad/fixed.c",
    "extern/libmad/frame.c",
    "extern/libmad/huffman.c",
    "extern/libmad/layer12.c",
    "extern/libmad/layer3.c",
    "extern/libmad/stream.c",
    "extern/libmad/synth.c",
    "extern/libmad/timer.c",
    "extern/libmad/version.c"
};
pub const include = .{
    "extern/libmad",
};
pub const define = .{
    .HAVE_CONFIG_H = "",
    .FPM_64BIT = "1",
};
