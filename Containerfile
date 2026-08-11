FROM ghcr.io/containerpak/wine:main

RUN apt update && \
    apt install -y --no-install-recommends lutris pciutils python3-protobuf && \
    ln -s /usr/games/lutris /usr/bin/lutris && \
    cpak-clean-junk
