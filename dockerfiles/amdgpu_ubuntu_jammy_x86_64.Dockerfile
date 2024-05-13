# Stock Ubuntu with AMDGPU deps.
# In order to use this in the container, you must pass /dev/dri in as:
#   --device /dev/dri
FROM ubuntu:jammy

# Basic packages.
RUN apt update && \
    apt install -y \
        wget python3.11 python3-pip git unzip curl gnupg2 lsb-release vulkan-tools && \
    update-alternatives --install /usr/local/bin/python python /usr/bin/python3.11 3 && \
    update-alternatives --install /usr/local/bin/python3 python3 /usr/bin/python3.11 3

# CMake
WORKDIR /install-cmake
# Install the latest CMake version we support
ARG CMAKE_VERSION="3.29.3"
COPY build_tools/install_cmake.sh ./
RUN ./install_cmake.sh "${CMAKE_VERSION}" && rm -rf /install-cmake

# AMD GPU DRM & Vulkan
WORKDIR /install-amdgpu
ARG AMDGPU_VERSION=6.1
COPY build_tools/install_amdgpu.sh ./
RUN ./install_amdgpu.sh "${AMDGPU_VERSION}" && rm -rf /install-amdgpu
WORKDIR /

# TheRock (ROCm)
WORKDIR /install-the-rock
COPY build_tools/install_the_rock.sh ./
RUN ./install_the_rock.sh \
#  && rm -rf /install-the-rock
WORKDIR /

# Clean up.
RUN apt clean && rm -rf /var/lib/apt/lists/*
