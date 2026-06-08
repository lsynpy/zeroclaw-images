# ZeroClaw Images — Makefile
# ============================
# Local dev helpers. CI does the real work.

VERSION ?= v0.8.0-beta-2
IMAGE   ?= ghcr.io/lsynpy/zeroclaw-full

.PHONY: help compile build push run release

help:
	@echo "Targets:"
	@echo "  compile         Trigger cross-compile in GitHub Actions"
	@echo "  build           Build Docker image locally"
	@echo "  push            Build and push to GHCR"
	@echo "  run             Run locally (tmp config)"
	@echo "  release         compile + build (full pipeline)"

# ── Cross-compile (in CI) ──
compile:
	gh workflow run cross-compile.yml \
		--repo lsynpy/zeroclaw-images \
		-f version=$(VERSION)

# ── Local Docker build (uses pre-compiled binary from release) ──
build:
	docker build \
		--build-arg VERSION=$(VERSION) \
		-t $(IMAGE):$(VERSION) \
		-t $(IMAGE):latest \
		images/zeroclaw-full

push: build
	docker push $(IMAGE):$(VERSION)
	docker push $(IMAGE):latest

# ── Quick local test ──
run: build
	docker run --rm -it \
		--name zeroclaw \
		$(IMAGE):$(VERSION)

# ── Full pipeline (CI trigger + note) ──
release:
	@echo "=== Triggering CI cross-compile ==="
	$(MAKE) compile
	@echo ""
	@echo "Wait for cross-compile to finish, then:"
	@echo "  gh workflow run build-image.yml -f version=$(VERSION)"
	@echo ""
	@echo "Or wait for the release trigger to pick it up automatically."
