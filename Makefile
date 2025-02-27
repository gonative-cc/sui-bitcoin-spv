
setup-hooks:
	@cd .git/hooks; ln -s -f ../../scripts/git-hooks/* ./

.git/hooks/pre-commit: setup

build: .git/hooks/pre-commit
	@sui move build

publish:
	@sui client publish --skip-dependency-verification  --gas-budget 100000000

# used as pre-commit
lint-git:
	@git diff --name-only --cached | grep  -E '\.md$$' | xargs -r markdownlint-cli2
	@sui move build --lint
# lint changed files
lint:
	@git diff --name-only | grep  -E '\.md$$' | xargs -r markdownlint-cli2
	@ sui move build --lint

lint-all:
	@markdownlint-cli2 **.md
	@sui move build --lint

lint-fix-all:
	@markdownlint-cli2 --fix **.md
	@echo "Sui move lint will be fixed by manual"

.PHONY: build setup
.PHONY: lint lint-all lint-fix-all

###############################################################################
##                                   Tests                                   ##
###############################################################################

test:
	@sui move test

test-coverage:
	echo TODO
# sui move test --coverage
# sui move coverage

.PHONY: test test-coverage

###############################################################################
##                                Infrastructure                             ##
###############################################################################

# To setup bitcoin, use Native Relayer.
