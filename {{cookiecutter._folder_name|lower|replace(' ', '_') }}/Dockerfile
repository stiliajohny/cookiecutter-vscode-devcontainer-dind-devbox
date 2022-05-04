# Note: You can use any Debian/Ubuntu based image you want.
FROM {{cookiecutter.dockerfile_FROM_image | lower }}

ARG INSTALL_ZSH="true" \
    UPGRADE_PACKAGES="true" \
    ENABLE_NONROOT_DOCKER="true" \
    USE_MOBY="true" \
    DOCKER_VERSION="latest" \
    PYTHON_PATH=/usr/local/sbin/python \
    USERNAME=automatic \
    USER_UID=1000 \
    USER_GID=$USER_UID \
    INSTALLED_PACKAGES=" {{ cookiecutter.dockerfile_FROM_image | lower }} "

ENV DOCKER_BUILDKIT=1 \
    PIPX_HOME=/usr/local/py-utils \
    PIPX_BIN_DIR=/usr/local/py-utils/bin \
    PATH=${PYTHON_PATH}/bin:${PATH}:${PIPX_BIN_DIR} \
    GOROOT=/usr/local/go \
    GOPATH=/go \
    PATH=${GOPATH}/bin:${GOROOT}/bin:${PATH} \
    DBUS_SESSION_BUS_ADDRESS="autolaunch:" \
    VNC_RESOLUTION="1920x1080x16" \
    VNC_DPI="96" \
    VNC_PORT="5901" \
    NOVNC_PORT="6080" \
    DISPLAY=":1" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8"

# Install additional OS packages.
RUN apt-get update && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get -y install --no-install-recommends $INSTALLED_PACKAGES

COPY library-scripts/*.sh /tmp/library-scripts/
COPY scripts/*.sh /tmp/scripts/
COPY library-scripts/kubectl-helm-debian.sh /tmp/library-scripts/
COPY library-scripts/awscli-debian.sh /tmp/library-scripts/
COPY library-scripts/python-debian.sh /tmp/library-scripts/
COPY library-scripts/go-debian.sh /tmp/library-scripts/
COPY library-scripts/terraform-debian.sh /tmp/library-scripts/
COPY library-scripts/desktop-lite-debian.sh /tmp/library-scripts/
COPY library-scripts/entrypoint.sh /home/vscode/entrypoint.sh



# RUN /bin/bash /tmp/scripts/*.sh && \
#     apt-get autoremove -y && apt-get clean -y && rm -rf /tmp/scripts

RUN /bin/bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "true" "true" \
    # Use Docker script from script library to set things up
    && /bin/bash /tmp/library-scripts/docker-in-docker-debian.sh "${ENABLE_NONROOT_DOCKER}" "${USERNAME}" "${USE_MOBY}" "${DOCKER_VERSION}"


# Install minikube kubectl and helm
# https://github.com/microsoft/vscode-dev-containers/blob/main/script-library/docs/kubectl-helm.md
RUN bash /tmp/library-scripts/kubectl-helm-debian.sh latest latest latest

# Install awscli
# https://github.com/microsoft/vscode-dev-containers/blob/main/script-library/docs/awscli.md
RUN bash /tmp/library-scripts/awscli-debian.sh

# Install python and packages
# https://github.com/microsoft/vscode-dev-containers/blob/main/script-library/docs/python.md
RUN apt-get update && bash /tmp/library-scripts/python-debian.sh "3.10" "${PYTHON_PATH}" "${PIPX_HOME}"

# Install kind
RUN curl -LO -o /tmp/kind ./kind https://kind.sigs.k8s.io/dl/v0.12.0/kind-linux-amd64 && \
    chmod +x /tmp/kind && \
    mv /tmp/kind /usr/local/bin/kind

# Install terraform, tflint and terragrunt
# https://github.com/microsoft/vscode-dev-containers/blob/main/script-library/docs/terraform.md
RUN apt-get update && bash /tmp/library-scripts/terraform-debian.sh

# Install Fluxbox
# https://github.com/microsoft/vscode-dev-containers/blob/main/script-library/docs/desktop-lite.md
RUN apt-get update && bash /tmp/library-scripts/desktop-lite-debian.sh

# Clean up
RUN apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

# Mount docker socket
VOLUME [ "/var/lib/docker" ]


ENTRYPOINT  [ "/home/vscode/entrypoint.sh" ]
CMD [ "sleep", "infinity" ]