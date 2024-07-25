.PHONY: all

SAVED_CACHE = .zig-cache-deps

all:
	zig build -p . --prefix-exe-dir .

release:
	zig build -p . --prefix-exe-dir . -Doptimize=ReleaseFast

deps:
	zig build -p . --prefix-exe-dir . deps

cache-clean:
	$(RM) -r .zig-cache
	mkdir .zig-cache
	cp -a $(SAVED_CACHE)/{args,h,z} .zig-cache/
	cp -rl $(SAVED_CACHE)/o .zig-cache/o

cache-save: deps
	$(RM) -r $(SAVED_CACHE)
	mkdir $(SAVED_CACHE)
	cp -a .zig-cache/{args,h,z} $(SAVED_CACHE)/
	cp -rl .zig-cache/o $(SAVED_CACHE)/o
