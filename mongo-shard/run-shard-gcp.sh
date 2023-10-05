#!bin/bash

echo "cleaning all other process..."
sudo kill -9 `lsof  -i | grep mongod | awk '{print $2}'`
sudo kill -9 `lsof  -i | grep mongos | awk '{print $2}'`

echo "cleaning up paths..."
cd ~
rm -rf shard-demo

echo "Setting up shard paths"
mkdir -p shard-demo/configsrv shard-demo/configsrv1 shard-demo/configsrv2 shard-demo/shardrep1 shard-demo/shardrep2 shard-demo/shardrep3 shard-demo/shard2rep1 shard-demo/shard2rep2 shard-demo/shard2rep3

##### Config
echo  "Setting up Config replica..."
nohup mongod --configsvr  --host '10.2.2.1' --port 28041 --replSet config_repl --dbpath ~/shard-demo/configsrv &
nohup mongod --configsvr  --host '10.2.2.1' --port 28042 --replSet config_repl --dbpath ~/shard-demo/configsrv1 &
nohup mongod --configsvr  --host '10.2.2.1' --port 28043 --replSet config_repl --dbpath ~/shard-demo/configsrv2 &
sleep 7
echo "Initating config replica"
mongosh --port 28041 --eval 'var config = { _id: "config_repl", members: [ { _id: 0, host: "localhost:28041" }, { _id: 1, host: "localhost:28042" }, { _id: 3, host: "localhost:28043" } ] }; rs.initiate( config ); while (rs.status().startupStatus || (rs.status().hasOwnProperty("myState") && rs.status().myState != 1)) { printjson( rs.status() ); sleep(1000); }; printjson( rs.status() );'

##### Shards.....

######## Shard 1 
echo  "Setting up shard1 replica..."
nohup mongod --shardsvr --host '10.2.2.2' --port 28081 --replSet shard_repl1 --dbpath ~/shard-demo/shardrep1 &
######## Initiating replica 1
mongosh  --host '10.2.2.2' --port 28081 --eval 'var config = { _id: "shard_repl1", members: [ { _id: 0, host: "10.2.2.2:28081" } ] }; rs.initiate( config ); while (rs.status().startupStatus || (rs.status().hasOwnProperty("myState") && rs.status().myState != 1)) { printjson( rs.status() ); sleep(1000); }; printjson( rs.status() );'


######## Shard 2
echo  "Setting up shard2 replica..."
nohup mongod --shardsvr --host '10.2.2.3' --port 29081 --replSet shard_repl2 --dbpath ~/shard-demo/shard2rep1 &
######## Initiating replica 2
mongosh  --host '10.2.2.2' --port 29081 --eval 'var config = { _id: "shard_repl2", members: [ { _id: 0, host: "10.2.2.3:29081" } ] }; rs.initiate( config ); while (rs.status().startupStatus || (rs.status().hasOwnProperty("myState") && rs.status().myState != 1)) { printjson( rs.status() ); sleep(1000); }; printjson( rs.status() );'


######## Shard 3
echo  "Setting up shard2 replica..."
nohup mongod --shardsvr --host '10.2.2.4' --port 30081 --replSet shard_repl3 --dbpath ~/shard-demo/shard2rep1 &
######## Initiating replica 3
echo "Initating replica in primary node..."
mongosh  --host '10.2.2.2' --port 30081 --eval 'var config = { _id: "shard_repl3", members: [ { _id: 0, host: "10.2.2.4:30081" } ] }; rs.initiate( config ); while (rs.status().startupStatus || (rs.status().hasOwnProperty("myState") && rs.status().myState != 1)) { printjson( rs.status() ); sleep(1000); }; printjson( rs.status() );'


##### MongoS
echo  "[10.2.2.5] Setting up mongos..." 
nohup mongos --host '10.2.2.5' --port 27017  --configdb config_repl/10.2.2.1:28041,10.2.2.1:28042,10.2.2.1:28043 &
echo "Adding all shards.."
mongosh --host '10.2.2.5' --port 27017 --eval 'sh.addShard("shard_repl1/10.2.2.2:28081");sh.addShard("shard_repl2/10.2.2.3:29081"); sh.addShard("shard_repl3/10.2.2.4:30081"); sh.status()'


echo "done."
