#!/bin/bash

ADMIN_CMD=""

# If we are root, run without sudo. Debian docker container doesn't include sudo
if [ $(whoami) != "root" ]; then
    # If we are not root but we have sudo installed, use it when calling apt
    if [ $(command -v sudo) ]; then
        ADMIN_CMD="sudo"
    else
        # If we are not root and we don't have sudo, exit
        echo "You need to be root!"
        exit 1
    fi
fi

# Dependencies for debian/ubuntu
# Nasm is not required for the cross-compiler but its required for fs-os
$ADMIN_CMD apt install -y \
    curl                  \
    build-essential       \
    bison                 \
    flex                  \
    libgmp3-dev           \
    libmpc-dev            \
    libmpfr-dev           \
    texinfo               \
    libisl-dev            \
    nasm

