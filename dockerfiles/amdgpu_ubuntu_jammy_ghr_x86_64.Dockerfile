# GitHub Actions Runner with AMDGPU deps.
# In order to use this in the container, you must pass /dev/dri in as:
#   --device /dev/dri
FROM docker.io/myoung34/github-runner:ubuntu-jammy

# Basic packages.
RUN apt update && \
    apt install -y \
        wget python3.11 git unzip curl gnupg2 lsb-release vulkan-tools && \
    update-alternatives --install /usr/local/bin/python python /usr/bin/python3.11 3 && \
    update-alternatives --install /usr/local/bin/python3 python3 /usr/bin/python3.11 3

# Install the AMDVLK driver.
WORKDIR /install-amdvlk
RUN wget https://github.com/GPUOpen-Drivers/AMDVLK/releases/download/v-2023.Q3.1/amdvlk_2023.Q3.1_amd64.deb && \
    dpkg -i amdvlk_2023.Q3.1_amd64.deb && \
    rm -rf /install-amdvlk/*
WORKDIR /
RUN rmdir /install-amdvlk

# Install the ROCM driver.
# In order to use this in the container, you must pass /dev/dri and /dev/kfd in as:
#   docker run --device=/dev/kfd --device=/dev/dri <docker ID> rocminfo
ARG ROCM_VERSION=5.6
WORKDIR /install-rocm
RUN mkdir --parents --mode=0755 /etc/apt/keyrings && wget https://repo.radeon.com/rocm/rocm.gpg.key -O - | \
    gpg --dearmor | tee /etc/apt/keyrings/rocm.gpg > /dev/null && \
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/rocm.gpg] https://repo.radeon.com/amdgpu/${ROCM_VERSION}/ubuntu jammy main" | \
    tee /etc/apt/sources.list.d/amdgpu.list && \
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/rocm.gpg] https://repo.radeon.com/rocm/apt/${ROCM_VERSION} jammy main" | \
    tee /etc/apt/sources.list.d/rocm.list && \
    echo -e 'Package: *\nPin: release o=repo.radeon.com\nPin-Priority: 600' | tee /etc/apt/preferences.d/rocm-pin-600 && \
    apt update && DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends ca-certificates rocm-hip-libraries && \
    echo "/opt/rocm/lib\n/opt/rocm/hip/lib" | tee /etc/ld.so.conf.d/24-rocm.conf && ldconfig && \
    rm -rf /install-rocm/*
WORKDIR /
RUN rmdir /install-rocm/

# Switch back to the working directory upstream expects.
WORKDIR /actions-runner
