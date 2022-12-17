#!/bin/bash
#set iotune(QoS) parameters on economy class compute nodes

for i in e1 e2 e3 e4 e5 e6 e7 e8 e9 e10 e11 e12 e13 e14 e15 e16 e17 e18 e19 e20 e21 e22 e23 e24 e25 e26 e27 e28 e29 e30 e31 e32 e33 e34 e35 ; do
    echo $i
    for j in $(timeout 5 ssh $i virsh list | grep instance | awk '{print $2}');    do
        echo "Instance name (qemu)--> $j"
        for k in $(timeout 5 ssh $i virsh domblklist $j | grep .| grep -v -E 'Target|\-\-' | awk '{print $1}');do
            echo "Disk name--> $k"
            timeout 5 ssh $i virsh blkdeviotune $j $k --total_bytes_sec 314572800 --live && echo "setting --total_bytes_sec" &&
            timeout 5 ssh $i virsh blkdeviotune $j $k --total_bytes_sec 314572800 --config && echo "setting --total_bytes_sec" &&
            timeout 5 ssh $i virsh blkdeviotune $j $k --total_iops_sec 300 --live && echo "setting --total_iops_sec" &&
            timeout 5 ssh $i virsh blkdeviotune $j $k --total_iops_sec 300 --config && echo "setting --total_iops_sec"
        done
    done
done
