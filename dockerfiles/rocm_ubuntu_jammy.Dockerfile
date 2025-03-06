# Extend the upstream ROCm image with IREE build dependencies.
# Installing dependencies on-demand at workflow run time can encounter
# periodic network/download issues.
FROM rocm/dev-ubuntu-22.04:6.3

RUN apt-get -y update && \
    apt-get install -y cmake ninja-build clang lld git

######## GIT CONFIGURATION ########
# Git started enforcing strict user checking, which thwarts version
# configuration scripts in a docker image where the tree was checked
# out by the host and mapped in. Disable the check.
# See: https://github.com/iree-org/iree/issues/12046
# We use the wildcard option to disable the checks. This was added
# in git 2.35.3
RUN git config --global --add safe.directory '*'

WORKDIR /
