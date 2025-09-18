.PHONY: setup-hooks lint-git

setup-hooks:
	@cd .git/hooks; ln -s -f ../../contrib/git-hooks/* ./
	@bun install -g prettier @mysten/prettier-plugin-move

.git/hooks/pre-commit: setup


# used as pre-commit
lint-git:
	@git diff --name-only --cached --diff-filter=ACM | grep  -E '\.md$$' | xargs -r markdownlint-cli2


############

# All immediate subdirectories inside /packages
SUBDIRS := $(wildcard packages/*/)

# Filter subdirectories that contain a Move.toml file
MOVE_SUBDIRS := $(foreach dir,$(SUBDIRS),$(if $(wildcard $(dir)Move.toml),$(dir)))
MAKE_SUBDIRS := $(foreach dir,$(SUBDIRS),$(if $(wildcard $(dir)Makefile),$(dir)))

format-move:
	@bun run format:move-all

build-all:
	@for dir in $(MOVE_SUBDIRS); do \
		echo "==> building $$dir"; cd $$dir; sui move build; cd -; \
	done


test-all:
	@for dir in $(MOVE_SUBDIRS); do \
		echo "==> testing $$dir"; cd $$dir; sui move test -i 5000000; cd -; \
	done

# add license header to every source file
add-license:
	@for dir in $(MOVE_SUBDIRS); do \
		cd $$dir; make add-license; cd -; \
	done
# with reuse tool:
# docker run --rm --volume $(pwd):/data fsfe/reuse annotate --license MPL-2.0  */tests/*.move */sources/*.move  -s cpp

.PHONY: add-license, build-all, test-all
