pub const name = "swscale";
pub const src = .{
    "extern/ffmpeg/libswscale/alphablend.c",
    "extern/ffmpeg/libswscale/gamma.c",
    "extern/ffmpeg/libswscale/hscale.c",
    "extern/ffmpeg/libswscale/hscale_fast_bilinear.c",
    "extern/ffmpeg/libswscale/input.c",
    "extern/ffmpeg/libswscale/options.c",
    "extern/ffmpeg/libswscale/output.c",
    "extern/ffmpeg/libswscale/rgb2rgb.c",
    "extern/ffmpeg/libswscale/slice.c",
    "extern/ffmpeg/libswscale/swscale.c",
    "extern/ffmpeg/libswscale/swscale_unscaled.c",
    "extern/ffmpeg/libswscale/utils.c",
    "extern/ffmpeg/libswscale/version.c",
    "extern/ffmpeg/libswscale/vscale.c",
    "extern/ffmpeg/libswscale/yuv2rgb.c",
};
pub const include = .{
    "extern/ffmpeg",
};
pub const define = .{
    .HAVE_AV_CONFIG_H = "1",
    .av_restrict = "restrict",
};
pub const c_std = "gnu17";
pub const flags = .{
    "-Wno-everything",
};
