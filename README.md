# ZeroClaw Images

**Pre-built ZeroClaw Docker images** with extra tools, cross-compiled
for ARM64 via GitHub Actions.

This repo contains **no ZeroClaw source code**. CI clones the official
source, cross-compiles three variants, and builds Docker images.

## The Three Variants

| # | Variant | Features | Binary Size | Profile |
|---|---------|----------|-------------|---------|
| **A** | `minimal` | `agent-runtime`, `gateway`, `channel-lark` | — | `ci` |
| **B** | `default-nochan` | default subsystems + `channel-lark`, no other channels | — | `ci` |
| **C** | `default-feishu` | official default + `channel-lark` | — | `ci` |

After the first build, check the [releases page][releases] for actual sizes.

## How It Works

```
GitHub Actions (x86_64 runner)
  │  cross-compile (3 variants in parallel)
  ▼
GitHub Release: zeroclaw-v0.8.0-beta-2
  ├─ zeroclaw-minimal
  ├─ zeroclaw-default-nochan
  └─ zeroclaw-default-feishu
      │  curl download at Docker build time
      ▼
ghcr.io/lsynpy/zeroclaw-full:{variant}-latest
```

## Quick Start

Pick a variant and run:

```bash
docker run -d --name zeroclaw \
  -v /path/to/config.yaml:/etc/zeroclaw/config.yaml \
  ghcr.io/lsynpy/zeroclaw-full:default-feishu-latest
```

## CI Pipeline

### 1. Cross-Compile

```bash
gh workflow run cross-compile.yml -f version=v0.8.0-beta-2
```

Runs **three jobs in parallel**. Each compiles its variant, then a
consolidation job publishes all binaries to one release with a summary
table.

### 2. Build Docker Image

Auto-triggers when a release is published, or manually:

```bash
gh workflow run build-image.yml -f version=v0.8.0-beta-2
```

Builds three images in parallel, tagged as:

- `ghcr.io/lsynpy/zeroclaw-full:minimal-latest`
- `ghcr.io/lsynpy/zeroclaw-full:default-nochan-latest`
- `ghcr.io/lsynpy/zeroclaw-full:default-feishu-latest`

## Testing on JDC

After the release is published:

```bash
# Download a specific variant
gh release download zeroclaw-v0.8.0-beta-2 \
  -p zeroclaw-minimal \
  -o ./zeroclaw && chmod +x ./zeroclaw

# Or pull a Docker image
docker pull ghcr.io/lsynpy/zeroclaw-full:minimal-latest
```

## Version Updates

```bash
gh workflow run cross-compile.yml -f version=v0.9.0
gh workflow run build-image.yml -f version=v0.9.0
```

[releases]: https://github.com/lsynpy/zeroclaw-images/releases
