#!/bin/bash
# scripts/ollama-models.sh - Pull common AI models for development

set -e

echo "Pulling Ollama models..."

# Check if Ollama service is reachable
if ! curl -s http://localhost:11434/api/tags > /dev/null; then
    echo "Warning: Ollama service is not running. Models will not be pulled."
    echo "Please start Ollama manually and run: ./scripts/ollama-models.sh"
    exit 0
fi

# Recommended coding models
models=(
    "qwen2.5-coder:7b"      # Current best-in-class coding model (7B version)
    "nomic-embed-text"      # Best for RAG and local indexing
)

for model in "${models[@]}"; do
    echo "Pulling $model..."
    ollama pull "$model"
done

echo "Ollama models pulled successfully."
