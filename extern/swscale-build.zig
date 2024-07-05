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
    "extern/ffmpeg/libswscale/x86/hscale_fast_bilinear_simd.c",
    "extern/ffmpeg/libswscale/x86/input.asm",
    "extern/ffmpeg/libswscale/x86/output.asm",
    "extern/ffmpeg/libswscale/x86/rgb2rgb.c",
    "extern/ffmpeg/libswscale/x86/rgb_2_rgb.asm",
    "extern/ffmpeg/libswscale/x86/scale.asm",
    "extern/ffmpeg/libswscale/x86/scale_avx2.asm",
    "extern/ffmpeg/libswscale/x86/swscale.c",
    "extern/ffmpeg/libswscale/x86/yuv2rgb.c",
    "extern/ffmpeg/libswscale/x86/yuv2yuvX.asm",
    "extern/ffmpeg/libswscale/x86/yuv_2_rgb.asm",
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
