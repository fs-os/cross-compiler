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
echo "Note: For running with qemu you will also need: (qemu-system-x86 qemu-ui-gtk qemu-audio-pa)"
