
setup-hooks:
	@cd .git/hooks; ln -s -f ../../scripts/git-hooks/* ./

.git/hooks/pre-commit: setup

build: .git/hooks/pre-commit
	sui move build

# used as pre-commit
lint-git:
	@git diff --name-only --cached | grep  -E '\.md$$' | xargs -r markdownlint-cli2

# lint changed files
lint:
	@git diff --name-only | grep  -E '\.md$$' | xargs -r markdownlint-cli2

lint-all:
	markdownlint-cli2 **.md

lint-fix-all:
	markdownlint-cli2 --fix **.md


.PHONY: build setup
.PHONY: lint lint-all lint-fix-all

###############################################################################
##                                   Tests                                   ##
###############################################################################

test:
	sui move test

test-coverage:
	sui move test --coverage
	sui move coverage

.PHONY: test test-coverage

###############################################################################
##                                Infrastructure                             ##
###############################################################################

# To setup bitcoin, use Native Relayer.
