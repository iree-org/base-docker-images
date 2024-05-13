#!/bin/bash
# Copyright 2024 The IREE Authors
#
# Licensed under the Apache License v2.0 with LLVM Exceptions.
# See https://llvm.org/LICENSE.txt for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

# Install the AMD GPU DRM libraries and Vulkan.
# In order to use this in the container, you must pass /dev/dri and /dev/kfd in as:
#   docker run --device=/dev/kfd --device=/dev/dri <docker ID>

set -euo pipefail

AMDGPU_VERSION=$1

ARCH="$(uname -m)"
if [[ "${ARCH}" == "x86_64" ]]; then
  apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ca-certificates curl libnuma-dev gnupg \
    && curl -sL https://repo.radeon.com/rocm/rocm.gpg.key | apt-key add - \
    && printf "deb [arch=amd64] https://repo.radeon.com/amdgpu/${AMDGPU_VERSION}/ubuntu focal main" | tee /etc/apt/sources.list.d/amdgpu.list \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    libdrm-amdgpu-dev \
    libdrm-dev
else
  echo "Installing ROCM for ${ARCH} is not supported yet."
fi

wget https://github.com/GPUOpen-Drivers/AMDVLK/releases/download/v-2023.Q3.1/amdvlk_2023.Q3.1_amd64.deb && \
    dpkg -i amdvlk_2023.Q3.1_amd64.deb
