#!/bin/bash
# Copyright 2022 The IREE Authors
#
# Licensed under the Apache License v2.0 with LLVM Exceptions.
# See https://llvm.org/LICENSE.txt for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

set -euo pipefail

CCACHE_VERSION="$1"

ARCH="$(uname -m)"

if [[ "${ARCH}" == "x86_64" ]]; then
  curl --silent --fail --show-error --location \
      "https://github.com/ccache/ccache/releases/download/v${CCACHE_VERSION}/ccache-${CCACHE_VERSION}-linux-${ARCH}.tar.xz" \
      --output ccache.tar.xz

  tar xf ccache.tar.xz
  cp ccache-${CCACHE_VERSION}-linux-${ARCH}/ccache /usr/local/bin
elif [[ "${ARCH}" == "aarch64" ]]; then
  # Latest version of ccache is not released for arm64, built it
  git clone --depth 1 --branch "v${CCACHE_VERSION}" https://github.com/ccache/ccache.git
  mkdir -p ccache/build && cd "$_"
  cmake -G "Ninja" -DCMAKE_BUILD_TYPE=Release ..
  ninja
  cp ccache /usr/bin/
fi
