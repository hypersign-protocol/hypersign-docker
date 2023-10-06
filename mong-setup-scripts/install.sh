#!/bin/bash

sudo apt-get install gnupg curl -y



curl -fsSL https://pgp.mongodb.com/server-7.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg \
   --dearmor



echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list


sudo apt-get update

sudo apt-get install -y mongodb-org




sudo mkdir -p /media/data

sudo chown mongodb:mongodb /media/data






sudo rm /etc/mongod.conf

echo "# mongod.conf

# for documentation of all options, see:
#   http://docs.mongodb.org/manual/reference/configuration-options/

# Where and how to store data.
storage:
  dbPath: /media/data
#  engine:
#  wiredTiger:

# where to write logging data.
systemLog:
  destination: file
  logAppend: true
  path: /var/log/mongodb/mongod.log

# network interfaces
net:
  port: 27017
  bindIp: 0.0.0.0


# how the process runs
processManagement:
  timeZoneInfo: /usr/share/zoneinfo

#security:
security:
    authorization: enabled
#operationProfiling:

#replication:

#sharding:

## Enterprise-Only Options:

#auditLog:

" | sudo tee  /etc/mongod.conf



sudo systemctl start mongod

sudo systemctl daemon-reload


sudo systemctl status mongod





