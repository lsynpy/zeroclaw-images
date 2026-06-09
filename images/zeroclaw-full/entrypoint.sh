#!/bin/bash
set -e

# ── entrypoint for zeroclaw-daemon ──
# If no config is mounted, generate a minimal one.
# Then exec the daemon so signals propagate correctly.

CONFIG_DIR="${ZEROCLAW_CONFIG_DIR:-/zeroclaw-data/.zeroclaw}"

if [ ! -d "$CONFIG_DIR" ]; then
    echo "[entrypoint] No config dir found at $CONFIG_DIR"
    echo "[entrypoint] Mount a volume with .zeroclaw/ at /zeroclaw-data/ or set ZEROCLAW_CONFIG_DIR."
    echo "[entrypoint] Using default config (may need manual setup)."
fi

if [ $# -eq 0 ]; then
    exec zeroclaw-daemon --config-dir "$CONFIG_DIR" daemon
else
    exec zeroclaw-daemon --config-dir "$CONFIG_DIR" "$@"
fi
