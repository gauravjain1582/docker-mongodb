# Create overlay network
# host 1
# docker network create --driver overlay --internal stack_storm

# Lable Mongo hosts
docker node update --label-add mongodb.rhost=1 $(docker node ls -q -f name=worker01)
docker node update --label-add mongodb.rhost=2 $(docker node ls -q -f name=worker01)
docker node update --label-add mongodb.rhost=3 $(docker node ls -q -f name=lenovo-dibba)

# host 1
ssh worker01 'docker volume create --name mongodb_datav1'
ssh worker01 'docker volume create --name mongodb_configv1'
# host 2
ssh worker01 'docker volume create --name mongodb_datav2'
ssh worker01 'docker volume create --name mongodb_configv2'
# host 3
ssh lenovo-dibba 'docker volume create --name mongodb_datav3'
ssh lenovo-dibba 'docker volume create --name mongodb_configv3'

#docker service create --replicas 1 --network stack_storm \
#--publish 27017:27017 \
#--mount type=volume,source=mongodb_datav1,target=/data/db \
#--mount type=volume,source=mongodb_configv1,target=/data/configdb \
#--constraint 'node.labels.mongodb.rhost == 1' \
#--name mdb1 mongo:latest \
#mongod --replSet stack_storm
##mongod --smallfiles --replSet stack_storm

docker network create   --driver overlay    --subnet=10.11.0.0/16   --gateway=10.11.0.2   --opt com.docker.network.mtu=1200 hosting

docker service create --replicas 1 --network hosting \
--publish 27017:27017 \
--mount type=volume,source=mongodb_datav1,target=/data/db \
--mount type=volume,source=mongodb_configv1,target=/data/configdb \
--constraint 'node.hostname == worker01' \
--name mdb1 mongo:latest \
mongod --replSet stack_storm

docker service create --replicas 1 --network hosting \
--publish 27019:27017 \
--mount type=volume,source=mongodb_datav2,target=/data/db \
--mount type=volume,source=mongodb_configv2,target=/data/configdb \
--constraint 'node.hostname == worker01' \
--name mdb2 mongo:latest \
mongod --replSet stack_storm

docker service create --replicas 1 --network hosting \
--publish 27020:27017 \
--mount type=volume,source=mongodb_datav3,target=/data/db \
--mount type=volume,source=mongodb_configv3,target=/data/configdb \
--constraint 'node.labels.mongodb.rhost == 3' \
--name mdb3 mongo:latest \
mongod --replSet stack_storm

#--add-host master:10.228.85.126 \
#--add-host master:10.228.85.72 \
#--add-host master:10.228.85.74 \


docker exec -it $(docker ps -qf label=com.docker.swarm.service.name=mdb1) mongo --eval 'rs.initiate({ _id: "stack_storm", members: [{ _id: 1, host: "mdb1:27017" }, { _id: 2, host: "mdb2:27017" }, { _id: 3, host: "mdb3:27017" }], settings: { getLastErrorDefaults: { w: "majority", wtimeout: 30000 }}})'

# with 2 host meanwhile
#docker exec -it $(docker ps -qf label=com.docker.swarm.service.name=mdb1) mongo --eval 'rs.initiate({ _id: "stack_storm", members: [{ _id: 1, host: "mdb1:27017" }, { _id: 3, host: "mdb3:27017" }], settings: { getLastErrorDefaults: { w: "majority", wtimeout: 30000 }}})'

#docker exec -it $(docker ps -qf label=com.docker.swarm.service.name=mdb1)  mongo --eval 'rs.initiate({ _id: "stack_storm", members: [{ _id: 1, host: "master:27018" }, { _id: 2, host: "worker01:27019" }, { _id: 3, host: "lenovo-dibba:27020" }], settings: { getLastErrorDefaults: { w: "majority", wtimeout: 30000 }}})'

#docker service rm mdb1
#docker service rm mdb2
#docker service rm mdb3
