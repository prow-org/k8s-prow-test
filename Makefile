DOCKER_REPO ?= vadar
IMAGE ?= spring3
VERSION ?= $(shell date +v%Y%m%d)-$(shell git describe --tags --always --dirty)

all: test build

clean:		## Clear all the .pyc/.pyo files and virtual env files.
   mvn clean

test:
	mvn test

build:
	mvn build

run: 
   mvn clean package

build-image:
	docker build --cache-from docker.io/$(DOCKER_REPO)/$(IMAGE):latest \
		-t docker.io/$(DOCKER_REPO)/$(IMAGE):$(VERSION) \
		-t docker.io/$(DOCKER_REPO)/$(IMAGE):latest .


push-image:
	docker push docker.io/$(PROJECT)/$(IMAGE):latest
	docker push docker.io/$(PROJECT)/$(IMAGE):$(VERSION)

ci-release: clean test build build-image push-image

.PHONY: clean test build-image push-image ci-release


update-config:
	kubectl create configmap config --from-file=config.yaml=prow/config.yaml --dry-run -o yaml | kubectl replace configmap config -f -

update-plugins:
	kubectl create configmap plugins --from-file=plugins.yaml=prow/plugins.yaml --dry-run -o yaml | kubectl replace configmap plugins -f -

update-jobs:
	kubectl create configmap job-config --from-file=prow/jobs/ --dry-run -o yaml | kubectl replace configmap job-config -f -

deploy-prow:
	kubectl create -f prow/cluster/prow-starter.yaml

.PHONY: update-config update-plugins update-jobs deploy-prow
