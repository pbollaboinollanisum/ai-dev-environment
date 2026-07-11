#!/bin/bash
# 03-docker.sh - Install Docker and Docker Compose

set -e

echo "Installing Docker..."

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings

. /etc/os-release
OS_ID=$ID
CODENAME=$VERSION_CODENAME

if [ "$OS_ID" = "debian" ]; then
    DOCKER_URL="https://download.docker.com/linux/debian"
elif [ "$OS_ID" = "ubuntu" ]; then
    DOCKER_URL="https://download.docker.com/linux/ubuntu"
else
    # Default fallback
    DOCKER_URL="https://download.docker.com/linux/ubuntu"
    OS_ID="ubuntu"
fi

curl -fsSL "$DOCKER_URL/gpg" | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Fallback for Debian Trixie/Sid which might not have official Docker repos yet
if [ "$OS_ID" = "debian" ]; then
    if [ "$CODENAME" = "trixie" ] || [ "$CODENAME" = "sid" ]; then
        echo "Detected Debian $CODENAME. Falling back to bookworm for Docker repository."
        CODENAME="bookworm"
    fi
elif [ "$OS_ID" = "ubuntu" ]; then
    if [ "$CODENAME" = "noble" ] || [ "$CODENAME" = "oracular" ]; then
        # Check if noble is supported yet, otherwise fallback to jammy
        if ! curl -Is "$DOCKER_URL/dists/$CODENAME/stable/binary-amd64/Packages" | grep -q "200 OK"; then
             echo "Detected Ubuntu $CODENAME is not yet supported by Docker. Falling back to jammy."
             CODENAME="jammy"
        fi
    fi
fi

echo "Using Docker repo: $DOCKER_URL with codename: $CODENAME"

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] $DOCKER_URL \
  $CODENAME stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add current user to docker group
sudo usermod -aG docker $USER

echo "Docker installed. Note: You may need to logout and log back in for docker group changes to take effect."
