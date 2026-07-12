# AI Developer Environment

This project provides a modular, idempotent setup for an AI development environment.

## Project Structure

- `Makefile`: Entry point for orchestration (`setup`, `verify`, `update`, `clean`).
- `setup.sh`: Main script that executes all scripts in `install/` sequentially.
- `install/`: Contains modular shell scripts for different tool categories (system, git, java, node, python, ai, cloud, tools, workspace).
- `configs/`: Shell aliases and other configuration files.
- `scripts/`: Supporting utility scripts (e.g., pulling Ollama models).
- `docker/`: Docker Compose configurations for local infrastructure.
- `vscode/`: VS Code settings and recommended extensions.

## Conventions

- **Idempotency**: All setup scripts should be idempotent (safe to run multiple times).
- **Modularity**: New tools should be added as new scripts in `install/` or by updating existing ones.
- **Logging**: The `setup.sh` script logs its progress to `setup.log`.
- **Verification**: Use `make verify` to check if key tools are installed and accessible.

## Development Workflow

1. Modify `install/*.sh` to add or update tools.
2. Run `make setup` to apply changes.
3. Run `make verify` to confirm the installation.
4. Update `configs/aliases.sh` if new aliases are needed.
