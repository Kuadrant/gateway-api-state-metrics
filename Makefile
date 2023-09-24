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

JSONNET_SRC_DIR := src/dashboards
JSONNET_TARGET_DIR := config/examples/dashboards
JSONNET_TARGETS := $(addprefix $(JSONNET_TARGET_DIR)/,$(patsubst %.jsonnet,%.json,$(shell ls $(JSONNET_SRC_DIR)/*.jsonnet | xargs -n 1 basename)))
DASHBOARD_CR_TARGETS := $(addprefix $(JSONNET_TARGET_DIR)/,$(patsubst %.jsonnet,%.yaml,$(shell ls $(JSONNET_SRC_DIR)/*.jsonnet | xargs -n 1 basename)))

$(JSONNET_TARGET_DIR)/%.json: $(JSONNET_SRC_DIR)/%.jsonnet
	jsonnet -J vendor $< -o $@

$(JSONNET_TARGET_DIR)/%.yaml: $(JSONNET_TARGET_DIR)/%.json
	DASHBOARD_NAME=$(shell echo "$<" | sed -r "s/.+\/(.+)\..+/\1/") envsubst < $(JSONNET_SRC_DIR)/dashboard_cr_template.yaml > $@
	cat "$<" | jq -c . >> $@

.PHONY: generate-dashboards
generate-dashboards: ${JSONNET_TARGETS}

.PHONY: generate-dashboard-crs
generate-dashboard-crs: generate-dashboards ${DASHBOARD_CR_TARGETS}

.PHONY: apply-latest-dashboard-crs
apply-latest-dashboard-crs: generate-dashboard-crs
	for i in ${DASHBOARD_CR_TARGETS}; do kubectl apply -f $$i; done

print-%  : ; @echo $* = $($*)
