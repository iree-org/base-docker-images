FROM ghcr.io/actions/actions-runner:latest

# base dependencies
RUN sudo apt-get update -y \
    && sudo apt-get install -y software-properties-common \
    && sudo add-apt-repository -y ppa:git-core/ppa \
    && sudo apt-get update -y \
    && sudo apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    git \
    jq \
    sudo \
    unzip \
    zip \
    cmake \
    ninja-build \
    clang \
    lld \
    wget \
    psmisc \
    python3-setuptools \
    python3-wheel \
    libpython3.10 \
    python3.10-venv \
    && sudo rm -rf /var/lib/apt/lists/*

# git lfs install
RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash && \
    sudo apt-get install git-lfs

RUN sudo groupadd -g 109 render

# ROCm install
RUN sudo apt update -y \
    && sudo usermod -a -G render,video runner \
    && wget https://repo.radeon.com/amdgpu-install/6.4/ubuntu/jammy/amdgpu-install_6.4.60400-1_all.deb \
    && sudo apt install -y ./amdgpu-install_6.4.60400-1_all.deb \
    && sudo apt update -y \
    && sudo apt install -y rocm-dev
