#!/bin/bash
set -e

sleep 5

#function mount_volumes(){

  # format   volume
#  if [ `file -s /dev/nvme0n1 | cut -d ' ' -f 2` = 'data' ]; then
#      sudo mkfs -t ext4 /dev/nvme0n1
#  fi

  # create the mount point
#  if [ ! -d /mnt/cassandra ]; then
#      sudo mkdir -p /mnt/cassandra
#  fi

  # mount the volume
#  if ! grep /dev/nvme0n1 /etc/mtab > /dev/null; then
#      sudo mount /dev/nvme0n1 /mnt/cassandra
#  fi

  # update fstab
# if ! grep /mnt/cassandra /etc/fstab > /dev/null; then
#     sudo echo "/dev/nvme0n1 /mnt/cassandra ext4 defaults,nofail 0 2" >> /etc/fstab
#  fi

}#


echo "This is output of user_data" >> /tmp/app.txt
#mount_volumes
#echo "Volumes are mounted" >> /tmp/app.txt
