#!/bin/bash
set -ev
docker-compose up -d
docker pull zentekmx/radtest
# Wait for MySQL to bootstrap
sleep 15
docker-compose ps
docker run -it --rm --network docker-freeradius_backend zentekmx/radtest radtest testing password freeradius 2 testing123
