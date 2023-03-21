# Build up Sharded Cluster

This repository uses docker compose to create 9 container

- sh0-mongo1, sh0-mongo2, sh0-mongo3
- sh1-mongo1, sh1-mongo2, sh1-mongo3
- configdb1, configdb2
- mongos

Three root users will be created with same password

- tom-sh0
- tom-sh1
- tom-mongos

# Usage

1. Build up all containers

```bash
docker compose up -d --build 
```

2. Run script at container and in the order of *sh0-mongo1*, *sh1-mongo1*, *configdb1*, *mongos*.

```bash
/config/init.sh
```

3. Access mongos with url: `mongodb://tom-mongos:jerry@localhost:27041/?directConnection=true&authMechanism=DEFAULT` and run `sh.status()`
   1. you can try to run `db.getUsers()` to check if they are using different user data

4. Run command at mongos shell to insert test data

```javascript
sh.enableSharding('test')
sh.shardCollection("test.sales", { "_id": "hashed" })

// inserting data for testing
var largeArray = []
for (let index = 0; index < 777; index++) {
    largeArray.push(
        { 'item': Math.random().toString().substring(2, 9), 'price': Math.random() * 100000, 'quantity': Math.random() * 100, 'date': new Date() }
    )
}
db.sales.insertMany(largeArray)

db.adminCommand( { flushRouterConfig: "test.sales" } );
db.getSiblingDB("test").sales.getShardDistribution();
```

This what i got after inserted 233K documents

```
[direct: mongos] test> db.getSiblingDB("test").sales.getShardDistribution();
Shard sh0 at sh0/sh0-mongo1:27017,sh0-mongo2:27017,sh0-mongo3:27017
{
  data: '9.66MiB',
  docs: 116506,
  chunks: 2,
  'estimated data per chunk': '4.83MiB',
  'estimated docs per chunk': 58253
}
---
Shard sh1 at sh1/sh1-mongo1:27017,sh1-mongo2:27017,sh1-mongo3:27017
{
  data: '9.69MiB',
  docs: 116825,
  chunks: 2,
  'estimated data per chunk': '4.84MiB',
  'estimated docs per chunk': 58412
}
---
Totals
{
  data: '19.35MiB',
  docs: 233331,
  chunks: 4,
  'Shard sh0': [
    '49.93 % data',
    '49.93 % docs in cluster',
    '87B avg obj size on shard'
  ],
  'Shard sh1': [
    '50.06 % data',
    '50.06 % docs in cluster',
    '87B avg obj size on shard'
  ]
}
```

# Reference

- [Create a replica set in MongoDB with Docker Compose](https://blog.tericcabrel.com/mongodb-replica-set-docker-compose/)
- [Deploy Replica Set With Keyfile Authentication](https://www.mongodb.com/docs/manual/tutorial/deploy-replica-set-with-keyfile-access-control/)
- [Sharding](https://www.mongodb.com/docs/manual/sharding/)
- [How to create user in Shard server](https://www.mongodb.com/community/forums/t/how-to-create-user-in-shard-server/117415)