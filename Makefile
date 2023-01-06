
ADMIN_CMD?=sudo

SRC_FOLDER=src
PREFIX=/usr/local/cross
TARGET=i686-elf

.PHONY: all dependencies deps-binutils deps-gcc deps-gdb build-utils build-gcc build-gdb

all: dependencies build-utils build-gcc

# Download and extract dependencies into ./src/
#   - binutils-2.39
#   - gcc-12.2.0
dependencies: deps-binutils deps-gcc

deps-binutils:
	@mkdir -p $(SRC_FOLDER)
	
	curl -o $(SRC_FOLDER)/binutils-2.39.tar.gz https://ftp.gnu.org/gnu/binutils/binutils-2.39.tar.gz
	tar -xf $(SRC_FOLDER)/binutils-2.39.tar.gz --directory=$(SRC_FOLDER)
	rm -f $(SRC_FOLDER)/binutils-2.39.tar.gz
	
deps-gcc:
	@mkdir -p $(SRC_FOLDER)
	
	curl -o $(SRC_FOLDER)/gcc-12.2.0.tar.gz https://bigsearcher.com/mirrors/gcc/releases/gcc-12.2.0/gcc-12.2.0.tar.gz
	tar -xf $(SRC_FOLDER)/gcc-12.2.0.tar.gz --directory=$(SRC_FOLDER)
	rm -f $(SRC_FOLDER)/gcc-12.2.0.tar.gz

# Optional, gdb-12.1 with custom patch
deps-gdb:
	@mkdir -p $(SRC_FOLDER)
	
	curl -o $(SRC_FOLDER)/gdb-12.1.tar.gz https://ftp.gnu.org/gnu/gdb/gdb-12.1.tar.gz
	tar -xf $(SRC_FOLDER)/gdb-12.1.tar.gz --directory=$(SRC_FOLDER)
	rm -f $(SRC_FOLDER)/gdb-12.1.tar.gz

# ----------------------------------------------------------------------------------

# Run after deps-binutils
build-utils:
	@mkdir -p $(SRC_FOLDER)/build-binutils
	
	cd $(SRC_FOLDER)/build-binutils && \
	../binutils-2.39/configure --target=$(TARGET) --prefix="$(PREFIX)" --with-sysroot --disable-nls --disable-werror && \
	make && \
	$(ADMIN_CMD) make install

# Run after deps-gcc and build-utils
build-gcc:
	@mkdir -p $(SRC_FOLDER)/build-gcc
	
	# Add to path and build. We don't need cpp when configuring
	export PATH="$(PREFIX)/bin:$$PATH" && \
	cd $(SRC_FOLDER)/build-gcc && \
	../gcc-12.2.0/configure --target=$(TARGET) --prefix="$(PREFIX)" --disable-nls --enable-languages=c --without-headers && \
	make all-gcc && \
	make all-target-libgcc && \
	$(ADMIN_CMD) make install-gcc && \
	$(ADMIN_CMD) make install-target-libgcc

# Run after deps-gdb
build-gdb:
	@mkdir -p $(SRC_FOLDER)/build-gdb
	
	cp ./remote-packet-patch.diff $(SRC_FOLDER)/build-gdb/
	
	cd $(SRC_FOLDER)/build-gdb && \
	patch -p1 < remote-packet-patch.diff && \
	../gdb-12.1/configure --target=$(TARGET) --prefix="$(PREFIX)" --disable-nls && \
	make all-gdb && \
	$(ADMIN_CMD) make install-gdb

