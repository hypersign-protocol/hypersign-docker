
## Run shards 

```bash
sh run-shard.sh
```

## Enable sharding on db "demo" and collection "users"


Connect to `mongos`:
```bash
mongosh --host localhost --port 27017
```
Then,

```bash
use demo; # Step1: Create a database
sh.enableSharding("demo"); # Step2: Enable sharding for db "demo"
db.users.createIndex({name: "hashed"}); # Step3: Create index (shard key) for collection 'users'
sh.shardCollection("demo.users", {name: "hashed"}); # Step4: Finally, add  shard key in collection
```
Other important commands:

```bash
db.users.getShardDistribution(); # check sharding status for users collection
db.printShardingStatus();  # print sharding status
sh.getBalancerState(); # print balancer state
sh.status()
```

## Deployment Architecture

### Local
![img](mongo-shard-architecture.png)

### GCP
![img](shard-gcp-architecture.png)


## Dumping 


```bash
sh mongodump.sh
```

## Restoring

First run your server 
```bash
ulimit -n 64000  && rm -rf ~/.mongo && mkdir ~/.mongo && mongod --dbpath ~/.mongo --port 2717
```


```bash
cd dir # into dir where all files are exported'
sh mongorestore.sh
```


db.
##


```
use admin;
db.createRole(
   {
     role: "my-user-role",
     privileges: [
       { resource: { cluster: true }, actions: [ "enableSharding", "shardCollection" ] }
     ],
     roles: [
       { role: "readWrite", db: "demo" }
     ]
   }
)

db.createRole(
   {
     role: "hypermineDBUserRole", 
     privileges: [
         { resource: { cluster: true }, actions:["shardCollection", "enableSharding"] },
         { resource: { db:"", collection: ""}, actions:["changeStream","collStats","compactStructuredEncryptionData","convertToCapped","createCollection","createIndex","dbHash","dbStats","dropIndex","find","insert","killCursors","listCollections","listIndexes","planCacheRead","remove","update"]},
     ],
     roles: ["readWriteAnyDatabase"]
   }
)

```
use admin 
db.createRole(
   {
     role: "hypermineDBUserRole",
     roles: ['readWriteAnyDatabase']
   }
)

## Create a new user

db.auth('fyreUser', 'fyreUser')
db.dropUser('fyreUser')
db.users.drop('fyreUser')
db.users.insertOne({})

```bash
## Creating role in fyre db
use fyre
db.createRole(
   {
     role: "fyreDBUserRole", 
     privileges: [
         { resource: { db:"fyre", collection: ""}, actions:["changeStream","collStats","compactStructuredEncryptionData","convertToCapped","createCollection","createIndex","dbHash","dbStats","dropIndex","find","insert","killCursors","listCollections","listIndexes","planCacheRead","remove","update"]},
     ],
     roles: []
   }
)

## Creating user for that role
use admin
db.createUser({
    user: 'fyreUser',
    pwd: 'fyreUser',
    roles: [
        {
            role: 'fyreDBUserRole', db: 'fyre'
        }
    ]
})
```

