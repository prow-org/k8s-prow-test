PROJECT ?= vadar
IMAGE ?= spring3

VERSION ?= $(shell date +v%Y%m%d)-$(shell git describe --tags --always --dirty)

image:
	docker build --cache-from docker.io/$(PROJECT)/$(IMAGE):latest \
		-t docker.io/$(PROJECT)/$(IMAGE):$(VERSION) \
		-t docker.io/$(PROJECT)/$(IMAGE):latest -f Dockerfile .


push:
	docker push docker.io/$(PROJECT)/$(IMAGE):latest
	docker push docker.io/$(PROJECT)/$(IMAGE):$(VERSION)


.PHONY: image push