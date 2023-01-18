# cross-compiler
Cross-Compiler stuff for the free and simple operative system (fs-os)

### Dependencies
If you are on gentoo, you can run:
```console
$ sudo ./gentoo-deps.sh
```
If you are on debian or ubuntu, you can run:
```console
$ ./debian-deps.sh
```
In other systems, you will need to install:
- gcc
- make
- bison
- flex
- gmp
- mpc
- mpfr
- texinfo

### Building the cross-compiler
Simply run
```console
$ git clone https://github.com/fs-os/cross-compiler
$ cd cross-compiler
$ make
...
```

Or in case you don't use sudo (for example doas):
```console
$ make ADMIN_CMD=doas
...
```

Or individual make targets (Each target depends on the one before):
```console
$ make deps-binutils    # For downloading and extracting the binutils source
...
$ make build-utils      # For building binutils 2.39 (Needs dependencies)
...
$ make deps-gcc         # For downloading and extracting the gcc source
...
$ make build-gcc        # For building gcc 12.2.0 (Needs binutils)
...
```

And if you also want to compile gdb (`/usr/local/cross/bin/i686-elf-gdb`) with a
custom patch (not included in `all`):
```console
$ make deps-gdb         # For downloading and extracting the gcc source
...
$ make build-gdb        # For building gdb 12.1
...
```

### Todo
- [ ] When building `gcc-12.2.0` (or `gcc-11.3.0`) with `nix-shell`, it fails with (Same error 3 times):

    ```
    ../../../gcc-11.3.0/libcpp/expr.c:811:35: error: format not a string literal and no format arguments [-Werror=format-security]
    ```
