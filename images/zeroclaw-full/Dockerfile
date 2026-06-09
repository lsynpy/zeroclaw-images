# ZeroClaw Full Image — Developer Tools Edition
# ==============================================
# Debian slim base + ZeroClaw daemon + Rust/Python development tools.
# Binary is downloaded from our own release (cross-compiled on CI).
#
# Build:
#   docker build -t zeroclaw-full \
#     --build-arg VERSION=v0.8.0-beta-2 \
#     --build-arg VARIANT=minimal \
#     .
#
# Run:
#   docker run -d --name zeroclaw \
#     -v /path/to/data:/zeroclaw-data \
#     zeroclaw-full

ARG VERSION=v0.8.0-beta-2
ARG VARIANT=minimal
ARG REPO=lsynpy/zeroclaw-images

FROM debian:trixie-slim

ARG VERSION
ARG VARIANT
ARG REPO
ARG TARGETARCH

# ── locale / tzdata (non-interactive) ──
ENV DEBIAN_FRONTEND=noninteractive

# ── install system packages ──
RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    git \
    python3 python3-pip \
    ssh \
    jq \
    vim \
    unzip \
    xz-utils \
    locales \
    && rm -rf /var/lib/apt/lists/* \
    && sed -i '/en_US.UTF-8/s/^# //' /etc/locale.gen \
    && locale-gen

ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

# ── Rust-based Python tools (via pip — pre-compiled Rust binaries) ──
RUN pip3 install --break-system-packages --no-cache-dir \
    ruff \
    ty \
    rumdl

# ── Pre-compiled Rust CLI tools (download from GitHub releases) ──

# ripgrep (rg) — code search
RUN ARCH=$(case "$TARGETARCH" in amd64) echo "x86_64" ;; arm64) echo "aarch64" ;; esac) \
    && curl -sL "https://github.com/BurntSushi/ripgrep/releases/download/14.1.1/ripgrep-14.1.1-${ARCH}-unknown-linux-gnu.tar.gz" \
    | tar xz -C /usr/local/bin --strip-components=1 "ripgrep-14.1.1-${ARCH}-unknown-linux-gnu/rg"

# fd — faster find
RUN ARCH=$(case "$TARGETARCH" in amd64) echo "x86_64" ;; arm64) echo "aarch64" ;; esac) \
    && curl -sL "https://github.com/sharkdp/fd/releases/download/v10.2.0/fd-v10.2.0-${ARCH}-unknown-linux-gnu.tar.gz" \
    | tar xz -C /usr/local/bin --strip-components=1 "fd-v10.2.0-${ARCH}-unknown-linux-gnu/fd"

# typos-cli — spell checker
RUN ARCH=$(case "$TARGETARCH" in amd64) echo "x86_64" ;; arm64) echo "aarch64" ;; esac) \
    && curl -sL "https://github.com/crate-ci/typos/releases/download/v1.47.2/typos-v1.47.2-${ARCH}-unknown-linux-musl.tar.gz" \
    | tar xz -C /usr/local/bin typos

# gh CLI — GitHub CLI
RUN curl -sL "https://github.com/cli/cli/releases/download/v2.70.0/gh_2.70.0_linux_${TARGETARCH}.tar.gz" \
    | tar xz -C /usr/local/bin --strip-components=2 "gh_2.70.0_linux_${TARGETARCH}/bin/gh"

# ── download pre-compiled zeroclaw binary from our release ──
RUN curl -sL "https://github.com/${REPO}/releases/download/zeroclaw-daemon-${VERSION}/zeroclaw-daemon-${VARIANT}" \
    -o /usr/local/bin/zeroclaw-daemon \
    && chmod +x /usr/local/bin/zeroclaw-daemon

# ── entrypoint ──
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
