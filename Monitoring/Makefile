.PHONY: lint
lint:
	python3 -m pylint --fail-under=6 src/api*

.PHONY: test
test:
	python3 -m pytest --version
	python3 -m pytest src/tests -vv --show-capture stderr --disable-warnings

.PHONY: black
black:
	python3 -m black --version
	python3 -m black src/*/*.py

# .PHONY: ci
# 	ci: precommit lint test

.PHONY: full
full: lint pytest black