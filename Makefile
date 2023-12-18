SHELL := bash
MAKEFLAGS += --no-print-directory
PROJECT?=default
OWNER?=elastic
AUTHOR?=apmmachine
ISSUE_URL?=
TIME=$(shell date +'%Y_%m_%d-%H_%M_%S')

## MAKE GOALS
.PHONY: add-repo
add-repo: ## Add the repo references in the releases repository
	@echo "::group::$@"  # Helping to group logs in GitHub actions
	git checkout -b feature/github-$(PROJECT)_$(TIME)
	cp minor minor.bck
	cp patch patch.bck
	echo "$(OWNER)/$(PROJECT)" >> minor
	echo "$(OWNER)/$(PROJECT)" >> patch
	sort minor.bck -u > minor
	sort patch.bck -u > patch
	rm minor.bck patch.bck
	git add .
	git commit -m "[release] $(PROJECT)"
	git remote -v; \
	git push --set-upstream origin feature/github-$(PROJECT)_$(TIME); \
	gh pr create --title "[release] $(PROJECT)" \
		--body "A new project has been added to the release automation - https://github.com/$(OWNER)/$(PROJECT).git. @$(AUTHOR) requested it $(ISSUE_URL)" \
		--assignee "$(AUTHOR)" \
		--label "automation" \
		--head feature/github-$(PROJECT)_$(TIME) > repo.issue
	[ -e repo.issue ] && cat repo.issue || true
	@echo "::endgroup::"

.PHONY: create-workflow
create-workflow: ## Create the workflow in the current repository
	$(MAKE) prepare-repo
	$(MAKE) prepare-workflow-files

.PHONY: link-created-github-issues
link-created-github-issues: ## Create GitHub action env variables on the fly
	@echo "::group::$@"  # Helping to group logs in GitHub actions
	[ -e manifest.issue ] && echo "MANIFEST_ISSUE=$$(cat manifest.issue)" >> $$GITHUB_ENV || true
	[ -e repo.issue ] && echo "REPO_ISSUE=$$(cat repo.issue)" >> $$GITHUB_ENV || true
	[ -e workflow.issue ] && echo "WORKFLOW_ISSUE=$$(cat workflow.issue)" >> $$GITHUB_ENV || true
	@echo "::endgroup::"

## MAKE GOALS for internal use
.PHONY: prepare-repo
prepare-repo: ## (INTERNAL) Prepare the repository for GitHub actions
	@echo "::group::$@"  # Helping to group logs in GitHub actions
	gh repo clone $(OWNER)/$(PROJECT) .repos/$(PROJECT)
	@echo "::endgroup::"

.PHONY: prepare-workflow-files
prepare-workflow-files: ## (INTERNAL) Prepare the workflow files
	@echo "::group::$@"  # Helping to group logs in GitHub actions
	cd .repos/$(PROJECT); \
		git checkout -b feature/workflow-$(PROJECT)_$(TIME)
	mkdir -p .repos/$(PROJECT)/.github/workflows
	cp .github/templates/*.yml .repos/$(PROJECT)/.github/workflows/
	cd .repos/$(PROJECT); \
		git add .; \
		git commit -m "[workflow] $(PROJECT)"; \
		git remote -v; \
		git push --set-upstream origin feature/workflow-$(PROJECT)_$(TIME); \
		gh pr create --title "[workflow] $(PROJECT)" \
		    --body "A new project has been added to the release automation - Feel free to adapt this workflow as you need." \
		    --assignee "$(AUTHOR)" \
		    --head feature/workflow-$(PROJECT)_$(TIME) > ../../workflow.issue
	[ -e workflow.issue ] && cat workflow.issue || true
	@echo "::endgroup::"

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'