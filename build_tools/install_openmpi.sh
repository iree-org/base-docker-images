#!/bin/bash

# Copyright 2024 The IREE Authors
#
# Licensed under the Apache License v2.0 with LLVM Exceptions.
# See https://llvm.org/LICENSE.txt for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

# Needed by IREE E2E collectives tests.

set -euo pipefail

apt update
apt install -y libopenmpi-dev

# Needs to run after installing openmpi as it will build against it.
python -m pip install --no-cache-dir mpi4py
