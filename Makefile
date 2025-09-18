.PHONY: setup-hooks, add-license, lint-git, build-all, test-all


setup-hooks:
	@cd .git/hooks; ln -s -f ../../contrib/git-hooks/* ./
	@pnpm install -g prettier @mysten/prettier-plugin-move


# used as pre-commit
lint-git:
	@git diff --name-only --cached --diff-filter=ACM | grep  -E '\.md$$' | xargs -r markdownlint-cli2


############

# All immediate subdirectories inside /packages
SUBDIRS := $(wildcard packages/*/)

# Filter subdirectories that contain a Move.toml file
MOVE_SUBDIRS := $(foreach dir,$(SUBDIRS),$(if $(wildcard $(dir)Move.toml),$(dir)))
MAKE_SUBDIRS := $(foreach dir,$(SUBDIRS),$(if $(wildcard $(dir)Makefile),$(dir)))


build-all:
	@for dir in $(MOVE_SUBDIRS); do \
		echo "==> building $$dir"; cd $$dir; sui move build; cd -; \
	done


test-all:
	@for dir in $(MOVE_SUBDIRS); do \
		echo "==> testing $$dir"; sui move test; cd -; \
	done

# add license header to every source file
add-license:
	@for dir in $(MOVE_SUBDIRS); do \
		cd $$dir; make add-license; cd -; \
	done

# with reuse tool:
# docker run --rm --volume $(pwd):/data fsfe/reuse annotate --license MPL-2.0  */tests/*.move */sources/*.move  -s cpp
