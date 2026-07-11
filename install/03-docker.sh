#!/bin/bash
# 03-docker.sh - Install Docker and Docker Compose

set -e

echo "Installing Docker..."

# 1. CLEANUP: Remove any existing docker-related lists that might be causing 404s
echo "Cleaning up old Docker repository configurations..."
sudo rm -f /etc/apt/sources.list.d/docker.list
sudo rm -f /etc/apt/sources.list.d/download_docker_com*.list
# Also remove any that might have been created by previous failed logic
sudo grep -l "download.docker.com" /etc/apt/sources.list.d/*.list 2>/dev/null | xargs sudo rm -f || true

# 2. Update and install prerequisites
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings

# 3. Detect OS and Codename
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS_ID=$ID
    OS_ID_LIKE=$ID_LIKE
    # Some systems (like GCE) might have custom IDs, so check ID_LIKE
    if [[ "$OS_ID" != "debian" && "$OS_ID" != "ubuntu" ]]; then
        if [[ "$OS_ID_LIKE" == *"debian"* ]]; then
            OS_ID="debian"
        elif [[ "$OS_ID_LIKE" == *"ubuntu"* ]]; then
            OS_ID="ubuntu"
        fi
    fi
    CODENAME=$VERSION_CODENAME
fi

# Fallback for empty or unknown codename
if [ -z "$CODENAME" ] || [ "$CODENAME" = "n/a" ]; then
    CODENAME=$(lsb_release -cs 2>/dev/null || echo "unknown")
fi

# 4. Force Fallbacks for Unsupported Codenames (especially Trixie/Sid)
echo "Original Detection: OS_ID=$OS_ID, CODENAME=$CODENAME"

case "$CODENAME" in
    trixie|sid|unknown|"")
        if [[ "$OS_ID" == "debian" ]]; then
            echo "Falling back to Debian bookworm for Docker repo."
            CODENAME="bookworm"
            DOCKER_URL="https://download.docker.com/linux/debian"
        else
            echo "Falling back to Ubuntu jammy for Docker repo."
            CODENAME="jammy"
            DOCKER_URL="https://download.docker.com/linux/ubuntu"
        fi
        ;;
    *)
        if [ "$OS_ID" = "debian" ]; then
            DOCKER_URL="https://download.docker.com/linux/debian"
        else
            DOCKER_URL="https://download.docker.com/linux/ubuntu"
        fi
        ;;
esac

echo "Final Choice: URL=$DOCKER_URL, CODENAME=$CODENAME"

# 5. Install GPG key
curl -fsSL "$DOCKER_URL/gpg" | sudo gpg --dearmor --yes -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# 6. Create fresh sources list
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] $DOCKER_URL \
  $CODENAME stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 7. Final Update and Install
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add current user to docker group
sudo usermod -aG docker $USER || true

echo "Docker installation attempt finished."
