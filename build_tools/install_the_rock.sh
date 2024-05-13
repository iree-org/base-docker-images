#!/bin/bash
# Copyright 2024 The IREE Authors
#
# Licensed under the Apache License v2.0 with LLVM Exceptions.
# See https://llvm.org/LICENSE.txt for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

# Build and install the parts of ROCm that are required by IREE.

set -euo pipefail

THE_ROCK_GIT_REFSPEC=${THE_ROCK_GIT_REFSPEC:-rocm-6.1.0}
THE_ROCK_ROCM_MANIFEST_URL=${THE_ROCK_ROCM_MANIFEST_URL:-https://github.com/ROCm/ROCm.git}
THE_ROCK_ROCM_MANIFEST_BRANCH=${THE_ROCK_ROCM_MANIFEST_BRANCH:-refs/tags/rocm-6.1.0}

ARCH="$(uname -m)"

if [[ "${ARCH}" != "x86_64" ]]; then
  echo "Installing TheRock (ROCm) for ${ARCH} is not supported yet."
  exit 0
fi

if [ ! -d TheRock ]; then
  git clone https://github.com/nod-ai/TheRock.git \
    --branch $THE_ROCK_GIT_REFSPEC \
    --depth 1
  cd TheRock
else
  cd TheRock
  git fetch --depth 1 origin $THE_ROCK_GIT_REFSPEC
  git checkout FETCH_HEAD
fi

apt update
apt install -y \
  repo git-lfs libnuma-dev ninja-build g++ pkg-config libdrm-dev \
  libelf-dev xxd libgl1-mesa-dev
python -m pip install CppHeaderParser

# Make sure git does not report Committer identity unknown errors.
# export GIT_COMMITTER_NAME="Noname"
# export GIT_AUTHOR_NAME="$GIT_COMMITTER_NAME"
# export GIT_COMMITTER_EMAIL="noname@email.com"
# export GIT_AUTHOR_EMAIL="$GIT_COMMITTER_EMAIL"
# export GIT_TERMINAL_PROMPT=0
# The buggy repo tool does not respect the above commented vars,
# so it asks us about our idenity.
git config --global user.email "Noname"
git config --global user.name "noname@email.com"

git config --global color.ui true
export GIT_TERMINAL_PROMPT=0

python ./build_tools/fetch_sources.py \
  --manifest-url $THE_ROCK_ROCM_MANIFEST_URL \
  --manifest-branch $THE_ROCK_ROCM_MANIFEST_BRANCH

# The build fails with clang-19.
export CC=gcc
export CXX=g++

cmake -B build \
  -GNinja \
  -DCMAKE_INSTALL_PREFIX=/usr/local \
  .

cmake --build build

cmake --install build --component amdgpu-runtime
cmake --install build --component amdgpu-runtime-dev
cmake --install build --component amdgpu-compiler
