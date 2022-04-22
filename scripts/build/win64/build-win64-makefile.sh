#!/bin/bash
set -eu

#
# MakeFile (for windows) build script.
#
# Attributions: 
# Robin Jones (NetworkFusion/JonesAlmighty)
#
# This script builds library source covered under the 'GNU LESSER GENERAL PUBLIC LICENSE'
# However, the original source is not changed and an OSS patch file is used.
# The repo 'LICENSE' is added for assurance.
#

# Parallel GCC build jobs
NUM_CPU_THREADS=`grep -c '^processor' /proc/cpuinfo` #$(nproc)
BUILD_NUM_JOBS="--jobs=$NUM_CPU_THREADS --load-average=$NUM_CPU_THREADS"

MAKE="https://ftp.gnu.org/gnu/make/make-4.2.1.tar.gz" # patches for 4.3 could be provided from https://github.com/mbuilov/gnumake-windows however, there are currently issues with canadian cross!

BUILD=${BUILD:-x86_64-linux-gnu}
HOST=${HOST:-x86_64-w64-mingw32}

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd ${SCRIPT_DIR} && mkdir -p {stamps,tarballs}

export PATH="${PATH}:${SCRIPT_DIR}/bin:${SCRIPT_DIR}/../linux64/bin"

if [ ! -f stamps/make-download ]; then
  wget "${MAKE}" -O "tarballs/$(basename ${MAKE})"
  touch stamps/make-download
fi

if [ ! -f stamps/make-extract ]; then
  mkdir -p make-{build,source}
  tar -xf tarballs/$(basename ${MAKE}) -C make-source --strip 1
  touch stamps/make-extract
fi

if [ ! -f stamps/make-patch ]; then
  pushd make-source
    patch -p1 -i ../make-*.patch
  popd
  touch stamps/make-patch
fi

if [ ! -f stamps/make-configure ]; then
  pushd make-build
  ../make-source/configure \
    --prefix="${SCRIPT_DIR}" \
    --build="$BUILD" \
    --host="$HOST" \
    --disable-largefile \
    --disable-nls \
    --disable-rpath
  popd

  touch stamps/make-configure
fi

if [ ! -f stamps/make-build ]; then
  pushd make-build
  make $BUILD_NUM_JOBS
  popd

  touch stamps/make-build
fi

if [ ! -f stamps/make-install ]; then
  pushd make-build
  make install
  popd

  touch stamps/make-install
fi

rm -rf "${SCRIPT_DIR}"/make-*.patch
rm -rf "${SCRIPT_DIR}"/tarballs
rm -rf "${SCRIPT_DIR}"/*-source
rm -rf "${SCRIPT_DIR}"/*-build
rm -rf "${SCRIPT_DIR}"/stamps
exit 0
