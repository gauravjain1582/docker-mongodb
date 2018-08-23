docker exec -it $(docker ps -qf label=com.docker.swarm.service.name=mongoDBStack_mdbS1) mongo --eval 'rs.initiate({ _id: "mdb_repSet", members: [{ _id: 1, host: "mongoDBStack_mdbS1:27017" }, { _id: 2, host: "mongoDBStack_mdbS2:27017" },{ _id: 3, host: "mongoDBStack_mdbS3:27017" }], settings: { getLastErrorDefaults: { w: "majority", wtimeout: 30000 }}})'
MongoDB shell version v4.0.1


docker exec -it $(docker ps -qf label=com.docker.swarm.service.name=mongoDBStack_mdbS1) mongo --eval 'rs.config()'
docker exec -it $(docker ps -qf label=com.docker.swarm.service.name=mongoDBStack_mdbS1) mongo --eval 'rs.status()'
docker exec -it $(docker ps -qf label=com.docker.swarm.service.name=mongoDBStack_mdbS1) mongo --eval 'rs.printReplicationInfo()'
