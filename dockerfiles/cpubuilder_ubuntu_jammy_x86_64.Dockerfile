# Stock Ubuntu with IREE build deps.
FROM ubuntu:jammy

######## Basic apt packages ########
RUN apt update && \
    apt install -y \
        wget git unzip curl gnupg2 lsb-release && \
    apt install -y \
        ccache clang-14 lld-14 libssl-dev ninja-build libxml2-dev llvm-dev pkg-config \
        libcapstone-dev libtbb-dev libzstd-dev
# Python
RUN apt install -y python3.11-dev python3.11-venv python3-pip && \
    update-alternatives --install /usr/local/bin/python python /usr/bin/python3.11 3 && \
    update-alternatives --install /usr/local/bin/python3 python3 /usr/bin/python3.11 3
# Toolchains and build deps
RUN apt install -y \
        ccache ninja-build clang-14 lld-14 gcc-9 g++-9 \
        libssl-dev libxml2-dev libcapstone-dev libtbb-dev libzstd-dev \
        llvm-dev pkg-config
# Cleanup
RUN apt clean && rm -rf /var/lib/apt/lists/*

######## CMake ########
WORKDIR /install-cmake
ENV CMAKE_VERSION="3.23.2"
COPY build_tools/install_cmake.sh ./
RUN ./install_cmake.sh "${CMAKE_VERSION}" && rm -rf /install-cmake

######## Build toolchain configuration ########
# Setup symlinks and alternatives.
RUN ln -s /usr/bin/lld-14 /usr/bin/lld && \
    ln -s /usr/bin/ld.lld-14 /usr/bin/ld.lld && \
    ln -s /usr/bin/clang-14 /usr/bin/clang && \
    ln -s /usr/bin/clang++-14 /usr/bin/clang++
# Default to using clang. This can be overriden to gcc as desired.
ENV CC=clang
ENV CXX=clang++

WORKDIR /
