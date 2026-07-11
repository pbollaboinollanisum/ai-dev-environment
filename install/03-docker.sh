#!/bin/bash
# 03-docker.sh - Install Docker and Docker Compose

set -e

echo "Installing Docker..."

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings

# Detect OS and Codename
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS_ID=$ID
    OS_ID_LIKE=$ID_LIKE
    CODENAME=$VERSION_CODENAME
else
    OS_ID="unknown"
    CODENAME="unknown"
fi

# Fallback for empty VERSION_CODENAME (common on testing/unstable)
if [ -z "$CODENAME" ]; then
    CODENAME=$(lsb_release -cs 2>/dev/null || echo "unknown")
fi

# Determine base distribution type
IS_DEBIAN=false
if [[ "$OS_ID" == *"debian"* ]] || [[ "$OS_ID_LIKE" == *"debian"* ]]; then
    IS_DEBIAN=true
fi

IS_UBUNTU=false
if [[ "$OS_ID" == *"ubuntu"* ]] || [[ "$OS_ID_LIKE" == *"ubuntu"* ]]; then
    IS_UBUNTU=true
fi

# Select Repository URL and Codename Fallbacks
if [ "$IS_DEBIAN" = true ]; then
    DOCKER_URL="https://download.docker.com/linux/debian"
    # Fallback for Debian Testing/Unstable
    if [ "$CODENAME" = "trixie" ] || [ "$CODENAME" = "sid" ] || [ "$CODENAME" = "n/a" ] || [ "$CODENAME" = "unknown" ]; then
        echo "Detected Debian $CODENAME (Testing/Unstable). Falling back to bookworm for Docker repository."
        CODENAME="bookworm"
    fi
elif [ "$IS_UBUNTU" = true ]; then
    DOCKER_URL="https://download.docker.com/linux/ubuntu"
    # Fallback for new Ubuntu releases
    if [[ " noble oracular " =~ " $CODENAME " ]]; then
        if ! curl -Is "$DOCKER_URL/dists/$CODENAME/stable/binary-amd64/Packages" | grep -q "200 OK"; then
             echo "Detected Ubuntu $CODENAME is not yet supported by Docker. Falling back to jammy."
             CODENAME="jammy"
        fi
    fi
else
    # Global fallback to Ubuntu Jammy as it's the most common
    echo "Warning: Unknown OS ID ($OS_ID). Defaulting to Ubuntu Jammy for Docker."
    DOCKER_URL="https://download.docker.com/linux/ubuntu"
    CODENAME="jammy"
fi

echo "OS Detection: ID=$OS_ID, ID_LIKE=$OS_ID_LIKE, CODENAME=$CODENAME"
echo "Using Docker repo: $DOCKER_URL with codename: $CODENAME"

# Import GPG key
curl -fsSL "$DOCKER_URL/gpg" | sudo gpg --dearmor --yes -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Create sources list
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] $DOCKER_URL \
  $CODENAME stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Clean up any potential conflicting lists from previous attempts
if [ -f /etc/apt/sources.list.d/download_docker_com_linux_ubuntu.list ]; then
    sudo rm /etc/apt/sources.list.d/download_docker_com_linux_ubuntu.list
fi

sudo apt-get update

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add current user to docker group
sudo usermod -aG docker $USER || true

echo "Docker installed successfully."
