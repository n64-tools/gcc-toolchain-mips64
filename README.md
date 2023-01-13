# mips64-gcc-toolchain for the N64

**NOTE:** This repo uses the [official libDragon](dragonminded/libdragon) toolchain build script to generate its artifacts. However, it may also include features or abilities that have not yet been added (see below).

This repo automatically generates the MIPS64 GCC toolchain to allow cross compilation for the N64. 
The binaries can be downloaded (from releases) and used as part of other build scripts/components which saves time (at least 30 minutes) when setting up a developer environment in order to build N64 libraries such as libdragon in a `Windows` environment (without using docker).

[![Github Action CI](https://github.com/n64-tools/mips64-gcc-toolchain/actions/workflows/build-toolchain.yml/badge.svg)](https://github.com/n64-tools/mips64-gcc-toolchain/actions/workflows/build-toolchain.yml)

Architecture | Download Links
--- | ---
Windows x86_x64 | [Latest](https://github.com/n64-tools/mips64-gcc-toolchain/releases/latest/download/gcc-toolchain-mips64-win64.zip)
Debian | [Latest](https://github.com/n64-tools/mips64-gcc-toolchain/releases/latest/download/gcc-toolchain-mips64-linux64.deb)
Redhat | [Latest](https://github.com/n64-tools/mips64-gcc-toolchain/releases/latest/download/gcc-toolchain-mips64-linux64.rpm)
Docker | [Latest](https://github.com/N64-tools/mips64-gcc-toolchain/pkgs/container/gcc-toolchain-mips64)


### Current Extra features:
* The docker image includes CMake and Ninja Build.
* There are debian and RPM packages available to download.
* There is a Windows toolchain available to download.
