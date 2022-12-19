
SRC_FOLDER=src
PREFIX=/usr/local/cross
TARGET=i686-elf

.PHONY: all dependencies build-utils build-gcc

all: dependencies build-utils build-gcc

# Download and extract dependencies into ./src/
#   - binutils-2.39
#   - gcc-11.3.0
dependencies:
	@mkdir -p $(SRC_FOLDER)
	
	curl -o $(SRC_FOLDER)/binutils-2.39.tar.gz https://ftp.gnu.org/gnu/binutils/binutils-2.39.tar.gz
	tar -xf $(SRC_FOLDER)/binutils-2.39.tar.gz --directory=$(SRC_FOLDER)
	rm -f $(SRC_FOLDER)/binutils-2.39.tar.gz
	
	curl -o $(SRC_FOLDER)/gcc-11.3.0.tar.gz https://bigsearcher.com/mirrors/gcc/releases/gcc-11.3.0/gcc-11.3.0.tar.gz
	tar -xf $(SRC_FOLDER)/gcc-11.3.0.tar.gz --directory=$(SRC_FOLDER)
	rm -f $(SRC_FOLDER)/gcc-11.3.0.tar.gz

# Run after dependencies
build-utils:
	@mkdir -p $(SRC_FOLDER)/build-binutils
	
	cd $(SRC_FOLDER)/build-binutils && \
	../binutils-2.39/configure --target=$(TARGET) --prefix="$(PREFIX)" --with-sysroot --disable-nls --disable-werror && \
	make && \
	sudo make install

# Run after dependencies and build-utils
build-gcc:
	@mkdir -p $(SRC_FOLDER)/build-gcc
	
	# Add to path and build. We don't need cpp when configuring
	export PATH="$(PREFIX)/bin:$$PATH" && \
	cd $(SRC_FOLDER)/build-gcc && \
	../gcc-11.3.0/configure --target=$(TARGET) --prefix="$(PREFIX)" --disable-nls --enable-languages=c --without-headers && \
	make all-gcc && \
	make all-target-libgcc && \
	sudo make install-gcc && \
	sudo make install-target-libgcc

