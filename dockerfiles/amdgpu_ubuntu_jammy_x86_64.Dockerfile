# Stock Ubuntu with AMDGPU deps.
# In order to use this in the container, you must pass /dev/dri in as:
#   --device /dev/dri
FROM ubuntu:jammy

# Basic packages.
RUN apt update && \
    apt install -y \
        wget python3.11 git unzip curl gnupg2 lsb-release vulkan-tools && \
    update-alternatives --install /usr/local/bin/python python /usr/bin/python3.11 3 && \
    update-alternatives --install /usr/local/bin/python3 python3 /usr/bin/python3.11 3

# Install the AMDVLK driver.
# In order to use this in the container, you must pass /dev/dri in as:
#   --device /dev/dri
WORKDIR /install-amdvlk
RUN wget https://github.com/GPUOpen-Drivers/AMDVLK/releases/download/v-2023.Q3.1/amdvlk_2023.Q3.1_amd64.deb && \
    dpkg -i amdvlk_2023.Q3.1_amd64.deb && \
    rm -rf /install-amdvlk/*
WORKDIR /
RUN rmdir /install-amdvlk

# Clean up.
RUN apt clean && rm -rf /var/lib/apt/lists/*
