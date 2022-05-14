Y=yarn -s --prefer-offline

include ui/elm-book.mk

.PHONY: install
install: .yarn.INSTALLED .yarn.examples-optimized.INSTALLED
.yarn.INSTALLED: package.json yarn.lock
	${Y} install
	@touch $@

.yarn.examples-optimized.INSTALLED: ./examples-optimized/package.json ./examples-optimized/yarn.lock
	${Y} --cwd examples-optimized install
	@touch $@

.PHONY: elm-examples
elm-examples: install
	cd examples && elm reactor & ${Y} --cwd examples-optimized start

.PHONY: elm-tests
elm-tests:
	${Y} elm-test

.PHONY: ts-tests
ts-tests: install
	./bin/test-ts.sh

.PHONY: ci-e2e-test
ci-e2e-test: 
	${Y} start-server-and-test  'make elm-examples' '8000|1234' 'make ts-tests'

.PHONY: elm-live
elm-live: install
	${Y} elm-live --no-server

.PHONY: elm-analyse
elm-analyse: install
	${Y} elm-analyse
