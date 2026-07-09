# ZeroClaw Images

**Deprecated** — we now use the **official ZeroClaw Docker image** directly.

The upstream project includes `channel-lark` (Feishu/Lark) in the default
build, supports `linux/arm64`, and ships the web dashboard. No custom
cross-compilation is needed.

## Quick Start (JDC / ARM64)

**推荐使用 `v0.8.2-debian` 标签**（debian 基础镜像，带 shell，方便排障）。

```bash
# Pull via Nanjing University GHCR mirror (China-friendly)
docker pull ghcr.nju.edu.cn/zeroclaw-labs/zeroclaw:v0.8.2-debian

# Run
docker run -d --name zeroclaw \
  --restart unless-stopped \
  --network host \
  -v zeroclaw-data:/zeroclaw-data \
  ghcr.nju.edu.cn/zeroclaw-labs/zeroclaw:v0.8.2-debian \
  daemon --verbose --log-level debug
```

### ⚠️ 首次部署 / 从旧版迁移

#### 1. 卷权限

官方镜像以 UID 65534 (nobody) 运行。确保配置卷权限正确：

```bash
VOL_PATH=/mnt/mmcblk0p19/docker/volumes/zeroclaw-data/_data
chown -R 65534:65534 "$VOL_PATH/.zeroclaw/"
```

#### 2. Dashboard 配置

在 `config.toml` 的 `[gateway]` 段添加 `web_dist_dir`，否则网关找不到前端文件：

```toml
[gateway]
web_dist_dir = "/usr/share/zeroclawlabs/web/dist"
port = 42617
host = "[::]"
allow_public_bind = true
require_pairing = false
```

如果缺少此项，Dashboard 能打开但 Config 页面会报 `API 404: /api/onboard/sections`。

#### 3. 清理旧版前端缓存

如果从旧版 distroless 镜像切换过来，volume 里可能残留旧版前端文件，导致新版前端加载异常：

```bash
VOL_PATH=/mnt/mmcblk0p19/docker/volumes/zeroclaw-data/_data
rm -rf "$VOL_PATH/web"
```

#### 4. 重启容器

```bash
docker restart zeroclaw
```

## Official Tags

| Tag | Base | 特点 |
|-----|------|------|
| `v0.8.2` | distroless | 最小体积，**无 shell** |
| `v0.8.2-debian` | debian:trixie-slim | **推荐**，有 shell/curl，方便排障 |

可用镜像源：
- Global：`ghcr.io/zeroclaw-labs/zeroclaw`
- China mirror：`ghcr.nju.edu.cn/zeroclaw-labs/zeroclaw`

## 已知问题

### Config 页面 404

如果 Dashboard 能打开但 Config 页面报以下错误：

```
Couldn't load sections: API 404: {"error":"not_found","path":"/api/onboard/sections"}
```

原因：旧版前端文件残留在 volume 中，或缺少 `web_dist_dir` 配置。
解决：按上方 **步骤 2 + 3** 操作后重启。

### distroless 镜像无法 exec

`v0.8.2`（distroless）标签不带 shell，无法执行 `docker exec zeroclaw sh`。
需要排障时请换用 `v0.8.2-debian`。

## History

This repo previously cross-compiled custom variants (minimal / default-nochan /
default-feishu) for environments where the official image was too large or
missing Lark support. As of v0.8.2 that is no longer needed. The CI workflows
and build scripts are kept for reference only.

[releases]: https://github.com/lsynpy/zeroclaw-images/releases
