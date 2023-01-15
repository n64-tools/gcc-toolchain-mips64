# gcc-toolchain-mips64 for the N64

**NOTE:** This repo uses the [official libDragon](dragonminded/libdragon) toolchain build script to generate its artifacts. However, it may also include features or abilities that have not yet been added (see below).

This repo automatically generates the MIPS64 GCC toolchain to allow cross compilation for the N64. 
The binaries can be downloaded (from releases) and used as part of other build scripts/components which saves time (at least 30 minutes) when setting up a developer environment in order to build N64 libraries such as libdragon in a `Windows` environment (without using docker).

[![Github Action CI](https://github.com/n64-tools/gcc-toolchain-mips64/actions/workflows/build-toolchain.yml/badge.svg)](https://github.com/n64-tools/gcc-toolchain-mips64/actions/workflows/build-toolchain.yml)

Architecture | Download Links
--- | ---
Windows x86_x64 | [Latest](https://github.com/n64-tools/gcc-toolchain-mips64/releases/latest/download/gcc-toolchain-mips64-win64.zip)
Debian x86_x64 | [Latest](https://github.com/n64-tools/gcc-toolchain-mips64/releases/download/latest/gcc-toolchain-mips64_n64-tools-x86_64.deb)
Redhat x86_x64 | [Latest](https://github.com/n64-tools/gcc-toolchain-mips64/releases/download/latest/gcc-toolchain-mips64_n64-tools-x86_64.rpm)
Docker | [Latest](https://github.com/n64-tools/gcc-toolchain-mips64/pkgs/container/gcc-toolchain-mips64)


### Current Extra features:
* The docker image includes CMake and Ninja Build.
* There are debian and RPM packages available to download.
* There is a Windows toolchain available to download.

## Licensing:
The GCC toolchain is the GPLv3 licence, this repo only cross compiles it (with no changes). 
However at times the repo may use differential files to fix bugs.
Given the toolchain is only used as a tool to build an output binary and its wider use as a toolchain, this license should not be an issue for any generated output.
However, I am not an expert in licensing!
