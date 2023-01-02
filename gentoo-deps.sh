#!/bin/bash

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

