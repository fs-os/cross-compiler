# i686 cross-compiler

**Automated build and installation of an i686 GCC cross-compiler.**

## Installing the dependencies

In order to build the cross-compiler, you will need to have some packages
installed in your host machine.

If you are using Arch Linux, you can run:

```console
$ sudo ./install-deps-arch.sh
```

If you are using Gentoo, you can run:

```console
$ sudo ./install-deps-gentoo.sh
```

If you are using Debian or Ubuntu, you can run:

```console
$ sudo ./install-deps-debian.sh
```

In other systems, you will need to install the following packages to build the
cross-compiler:

- gcc
- make
- bison
- flex
- gmp
- mpc
- mpfr
- texinfo

## Building and installing the cross-compiler

Clone this repository, and run `make`.

```console
$ git clone https://github.com/fs-os/cross-compiler
$ cd cross-compiler
$ make  # Build Binutils 2.39 and GCC 12.2.0
...
```

Or invoke the individual make targets.

```console
$ make deps-binutils  # Download and extract the Binutils 2.39 source
...

$ make build-utils    # Build Binutils 2.39
...

$ make deps-gcc       # Download and extract the GCC 12.2.0 source
...

$ make build-gcc      # Build GCC 12.2.0
...
```

After you have built the cross compiler, you can install it with the `install`
target. Remember to use `sudo` or a similar command for installing them as
root. By default, the cross-compiler will be installed in
`/usr/local/cross/bin/`, but this path can be overwritten with the `PREFIX`
Makefile variable.

```console
$ sudo make install  # Install Binutils 2.39 and GCC 12.2.0
...
```

## Building and installing the i686 debugger

Optionally, you can compile the GNU debugger with a custom patch with the
`build-gdb` target, and install it (to `/usr/local/cross/bin/i686-elf-gdb`) with
the `install-gdb` target. By default, this is not build when invoking the `all`
target.

```console
$ make build-gdb  # For building GDB 12.1
...

$ sudo make install-gdb  # For installing it into '$PREFIX'
...
```
