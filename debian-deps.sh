#!/bin/bash

# Run as root!
if [ $(whoami) != "root" ]; then
    echo "You need to be root!"
    exit 1
fi

# Dependencies for debian/ubuntu
# Nasm is not required for the cross-compiler but its required for fs-os
apt install -y      \
    curl            \
    build-essential \
    bison           \
    flex            \
    libgmp3-dev     \
    libmpc-dev      \
    libmpfr-dev     \
    texinfo         \
    libisl-dev      \
    nasm

