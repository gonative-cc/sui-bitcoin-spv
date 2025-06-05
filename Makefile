
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
	@sui move test --coverage
	@sui move coverage summary --test

.PHONY: test test-coverage

###############################################################################
##                                Infrastructure                             ##
###############################################################################

# To setup bitcoin, use Native Relayer.
