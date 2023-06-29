#!/bin/sh

docker-compose build --build-arg UID=$(id -u) --build-arg GID=131 akkoma
docker-compose build --build-arg UID=$(id -u) --build-arg GID=131 db
# docker-compose run --rm -d --user root --name akkoma-db-install db
# docker exec -it akkoma-db-install /usr/local/bin/setup-db.sh
# docker kill akkoma-db-install
# docker rm akkoma-db-install
