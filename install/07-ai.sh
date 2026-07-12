#!/bin/bash
# 07-ai.sh - Install AI Tools (Ollama, Gemini CLI, Claude Code CLI)

set -e

echo "Installing AI tools..."

# Install Ollama
if ! command -v ollama &> /dev/null; then
    curl -fsSL https://ollama.com/install.sh | sh
fi

# Install Gemini CLI (Assuming it's available via npm/pip or global installer)
# For now, we'll use a placeholder or install common AI dev tools
npm install -g @google/gemini-cli || true
npm install -g @anthropic-ai/claude-code || true

# Pull recommended AI models (if ollama is running)
if command -v ollama &> /dev/null; then
    ./scripts/ollama-models.sh || true
fi

echo "AI tools installed."
