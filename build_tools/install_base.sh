#!/bin/bash

# Copyright 2024 The IREE Authors
#
# Licensed under the Apache License v2.0 with LLVM Exceptions.
# See https://llvm.org/LICENSE.txt for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

# Basic packages.

set -euo pipefail

apt update
apt install -y \
        wget python3.11-dev python3-pip git unzip curl gnupg2 \
        lsb-release vulkan-tools && \
    update-alternatives --install /usr/local/bin/python python /usr/bin/python3.11 3 && \
    update-alternatives --install /usr/local/bin/python3 python3 /usr/bin/python3.11 3

apt clean && rm -rf /var/lib/apt/lists/*
