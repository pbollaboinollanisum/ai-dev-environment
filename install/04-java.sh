#!/bin/bash
# 04-java.sh - Install Java 21 (Temurin), Maven, and Gradle

set -e

echo "Installing Java 21 (Temurin)..."

# Install SDKMAN to manage Java versions
if [ ! -d "$HOME/.sdkman" ]; then
    curl -s "https://get.sdkman.io" | bash
fi

# Load SDKMAN
source "$HOME/.sdkman/bin/sdkman-init.sh"

sdk install java 21.0.2-tem
sdk install maven
sdk install gradle

echo "Java stack installed."
