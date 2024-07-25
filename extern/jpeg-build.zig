pub const name = "jpeg";
pub const config = .{
    .@"jconfig.h" = "extern/config.jpeg.in.h",
};
pub const src = .{
    // "extern/libjpeg/cjpegalt.c",
    // "extern/libjpeg/djpegalt.c",
    "extern/libjpeg/jaricom.c",
    "extern/libjpeg/jcapimin.c",
    "extern/libjpeg/jcapistd.c",
    "extern/libjpeg/jcarith.c",
    "extern/libjpeg/jccoefct.c",
    "extern/libjpeg/jccolor.c",
    "extern/libjpeg/jcdctmgr.c",
    "extern/libjpeg/jchuff.c",
    "extern/libjpeg/jcinit.c",
    "extern/libjpeg/jcmainct.c",
    "extern/libjpeg/jcmarker.c",
    "extern/libjpeg/jcmaster.c",
    "extern/libjpeg/jcomapi.c",
    "extern/libjpeg/jcparam.c",
    "extern/libjpeg/jcprepct.c",
    "extern/libjpeg/jcsample.c",
    "extern/libjpeg/jctrans.c",
    "extern/libjpeg/jdapimin.c",
    "extern/libjpeg/jdapistd.c",
    "extern/libjpeg/jdarith.c",
    "extern/libjpeg/jdatadst.c",
    "extern/libjpeg/jdcoefct.c",
    "extern/libjpeg/jdcolor.c",
    "extern/libjpeg/jddctmgr.c",
    "extern/libjpeg/jdhuff.c",
    "extern/libjpeg/jdinput.c",
    "extern/libjpeg/jdmainct.c",
    "extern/libjpeg/jdmarker.c",
    "extern/libjpeg/jdmaster.c",
    "extern/libjpeg/jdmerge.c",
    "extern/libjpeg/jdpostct.c",
    "extern/libjpeg/jdsample.c",
    "extern/libjpeg/jdtrans.c",
    "extern/libjpeg/jerror.c",
    "extern/libjpeg/jfdctflt.c",
    "extern/libjpeg/jfdctfst.c",
    "extern/libjpeg/jfdctint.c",
    "extern/libjpeg/jidctflt.c",
    "extern/libjpeg/jidctfst.c",
    "extern/libjpeg/jidctint.c",
    "extern/libjpeg/jmemmgr.c",
    "extern/libjpeg/jmemnobs.c",
    "extern/libjpeg/jquant1.c",
    "extern/libjpeg/jquant2.c",
    "extern/libjpeg/jutils.c",
    "extern/libjpeg/rdbmp.c",
    "extern/libjpeg/rdcolmap.c",
    "extern/libjpeg/rdgif.c",
    // "extern/libjpeg/rdjpgcom.c",
    "extern/libjpeg/rdppm.c",
    "extern/libjpeg/rdrle.c",
    "extern/libjpeg/rdswitch.c",
    "extern/libjpeg/rdtarga.c",
    "extern/libjpeg/transupp.c",
    "extern/libjpeg/wrbmp.c",
    "extern/libjpeg/wrgif.c",
    // "extern/libjpeg/wrjpgcom.c",
    "extern/libjpeg/wrppm.c",
    "extern/libjpeg/wrrle.c",
    "extern/libjpeg/wrtarga.c",
};
pub const include = .{
    "extern/libjpeg",
};
