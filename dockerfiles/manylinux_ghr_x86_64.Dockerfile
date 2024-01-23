# We build our portable linux releases on the manylinux (RHEL-based)
# images, with custom additional packages installed. We switch to
# new upstream versions as needed.
FROM quay.io/pypa/manylinux_2_28_x86_64

ARG GH_RUNNER_VERSION="2.312.0"
ARG TARGETPLATFORM

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

######## Python setup #######
# These images come with multiple python versions. We pin one for
# default use.
ENV PATH="/opt/python/cp311-cp311/bin:${PATH}"

######## User setup #######
RUN groupadd -g 121 runner \
  && useradd -mr -d /home/runner -u 1001 -g 121 runner \
  && usermod -aG wheel runner \
  && echo '%sudo ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

######## GIT CONFIGURATION ########
# Git started enforcing strict user checking, which thwarts version
# configuration scripts in a docker image where the tree was checked
# out by the host and mapped in. Disable the check.
# See: https://github.com/openxla/iree/issues/12046
# We use the wildcard option to disable the checks. This was added
# in git 2.35.3
RUN git config --global --add safe.directory '*'

######## Stage files ########
ENV AGENT_TOOLSDIRECTORY=/opt/hostedtoolcache
RUN mkdir -p /opt/hostedtoolcache
RUN mkdir -p /actions-runner
WORKDIR /actions-runner
COPY docker-github-actions-runner/install_actions.sh /actions-runner
RUN chmod +x /actions-runner/install_actions.sh
COPY docker-github-actions-runner/token.sh docker-github-actions-runner/entrypoint.sh docker-github-actions-runner/app_token.sh /
RUN chmod +x /token.sh /entrypoint.sh /app_token.sh

######## Install Packages #######
# First we enable yum (epel-release), then install deps for GHR,
# then common build deps.
# Note that the actions-runner install script does yum transactions.
RUN yum install -y epel-release && \
    yum install -y dumb-init jq && \
    yum install -y ccache ninja-build clang lld && \
    yum install -y capstone-devel tbb-devel libzstd-devel && \
    yum install -y boost-devel && \
    /actions-runner/install_actions.sh ${GH_RUNNER_VERSION} ${TARGETPLATFORM} && \
    yum clean all && \
    rm -rf /var/cache/yum

######## CMake ########
WORKDIR /install-cmake

# Install our minimum supported CMake version, which may be ahead of apt-get's version.
ENV CMAKE_VERSION="3.23.2"

COPY build_tools/install_cmake.sh ./
RUN ./install_cmake.sh "${CMAKE_VERSION}" && rm -rf /install-cmake

######## GHR Setup ########
# The cwd must be /actions-runner for the entrypoint to work.

WORKDIR /actions-runner
RUN chown runner /_work /actions-runner /opt/hostedtoolcache
ENTRYPOINT ["/entrypoint.sh"]
CMD ["./bin/Runner.Listener", "run", "--startuptype", "service"]
