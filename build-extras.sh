#! /bin/bash
# N64 MIPS GCC toolchain build/install script for Unix distributions
# (c) 2023 NetworkFusion.
# See the root folder for license information.

# Bash strict mode http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

# Check that N64_INST is defined
if [ -z "${N64_INST-}" ]; then
    echo "N64_INST environment variable is not defined."
    echo "Please define N64_INST and point it to the requested installation directory"
    exit 1
fi

# Path where the toolchain will be built.
BUILD_PATH="${BUILD_PATH:-toolchain}"

# Defines the build system variables to allow cross compilation.
BUILD=${BUILD:-""}
HOST=${HOST:-""}
TARGET=${TARGET:-mips64-elf}

# Set N64_INST before calling the script to change the default installation directory path
INSTALL_PATH="${N64_INST}"
# Set PATH for newlib to compile using GCC for MIPS N64 (pass 1)
export PATH="$PATH:$INSTALL_PATH/bin"

# Determine how many parallel Make jobs to run based on CPU count
JOBS="${JOBS:-$(getconf _NPROCESSORS_ONLN)}"
JOBS="${JOBS:-1}" # If getconf returned nothing, default to 1

# GCC configure arguments to use system GMP/MPC/MFPF
GCC_CONFIGURE_ARGS=()


# Check if a command-line tool is available: status 0 means "yes"; status 1 means "no"
command_exists () {
    (command -v "$1" >/dev/null 2>&1)
    return $?
}

# Download the file URL using wget or curl (depending on which is installed)
download () {
    if   command_exists wget ; then wget -c  "$1"
    elif command_exists curl ; then curl -LO "$1"
    else
        echo "Install wget or curl to download toolchain sources" 1>&2
        return 1
    fi
}


# Create build path and enter it
mkdir -p "$BUILD_PATH"
cd "$BUILD_PATH"

# Dependency downloads and unpack
test -f "gdb-$GDB_V.tar.gz"       || download "https://ftp.gnu.org/gnu/gdb/gdb-$GDB_V.tar.gz"
test -d "gdb-$GDB_V"              || tar -xzf "gdb-$GDB_V.tar.gz"

if [ "$HOST" == "" ]; then
    HOST="$BUILD"
fi


if [ "$BUILD" == "$HOST" ]; then
    # Standard cross.
    CROSS_PREFIX=$INSTALL_PATH
else
    # Canadian cross.
    # The standard BUILD->TARGET cross-compiler will be installed into a separate prefix, as it is not
    # part of the distribution.
    mkdir -p cross_prefix
    CROSS_PREFIX="$(cd "$(dirname -- "cross_prefix")" >/dev/null; pwd -P)/$(basename -- "cross_prefix")"
    PATH="$CROSS_PREFIX/bin:$PATH"
    export PATH

    # Instead, the HOST->TARGET cross-compiler can be installed into the final installation path
    CANADIAN_PREFIX=$INSTALL_PATH
fi

if [ "$GDB_V" != "" ]; then
    pushd "gdb-$GDB_V"
    ./configure \
      --prefix="$INSTALL_PATH" \
      --target=mips64-elf --with-arch=vr4300 \
      --build="$BUILD" \
      --host="$HOST" \
      --disable-werror # \
      # CFLAGS="" LDFLAGS=""

    make -j "$JOBS"
    make install || sudo make install || su -c "make install"
    popd
fi

# Final message
echo
echo "***********************************************"
echo "Libdragon toolchain extras correctly built and installed"
echo "Installation directory: \"${N64_INST}\""
echo "Build directory: \"${BUILD_PATH}\" (can be removed now)"
