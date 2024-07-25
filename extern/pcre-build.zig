pub const name = "pcre";
pub const config = .{
    .@"config.h" = "extern/config.pcre.in.h",
    .@"pcre.h" = "extern/pcre/pcre.h.generic",
};
pub const rename_src = .{
    .@"extern/pcre/pcre_chartables.c" = "extern/pcre/pcre_chartables.c.dist",
};
pub const src = .{
    "extern/pcre/pcre_byte_order.c",
    "extern/pcre/pcre_compile.c",
    "extern/pcre/pcre_config.c",
    "extern/pcre/pcre_dfa_exec.c",
    "extern/pcre/pcre_exec.c",
    "extern/pcre/pcre_fullinfo.c",
    "extern/pcre/pcre_get.c",
    "extern/pcre/pcre_globals.c",
    "extern/pcre/pcre_jit_compile.c",
    "extern/pcre/pcre_maketables.c",
    "extern/pcre/pcre_newline.c",
    "extern/pcre/pcre_ord2utf8.c",
    "extern/pcre/pcre_refcount.c",
    "extern/pcre/pcre_string_utils.c",
    "extern/pcre/pcre_study.c",
    "extern/pcre/pcre_tables.c",
    "extern/pcre/pcre_ucd.c",
    "extern/pcre/pcre_valid_utf8.c",
    "extern/pcre/pcre_version.c",
    "extern/pcre/pcre_xclass.c",
};
pub const include = .{
    "extern/pcre",
};
pub const define = .{
    .HAVE_CONFIG_H = "",
    .PCRE_STATIC = "",
};
