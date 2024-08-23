# Stock Ubuntu with IREE build deps.
FROM ubuntu:jammy

######## Basic apt packages ########
RUN apt update && \
    apt install -y \
        wget python3.11-dev python3-pip git unzip curl gnupg2 lsb-release && \
    update-alternatives --install /usr/local/bin/python python /usr/bin/python3.11 3 && \
    update-alternatives --install /usr/local/bin/python3 python3 /usr/bin/python3.11 3 && \
    apt install -y \
        ccache clang-14 lld-14 libssl-dev ninja-build libxml2-dev llvm-dev pkg-config \
        libcapstone-dev libtbb-dev libzstd-dev && \
    apt clean && rm -rf /var/lib/apt/lists/*

######## CMake ########
WORKDIR /install-cmake
# Install our minimum supported CMake version.
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
