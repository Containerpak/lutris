# 1. BUILD
FROM ghcr.io/containerpak/gtk-sdk:main AS builder
ARG VERSION=0.5.18
WORKDIR /src

RUN apt update && apt install -y --no-install-recommends \
    python3-yaml \
    python3-lxml \
    python3-requests \
    python3-pil \
    python3-gi \
    python3-gi-cairo \
    python3-setproctitle \
    python3-magic \
    python3-distro \
    python3-dbus \
    gir1.2-gtk-3.0 \
    gir1.2-webkit2-4.0 \
    gir1.2-notify-0.7 \
    meson \
    ninja-build \
    wget \
    tar \
    make \
    build-essential

RUN wget -O lutris.tar.gz "https://github.com/lutris/lutris/archive/refs/tags/v${VERSION}.tar.gz" && \
    tar -xf lutris.tar.gz --strip-components=1 && \
    rm lutris.tar.gz

RUN meson --prefix=/app build && \
    ninja -C build && \
    ninja -C build install && \
    rm -rf build


# 2. RUNTIME
FROM ghcr.io/containerpak/gtk:main
COPY --from=builder /app /usr/

RUN apt update && apt install -y --no-install-recommends \
    python3-yaml \
    python3-lxml \
    python3-requests \
    python3-pil \
    python3-gi \
    python3-gi-cairo \
    python3-setproctitle \
    python3-magic \
    python3-distro \
    python3-dbus \
    gir1.2-gtk-3.0 \
    gir1.2-webkit2-4.0 \
    gir1.2-notify-0.7 && \
    cpak-clean-junk

ENTRYPOINT ["/usr/bin/lutris"]
