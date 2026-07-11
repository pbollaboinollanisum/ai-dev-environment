#!/bin/bash
# 06-python.sh - Install Python and uv

set -e

echo "Installing Python and uv..."

sudo apt-get install -y python3 python3-pip python3-venv

# Install uv (modern python package manager)
curl -LsSf https://astral.sh/uv/install.sh | sh

echo "Python stack installed."
