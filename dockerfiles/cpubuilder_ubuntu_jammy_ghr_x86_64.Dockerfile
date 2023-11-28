# GitHub Actions Runner with IREE build deps.
FROM docker.io/myoung34/github-runner:ubuntu-jammy

# Apt packages.
RUN apt update && \
    apt install -y \
        wget python3.11 git unzip curl gnupg2 lsb-release && \
    update-alternatives --install /usr/local/bin/python python /usr/bin/python3.11 3 && \
    update-alternatives --install /usr/local/bin/python3 python3 /usr/bin/python3.11 3 && \
    apt install -y \
        ccache clang-14 lld-14 libssl-dev ninja-build libxml2-dev llvm-dev pkg-config \
        libcapstone-dev libtbb-dev libzstd-dev && \
    apt install -y \
        libboost-all-dev && \
    apt clean && rm -rf /var/lib/apt/lists/*

# Python deps.
# It is expected the venvs get set up for real deployment needs.
# These are just basic deps for running automation.
RUN python -m pip --no-cache-dir install --upgrade pip && \
    python -m pip --no-cache-dir install \
        numpy==1.26.2 \
        requests==2.31.0 \
        setuptools==59.6.0 \
        PyYAML==5.4.1

# CMake.
# Version 3.23 has support for presets v4, needed for out of tree
# configurations.
RUN curl --silent --fail --show-error --location \
        "https://github.com/Kitware/CMake/releases/download/v3.23.2/cmake-3.23.2-linux-x86_64.sh" \
        --output /cmake-installer.sh && \
    bash /cmake-installer.sh --skip-license --prefix=/usr && \
    rm -f /cmake-installer.sh

# Setup symlinks and alternatives.
RUN ln -s /usr/bin/lld-14 /usr/bin/lld && \
    ln -s /usr/bin/ld.lld-14 /usr/bin/ld.lld && \
    ln -s /usr/bin/clang-14 /usr/bin/clang && \
    ln -s /usr/bin/clang++-14 /usr/bin/clang++

# Environment.
ENV CC=clang
ENV CXX=clang++

# Switch back to the working directory upstream expects.
WORKDIR /actions-runner
