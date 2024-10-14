FROM ubuntu:24.04

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    sudo \
    nano \
    rsync \
    python3 \
    python3-pip \
    python3-docker \
    python3-requests \
    openssh-server \
    docker.io \
    docker-compose

RUN rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash -g root -G sudo user \
    && echo "user:pass" | chpasswd \
    && echo "user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN mkdir /var/run/sshd

EXPOSE 22

SHELL [ "/bin/bash", "-c" ]
ENTRYPOINT [ "sshd", "-D" ]
