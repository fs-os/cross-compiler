
ARCHIVEDIR=archives
BUILDDIR=build

BINUTILS_VER=2.39
GCC_VER=12.2.0
GDB_VER=12.1

PREFIX=/usr/local/cross
TARGET=i686-elf

# ------------------------------------------------------------------------------

.PHONY: all clean clean-archives clean-builds
all: build

clean: clean-archives clean-builds

clean-archives:
	rm -rf $(ARCHIVEDIR)/*

clean-builds:
	rm -rf $(BUILDDIR)/*

# ------------------------------------------------------------------------------

.PHONY: dependencies
dependencies: $(ARCHIVEDIR)/binutils-$(BINUTILS_VER) $(ARCHIVEDIR)/gcc-$(GCC_VER) $(ARCHIVEDIR)/gdb-$(GDB_VER)

$(ARCHIVEDIR)/binutils-$(BINUTILS_VER).tar.gz:
	@mkdir -p "$(dir $@)"
	curl -o $@ https://ftp.gnu.org/gnu/binutils/binutils-$(BINUTILS_VER).tar.gz

$(ARCHIVEDIR)/gcc-$(GCC_VER).tar.gz:
	@mkdir -p "$(dir $@)"
	curl -o $@ https://ftp.gnu.org/gnu/gcc/gcc-$(GCC_VER)/gcc-$(GCC_VER).tar.gz

$(ARCHIVEDIR)/gdb-$(GDB_VER).tar.gz:
	@mkdir -p "$(dir $@)"
	curl -o $@ https://ftp.gnu.org/gnu/gdb/gdb-$(GDB_VER).tar.gz

# NOTE: We need to touch the extracted directory so it's timestamp is updated
# and future calls to 'make' can detect that the directory is newer than the
# archive.
$(ARCHIVEDIR)/%: $(ARCHIVEDIR)/%.tar.gz
	tar --directory="$(dir $@)" -xf $<
	@touch "$@"

# ----------------------------------------------------------------------------------

.PHONY: build build-binutils build-gcc build-gdb
build: build-binutils build-gcc build-gdb

# Arbitrary files that only exist when the target is built.
#
# NOTE: We need to build in a different path because building in the source tree
# is unsupported by GNU.
build-binutils: $(BUILDDIR)/binutils-$(BINUTILS_VER)
build-gcc: $(BUILDDIR)/gcc-$(GCC_VER)
build-gdb: $(BUILDDIR)/gdb-$(GDB_VER)

# TODO: Don't use annoying "&& \", which are needed because we are changing
# directory across multiple commands. We could perhaps use '.ONESHELL'.
$(BUILDDIR)/binutils-$(BINUTILS_VER): $(ARCHIVEDIR)/binutils-$(BINUTILS_VER)
	@mkdir -p "$@"
	cd "$@" && \
	"$(PWD)/$</configure" --target="$(TARGET)" --prefix="$(PREFIX)" --disable-nls --with-sysroot --disable-werror && \
	make

# We modify the $PATH to include binaries from the 'build-binutils' target.
#
# FIXME: The 'build-gcc' target depends on the 'install-binutils' target,
# because we need to add its binaries to the $PATH. We should somehow specify
# the binaries from the build directory after 'build-binutils'.
$(BUILDDIR)/gcc-$(GCC_VER): $(ARCHIVEDIR)/gcc-$(GCC_VER)
	@mkdir -p "$@"
	export PATH="$(PREFIX)/bin:$$PATH" && \
	cd "$@" && \
	"$(PWD)/$</configure" --target="$(TARGET)" --prefix="$(PREFIX)" --disable-nls --enable-languages=c --without-headers && \
	make all-gcc && \
	make all-target-libgcc

# FIXME: There is a compilation error.
$(BUILDDIR)/gdb-$(GDB_VER): $(ARCHIVEDIR)/gdb-$(GDB_VER)
	@mkdir -p "$@"
	cd "$<" && \
	patch --forward -p1 < "$(PWD)/remote-packet-patch.diff" # End of source patching
	cd "$@" && \
	"$(PWD)/$</configure" --target="$(TARGET)" --prefix="$(PREFIX)" --disable-nls && \
	make all-gdb

# ----------------------------------------------------------------------------------

# Remember to run as root when needed.
.PHONY: install install-binutils install-gcc install-gdb
install: install-binutils install-gcc install-gdb

install-binutils: $(BUILDDIR)/binutils-$(BINUTILS_VER)
	@[ "$$UID" -eq 0 ] || (echo "This target ($@) needs to be run as root." 1>&2 && exit 1)
	cd "$<" && \
	make install

install-gcc: $(BUILDDIR)/gcc-$(GCC_VER)
	@[ "$$UID" -eq 0 ] || (echo "This target ($@) needs to be run as root." 1>&2 && exit 1)
	cd "$<" && \
	make install-gcc && \
	make install-target-libgcc

install-gdb: $(BUILDDIR)/gdb-$(GDB_VER)
	@[ "$$UID" -eq 0 ] || (echo "This target ($@) needs to be run as root." 1>&2 && exit 1)
	cd "$<" && \
	make install-gdb
