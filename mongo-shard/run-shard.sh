#!bin/bash

ROOT_PASSWORD='12345661@'
ROOT_USER='root'

echo "cleaning all other process..."
sudo kill -9 `lsof  -i | grep mongod | awk '{print $2}'`
sudo kill -9 `lsof  -i | grep mongos | awk '{print $2}'`

echo "cleaning up paths..."
cd ~
rm -rf shard-demo

echo "Setting up shard paths"
mkdir -p shard-demo/configsrv shard-demo/configsrv1 shard-demo/configsrv2 shard-demo/shardrep1 shard-demo/shardrep2 shard-demo/shardrep3 shard-demo/shard2rep1 shard-demo/shard2rep2 shard-demo/shard2rep3
## Setup keyfile
openssl rand -base64 756 > shard-demo/keyfile.yml
chmod 400 shard-demo/keyfile.yml

echo  "Setting up Config replica..."
nohup mongod --configsvr  --port 28041 --replSet config_repl --keyFile shard-demo/keyfile.yml --dbpath ~/shard-demo/configsrv &
nohup mongod --configsvr  --port 28042 --replSet config_repl --keyFile shard-demo/keyfile.yml --dbpath ~/shard-demo/configsrv1 &
nohup mongod --configsvr  --port 28043 --replSet config_repl --keyFile shard-demo/keyfile.yml --dbpath ~/shard-demo/configsrv2 &
sleep 7
echo "Initating config replica"
mongosh --port 28041 --eval 'var config = { _id: "config_repl", members: [ { _id: 0, host: "localhost:28041" }, { _id: 1, host: "localhost:28042" }, { _id: 3, host: "localhost:28043" } ] }; rs.initiate( config ); while (rs.status().startupStatus || (rs.status().hasOwnProperty("myState") && rs.status().myState != 1)) { printjson( rs.status() ); sleep(1000); }; printjson( rs.status() );'


echo  "Setting up shard1 replica..."
nohup mongod --shardsvr --port 28081 --replSet shard_repl --keyFile shard-demo/keyfile.yml --dbpath ~/shard-demo/shardrep1 &
nohup mongod --shardsvr --port 28082 --replSet shard_repl --keyFile shard-demo/keyfile.yml --dbpath ~/shard-demo/shardrep2 &
nohup mongod --shardsvr --port 28083 --replSet shard_repl --keyFile shard-demo/keyfile.yml --dbpath ~/shard-demo/shardrep3 &
sleep 7
echo "Initating shard1 replica"
mongosh --port 28081 --eval 'var config = { _id: "shard_repl", members: [ { _id: 0, host: "localhost:28081" }, { _id: 1, host: "localhost:28082" }, { _id: 3, host: "localhost:28083" } ] }; rs.initiate( config ); while (rs.status().startupStatus || (rs.status().hasOwnProperty("myState") && rs.status().myState != 1)) { printjson( rs.status() ); sleep(1000); }; printjson( rs.status() );'

echo  "Setting up shard2 replica..."
nohup mongod --shardsvr --port 29081 --replSet shard2_repl --keyFile shard-demo/keyfile.yml --dbpath ~/shard-demo/shard2rep1 &
nohup mongod --shardsvr --port 29082 --replSet shard2_repl --keyFile shard-demo/keyfile.yml --dbpath ~/shard-demo/shard2rep2 &
nohup mongod --shardsvr --port 29083 --replSet shard2_repl --keyFile shard-demo/keyfile.yml --dbpath ~/shard-demo/shard2rep3 &
sleep 7
echo "Initating shard2 replica"
mongosh --port 29081 --eval 'var config = { _id: "shard2_repl", members: [ { _id: 0, host: "localhost:29081" }, { _id: 1, host: "localhost:29082" }, { _id: 3, host: "localhost:29083" } ] }; rs.initiate( config ); while (rs.status().startupStatus || (rs.status().hasOwnProperty("myState") && rs.status().myState != 1)) { printjson( rs.status() ); sleep(1000); }; printjson( rs.status() );'


echo  "Setting up mongos..."
nohup mongos --keyFile shard-demo/keyfile.yml --configdb config_repl/localhost:28041,localhost:28042,localhost:28043 &
sleep 5

# create root user
echo "Root users..."
mongosh --host localhost --port 27017 --eval "var admin = db.getSiblingDB('admin'); admin.createUser({ user: '$ROOT_USER', pwd: '$ROOT_PASSWORD', roles: [ { role: 'root', db: 'admin' } ]}); admin.auth('$ROOT_USER', '$ROOT_PASSWORD');"

echo "Adding all shards using root user."
mongosh --host localhost --port 27017 -u $ROOT_USER -p $ROOT_PASSWORD --eval 'sh.addShard("shard_repl/localhost:28081,localhost:28082,localhost:28083"); sh.addShard( "shard2_repl/localhost:29081,localhost:29082,localhost:29083"); sh.status()'
echo "done."

