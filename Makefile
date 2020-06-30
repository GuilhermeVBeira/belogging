.PHONY: clean-pyc

default: test

clean-pyc:
	@find . -iname '*.py[co]' -delete
	@find . -iname '__pycache__' -delete
	@find . -iname '.coverage' -delete
	@rm -rf htmlcov/
	@rm -rf *.tox/

clean-dist:
	@rm -rf dist/
	@rm -rf build/
	@rm -rf *.egg-info

clean: clean-pyc clean-dist

lint:
	pre-commit run -a -v

test:
	pytest -xv

test-ci: clean lint test

dist: clean
	python setup.py sdist
	python setup.py bdist_wheel

release: dist
	git tag `python setup.py -q version`
	git push origin `python setup.py -q version`
	twine upload dist/*

changelog-preview:
	@echo "\nmaster ("$$(date '+%Y-%m-%d')")"
	@echo "-------------------\n"
	@git log $$(python setup.py -q version)...master --oneline --reverse
