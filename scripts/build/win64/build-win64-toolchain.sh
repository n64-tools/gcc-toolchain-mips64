#!/bin/bash
set -eu

#
# tools/build-win64-toolchain.sh: Win64 toolchain build script.
#
# n64chain: A (free) open-source N64 development toolchain.
# Copyright 2014-2018 Tyler J. Stachecki <stachecki.tyler@gmail.com>
# modified for N64-TOOLS by Robin Jones
#
# This file is subject to the terms and conditions defined in
# 'LICENSE', which is part of this source code package.
#

BINUTILS="https://ftp.gnu.org/gnu/binutils/binutils-2.35.tar.bz2"
GCC="https://ftp.gnu.org/gnu/gcc/gcc-10.2.0/gcc-10.2.0.tar.gz"
GMP="https://ftp.gnu.org/gnu/gmp/gmp-6.2.0.tar.bz2"
MAKE="https://ftp.gnu.org/gnu/make/make-4.2.1.tar.gz"
MPC="https://ftp.gnu.org/gnu/mpc/mpc-1.2.1.tar.gz"
MPFR="https://ftp.gnu.org/gnu/mpfr/mpfr-4.1.0.tar.bz2"
NEWLIB="https://sourceware.org/pub/newlib/newlib-3.3.0.tar.gz"
GDB="https://ftp.gnu.org/gnu/gdb/gdb-10.1.tar.gz"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd ${SCRIPT_DIR} && mkdir -p {stamps,tarballs}

export PATH="${PATH}:${SCRIPT_DIR}/bin"

if [ ! -f stamps/binutils-download ]; then
  wget "${BINUTILS}" -O "tarballs/$(basename ${BINUTILS})"
  touch stamps/binutils-download
fi

if [ ! -f stamps/binutils-extract ]; then
  mkdir -p binutils-{build,source}
  tar -xf tarballs/$(basename ${BINUTILS}) -C binutils-source --strip 1
  touch stamps/binutils-extract
fi

if [ ! -f stamps/binutils-configure ]; then
  pushd binutils-build
  ../binutils-source/configure \
    --build=x86_64-linux-gnu \
    --host=x86_64-w64-mingw32 \
    --prefix="${SCRIPT_DIR}" \
    --with-lib-path="${SCRIPT_DIR}/lib" \
    --target=mips64-elf --with-arch=vr4300 \
    --enable-64-bit-bfd \
    --enable-plugins \
    --enable-shared \
    --disable-gold \
    --disable-multilib \
    --disable-nls \
    --disable-rpath \
    --disable-static \
    --disable-werror
  popd

  touch stamps/binutils-configure
fi

if [ ! -f stamps/binutils-build ]; then
  pushd binutils-build
  make --jobs=2
  popd

  touch stamps/binutils-build
fi

if [ ! -f stamps/binutils-install ]; then
  pushd binutils-build
  make install
  popd

  touch stamps/binutils-install
fi

if [ ! -f stamps/gmp-download ]; then
  wget "${GMP}" -O "tarballs/$(basename ${GMP})"
  touch stamps/gmp-download
fi

if [ ! -f stamps/mpfr-download ]; then
  wget "${MPFR}" -O "tarballs/$(basename ${MPFR})"
  touch stamps/mpfr-download
fi

if [ ! -f stamps/mpc-download ]; then
  wget "${MPC}" -O "tarballs/$(basename ${MPC})"
  touch stamps/mpc-download
fi

if [ ! -f stamps/gcc-download ]; then
  wget "${GCC}" -O "tarballs/$(basename ${GCC})"
  touch stamps/gcc-download
fi

if [ ! -f stamps/gcc-extract ]; then
  mkdir -p gcc-{build,source}
  tar -xf tarballs/$(basename ${GCC}) -C gcc-source --strip 1
  touch stamps/gcc-extract
fi

if [ ! -f stamps/gmp-extract ]; then
  mkdir -p gcc-source/gmp
  tar -xf tarballs/$(basename ${GMP}) -C gcc-source/gmp --strip 1
  touch stamps/gmp-extract
fi

if [ ! -f stamps/mpfr-extract ]; then
  mkdir -p gcc-source/mpfr
  tar -xf tarballs/$(basename ${MPFR}) -C gcc-source/mpfr --strip 1
  touch stamps/mpfr-extract
fi

if [ ! -f stamps/mpc-extract ]; then
  mkdir -p gcc-source/mpc
  tar -xf tarballs/$(basename ${MPC}) -C gcc-source/mpc --strip 1
  touch stamps/mpc-extract
fi

if [ ! -f stamps/gcc-configure ]; then
  pushd gcc-build
  ../gcc-source/configure \
    --build=x86_64-linux-gnu \
    --host=x86_64-w64-mingw32 \
    --prefix="${SCRIPT_DIR}" \
    --target=mips64-elf --with-arch=vr4300 \
    --enable-languages=c,c++ --without-headers --with-newlib \
    --with-gnu-as=${SCRIPT_DIR}/bin/mips64-elf-as.exe \
    --with-gnu-ld=${SCRIPT_DIR}/bin/mips64-elf-ld.exe \
    --enable-checking=release \
    --enable-shared \
    --enable-shared-libgcc \
    --disable-decimal-float \
    --disable-gold \
    --disable-libatomic \
    --disable-libgomp \
    --disable-libitm \
    --disable-libquadmath \
    --disable-libquadmath-support \
    --disable-libsanitizer \
    --disable-libssp \
    --disable-libunwind-exceptions \
    --disable-libvtv \
    --disable-multilib \
    --disable-nls \
    --disable-rpath \
    --disable-static \
    --disable-symvers \
    --disable-threads \
    --disable-win32-registry \
    --enable-lto \
    --enable-plugin \
    --without-included-gettext
  popd

  touch stamps/gcc-configure
fi

if [ ! -f stamps/gcc-build ]; then
  pushd gcc-build
  make --jobs=2 all-gcc
  popd

  touch stamps/gcc-build
fi

if [ ! -f stamps/gcc-install ]; then
  pushd gcc-build
  make install-gcc
  popd

  # While not necessary, this is still a good idea.
  pushd "${SCRIPT_DIR}/bin"
  cp mips64-elf-{gcc,cc}.exe
  popd

  touch stamps/gcc-install
fi

if [ ! -f stamps/make-download ]; then
  wget "${MAKE}" -O "tarballs/$(basename ${MAKE})"
  touch stamps/make-download
fi

if [ ! -f stamps/make-extract ]; then
  mkdir -p make-{build,source}
  tar -xf tarballs/$(basename ${MAKE}) -C make-source --strip 1
  touch stamps/make-extract
fi

if [ ! -f stamps/make-configure ]; then
  pushd make-build
  ../make-source/configure \
    --build=x86_64-linux-gnu \
    --host=x86_64-w64-mingw32 \
    --prefix="${SCRIPT_DIR}" \
    --disable-largefile \
    --disable-nls \
    --disable-rpath
  popd

  touch stamps/make-configure
fi

if [ ! -f stamps/make-build ]; then
  pushd make-build
  make --jobs=2
  popd

  touch stamps/make-build
fi

if [ ! -f stamps/make-install ]; then
  pushd make-build
  make install
  popd

  touch stamps/make-install
fi

if [ ! -f stamps/libgcc-build ]; then
  pushd gcc-build
  make --jobs=4 all-target-libgcc
  popd

  touch stamps/libgcc-build
fi

if [ ! -f stamps/libgcc-install ]; then
  pushd gcc-build
  make install-target-libgcc
  popd

  touch stamps/libgcc-install
fi

if [ ! -f stamps/newlib-download ]; then
  wget "${NEWLIB}" -O "tarballs/$(basename ${NEWLIB})"
  touch stamps/newlib-download
fi

if [ ! -f stamps/newlib-extract ]; then
  mkdir -p newlib-{build,source}
  tar -xf tarballs/$(basename ${NEWLIB}) -C newlib-source --strip 1
  touch stamps/newlib-extract
fi

if [ ! -f stamps/newlib-configure ]; then
  pushd newlib-build
    CFLAGS="-O2 -fomit-frame-pointer -ffast-math -fstrict-aliasing" \
        ../newlib-source/configure \
        --build=x86_64-linux-gnu \
        --host=x86_64-w64-mingw32 \
        --disable-bootstrap \
        --disable-build-poststage1-with-cxx \
        --disable-build-with-cxx \
        --disable-cloog-version-check \
        --disable-dependency-tracking \
        --disable-libada \
        --disable-libquadmath \
        --disable-libquadmath-support \
        --disable-libssp \
        --disable-maintainer-mode \
        --disable-malloc-debugging \
        --disable-multilib \
        --disable-newlib-atexit-alloc \
        --disable-newlib-hw-fp \
        --disable-newlib-iconv \
        --disable-newlib-io-float \
        --disable-newlib-io-long-double \
        --disable-newlib-io-long-long \
        --disable-newlib-mb \
        --disable-newlib-multithread \
        --disable-newlib-register-fini \
        --disable-newlib-supplied-syscalls \
        --disable-objc-gc \
        --enable-newlib-io-c99-formats \
        --enable-newlib-io-pos-args \
        --enable-newlib-reent-small \
        --prefix="${SCRIPT_DIR}" \
        --target=mips64-elf --with-arch=vr4300 \
        --with-endian=little \
        --without-cloog \
        --without-gmp \
        --without-mpc \
        --without-mpfr
         popd

  touch stamps/newlib-configure
fi

if [ ! -f stamps/newlib-build ]; then
  pushd newlib-build
  make --jobs=4
  popd

  touch stamps/newlib-build
fi

if [ ! -f stamps/newlib-install ]; then
  pushd newlib-build
  make install
  popd

  touch stamps/newlib-install
fi

if [ ! -f stamps/gdb-download ]; then
  wget "${GDB}" -O "tarballs/$(basename ${GDB})"
  touch stamps/gdb-download
fi

if [ ! -f stamps/gdb-extract ]; then
  mkdir -p gdb-{build,source}
  tar -xf tarballs/$(basename ${GDB}) -C gdb-source --strip 1
  touch stamps/gdb-extract
fi

if [ ! -f stamps/gdb-configure ]; then
  pushd gdb-build
    CFLAGS="" LDFLAGS="" \
        ../gdb-source/configure \
        --disable-werror \
        --build=x86_64-linux-gnu \
        --host=x86_64-w64-mingw32 \
        --prefix="${SCRIPT_DIR}" \
        --target=mips64-elf --with-arch=vr4300
         popd

  touch stamps/gdb-configure
fi

if [ ! -f stamps/gdb-build ]; then
  pushd gdb-build
  make --jobs=4
  popd

  touch stamps/gdb-build
fi

if [ ! -f stamps/gdb-install ]; then
  pushd gdb-build
  make install
  popd

  # While not necessary, this is still a good idea.
  #pushd "${SCRIPT_DIR}/bin"
  #cp mips64-elf-{gdb,gdb-add-index}.exe
  #popd

  touch stamps/gdb-install
fi

rm -rf "${SCRIPT_DIR}"/../tools/tarballs
rm -rf "${SCRIPT_DIR}"/../tools/*-source
rm -rf "${SCRIPT_DIR}"/../tools/*-build
rm -rf "${SCRIPT_DIR}"/../tools/stamps
exit 0

