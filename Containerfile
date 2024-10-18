FROM registry.access.redhat.com/ubi9-minimal
ARG USER_HOME_DIR="/home/user"

ENV HOME=${USER_HOME_DIR}
ENV BUILDAH_ISOLATION=chroot

COPY --chown=0:0 entrypoint.sh /

RUN microdnf --disableplugin=subscription-manager install -y openssl git tar shadow-utils bash zsh podman buildah skopeo fuse-overlayfs ; \
    microdnf update -y ; \
    microdnf clean all ; \
    mkdir -p ${USER_HOME_DIR} ; \
    chgrp -R 0 /home ; \
    #
    # Setup for root-less podman
    #
    mkdir -p "${HOME}"/.config/containers ; \
    setcap cap_setuid+ep /usr/bin/newuidmap ; \
    setcap cap_setgid+ep /usr/bin/newgidmap ; \
    touch /etc/subgid /etc/subuid ; \
    chown 0:0 /etc/subgid ; \
    chown 0:0 /etc/subuid ; \
    chown 0:0 /etc/passwd ; \
    chown 0:0 /etc/group ; \
    chmod +x /entrypoint.sh ; \
    chmod -R g=u /etc/passwd /etc/group /etc/subuid /etc/subgid /home

WORKDIR ${HOME}
ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["/bin/bash","-c","podman build -t test:test -f ./image/Containerfile ."]

