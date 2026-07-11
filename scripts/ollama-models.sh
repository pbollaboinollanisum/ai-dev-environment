#!/bin/bash
# scripts/ollama-models.sh - Pull common AI models for development

set -e

echo "Pulling Ollama models..."

models=(
    "qwen2.5-coder"
    "deepseek-v2.5"
    "nomic-embed-text"
    "llama3.1"
)

for model in "${models[@]}"; do
    echo "Pulling $model..."
    ollama pull "$model"
done

echo "Ollama models pulled successfully."
