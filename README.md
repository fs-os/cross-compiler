# cross-compiler
Cross-Compiler stuff for the free and simple operative system (fs-os)

### Dependencies
If you are on gentoo, you can run:
```console
$ sudo ./gentoo-deps.sh
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

Or individual make targets (Each target depends on the one before):
```console
$ make dendencies   # For downloading and extracting the binutils and gcc sources
...
$ make build-utils  # For building binutils 2.39 (Needs dependencies)
...
$ make build-gcc    # For building gcc 11.3.0 (Needs binutils)
...
```

### Todo
- [ ] When building `gcc-12.2.0` (or `gcc-11.3.0`) with `nix-shell`, it fails with (Same error 3 times):

    ```
    ../../../gcc-11.3.0/libcpp/expr.c:811:35: error: format not a string literal and no format arguments [-Werror=format-security]
    ```
