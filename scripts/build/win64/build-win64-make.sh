#!/bin/bash
set -eu

#
# tools/build-win64-toolchain.sh: Win64 makefile build script.
#
# for N64-TOOLS by Robin Jones
#
# This file is subject to the terms and conditions defined in
# 'LICENSE', which is part of this source code package.
#

# parallel make
NUMCPUS=`grep -c '^processor' /proc/cpuinfo` #$(nproc)
MAKEJOB_PARALLEL="--jobs=$NUMCPUS --load-average=$NUMCPUS"

MAKE="https://ftp.gnu.org/gnu/make/make-4.2.1.tar.gz" # patches are provided from https://github.com/mbuilov/gnumake-windows for 4.3!

BUILD=${BUILD:-x86_64-linux-gnu}
HOST=${HOST:-x86_64-w64-mingw32}

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
  # MAKE_FILE_PATCHES=("../"make-*.patch)
  # for f in "${MAKE_FILE_PATCHES[@]}"
  # do
  #   patch -p1 -i "${f}" # Apply patches if they exist in the folder
  # done
  patch -p1 -i ../make-4.2*.patch # Apply patches if they exist in the folder
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
  make $MAKEJOB_PARALLEL
  popd

  touch stamps/make-build
fi

if [ ! -f stamps/make-install ]; then
  pushd make-build
  make install
  popd

  touch stamps/make-install
fi