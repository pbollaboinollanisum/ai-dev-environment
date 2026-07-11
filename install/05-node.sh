#!/bin/bash
# 05-node.sh - Install Node.js 22 LTS and pnpm

set -e

echo "Installing Node.js 22 LTS..."

# Install NVM
if [ ! -d "$HOME/.nvm" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi

# Load NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

nvm install 22
nvm use 22
nvm alias default 22

# Install pnpm
curl -fsSL https://get.pnpm.io/install.sh | sh -

echo "Node.js stack installed."
