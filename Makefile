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

jupyter:
	docker exec -it -u root ${NAME}-jupyter /bin/bash

prepare-database:
	docker exec -it ${CONTAINER_NAME} bash -c "cd /usr/src/app/; ./scripts/prepare.sh"

prepare-jupyter:
	docker exec -it -u root ${NAME}-jupyter ./scripts/jupyter.sh

log:
	docker logs datascience-piscine-jupyter

clean:
	docker stop $(docker ps -qa)
	docker rm $(docker ps -qa)

fclean: clean
	docker rmi -f $(docker images -qa)
	docker volume rm $(docker volume ls -q)
	docker network rm $(docker network ls -q) 2>/dev/null

.PHONY: all up dev down exec jupyter prepare-database prepare-jupyter log clean fclean