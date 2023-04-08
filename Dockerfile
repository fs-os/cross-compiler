FROM debian:11
COPY . /cross-compiler
WORKDIR /cross-compiler

# Install dependencies for building the package
RUN apt-get update && \
    ./debian-deps

RUN make deps-binutils # Download and extract the binutils source
RUN make deps-gcc      # Download and extract the gcc source
RUN make build-utils   # Building binutils 2.39 (Needs dependencies)
RUN make build-gcc     # Building gcc 12.2.0 (Needs binutils)
