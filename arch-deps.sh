#!/bin/bash

# Run as root!
if [ $(whoami) != "root" ]; then
    echo "You need to be root!"
    exit 1
fi

sudo pacman -S \
    curl       \
    base-devel \
    bison      \
    flex       \
    gmp        \
    libmpc     \
    mpfr       \
    texinfo    \
    libisl     \
    nasm

echo "Note: For building the iso you will need xorriso: (libisoburn)"

