#!/bin/bash

# Dependencies for debian/ubuntu
# Nasm is not required for the cross-compiler but its required for fs-os
sudo apt install -y \
    build-essential \
    bison           \
    flex            \
    libgmp3-dev     \
    libmpc-dev      \
    libmpfr-dev     \
    texinfo         \
    libisl-dev      \
    nasm

