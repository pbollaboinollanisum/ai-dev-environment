#!/bin/bash
# 09-tools.sh - Install additional developer tools

set -e

echo "Installing additional tools..."

# Install JupyterLab via uv (avoids PEP 668 externally-managed-environment error)
if command -v uv &> /dev/null; then
    # Clear uv cache first to maximize space for extraction
    uv cache clean || true
    uv tool install jupyterlab || true
else
    # Fallback to pip with --break-system-packages if uv is not found (use with caution)
    pip3 install jupyterlab --user --break-system-packages || true
fi

echo "Additional tools installed."
