#!/bin/bash
#generating name and path of luns to create and execute and qemu convert command
set -e
EXIT_CODE=0
BackupDir=/Backup/SanDisasterBackup
BaseDir=/opt/scripts/SanDisasterBackup
time=`date '+%Y-%m-%d'` # get time for create appropriate directory in NFS
> $BaseDir/volume_ids.txt
ls $BackupDir/ > $BaseDir/old_volume_ids.txt
mkdir -p $BackupDir/new
#inter=0
# announcing start time
echo "Start time is: " `date` >>$BaseDir/date.txt
for i in s3 s4 s6 s8 s9 s12 s13 s14 s15 s20; do # iterate list of hosts
        echo $i
        for j in $(timeout 5 ssh $i virsh list --all | grep instance | awk '{print $2}'); do # iterate list of inatnces againts hosts
                echo "Instance name (qemu)--> $j"
                blkCounter=0 # there are possibility to cinder id return more than one row, this counter controll it to ensure file name is correct
                for k in $(timeout 5 ssh $i virsh domblklist $j | grep .| grep -v -E 'Target|\-\-' | awk '{print $2}');do # iterate list of disks againts instances
                        blkCounter=$((blkCounter+1))
                        prjname=$(timeout 5 ssh $i virsh dumpxml $j | grep project | awk  -F [\>\<] '{print $3}') # get the disk name e.g= VPC_v.kargar.gh@gmail.com_00:33:03
                        cinderid=$(timeout 5 ssh $i virsh dumpxml $j | grep "<serial>" | cut -d ">" -f2| cut -d "<" -f1 | awk "NR==${blkCounter}")
                        echo $cinderid
                        filename=$prjname---$cinderid
                        echo $filename >> $BaseDir/volume_ids.txt #genarting list of current volume to be compared with old ones
                        echo "Disk name --> $k"
                        if [ -s $BackupDir/$filename ] # k is here for second time
                        then
                                ssh $i qemu-img  convert -f raw -O qcow2 $k $BackupDir/new/$filename -p || EXIT_CODE=$? # if k is here for first time
                                echo $EXIT_CODE
                                rm -rf $BackupDir/$filename # delete old version
                                mv $BackupDir/new/$filename $BackupDir/$filename # move new one in main folder
                                echo $filename
                        else
                                ssh $i qemu-img  convert -f raw -O qcow2 $k $BackupDir/$filename -p || EXIT_CODE=$?
                                echo $EXIT_CODE
                        fi
                done
#               if [[ $inter == 1 ]]
#               then
#                       break;
#               fi
#               inter=$((inter+1))

        done
done

rm -rf $BackupDir/new
noLongerExistVolumes=$(grep -Fxvf $BaseDir/volume_ids.txt $BaseDir/old_volume_ids.txt )
# no longer exsist volumes
if [ ! -z "$noLongerExistVolumes" ]
then
        for l in $noLongerExistVolumes ; do
                rm -rf $(find $BackupDir/$l -ctime +29)
        done
else
        echo "No nominated found to remove"
fi
echo "End time is: " `date` >>$BaseDir/date.txt
