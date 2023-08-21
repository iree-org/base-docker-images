# We build our portable linux releases on the manylinux (RHEL-based)
# images, with custom additional packages installed. We switch to
# new upstream versions as needed.
FROM quay.io/pypa/manylinux_2_28_x86_64@sha256:8ab319e0ecea2f642b2436dbf736993f1af3051186d2e2fd27ac79a461f47191

RUN yum install -y epel-release && \
    yum install -y ccache clang lld && \
    yum install -y capstone-devel tbb-devel libzstd-devel && \
    yum clean all && \
    rm -rf /var/cache/yum
