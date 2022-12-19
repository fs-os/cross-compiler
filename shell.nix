# https://nix.dev/tutorials/towards-reproducibility-pinning-nixpkgs#pinning-nixpkgs
# https://nix.dev/tutorials/declarative-and-reproducible-developer-environments
# https://wiki.osdev.org/GCC_Cross-Compiler#Installing_Dependencies
{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/0938d73bb143f4ae037143572f11f4338c7b2d1c.tar.gz") {} }:

pkgs.mkShell {
    buildInputs = [
        pkgs.gcc12
        pkgs.gnumake
        pkgs.bison
        pkgs.flex
        pkgs.gmp
        pkgs.libmpc
        pkgs.mpfr
        pkgs.texinfo
    ];
}
