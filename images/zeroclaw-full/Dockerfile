# ZeroClaw Full Image
# ====================
# Minimal debian base + pre-compiled zeroclaw-daemon + essential tools.
# Binary is downloaded from our own release (cross-compiled on CI).
#
# Build:
#   docker build -t zeroclaw-full \
#     --build-arg VERSION=v0.8.0-beta-2 \
#     .
#
# Run:
#   docker run -d --name zeroclaw \
#     -v /path/to/config.yaml:/etc/zeroclaw/config.yaml \
#     zeroclaw-full

ARG VERSION=v0.8.0-beta-2
ARG REPO=lsynpy/zeroclaw-images

FROM debian:trixie-slim

ARG VERSION
ARG REPO

# ── locale / tzdata (non-interactive) ──
ENV DEBIAN_FRONTEND=noninteractive

# ── install tools ──
RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    git \
    python3 python3-pip \
    ssh \
    jq \
    vim \
    unzip \
    locales \
    && rm -rf /var/lib/apt/lists/* \
    && sed -i '/en_US.UTF-8/s/^# //' /etc/locale.gen \
    && locale-gen

ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

# ── download pre-compiled binary from our release ──
RUN curl -sL "https://github.com/${REPO}/releases/download/zeroclaw-daemon-${VERSION}/zeroclaw-daemon" \
    -o /usr/local/bin/zeroclaw-daemon \
    && chmod +x /usr/local/bin/zeroclaw-daemon

# ── entrypoint ──
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
