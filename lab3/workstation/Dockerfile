FROM ubuntu:24.04

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    nano

RUN apt-get install -y \
    openssh-server \
    && mkdir /var/run/sshd

RUN apt-get install \
    sshpass

RUN rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash -g root -G sudo user \
    && chpasswd user:pass

EXPOSE 22

SHELL [ "/bin/bash", "-c" ]
ENTRYPOINT [ "sshd", "-D" ]
