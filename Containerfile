# Using a multi-stage build here just to provide an example of how a cpak
# should be built.
# FIXME: (WIP) This image needs fixing, as it is including a lot of nnecessary
# packages in the build stage.

# 1.0 BUILD
# 1.1 Use the proper SDK as the base image
FROM ghcr.io/containerpak/gtk-sdk:main AS builder
#FROM cpak/gtk-sdk AS builder

# 1.2 Install any build dependencies not provided by the SDK
# FIXME: some of the following packages may not be necessary
RUN apt install -y \
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
  wget \
  lsof \
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
  gettext \
  pciutils \
  mangohud

# 1.3 Build the application
RUN wget https://github.com/lutris/lutris/archive/refs/tags/v0.5.16.tar.gz && \
  tar -xvf v0.5.16.tar.gz && \
  cd lutris-0.5.16 && \
  meson --prefix=/app build && \
  ninja -C build && \
  ninja -C build install && \
  cd .. && \
  rm -rf lutris-0.5.16 && \
  rm v0.5.16.tar.gz

# 2.0 DIST
# 2.1 Use the proper platform as the base image
#FROM ghcr.io/containerpak/gtk:main
FROM cpak/gtk

# 2.2 Copy the built application from the builder image
COPY --from=builder /app /usr/

# 2.3 Install any runtime dependencies not provided by the platform
RUN apt install -y \
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
  lsof \
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
  gettext \
  pciutils \
  mangohud && \
  # 2.4 Clean up any junk that may have been left behind
  /usr/bin/cpak-clean-junk