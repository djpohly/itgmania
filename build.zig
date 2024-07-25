const std = @import("std");
const StructField = std.builtin.Type.StructField;

fn validConfigType(comptime Config: type) bool {
    switch (@typeInfo(Config)) {
        .Struct => |info| {
            var valid = true;
            if (info.layout != .auto) {
                valid = false;
                @compileLog("config parameter " ++ @typeName(Config) ++ " must not be extern/packed");
            }
            if (info.decls.len > 0) {
                valid = false;
                @compileLog("config parameter " ++ @typeName(Config) ++ " must only have fields, not declarations");
            }
            if (info.is_tuple) {
                valid = false;
                @compileLog("config parameter " ++ @typeName(Config) ++ " must have explicitly named fields");
            }
            return valid;
        },
        else => |info| {
            @compileLog("config parameter " ++ @typeName(Config) ++ " must be a struct, not a " ++ @tagName(info));
            return false;
        },
    }
}

fn MergedConfig(a: anytype, b: anytype) type {
    @setEvalBranchQuota(2000);

    const A = @TypeOf(a);
    const B = @TypeOf(b);
    if (!validConfigType(A) or !validConfigType(B)) @compileError("invalid config struct");

    const fieldsA = std.meta.fields(A);
    const fieldsB = std.meta.fields(B);
    var fields: [fieldsA.len + fieldsB.len]StructField = undefined;
    var i: usize = 0;
    for (fieldsB) |field| {
        fields[i] = .{
            .name = field.name,
            .type = field.type,
            .default_value = @ptrCast(&@field(b, field.name)),
            .is_comptime = field.is_comptime,
            .alignment = field.alignment,
        };
        i += 1;
    }
    for (fieldsA) |field| {
        // B overrides A
        if (@hasField(B, field.name)) continue;
        fields[i] = .{
            .name = field.name,
            .type = field.type,
            .default_value = @ptrCast(&@field(a, field.name)),
            .is_comptime = field.is_comptime,
            .alignment = field.alignment,
        };
        i += 1;
    }
    return @Type(std.builtin.Type{ .Struct = .{
        .layout = .auto,
        .fields = std.meta.fields(A) ++ std.meta.fields(B),
        .decls = std.meta.declarations(A) ++ std.meta.declarations(B),
        .is_tuple = false,
    }});
}

fn mergeConfig(a: anytype, b: anytype) MergedConfig(a, b) {
    return MergedConfig(a, b){};
}

const global_config = @import("config.zig"){};
const ffmpeg_config = mergeConfig(global_config, @import("config-ffmpeg.zig"){});

const Helper = struct {
    b: *std.Build,
    target: std.Build.ResolvedTarget,
    submodules_update: *std.Build.Step,
    exe: *std.Build.Step.Compile,
    dep_step: *std.Build.Step,
    nasm: ?NasmInfo,

    const NasmInfo = struct {
        exe: *std.Build.Step.Compile,
        config: std.Build.LazyPath,
    };

    fn makeLib(self: Helper, comptime libconfig: anytype) *std.Build.Step.Compile {
        const b = self.b;
        const lib = b.addStaticLibrary(.{
            .name = libconfig.name,
            .target = self.target,
            .optimize = .ReleaseFast,
        });

        if (@hasDecl(libconfig, "copyfrom")) {
            const usf = b.addUpdateSourceFiles();
            inline for (std.meta.fields(@TypeOf(libconfig.copyfrom))) |f| {
                const dest = f.name;
                const src = @field(libconfig.copyfrom, f.name);
                usf.addCopyFileToSource(b.path(src), dest);
            }
            lib.step.dependOn(&usf.step);
        }

        if (@hasDecl(libconfig, "define")) {
            inline for (std.meta.fields(@TypeOf(libconfig.define))) |f| {
                lib.root_module.addCMacro(f.name, @field(libconfig.define, f.name));
            }
        }

        if (@hasDecl(libconfig, "define_public")) {
            inline for (std.meta.fields(@TypeOf(libconfig.define_public))) |f| {
                lib.root_module.addCMacro(f.name, @field(libconfig.define_public, f.name));
                self.exe.root_module.addCMacro(f.name, @field(libconfig.define_public, f.name));
            }
        }

        if (@hasDecl(libconfig, "config")) {
            inline for (std.meta.fields(@TypeOf(libconfig.config))) |f| {
                const dest = f.name;
                const src = @field(libconfig.config, f.name);
                const hdr = b.addConfigHeader(.{
                    .style = .{ .cmake = b.path(src) },
                    .include_path = dest
                }, global_config);
                lib.addConfigHeader(hdr);
            }
        }

        if (@hasDecl(libconfig, "include")) {
            inline for (libconfig.include) |path| {
                lib.addIncludePath(b.path(path));
                self.exe.addIncludePath(b.path(path));
            }
        }

        if (!@hasDecl(libconfig, "needs_libc") or libconfig.needs_libc) {
            lib.linkLibC();
        }

        if (@hasDecl(libconfig, "needs_libcpp") and libconfig.needs_libcpp) {
            lib.linkLibCpp();
        }

        const flags = @as([]const []const u8, &.{}) ++
            (if (@hasDecl(libconfig, "c_std")) .{ "-std=" ++ libconfig.c_std } else .{}) ++
            (if (@hasDecl(libconfig, "flags")) libconfig.flags else .{});

        inline for (libconfig.src) |path| {
            if (std.mem.endsWith(u8, path, ".asm")) {
                const nasm = self.nasm orelse @panic("Nasm is required to assemble source");

                const basename = std.fs.path.basename(path);
                const outfile = b.fmt("{s}.o", .{ basename[0 .. basename.len - ".asm".len] });

                const nasm_run = b.addRunArtifact(nasm.exe);
                nasm_run.addArgs(&.{
                    "-f", "elf64",
                    "-g",
                    "-F", "dwarf",
                    "-Iextern/ffmpeg/",
                    b.fmt("-I{s}/", .{ std.fs.path.dirname(path).? }),
                });
                nasm_run.addArgs(&.{ "--include" });
                nasm_run.addFileArg(nasm.config);

                nasm_run.addArgs(&.{ "-o" });
                lib.addObjectFile(nasm_run.addOutputFileArg(outfile));

                nasm_run.addFileArg(b.path(path));
            } else {
                lib.addCSourceFile(.{
                    .file = b.path(path),
                    .flags = flags,
                });
            }
        }

        lib.step.dependOn(self.submodules_update);
        self.dep_step.dependOn(&lib.step);
        self.exe.linkLibrary(lib);
        return lib;
    }
};

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) !void {
    @setEvalBranchQuota(2000);

    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard optimization options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall. Here we do not
    // set a preferred release mode, allowing the user to decide how to optimize.
    const optimize = b.standardOptimizeOption(.{});

    const submodules_update = b.addSystemCommand(&.{
        "git", "submodule", "update", "--init", "--recursive"
    });

    const itgm_config = @import("itgmania-build.zig");
    const exe = b.addExecutable(.{
        .name = itgm_config.name,
        .target = target,
        .optimize = optimize,
        .use_llvm = optimize != .Debug,
        .use_lld = optimize != .Debug,
    });
    exe.addConfigHeader(b.addConfigHeader(.{
        .style = .{ .cmake = b.path("src/config.in.hpp") },
        .include_path = "config.hpp",
    }, global_config));
    exe.addCSourceFiles(.{ .files = &itgm_config.src });

    const nasm = switch (target.result.cpu.arch) {
        .x86, .x86_64 => blk: {
            const nasm_step = b.dependency("nasm", .{
                .optimize = .ReleaseFast,
            });
            const nasm_config_step = b.addConfigHeader(.{
                .style = .nasm,
                .include_path = "config.asm",
            }, ffmpeg_config);
            break :blk Helper.NasmInfo{
                .exe = nasm_step.artifact("nasm"),
                .config = nasm_config_step.getOutput(),
            };
        },
        else => null,
    };

    const dep_step = b.step("deps", "Build dependencies");

    const helper = Helper{
        .b = b,
        .target = target,
        .submodules_update = &submodules_update.step,
        .exe = exe,
        .dep_step = dep_step,
        .nasm = nasm,
    };

    const ffversion_hdr = b.addConfigHeader(.{
        .style = .blank,
        .include_path = "libavutil/ffversion.h",
    }, .{ .FFMPEG_VERSION = "n5.1.4" });
    const ffmpeg_config_hdr = b.addConfigHeader(.{
        .style = .blank,
        .include_path = "config.h",
    }, ffmpeg_config);
    const avutil_config_hdr = b.addConfigHeader(.{
        .style = .blank,
        .include_path = "libavutil/avconfig.h",
    }, global_config);
    const ffmpeg_components_hdr = b.addWriteFile("config_components.h",
        \\#include "config.h"
        \\
    );
    const avformat_protocols = b.addWriteFile("libavformat/protocol_list.c",
        \\static const URLProtocol * const url_protocols[] = {
        \\    &ff_file_protocol,
        \\    NULL };
        \\
    );
    const avformat_muxers = b.addWriteFile("libavformat/protocol_list.c",
        \\static const AVOutputFormat * const muxer_list[] = {
        \\    NULL };
        \\
    );

    // FFmpeg libraries
    inline for (.{
        @import("extern/avcodec-build.zig"),
        @import("extern/avformat-build.zig"),
        @import("extern/avutil-build.zig"),
        @import("extern/swscale-build.zig"),
    }) |config| {
        const lib = helper.makeLib(config);
        lib.step.dependOn(&submodules_update.step);
        lib.addConfigHeader(ffversion_hdr);
        lib.addConfigHeader(ffmpeg_config_hdr);
        lib.addConfigHeader(avutil_config_hdr);
        lib.addIncludePath(ffmpeg_components_hdr.getDirectory());
        lib.addIncludePath(avformat_protocols.getDirectory());
        lib.addIncludePath(avformat_muxers.getDirectory());
    }

    exe.addIncludePath(b.path("src"));

    _ = helper.makeLib(@import("extern/tommath-build.zig"));
    _ = helper.makeLib(@import("extern/tomcrypt-build.zig"));
    _ = helper.makeLib(@import("extern/ixwebsocket-build.zig"));
    _ = helper.makeLib(@import("extern/jsoncpp-build.zig"));
    _ = helper.makeLib(@import("extern/mad-build.zig"));
    _ = helper.makeLib(@import("extern/glew-build.zig"));
    _ = helper.makeLib(@import("extern/jpeg-build.zig"));
    _ = helper.makeLib(@import("extern/lua-build.zig"));
    _ = helper.makeLib(@import("extern/miniz-build.zig"));
    _ = helper.makeLib(@import("extern/ogg-build.zig"));
    _ = helper.makeLib(@import("extern/pcre-build.zig"));
    _ = helper.makeLib(@import("extern/png-build.zig"));
    _ = helper.makeLib(@import("extern/vorbis-build.zig"));
    _ = helper.makeLib(@import("extern/vorbisfile-build.zig"));
    _ = helper.makeLib(@import("extern/zlib-build.zig"));

    exe.root_module.addCMacro("UNIX", "");
    // Not handled by config.hpp
    exe.root_module.addCMacro("HAVE_FCNTL_H", "1");
    exe.root_module.addCMacro("BACKTRACE_METHOD_X86_LINUX", "1");
    exe.root_module.addCMacro("BACKTRACE_METHOD_TEXT", "x86 custom backtrace");
    exe.root_module.addCMacro("BACKTRACE_LOOKUP_METHOD_DLADDR", "1");
    exe.root_module.addCMacro("BACKTRACE_LOOKUP_METHOD_TEXT", "dladdr");
    exe.root_module.addCMacro("CPU_X86_64", "1");

    exe.linkSystemLibrary("GL");
    exe.linkSystemLibrary("GLU");
    exe.linkSystemLibrary("x11");
    exe.linkSystemLibrary("xext");
    exe.linkSystemLibrary("xrandr");
    exe.linkSystemLibrary("libudev");
    exe.linkSystemLibrary("libusb");
    exe.linkSystemLibrary("libpulse");
    exe.linkSystemLibrary("jack");
    exe.linkLibC();
    exe.linkLibCpp();

    // This declares intent for the executable to be installed into the
    // standard location when the user invokes the "install" step (the default
    // step when running `zig build`).
    b.installArtifact(exe);

    // This *creates* a Run step in the build graph, to be executed when another
    // step is evaluated that depends on it. The next line below will establish
    // such a dependency.
    const run_cmd = b.addRunArtifact(exe);

    // By making the run step depend on the install step, it will be run from the
    // installation directory rather than directly from within the cache directory.
    // This is not necessary, however, if the application depends on other installed
    // files, this ensures they will be present and in the expected location.
    run_cmd.step.dependOn(b.getInstallStep());

    // This allows the user to pass arguments to the application in the build
    // command itself, like this: `zig build run -- arg1 arg2 etc`
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    // This creates a build step. It will be visible in the `zig build --help` menu,
    // and can be selected like this: `zig build run`
    // This will evaluate the `run` step rather than the default, which is "install".
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
