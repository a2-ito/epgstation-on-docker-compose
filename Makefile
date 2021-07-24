DOCKER      = docker
DOCKER_COMPOSE = docker-compose
DOCKERFILE  = Dockerfile
LINT_IGNORE = "DL3007"
GRADLEW     = ./gradlew
PACK        = pack
BUILDER_CNF = ./builder/builder.toml
BUILDER_IMG = my-builder:bionic
CONTAINER   = epgstation-on-docker-compose_mirakurun_1

all:
	$(DOCKER_COMPOSE) up -d
	sleep 10
	docker cp ./libpcsclite.so.1.0.0 $(CONTAINER):/usr/lib/x86_64-linux-gnu

clean:
	$(DOCKER_COMPOSE) down
