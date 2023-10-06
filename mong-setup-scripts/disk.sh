#!/bin/bash



echo "create disk partition"

sudo fdisk /dev/sdb

sudo mkfs -t ext4 /dev/sdb1


sudo mkdir -p /media/data 



sudo mount /dev/sdb1 /media/data/



