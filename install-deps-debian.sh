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
building_deps=(build-essential
               bison
               flex
               libgmp3-dev
               libmpc-dev
               libmpfr-dev
               texinfo
               libisl-dev)

apt install -y "${cloning_deps[@]}" "${building_deps[@]}"
