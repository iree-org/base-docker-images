# Stock Ubuntu Noble (24.04) with IREE build dependencies.
FROM ubuntu:noble

ARG TARGETARCH
ARG TARGETPLATFORM

######## Apt packages ########
RUN apt update
RUN apt install -y wget git unzip curl gnupg2 lsb-release
# Python 3, using the default version (3.12).
# We could also install a specific version like 3.11.
RUN apt install -y python3-dev python3-venv python3-pip
# Toolchains and build dependencies.
# Recent version of clang to pick up the latest features for ASan/TSan/etc.
RUN apt install -y clang-18 lld-18 llvm-dev
# Recent version of gcc, aiming to be close to what the manylinux image includes.
RUN apt install -y gcc-14 g++-14
RUN apt install -y \
    libcapstone-dev libssl-dev libtbb-dev libxml2-dev libzstd-dev ninja-build pkg-config
# Cleanup.
RUN apt clean && rm -rf /var/lib/apt/lists/*

######## CMake ########
WORKDIR /install-cmake
ENV CMAKE_VERSION="3.31.4"
COPY build_tools/install_cmake.sh ./
RUN ./install_cmake.sh "${CMAKE_VERSION}" && rm -rf /install-cmake

######## Build toolchain configuration ########
# Setup symlinks then default to using clang.
# This can be overriden to gcc or another clang version as needed.
RUN ln -s /usr/bin/lld-18 /usr/bin/lld && \
    ln -s /usr/bin/ld.lld-18 /usr/bin/ld.lld && \
    ln -s /usr/bin/clang-18 /usr/bin/clang && \
    ln -s /usr/bin/clang++-18 /usr/bin/clang++
ENV CC=clang
ENV CXX=clang++

######## CCache ########
WORKDIR /install-ccache
COPY build_tools/install_ccache.sh ./
RUN ./install_ccache.sh "4.10.2" && rm -rf /install-ccache

######## sccache ########
WORKDIR /install-sccache
COPY build_tools/install_sccache.sh ./
RUN ./install_sccache.sh "0.9.1" && rm -rf /install-sccache

######## target-architecture-specific installs ########
WORKDIR /install-target-arch
COPY build_tools/install_arch_extras_${TARGETARCH}.sh ./
RUN ./install_arch_extras_${TARGETARCH}.sh && rm -rf /install-target-arch

WORKDIR /
