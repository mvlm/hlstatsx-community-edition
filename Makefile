
# Build options
IMAGE_NAME?=mvlm/hlxce
IMAGE_TAG?=latest

.PHONY: build
build:
	docker build . \
	-f dockerfiles/nginx.dockerfile \
	-t $(IMAGE_NAME):nginx-$(IMAGE_TAG)

	docker build . \
	-f dockerfiles/php.dockerfile \
	-t $(IMAGE_NAME):php-$(IMAGE_TAG)

	docker build . \
	-f dockerfiles/hlxce-daemon.dockerfile \
	-t $(IMAGE_NAME):daemon-$(IMAGE_TAG)

.PHONY: publish
publish:
	docker push $(IMAGE_NAME):nginx-$(IMAGE_TAG)
	docker push $(IMAGE_NAME):php-$(IMAGE_TAG)
	docker push $(IMAGE_NAME):daemon-$(IMAGE_TAG)
