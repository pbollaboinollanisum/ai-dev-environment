#!/bin/bash
# 08-cloud.sh - Install Cloud and Infrastructure tools

set -e

echo "Installing Cloud and Infrastructure tools..."

# Install Google Cloud CLI
if ! command -v gcloud &> /dev/null; then
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
    sudo apt-get update && sudo apt-get install -y google-cloud-cli
fi

# Install Terraform
if ! command -v terraform &> /dev/null; then
    wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    . /etc/os-release
    CODENAME=$VERSION_CODENAME
    # Fallback for newer versions
    if [ "$CODENAME" = "trixie" ] || [ "$CODENAME" = "sid" ]; then
        CODENAME="bookworm"
    fi
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $CODENAME main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt-get update && sudo apt-get install terraform
fi

# Install kubectl
if ! command -v kubectl &> /dev/null; then
    sudo apt-get install -y kubectl
fi

# Install Helm
if ! command -v helm &> /dev/null; then
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
fi

echo "Cloud tools installed."
