# A Self-Documenting Makefile: http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html

DOCKER_IMAGE = php:7.1

.PHONY: setup dep clean test docker

setup: dep ## Setup the project for development

dep: ## Install dependencies
	@composer ${COMPOSER_FLAGS} install

clean: ## Clean the working area
	rm -rf build/ vendor/

test: ## Run tests
	vendor/bin/phpunit ${PHPUNIT_FLAGS}

docker: ## Execute commands inside a Docker container
	docker run --rm -it -v $$PWD:/app -w /app $(DOCKER_IMAGE) make $(filter-out docker, $(MAKECMDGOALS))
	@printf "\033[36mExiting with non-zero status code to abort make. If you see this message your command successfully ran.\033[0m\n"
	exit 1

.PHONY: help
.DEFAULT_GOAL := help
help:
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

-include custom.mk
