## Location to install dependencies to
LOCALBIN ?= $(shell pwd)/bin
$(LOCALBIN):
	mkdir -p $(LOCALBIN)

# Get the currently used golang install path (in GOPATH/bin, unless GOBIN is set)
ifeq (,$(shell go env GOBIN))
GOBIN=$(shell go env GOPATH)/bin
else
GOBIN=$(shell go env GOBIN)
endif

SHELL = /usr/bin/env bash -o pipefail

.PHONY: test
test:
	./tests/e2e.sh

.PHONY: generate-bundles
generate-bundles:
	kustomize build ./config/examples/kube-prometheus | docker run --rm -i ryane/kfilt -i kind=CustomResourceDefinition > ./config/examples/kube-prometheus/bundle_crd.yaml
	kustomize build ./config/examples/kube-prometheus | docker run --rm -i ryane/kfilt -x kind=CustomResourceDefinition > ./config/examples/kube-prometheus/bundle.yaml


.PHONY: compare-bundles
compare-bundles: generate-bundles
	git diff --exit-code