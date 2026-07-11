#!/bin/bash

# AI Developer Environment - Setup Script
# Idempotent installer for essential development tools.

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Starting AI Developer Environment Setup...${NC}"

# Ensure we are in the script directory
cd "$(dirname "$0")"

# Create log file
LOG_FILE="setup.log"
touch $LOG_FILE

log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}" | tee -a $LOG_FILE
}

# Run modular installers
for script in install/*.sh; do
    if [ -x "$script" ]; then
        log "Running $script..."
        ./"$script"
    fi
done

log "Setup complete! Please restart your terminal or source your profile."
