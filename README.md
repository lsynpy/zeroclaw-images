# ZeroClaw Images

**Pre-built ZeroClaw Docker images** with extra tools, cross-compiled for ARM64.

This repo **does not contain ZeroClaw source code**. It downloads the official source at build time, cross-compiles it on CI, then builds a Docker image with the binary plus essential tools.

## Repo structure

```
.github/workflows/
├── cross-compile.yml     # Cross-compile zeroclaw-daemon → release asset
└── build-image.yml        # Build Docker image → push to GHCR

images/zeroclaw-full/
├── Dockerfile
├── entrypoint.sh
└── config.yaml.example

Makefile                   # Local dev helpers
```

## How it works

```
GitHub Actions (x86_64 runner)
    │  cross-compile aarch64 binary
    ▼
Our release asset (zeroclaw-daemon-v0.x.x)
    │  curl download at Docker build time
    ▼
ghcr.io/lsynpy/zeroclaw-full:latest
    (debian slim + tools + binary)
```

## Usage

### Quick start

```bash
docker run -d --name zeroclaw \
  -v /path/to/config.yaml:/etc/zeroclaw/config.yaml \
  ghcr.io/lsynpy/zeroclaw-full:latest
```

### Build locally

```bash
make build VERSION=v0.8.0-beta-2
```

## CI Pipeline

| Step | Trigger | Output |
|------|---------|--------|
| **Cross-compile** | Manual `workflow_dispatch` | Binary asset in GitHub Release |
| **Build image** | New release published  or manual | Docker image on GHCR |

To start a build:

```bash
# 1. Cross-compile (takes ~60-90 min first time)
gh workflow run cross-compile.yml -f version=v0.8.0-beta-2

# 2. Wait for it to finish → binary uploaded to release

# 3. Build Docker image (takes ~2 min)
gh workflow run build-image.yml -f version=v0.8.0-beta-2
```

## Version updates

When a new ZeroClaw version is released:

```bash
# Change version
gh workflow run cross-compile.yml -f version=v0.9.0
```
