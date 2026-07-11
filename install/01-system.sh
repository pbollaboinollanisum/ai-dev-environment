#!/bin/bash
# 01-system.sh - Install core system utilities

set -e

echo "Installing system utilities..."

# Update package list
sudo apt-get update

# Install basics
sudo apt-get install -y \
    curl \
    wget \
    jq \
    tree \
    unzip \
    tmux \
    htop \
    build-essential \
    software-properties-common \
    ca-certificates \
    gnupg \
    lsb-release

echo "System utilities installed."
