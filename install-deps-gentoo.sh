#!/bin/bash

# Run as root!
if [ $(whoami) != "root" ]; then
    echo "You need to be root!"
    exit 1
fi

EMERGE_FLAGS="--ask --quiet"

emerge ${EMERGE_FLAGS} \
    sys-devel/gcc   \
    sys-devel/make  \
    sys-devel/bison \
    sys-devel/flex  \
    dev-libs/gmp    \
    dev-libs/mpc    \
    dev-libs/mpfr   \
    sys-apps/texinfo

echo "Note: For building the iso you will need xorriso: (dev-libs/libisoburn)"

