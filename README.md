# cross-compiler
Cross-Compiler stuff for the free and simple operative system (fs-os)

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
