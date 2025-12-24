#!/bin/bash
#set iotune(QoS) parameters on economy class compute nodes

escapelst=("instance-0000646d")
for i in b1 b2 b3 b4 b5 ; do
    echo $i
    for j in $(timeout 5 ssh $i virsh list | grep instance | awk '{print $2}');    do
        echo "Instance name (qemu)--> $j"
        if echo $escapelst | grep -w -q $j
        then
                for e in $(timeout 5 ssh $i virsh domblklist $j | grep .| grep -v -E 'Target|\-\-' | awk '{print $1}');do
                        echo "Disk name--> $e"
                        timeout 5 ssh $i virsh blkdeviotune $j $e --total_bytes_sec 319572800 --live && echo "setting -->total_bytes_sec done" &&
                        timeout 5 ssh $i virsh blkdeviotune $j $e --total_bytes_sec 319572800 --config && echo "setting -->total_bytes_sec done" &&
                        timeout 5 ssh $i virsh blkdeviotune $j $e --total_iops_sec 300 --live && echo "setting -->total_iops_sec done" &&
                        timeout 5 ssh $i virsh blkdeviotune $j $e --total_iops_sec 300 --config && echo "setting -->total_iops_sec done"
                done
        else
                for k in $(timeout 5 ssh $i virsh domblklist $j | grep .| grep -v -E 'Target|\-\-' | awk '{print $1}');do
                    echo "Disk name--> $k"
                    timeout 5 ssh $i virsh blkdeviotune $j $k --total_bytes_sec 209572800 --live && echo "setting -->total_bytes_sec done" &&
                    timeout 5 ssh $i virsh blkdeviotune $j $k --total_bytes_sec 209572800 --config && echo "setting -->total_bytes_sec done" &&
                    timeout 5 ssh $i virsh blkdeviotune $j $k --total_iops_sec 200 --live && echo "setting -->total_iops_sec done" &&
                    timeout 5 ssh $i virsh blkdeviotune $j $k --total_iops_sec 200 --config && echo "setting -->total_iops_sec done"
                done
        fi
    done
done
