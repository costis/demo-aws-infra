IMAGE_REPO := costis/stimulus-reflex
IMAGE_TAG  := $(shell git rev-parse HEAD)

.PHONY: build
build:
	docker build -t ${IMAGE_REPO}:${IMAGE_TAG} .

.PHONY: push
push:
	docker push ${IMAGE_REPO}:${IMAGE_TAG}

.PHONY: publish
publish: build push
