.PHONY: setup verify clean update

setup:
	./setup.sh

verify:
	@echo "Verifying installation..."
	@docker --version || echo "Docker not installed"
	@java -version || echo "Java not installed"
	@node -v || echo "Node not installed"
	@python3 --version || echo "Python not installed"
	@uv --version || echo "uv not installed"
	@ollama --version || echo "Ollama not installed"
	@gcloud --version || echo "gcloud not installed"
	@terraform --version || echo "Terraform not installed"

update:
	@echo "Updating scripts from origin..."
	git pull origin main

clean:
	rm -f setup.log
	find . -name "*.tmp" -delete
