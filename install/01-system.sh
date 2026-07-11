#!/bin/bash
# 01-system.sh - Install core system utilities

set -e

echo "Cleaning up invalid repositories..."
# Remove any persistent docker-related lists that cause 404s
sudo rm -f /etc/apt/sources.list.d/docker.list
sudo rm -f /etc/apt/sources.list.d/download_docker_com*.list
# Also remove any that might have been created by previous failed logic or other tools
sudo grep -l "download.docker.com" /etc/apt/sources.list.d/*.list 2>/dev/null | xargs sudo rm -f || true

# Check /etc/apt/sources.list for docker entries and remove them
if grep -q "download.docker.com" /etc/apt/sources.list; then
    echo "Removing docker entries from /etc/apt/sources.list..."
    sudo sed -i '/download.docker.com/d' /etc/apt/sources.list
fi

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
