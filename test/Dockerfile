FROM ubuntu:24.04

ARG USERNAME=testuser
ARG UID=1000

RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      sudo git curl ca-certificates && \
    rm -rf /var/lib/apt/lists/* && \
    userdel -r ubuntu 2>/dev/null || true

RUN useradd -m -u ${UID} -s /bin/bash ${USERNAME} && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} && \
    chmod 0440 /etc/sudoers.d/${USERNAME}

USER ${USERNAME}
WORKDIR /home/${USERNAME}
