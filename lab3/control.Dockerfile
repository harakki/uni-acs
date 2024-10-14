FROM ubuntu:24.04

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    nano \
    rsync \
    python3 \
    python3-pip \
    ssh-client \
    sshpass \
    ansible

RUN rm -rf /var/lib/apt/lists/*

SHELL [ "/bin/bash", "-c" ]
ENTRYPOINT [ "tail", "-f", "/dev/null" ]
