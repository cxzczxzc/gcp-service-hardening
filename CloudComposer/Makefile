PROJECT_DIR = ${CURDIR}

fmt:
	cd test && go fmt $(wildcard *.go)
	terraform fmt -recursive .

test: export TF_COMMAND = plan
test: fmt
test:
	cd test && go mod tidy && go test -v -timeout 120m $(wildcard *.go)

test-apply: export TF_COMMAND = apply
test-apply: fmt
	cd test && go mod tidy && go test -v -timeout 120m $(wildcard *.go)

.PHONY: *
