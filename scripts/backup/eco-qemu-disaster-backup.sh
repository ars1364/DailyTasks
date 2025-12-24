#!/bin/bash

#### Variables and value assign
BackupDir=/Backup/newmethod/eco
BaseDir=/opt/scripts/CephDisasterBackup/eco
PoolName=cinder-volumes
time=`date '+%Y-%m-%d'` #get time for create appropriate directory in NFS
rbd -p $PoolName ls > $BaseDir/volume_ids.txt ##get volume id from ceph
ls $BackupDir/ > $BaseDir/old_volume_ids.txt # get the current list and compare it with new list
noLongerExistVolumes=$(grep -Fxvf $BaseDir/volume_ids.txt $BaseDir/old_volume_ids.txt )

#Prepare enviroment
mkdir -p $BackupDir/new

# announcing start time
echo "Start time is: " `date` >>$BaseDir/date.txt

##start get backup form ceph for new and duplicate volumes
for i in $(cat $BaseDir/volume_ids.txt) ; do
    echo $i
    if [ -s $BackupDir/$i ] #$i is here for second time
    then
        qemu-img convert -f raw -O qcow2 -p rbd:$PoolName/$i $BackupDir/new/$i #pull volume form ceph and add to NFS(BackupDir)
        rm -rf $BackupDir/$i #delete old version
        mv $BackupDir/new/$i $BackupDir/$i # move new one in main folder
    else
        qemu-img convert -f raw -O qcow2 rbd:$PoolName/$i $BackupDir/$i -p #if $i is here for first time
    fi
done
rm -rf $BackupDir/new #remove temp directory

# no longer exsist volumes
if [ ! -z "$noLongerExistVolumes" ] # value content check
then
    for k in $noLongerExistVolumes ; do #iterate list of volume to delete
        rm -rf $(find $BackupDir/$k -ctime +30) # remove volumes older than 30 days
    done
else
    echo "No nominated found to remove"
fi
echo "End time is: " `date` >>$BaseDir/date.txt
