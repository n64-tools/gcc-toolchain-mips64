#!/bin/bash
# Abort on Error
set -e

export PING_SLEEP=60s
export WORKDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export BUILD_OUTPUT=${WORKDIR}/build.out

touch ${BUILD_OUTPUT}

dump_output() {
   echo "Tailing the last 1000 lines of output:"
   tail -1000 ${BUILD_OUTPUT}  
}
error_handler() {
  kill ${PING_LOOP_PID}
  echo "ERROR: An error was encountered with the build."
  dump_output
  exit 1
}
# If an error occurs, run our error handler to output a tail of the build
trap 'error_handler' ERR

# Set up a repeating loop to send some output to Travis.

bash -c "while true; do echo \$(date) - building ...; sleep ${PING_SLEEP}; done" &
PING_LOOP_PID=$!

# Put build scripts here:
LINUX_BUILD_DIR="${WORKDIR}/scripts/build/linux64"
WIN_BUILD_DIR="${WORKDIR}/scripts/build/win64"

echo "Starting the linux build process..."
cd ${LINUX_BUILD_DIR}
bash ./build-linux64-toolchain.sh >> ${BUILD_OUTPUT} 2>&1

rm -rf ./tarballs
rm -rf ./*-source
rm -rf ./*-build
rm -rf ./stamps
rm ./build-linux64-toolchain.sh

echo "Starting the Windows build process..."
export PATH="${PATH}:${LINUX_BUILD_DIR}/bin"
cd ${WIN_BUILD_DIR}
bash ./build-win64-toolchain.sh >> ${BUILD_OUTPUT} 2>&1

rm -rf ./tarballs
rm -rf ./*-source
rm -rf ./*-build
rm -rf ./stamps
rm -rf ./x86_64-w64-mingw32
rm ./build-win64-toolchain.sh
rm ./gcc-win64-enable-plugins.patch

echo "Compressing files for upload..."
cd ${WORKDIR}/scripts/build/
tar -czf gcc-toolchain-mips64-linux64.tar.gz ./linux64
zip -rq gcc-toolchain-mips64-win64.zip ./win64


echo "The build completed successfully."
# The build finished without returning an error so dump a tail of the output
#dump_output

# nicely terminate the ping output loop
kill ${PING_LOOP_PID}