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

# Flags for the package manager.
emerge_flags=(--ask
              --quiet)

# Dependencies for cloning the sources.
cloning_deps=(net-misc/curl)

# Dependencies for building the cross-compiler.
building_deps=(sys-devel/gcc
               sys-devel/make
               sys-devel/bison
               sys-devel/flex
               dev-libs/gmp
               dev-libs/mpc
               dev-libs/mpfr
               sys-apps/texinfo)

emerge "${emerge_flags[@]}" "${cloning_deps[@]}" "${building_deps[@]}"

echo "Note: For building the Operating System ISO, you will need NASM: (dev-lang/nasm)"
echo "Note: For building the Operating System ISO, you will need xorriso: (dev-libs/libisoburn)"

# TODO: Correct package names.
#echo "Note: For running it with Qemu, you will also need: (qemu-system-x86 qemu-ui-gtk qemu-audio-pa)"
