# syntax=docker/dockerfile:1
# V0 - Use this comment to force a re-build without changing the contents

# Stage 1 - Build the toolchain
FROM debian:stable-slim AS toolchain-builder
# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Install required dependencies
RUN apt-get update \
    && apt-get -y install --no-install-recommends apt-utils \
    && apt-get install -y \
    curl \
    bzip2 \
    make \
    file \
    libmpfr-dev \
    libmpc-dev \
    zlib1g-dev \
    texinfo \
    git \
    gcc \
    g++

ARG N64_INST=/n64_toolchain
ENV N64_INST=${N64_INST}

# Build
COPY ./tools/build-toolchain.sh /tmp/tools/build-toolchain.sh
WORKDIR /tmp/tools
RUN ./build-toolchain.sh

# Remove locale strings which are not so important in our use case
RUN rm -rf ${N64_INST}/share/locale/*

# Stage 2 - Prepare minimal image
FROM debian:stable-slim
# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive
# Setup paths for the libgragon toolchain
ARG N64_INST=/n64_toolchain
ENV N64_INST=${N64_INST}
ENV PATH="${N64_INST}/bin:$PATH"

# Install dependencies for building libdragon tools and ROMS (using makefiles and CMake)
# and (commented out) ability to use it as a vs-code devcontainer.
RUN apt-get update && \
    apt-get -y install --no-install-recommends apt-utils dialog icu-devtools 2>&1 &&\
    apt-get install -yq \
    gcc \
    g++ \
    make \
    libpng-dev \
    git \
    curl \
    cmake \
    ninja-build

COPY --from=toolchain-builder ${N64_INST} ${N64_INST}

# Clean up downloaded files
RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog
