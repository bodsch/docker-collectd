
include env_make

NS       = bodsch
VERSION ?= latest

REPO     = docker-collectd
NAME     = collectd
INSTANCE = default

BUILD_DATE 	:= $(shell date +%Y-%m-%d)
BUILD_VERSION 	:= $(shell date +%y%m)
BUILD_TYPE 	?= "stable"
COLLECTD_VERSION ?= "5.8.0"

.PHONY: build push shell run start stop rm release

default: build

params:
	@echo ""
	@echo " COLLECTD_VERSION: ${COLLECTD_VERSION}"
	@echo " BUILD_DATE     : $(BUILD_DATE)"
	@echo ""

build: params
	docker build \
		--force-rm \
		--compress \
		--build-arg BUILD_DATE=$(BUILD_DATE) \
		--build-arg BUILD_VERSION=$(BUILD_VERSION) \
		--build-arg BUILD_TYPE=$(BUILD_TYPE) \
		--build-arg COLLECTD_VERSION=${COLLECTD_VERSION} \
		--tag $(NS)/$(REPO):$(COLLECTD_VERSION) .

clean:
	docker rmi \
		--force \
		$(NS)/$(REPO):$(COLLECTD_VERSION)

history:
	docker history \
		$(NS)/$(REPO):$(COLLECTD_VERSION)

push:
	docker push \
		$(NS)/$(REPO):$(COLLECTD_VERSION)

shell:
	docker run \
		--rm \
		--name $(NAME)-$(INSTANCE) \
		--interactive \
		--tty \
		$(PORTS) \
		$(VOLUMES) \
		$(ENV) \
		$(NS)/$(REPO):$(COLLECTD_VERSION) \
		/bin/sh

run:
	docker run \
		--rm \
		--name $(NAME)-$(INSTANCE) \
		--privileged \
		$(PORTS) \
		$(VOLUMES) \
		$(ENV) \
		$(NS)/$(REPO):$(COLLECTD_VERSION)

exec:
	docker exec \
		--interactive \
		--tty \
		$(NAME)-$(INSTANCE) \
		/bin/sh

start:
	docker run \
		--detach \
		--name $(NAME)-$(INSTANCE) \
		$(PORTS) \
		$(VOLUMES) \
		$(ENV) \
		$(NS)/$(REPO):$(COLLECTD_VERSION)

stop:
	docker stop \
		$(NAME)-$(INSTANCE)

rm:
	docker rm \
		$(NAME)-$(INSTANCE)

release: build
	make push -e VERSION=$(COLLECTD_VERSION)

default: build


