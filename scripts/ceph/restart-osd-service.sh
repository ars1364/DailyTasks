#!/bin/bash
#Restart CEPH OSD services in order to kernel reclaims the memory

#for i in e1 e3 e4 e5 e6 e7 e8 e9 e10 e25 e26 e32 ; do
#for i in E1 ; do
for i in $1 ; do
    echo "compute: $i"
    for j in $(ssh $i systemctl list-units --type=service --state=running | grep ceph-osd | awk '{print $1}');  do
        echo "Restarting: $j service" &&
                ssh $i systemctl restart $j &&
                sleep 25
    done
done
