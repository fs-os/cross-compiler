
# Installation path, also used when configuring the components.
PREFIX=/usr/local/cross

# Target architecture.
TARGET=i686-elf

# Component versions.
BINUTILS_VER=2.39
GCC_VER=12.2.0
GDB_VER=12.1

# Directories that will contain the extracted contents of each component.
ARCHIVEDIR=archives
BINUTILS_ARCHIVEDIR=$(ARCHIVEDIR)/binutils-$(BINUTILS_VER)
GCC_ARCHIVEDIR=$(ARCHIVEDIR)/gcc-$(GCC_VER)
GDB_ARCHIVEDIR=$(ARCHIVEDIR)/gdb-$(GDB_VER)

# Directories used when building each component.
#
# NOTE: We need to build in a different path because building in the source tree
# is unsupported by GNU.
BUILDDIR=build
BINUTILS_BUILDDIR=$(BUILDDIR)/binutils-$(BINUTILS_VER)
GCC_BUILDDIR=$(BUILDDIR)/gcc-$(GCC_VER)
GDB_BUILDDIR=$(BUILDDIR)/gdb-$(GDB_VER)

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
	curl -o $@ "https://ftp.gnu.org/gnu/binutils/binutils-$(BINUTILS_VER).tar.gz"

$(ARCHIVEDIR)/gcc-$(GCC_VER).tar.gz:
	@mkdir -p "$(dir $@)"
	curl -o $@ "https://ftp.gnu.org/gnu/gcc/gcc-$(GCC_VER)/gcc-$(GCC_VER).tar.gz"

$(ARCHIVEDIR)/gdb-$(GDB_VER).tar.gz:
	@mkdir -p "$(dir $@)"
	curl -o $@ "https://ftp.gnu.org/gnu/gdb/gdb-$(GDB_VER).tar.gz"

# NOTE: We need to touch the extracted directory so it's timestamp is updated
# and future calls to 'make' can detect that the directory is newer than the
# archive.
$(ARCHIVEDIR)/%: $(ARCHIVEDIR)/%.tar.gz
	tar --directory="$(dir $@)" -xf $<
	@touch "$@"

# ----------------------------------------------------------------------------------

.PHONY: build build-binutils build-gcc build-gdb
build: build-binutils build-gcc build-gdb

build-binutils: $(BINUTILS_BUILDDIR)
build-gcc: $(GCC_BUILDDIR)
build-gdb: $(GDB_BUILDDIR)

# TODO: Don't use annoying "&& \", which are needed because we are changing
# directory across multiple commands. We could perhaps use '.ONESHELL'.
$(BINUTILS_BUILDDIR): $(BINUTILS_ARCHIVEDIR)
	@mkdir -p "$@"
	cd "$@" && \
	"$(PWD)/$</configure" --target="$(TARGET)" --prefix="$(PREFIX)" --disable-nls --with-sysroot --disable-werror && \
	make

# We modify the $PATH to include binaries from the 'build-binutils' target.
#
# FIXME: The 'build-gcc' target depends on the 'install-binutils' target,
# because we need to add its binaries to the $PATH. We should somehow specify
# the binaries from the build directory after 'build-binutils'.
$(GCC_BUILDDIR): $(GCC_ARCHIVEDIR)
	@mkdir -p "$@"
	export PATH="$(PREFIX)/bin:$$PATH" && \
	cd "$@" && \
	"$(PWD)/$</configure" --target="$(TARGET)" --prefix="$(PREFIX)" --disable-nls --enable-languages=c --without-headers && \
	make all-gcc && \
	make all-target-libgcc

# FIXME: There is a compilation error.
$(GDB_BUILDDIR): $(GDB_ARCHIVEDIR)
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

install-binutils: $(BINUTILS_BUILDDIR)
	@[ "$$UID" -eq 0 ] || (echo "This target ($@) needs to be run as root." 1>&2 && exit 1)
	cd "$<" && \
	make install

install-gcc: $(GCC_BUILDDIR)
	@[ "$$UID" -eq 0 ] || (echo "This target ($@) needs to be run as root." 1>&2 && exit 1)
	cd "$<" && \
	make install-gcc && \
	make install-target-libgcc

install-gdb: $(GDB_BUILDDIR)
	@[ "$$UID" -eq 0 ] || (echo "This target ($@) needs to be run as root." 1>&2 && exit 1)
	cd "$<" && \
	make install-gdb
