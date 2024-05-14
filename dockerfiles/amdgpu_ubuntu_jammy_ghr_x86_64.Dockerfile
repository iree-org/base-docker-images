# GitHub Actions Runner with AMDGPU deps.
# In order to use this in the container, you must pass /dev/dri in as:
#   --device /dev/dri
FROM docker.io/myoung34/github-runner:2.314.1-ubuntu-jammy

# Basic packages.
WORKDIR /install-base
COPY build_tools/install_base.sh ./
RUN ./install_base.sh "${CMAKE_VERSION}" && rm -rf /install-base

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

# TheRock (ROCm)
WORKDIR /install-the-rock
COPY build_tools/install_the_rock.sh ./
RUN ./install_the_rock.sh \
  && rm -rf /install-the-rock

# OpenMPI
WORKDIR /install-openmpi
COPY build_tools/install_openmpi.sh ./
RUN ./install_openmpi.sh \
  && rm -rf /install-openmpi

# Switch back to the working directory upstream expects.
WORKDIR /actions-runner
