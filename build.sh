#!/bin/bash
# Abort on Error
set -e

export WORKDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Put build scripts here:
LINUX_BUILD_DIR="${WORKDIR}/scripts/build/linux64"
WIN_BUILD_DIR="${WORKDIR}/scripts/build/win64"

echo "Starting the linux build process..."
cd ${LINUX_BUILD_DIR}
bash ./build-linux64-toolchain.sh

rm -rf ./tarballs
rm -rf ./*-source
rm -rf ./*-build
rm -rf ./stamps
rm ./build-linux64-toolchain.sh

echo "Starting the Windows build process..."
export PATH="${PATH}:${LINUX_BUILD_DIR}/bin"
cd ${WIN_BUILD_DIR}
bash ./build-win64-toolchain.sh

rm -rf ./tarballs
rm -rf ./*-source
rm -rf ./*-build
rm -rf ./stamps
rm -rf ./x86_64-w64-mingw32
rm ./build-win64-toolchain.sh

echo "Compressing files for upload..."
cd ${WORKDIR}/scripts/build/linux64
tar -czf ../gcc-toolchain-mips64-linux64.tar.gz *
cd ${WORKDIR}/scripts/build/win64
zip -rq ../gcc-toolchain-mips64-win64.zip *

echo "The build completed successfully."
