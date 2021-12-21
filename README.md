# mips64-gcc-toolchain for the N64

This repo automatically generates the MIPS64 toolchain to allow cross compilation for the N64. 
The binaries can be downloaded as part of other build scripts which saves time (at least 30 minutes) setting up a developer environment in order to build N64 libraries such as libdragon.

[![Build Status](https://dev.azure.com/n64-tools/N64-Tools/_apis/build/status/N64-tools.mips64-gcc-toolchain)](https://dev.azure.com/n64-tools/N64-Tools/_build/latest?definitionId=1)

## Note: the build script is not currently uploading releases correctly, although the download link for the `Win64` artifact is now avaliable from [Releases](https://github.com/N64-tools/mips64-gcc-toolchain/releases)

Architecture | Download Links
--- | --- 
Windows x64 | [Latest](https://n64tools.blob.core.windows.net/binaries/N64-tools/mips64-gcc-toolchain/master/latest/gcc-toolchain-mips64-win64.zip)
Linux x64 | [Latest](https://n64tools.blob.core.windows.net/binaries/N64-tools/mips64-gcc-toolchain/master/latest/gcc-toolchain-mips64-linux64.tar.gz)
