
setup-hooks:
	@cd .git/hooks; ln -s -f ../../scripts/git-hooks/* ./

.git/hooks/pre-commit: setup

build: .git/hooks/pre-commit
	@sui move build

publish:
	@sui client publish --skip-dependency-verification  --gas-budget 100000000

# used as pre-commit
lint-git:
	@git diff --name-only --cached | grep  -E '\.md$$'| grep -v '^docs/' | xargs -r markdownlint-cli2
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


# add license header to every source file
add-license:
	@awk -i inplace 'FNR==1 && !/SPDX-License-Identifier/ {print "// SPDX-License-Identifier: MPL-2.0\n"}1' sources/*.move tests/*.move
.PHONY: add-license


###############################################################################
##                                   Tests                                   ##
###############################################################################

test:
	@sui move test

test-coverage:
	echo TODO
# sui move test --coverage
# sui move coverage

# Variables for build output and module name
BUILD_DIR := build
MODULE_NAME := BitcoinSPV
DOCS_SUBDIR := bitcoin_spv

gen-docs:
	@sui move build --doc
	@cp -r ./$(BUILD_DIR)/$(MODULE_NAME)/docs/$(DOCS_SUBDIR) ./docs

.PHONY: test test-coverage gen-docs

###############################################################################
##                                Infrastructure                             ##
###############################################################################

# To setup bitcoin, use Native Relayer.
