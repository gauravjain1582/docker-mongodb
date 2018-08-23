# docker pull mongo-express
# run mongo-express container link with mongoDB (container)
# to get UI access for MongoDB have to run this container in run-time
# mongoDB container is already running
#docker run --link 8a654ed1e607:mongo -p 8881:8081 mongo-express
docker service create --replicas 1 \
--publish 8881:8081 \
--env ME_CONFIG_MONGODB_SERVER="mongoDBStack_mdbS1" \
--constraint 'node.hostname == worker01' \
--network mongoDBStack_mdbnw \
--network traefik \
-l traefik.enable=true \
-l traefik.frontend.passHostHeader=true \
-l traefik.frontend.rule="Host:mdb.vlekh.net,http://mdb.vlekh.net" \
-l traefik.backend=mexp \
-l traefik.docker.network=traefik \
-l traefik.entryPoint=https \
-l traefik.port=8081 \
--name mexp mongo-express:latest
