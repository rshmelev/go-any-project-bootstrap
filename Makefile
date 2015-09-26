## quite simple makefile
.PHONY: build all test clean install fmt
.DEFAULT_GOAL := build

GOFLAGS ?= $(GOFLAGS:)

all: build install test

debugbuild:
	@BUILD_OPTION=debug ./build.sh

build:
	@./build.sh

install:
	@echo "installing..."
	@cp bin/* $(GOPATH)/bin

test: install
	@go test $(GOFLAGS) ./...

bench: install
	@go test -run=NONE -bench=. $(GOFLAGS) ./...

clean:
	@echo "cleanup..."
	@cd bin ; find * -exec rm -rf $(GOPATH)/bin/{} \;

fmt:
	@gofmt -w .

run:
	@go run *.go

## EOF