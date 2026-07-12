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

# Install pnpm with cleanup to avoid ENOSPC
echo "Installing pnpm..."
if ! command -v pnpm &> /dev/null; then
    # Try to free space before pnpm install
    npm cache clean --force || true
    curl -fsSL https://get.pnpm.io/install.sh | sh - || {
        echo "Error: pnpm installation failed. This is often due to disk space (ENOSPC)."
        echo "Try manually running: npm cache clean --force && rm -rf /tmp/*"
        exit 1
    }
fi

echo "Node.js stack installed."
