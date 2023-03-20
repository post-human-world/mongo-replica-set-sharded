# Workflow

1. docker-compose up
2. run */config/init.sh* in *mongo1*, *configdb1*, *mongos*. It must run *mongo1* and *config1* before *mongos* to ensure *mongos* can connect to the nodes

# Reference

- [Create a replica set in MongoDB with Docker Compose](https://blog.tericcabrel.com/mongodb-replica-set-docker-compose/)
- [Deploy Replica Set With Keyfile Authentication](https://www.mongodb.com/docs/manual/tutorial/deploy-replica-set-with-keyfile-access-control/)
- [Sharding](https://www.mongodb.com/docs/manual/sharding/)
- [How to create user in Shard server](https://www.mongodb.com/community/forums/t/how-to-create-user-in-shard-server/117415)