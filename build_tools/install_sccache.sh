#!/bin/bash
# Copyright 2022 The IREE Authors
#
# Licensed under the Apache License v2.0 with LLVM Exceptions.
# See https://llvm.org/LICENSE.txt for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

set -xeuo pipefail

SCCACHE_VERSION="$1"

ARCH="$(uname -m)"

curl --silent --fail --show-error --location \
    "https://github.com/mozilla/sccache/releases/download/v${SCCACHE_VERSION}/sccache-v${SCCACHE_VERSION}-${ARCH}-unknown-linux-musl.tar.gz" \
    --output sccache.tar.gz

tar xf sccache.tar.gz
cp sccache-v${SCCACHE_VERSION}-${ARCH}-unknown-linux-musl/sccache /usr/local/bin
