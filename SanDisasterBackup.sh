#!/bin/bash
#generating name and path of luns to create and execute and qemu convert command
BackupDir=/Backup/newmethod/eco
BaseDir=/opt/scripts/SanDisasterBackup/eco
time=`date '+%Y-%m-%d'` # get time for create appropriate directory in NFS
ls $BackupDir/ > $BaseDir/old_volume_ids.txt
mkdir -p $BackupDir/new

# announcing start time
echo "Start time is: " `date` >>$BaseDir/date.txt
for i in s3 e1 e2 e3 e4 e5 e6 e7 e8; do # iterate list of hosts
    echo $i
    for j in $(timeout 5 ssh $i virsh list | grep instance | awk '{print $2}');    do # iterate list of inatnces againts hosts
        echo "Instance name (qemu)--> $j"
        for k in     $(timeout 5 ssh $i virsh domblklist $j | grep .| grep -v -E 'Target|\-\-' | awk '{print $2}');do # iterate list of disks againts instances
#			disk=    $(timeout 5 ssh $i virsh domblklist $j | grep .| grep -v -E 'Target|\-\-' | awk '{print $1}') # get the disk name e.g=vda
			prjname= $(timeout 5 ssh $i virsh dumpxml    $j | grep  project | awk  -F [\>\<] '{print $3}') # get the disk name e.g= VPC_v.kargar.gh@gmail.com_00:33:03
			cinderid=$(timeout 5 ssh $i virsh dumpxml    $j | grep  "<serial>" | cut -d ">" -f2| cut -d "<" -f1 )
			filename=$prjname---$cinderid
			$filename > $BaseDir/volume_ids.txt #genarting list of current volume to be compared with old ones
            echo "Disk name --> $k"
			if [ -s $BackupDir/$filename ] # k is here for second time
			then
				qemu-img  convert -f raw -O qcow2 $k $BackupDir/new/$filename -p # if k is here for first time
				rm -rf $BackupDir/$filename # delete old version
				mv $BackupDir/new/$filename $BackupDir/$filename # move new one in main folder 
				echo $filename
			else
				qemu-img  convert -f raw -O qcow2 $k $BackupDir/$filename -p
			fi
        done
    done
done

rm -rf $BackupDir/new
noLongerExistVolumes=$(grep -Fxvf $BaseDir/volume_ids.txt $BaseDir/old_volume_ids.txt )
# no longer exsist volumes
if [ ! -z "$noLongerExistVolumes" ]
then
    for l in $noLongerExistVolumes ; do
        rm -rf $(find $BackupDir/$l -ctime +30)
    done
else
    echo "No nominated found to remove"
fi
echo "End time is: " `date` >>$BaseDir/date.txt
