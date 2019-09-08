#!/bin/bash

docker volume rm $(docker volume ls -qf dangling=true)
docker network ls $(docker network ls | awk '$3 == "bridge" && $2 != "bridge" { print $1 }')
docker rm -f $(docker ps -a -q)
docker rmi -f $(docker images -q)


