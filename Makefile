# ZeroClaw Images — Makefile
# ============================

VERSION ?= v0.8.0-beta-2
VARIANT ?= default-feishu
IMAGE   ?= ghcr.io/lsynpy/zeroclaw-full

.PHONY: help compile build push run release

help:
	@echo "Targets:"
	@echo "  compile         Trigger cross-compile in GitHub Actions"
	@echo "  build           Build Docker image locally"
	@echo "  push            Build and push to GHCR"
	@echo "  run             Run locally (tmp config)"
	@echo ""
	@echo "Variables:"
	@echo "  VERSION=$(VERSION)    ZeroClaw version"
	@echo "  VARIANT=$(VARIANT)    Binary variant: minimal | default-nochan | default-feishu"

# ── Cross-compile (in CI) ──
compile:
	gh workflow run cross-compile.yml \
		--repo lsynpy/zeroclaw-images \
		-f version=$(VERSION)

# ── Local Docker build ──
build:
	docker build \
		--build-arg VERSION=$(VERSION) \
		--build-arg VARIANT=$(VARIANT) \
		-t $(IMAGE):$(VARIANT)-$(VERSION) \
		-t $(IMAGE):$(VARIANT)-latest \
		images/zeroclaw-full

push: build
	docker push $(IMAGE):$(VARIANT)-$(VERSION)
	docker push $(IMAGE):$(VARIANT)-latest

# ── Quick local test ──
run: build
	docker run --rm -it \
		--name zeroclaw \
		$(IMAGE):$(VARIANT)-latest

# ── Helpers ──
compile-minimal:
	gh workflow run cross-compile.yml -f version=$(VERSION) -f variant=minimal

compile-default-nochan:
	gh workflow run cross-compile.yml -f version=$(VERSION) -f variant=default-nochan

compile-default-feishu:
	gh workflow run cross-compile.yml -f version=$(VERSION) -f variant=default-feishu
