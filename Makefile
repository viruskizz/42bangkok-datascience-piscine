NAME=datascience-piscine
CONTAINER_NAME=${NAME}-database
$(NAME): all

all: up

up:
	docker compose up -d

dev:
	docker compose up

down:
	docker compose down

exec:
	docker exec -it ${CONTAINER_NAME} /bin/bash

.PHONY: all up dev