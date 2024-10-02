# We build our portable linux releases on the manylinux (RHEL-based)
# images, with custom additional packages installed. We switch to
# new upstream versions as needed.
# See https://github.com/pypa/manylinux and https://quay.io/organization/pypa.
FROM quay.io/pypa/manylinux_2_28_x86_64@sha256:cea0ade79068b36deae7eb7a04b4192e5ba2761d045ba5a92ba36eb5ce5f88b6

RUN yum install -y epel-release && \
    yum install -y ccache clang lld && \
    yum install -y capstone-devel tbb-devel libzstd-devel && \
    yum clean all && \
    rm -rf /var/cache/yum

######## GIT CONFIGURATION ########
# Git started enforcing strict user checking, which thwarts version
# configuration scripts in a docker image where the tree was checked
# out by the host and mapped in. Disable the check.
# See: https://github.com/iree-org/iree/issues/12046
# We use the wildcard option to disable the checks. This was added
# in git 2.35.3
RUN git config --global --add safe.directory '*'

WORKDIR /
