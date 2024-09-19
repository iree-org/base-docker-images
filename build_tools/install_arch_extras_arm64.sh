#!/bin/bash
# Copyright 2024 The IREE Authors
#
# Licensed under the Apache License v2.0 with LLVM Exceptions.
# See https://llvm.org/LICENSE.txt for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

set -euo pipefail

# QEMU for aarch64
wget --no-verbose "https://sharkpublic.blob.core.windows.net/sharkpublic/GCP-Migration-Files/qemu-aarch64"
chmod +x ./qemu-aarch64
mv ./qemu-aarch64 /usr/bin/qemu-aarch64
