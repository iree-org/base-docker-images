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
    && sudo rm -rf /var/lib/apt/lists/*

# git lfs install
RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash && \
    sudo apt-get install git-lfs
