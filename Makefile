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

clean:
	docker stop $(docker ps -qa)
	docker rm $(docker ps -qa)

fclean: clean
	docker rmi -f $(docker images -qa)
	docker volume rm $(docker volume ls -q)
	docker network rm $(docker network ls -q) 2>/dev/null

.PHONY: all up dev down exec clean fclean