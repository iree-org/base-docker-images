# Stock Ubuntu Jammy (22.04) with IREE build dependencies.
FROM ubuntu:jammy

ARG TARGETARCH
ARG TARGETPLATFORM

######## Apt packages ########
RUN apt update && \
    apt install -y wget git unzip curl gnupg2 lsb-release
# Python 3.
RUN apt install -y python3.11-dev python3.11-venv python3-pip && \
    update-alternatives --install /usr/local/bin/python python /usr/bin/python3.11 3 && \
    update-alternatives --install /usr/local/bin/python3 python3 /usr/bin/python3.11 3
# Toolchains and build dependencies.
RUN apt update && \
    apt install -y \
        clang-14 lld-14 \
        gcc-9 g++-9 \
        ninja-build libssl-dev libxml2-dev libcapstone-dev libtbb-dev \
        libzstd-dev llvm-dev pkg-config
# TODO: re-enable this when LLVM apt packages are working again
# Recent compiler tools for build configurations like ASan/TSan.
#   * See https://apt.llvm.org/ for context on the apt commands.
# ARG LLVM_VERSION=19
# RUN echo "deb http://apt.llvm.org/jammy/ llvm-toolchain-jammy-${LLVM_VERSION} main" >> /etc/apt/sources.list && \
#     curl https://apt.llvm.org/llvm-snapshot.gpg.key | gpg --dearmor > /etc/apt/trusted.gpg.d/llvm-snapshot.gpg && \
#     apt update && \
#     apt install -y clang-${LLVM_VERSION} lld-${LLVM_VERSION}
# Cleanup.
RUN apt clean && rm -rf /var/lib/apt/lists/*

######## CMake ########
WORKDIR /install-cmake
ENV CMAKE_VERSION="3.23.2"
COPY build_tools/install_cmake.sh ./
RUN ./install_cmake.sh "${CMAKE_VERSION}" && rm -rf /install-cmake

######## Build toolchain configuration ########
# Setup symlinks and alternatives then default to using clang-14.
# This can be overriden to gcc or another clang version as needed.
RUN ln -s /usr/bin/lld-14 /usr/bin/lld && \
    ln -s /usr/bin/ld.lld-14 /usr/bin/ld.lld && \
    ln -s /usr/bin/clang-14 /usr/bin/clang && \
    ln -s /usr/bin/clang++-14 /usr/bin/clang++
ENV CC=clang
ENV CXX=clang++

######## CCache ########
WORKDIR /install-ccache
COPY build_tools/install_ccache.sh ./
RUN ./install_ccache.sh "4.10.2" && rm -rf /install-ccache

######## sccache ########
WORKDIR /install-sccache
COPY build_tools/install_sccache.sh ./
RUN ./install_sccache.sh "0.8.1" && rm -rf /install-sccache

######## target-architecture-specific installs ########
WORKDIR /install-target-arch
COPY build_tools/install_arch_extras_${TARGETARCH}.sh ./
RUN ./install_arch_extras_${TARGETARCH}.sh && rm -rf /install-target-arch

WORKDIR /
