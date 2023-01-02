**NOTE:** This repo will be updated or deprecated in the near future as the [official libDragon](dragonminded/libgragon) toolchain now supports the ability to do the same thing using:
```
sudo apt-get install -y mingw-w64
cd ./tools/
sudo N64_INST=/usr/local/n64/ HOST=x86_64-w64-mingw32 ./build-toolchain.sh
```


# mips64-gcc-toolchain for the N64

This repo automatically generates the MIPS64 GCC toolchain to allow cross compilation for the N64. 
The binaries can be downloaded (from releases) and used as part of other build scripts/components which saves time (at least 30 minutes) when setting up a developer environment in order to build N64 libraries such as libdragon in a `Windows` environment.

[![Github Action CI](https://github.com/n64-tools/mips64-gcc-toolchain/actions/workflows/build-toolchain.yml/badge.svg)](https://github.com/n64-tools/mips64-gcc-toolchain/actions/workflows/build-toolchain.yml)

Architecture | Download Links
--- | ---
Windows x86_x64 | [Latest](https://github.com/n64-tools/mips64-gcc-toolchain/releases/latest/download/gcc-toolchain-mips64-win64.zip)
Debian | [Latest](https://github.com/n64-tools/mips64-gcc-toolchain/releases/latest/download/gcc-toolchain-mips64.deb)
Redhat | [Latest](https://github.com/n64-tools/mips64-gcc-toolchain/releases/latest/download/gcc-toolchain-mips64.rpm)
