FROM debian

ENV ARCH=amd64
ENV S6_VERSION=2.1.0.2

ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

# update packages
RUN apt-get update \
  && apt-get install -y \
    tzdata apt-utils locales locales-all \
    curl git ssh nano zsh fonts-powerline \
  && locale-gen en_US.UTF-8

# install s6-overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-${ARCH}-installer /tmp/
RUN chmod +x /tmp/s6-overlay-${ARCH}-installer && /tmp/s6-overlay-${ARCH}-installer / \
  && rm -rf /tmp/s6-overlay-${ARCH}-installer

# config user
RUN useradd -u 911 -U -d /config -s /bin/false thinhhoang \
  && usermod -G users thinhhoang \
  && mkdir -p /app /config /defaults

# clean
RUN apt-get clean \
  && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

COPY rootfs /

ENTRYPOINT [ "/init" ]
