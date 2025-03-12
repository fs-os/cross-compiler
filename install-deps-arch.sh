#!/usr/bin/env bash

if [ "$UID" -ne 0 ]; then
    echo -n "This script must be ran as root, " 1>&2
    if [ "$(command -v 'sudo')" ]; then
        echo "escalating privileges..." 1>&2
        exec sudo "$0" "$@"
    else
        echo "but 'sudo' was not found in the PATH." 1>&2
        exit 1
    fi
fi

# Dependencies for cloning the sources.
cloning_deps=(curl)

# Dependencies for building the cross-compiler.
building_deps=(base-devel
               bison
               flex
               gmp
               libmpc
               mpfr
               texinfo
               libisl)

pacman -S "${cloning_deps[@]}" "${building_deps[@]}"

echo "Note: For building the Operating System ISO, you will need NASM: (nasm)"
echo "Note: For building the Operating System ISO, you will need xorriso: (libisoburn)"
echo "Note: For running it with Qemu, you will also need: (qemu-system-x86 qemu-ui-gtk qemu-audio-pa)"
