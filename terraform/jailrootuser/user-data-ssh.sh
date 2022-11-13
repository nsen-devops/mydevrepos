Content-Type: multipart/mixed; boundary="//"
MIME-Version: 1.0

--//
Content-Type: text/cloud-config; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="cloud-config.txt"

#cloud-config
cloud_final_modules:
- [scripts-user, always]

--//
Content-Type: text/x-shellscript; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="userdata.txt"

#!/bin/bash
a="/dev/`lsblk | grep ${volume2_size}G |awk '{print $1}'`"
sudo file -s $a | grep 'SGI XFS filesystem'
if [ "`echo $?`" == 1 ];
then
        sudo mkdir /data
        sleep 10
        sudo mkfs -t xfs /dev/`lsblk | grep ${volume2_size}G |awk '{print $1}'`
        echo "/dev/`lsblk | grep ${volume2_size}G |awk '{print $1}'` /data xfs defaults,nofail 0 0" >> /etc/fstab
        sudo mount -a
        sudo useradd ${jailroot_username}
        echo ${ssh_user_pass} | sudo passwd --stdin ${jailroot_username}
        sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/; s/^PasswordAuthentication no/#PasswordAuthentication no/; /^#Match User/a Match User ssh\nChrootDirectory /data/'  /etc/ssh/sshd_config
        sudo systemctl restart sshd
        sudo mkdir -p /data/{bin,dev,etc,lib64,proc}
        sudo cp {/bin/bash,/bin/df,/bin/ls,/bin/grep} /data/bin/
        for i in `ldd /bin/bash /bin/ls /bin/df /bin/grep | grep -wo '[[:alnum:]]*/lib64/[[:alnum:]]*.*' |awk '{print $1}'`; do sudo cp $i /data/lib64/; done
        sudo cp -v /etc/mtab /data/etc/
        sudo aws s3 sync ${s3_bucket_path} /data
else
        sudo aws s3 sync ${s3_bucket_path} /data
fi
--//--
