pub const name = "ogg";
pub const config = .{
    .@"ogg/config_types.h" = "extern/config.ogg.types.in.h",
};
pub const src = .{
    "extern/ogg/src/bitwise.c",
    "extern/ogg/src/framing.c"
};
pub const include = .{
    "extern/ogg/include",
};
