#!/bin/bash
# 10-workspace.sh - Create workspace directory structure

set -e

echo "Creating workspace structure in $HOME/workspace..."

mkdir -p "$HOME/workspace"/{java,springboot,react,angular,python,ai,agents,rag,mcp,docker,kubernetes,playground}

echo "Workspace structure created."
