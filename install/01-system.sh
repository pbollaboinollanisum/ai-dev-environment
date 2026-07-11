#!/bin/bash
# 01-system.sh - Install core system utilities

set -e

echo "Installing system utilities..."

# Update package list
sudo apt-get update

# Ensure we have common repositories (for Ubuntu)
if [ -f /etc/lsb-release ]; then
    echo "Ensuring universe repository is enabled..."
    sudo apt-get install -y software-properties-common || true
    if command -v add-apt-repository >/dev/null 2>&1; then
        sudo add-apt-repository -y universe
        sudo apt-get update
    fi
fi

# List of essential packages
PACKAGES=(
    curl
    wget
    jq
    tree
    unzip
    zip
    tmux
    htop
    build-essential
    ca-certificates
    gnupg
    lsb-release
)

echo "Installing packages: ${PACKAGES[*]}"
sudo apt-get install -y "${PACKAGES[@]}"

# Attempt to install software-properties-common if not already tried
sudo apt-get install -y software-properties-common || echo "Warning: software-properties-common could not be installed."

echo "System utilities installed."
