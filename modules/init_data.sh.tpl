#! /bin/bash
set -x

touch /tmp/init_log
exec 1>/tmp/init_log
exec 2>&1

#set hostname as cname
cname=${cname}
if [ "${cname}" ]; then
hostname "${cname}"
hostnamectl set-hostname "${cname}"
fi

cat <<EOT >/usr/local/bin/update_user.sh
#! /bin/bash
set -ex
touch /tmp/update_users.log
exec 1>/tmp/update_users.log
exec 2>&1
PATH=\$PATH:/usr/sbin
if [ -e "/etc/redhat-release" ]
then
#  if ! rpm -q epel-release
#  then
#    yum install epel-release -y
#  fi
  if ! rpm -q awscli
  then
    yum install awscli jq -y
  fi
else
    apt install awscli jq -y
fi
public_key=\`aws ssm get-parameter --name "/il5/dbaas/os/user/dbaas/public_key" --with-decryption --region ${region} | jq -r '.Parameter.Value'\`
if [ ! -d "/home/dbaas" ]
then
  useradd -d /home/dbaas -m -s /bin/bash dbaas
  chage -I -1 -m 0 -M 99999 -E -1 dbaas
  mkdir /home/dbaas/.ssh && chmod 700 /home/dbaas/.ssh
  echo '%dbaas ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
fi
if [ ! -f "/home/dbaas/.ssh/authorized_keys" ]
then
  echo "ssh-rsa \$public_key dbaas_key" > /home/dbaas/.ssh/authorized_keys
  cp /home/dbaas/.ssh/authorized_keys /home/dbaas/.ssh/authorized_keys2
  chown dbaas:dbaas -R /home/dbaas/.ssh
  chmod 400 /home/dbaas/.ssh/authorized_keys /home/dbaas/.ssh/authorized_keys2
fi
existing_key=\`awk '{print \$2}' /home/dbaas/.ssh/authorized_keys\`
if [ \$public_key != \$existing_key ]
then
  echo "ssh-rsa \$public_key dbaas_key" > /home/dbaas/.ssh/authorized_keys
  cp /home/dbaas/.ssh/authorized_keys /home/dbaas/.ssh/authorized_keys2
fi
EOT
chmod +x /usr/local/bin/update_user.sh
#echo "*/10 * * * * root bash /usr/local/bin/update_user.sh" > /etc/cron.d/update_users

if [ -e "/etc/redhat-release" ]; then
  if ! rpm -q WBXsdeos-rhel8; then
    yum install https://cmse4ext.webex.com/rmc/prod/bundle/rhel8_noarch/WBXsdeos-rhel8-1.0-1.el8.noarch.rpm -y
    cd /opt/sdeos/
    ./sdeos
  fi
fi
if ! rpm -q awscli
then
  yum install awscli jq -y
fi
echo "*/10 * * * * root bash /usr/local/bin/update_user.sh" >/etc/cron.d/update_users
if ! rpm -q nvme-cli; then
  yum install nvme-cli -y
fi

sleep 5 
nvme list | grep -v nvme0n1 | grep ^/dev | awk '{print $1" "$2}' | sed 's/ vol/ vol-/' > /tmp/nvme.list
aws ec2 describe-instances --instance-ids `curl -s http://169.254.169.254/latest/meta-data/instance-id` --region ${region} > /tmp/jq.out
aws ec2 describe-instances --instance-ids `curl -s http://169.254.169.254/latest/meta-data/instance-id` --region ${region} | jq '."Reservations"[]."Instances"[]."BlockDeviceMappings"[] | [.DeviceName, .Ebs.VolumeId]| @csv' | sed 's/["\]//g' | sed 's/,/ /' | grep /xv >> /tmp/nvme.list
cat /tmp/nvme.list | while read line 
do
  device_name=`echo $line | awk '{print $1}'`
  volume_id=`echo $line | awk '{print $2}'`
  echo $device_name
  echo $volume_id
  aws ec2 describe-volumes --volume-ids $volume_id --query "Volumes[*].{ID:VolumeId,Tag:Tags}" --region ${region} --output text | grep ^TAG | grep -v volume- | awk '{print "export "$2"="$3}' > /tmp/tag_data_env
  . /tmp/tag_data_env

  if ! file -s $device_name | grep "filesystem data"; then
      mkfs -t $fs_type -f -L $volume_label $device_name
  fi
  sleep 5
  echo "lsblk -f"
  lsblk -f 
  blkid >> /tmp/uuid
  uuid=`lsblk -f $device_name | grep -v ^NAME | awk '{print $4}'`
  echo $uuid
  mkdir -p $fs_mount_point
  if ! grep " $fs_mount_point " /etc/fstab; then
      echo "UUID=$uuid $fs_mount_point $fs_type $fs_mount_option 0 0" >> /etc/fstab
      mount $fs_mount_point
  fi
done

