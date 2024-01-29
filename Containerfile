FROM ghcr.io/containerpak/gtk:main
ARG DEBIAN_FRONTEND=noninteractive
RUN dpkg --add-architecture i386 && \
  apt update && \
  apt install -y \
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
  psmisc \
  cabextract \
  unzip \
  p7zip \
  curl \
  fluid-soundfont-gs \
  x11-xserver-utils \
  mesa-utils \
  vulkan-tools \
  python3-evdev \
  python3-protobuf \
  gvfs-backends \
  libwine-development \
  winetricks \
  fluidsynth \
  gamescope \
  gamemode \
  xdg-desktop-portal \
  xdg-desktop-portal-gtk \
  appstream \
  meson && \
  /usr/bin/cpak-clean-junk
RUN apt install -y wget lsof pciutils mangohud && \
  wget https://github.com/lutris/lutris/archive/refs/tags/v0.5.16.tar.gz && \
  tar -xvf v0.5.16.tar.gz && \
  cd lutris-0.5.16 && \
  meson --prefix=/usr build && \
  ninja -C build && \
  ninja -C build install && \
  cd .. && \
  rm -rf lutris-0.5.16 && \
  rm v0.5.16.tar.gz
  
