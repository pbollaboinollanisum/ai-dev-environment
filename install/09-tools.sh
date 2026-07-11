#!/bin/bash
# 09-tools.sh - Install additional developer tools

set -e

echo "Installing additional tools..."

# Install JupyterLab via pip
pip3 install jupyterlab --user || true

echo "Additional tools installed."
