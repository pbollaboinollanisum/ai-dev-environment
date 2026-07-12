#!/bin/bash
# scripts/cleanup.sh - Cleanup caches to free up space

echo "Cleaning up package manager caches..."

# NPM cleanup
if command -v npm &> /dev/null; then
    npm cache clean --force || true
fi

# PNPM cleanup
if command -v pnpm &> /dev/null; then
    pnpm store prune || true
fi

# UV cleanup
if command -v uv &> /dev/null; then
    uv cache clean || true
fi

# APT cleanup (if sudo available)
if command -v apt-get &> /dev/null; then
    sudo apt-get clean || true
    sudo apt-get autoremove -y || true
fi

# Temp files
rm -rf /tmp/* || true

echo "Cleanup complete."
