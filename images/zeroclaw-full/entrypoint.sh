#!/bin/bash
set -e

# ── entrypoint for zeroclaw-daemon ──
# If no config is mounted, generate a minimal one.
# Then exec the daemon so signals propagate correctly.

CONFIG_PATH="${ZEROCLAW_CONFIG:-/etc/zeroclaw/config.yaml}"

if [ ! -f "$CONFIG_PATH" ]; then
    echo "[entrypoint] No config found at $CONFIG_PATH"
    echo "[entrypoint] Mount one or set ZEROCLAW_CONFIG to a config file path."
    echo "[entrypoint] Using default config (may need manual setup)."
fi

exec zeroclaw-daemon --config "$CONFIG_PATH" "$@"
