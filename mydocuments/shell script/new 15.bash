#!/bin/bash
dt=$(date '+%d-%m-%Y_%H-%M-%S')
Outputs="/var/tmp/`hostname`"
VER="/var/tmp/`hostname`/$(date '+%d-%m-%Y')"
PATH=$PATH:/usr/sbin/:/usr/local/bin:/usr/bin:/usr/local/sbin:
if [ "$1" = "pre" ]
then
[ -e /var/tmp/`hostname` ] && echo "Directory /var/tmp/`hostname` already exists" || mkdir -p /var/tmp/`hostname`
[ -e /var/tmp/`hostname`/$(date '+%d-%m-%Y') ] && echo "Directory /var/tmp/`hostname`/$VER  already exists" || mkdir -p /var/tmp/`hostname`/$(date '+%d-%m-%Y')
[ -e /var/tmp/`hostname`/$(date '+%d-%m-%Y')/pre ] && echo "Directory /var/tmp/`hostname`/$VER/pre already exists" || mkdir -p /var/tmp/`hostname`/$(date '+%d-%m-%Y')/pre
[ -e /var/tmp/`hostname`/$(date '+%d-%m-%Y')/post ] && echo "" || mkdir -p /var/tmp/`hostname`/$(date '+%d-%m-%Y')/post

                echo -e "\e[44;32m#####################################Started PRE-CHECK BEGIN######################################\e[0m" |tee -a $VER/`hostname`_$dt
                echo -e "\e[31;43m***** HOSTNAME INFORMATION *****\e[0m" |tee -a $VER/`hostname`_$dt
				
				echo -e "SERVER NAME     :`hostname`" |tee -a $VER/`hostname`_$dt
				echo -e "KERNEL_INSTALLED:`uname -sr`" |tee -a $VER/`hostname`_$dt
				echo -e "OPERATING_SYSTEM:`cat /etc/redhat-release`" |tee -a $VER/`hostname`_$dt
				echo -e "UPTIME AND  LOAD:`uptime`"|tee -a $VER/`hostname`_$dt
					
					# copy the lvm file
				cp -p /etc/lvm/lvm.conf $Outputs/lvm.conf_pre
				cp -p /etc/security/limits.conf $Outputs/limits.conf_pre
				cp -p /etc/sysctl.conf $Outputs/sysctl.conf_pre
                cp -p /etc/sysconfig/network $Outputs/sysctl.conf_pre
                # copy the grub file
                OSVER=$(cat /etc/redhat-release | awk '{print $7}'| cut -d . -f 1)
                if [ ${OSVER} -eq 7 ]; then
                 cp -p /boot/grub2/grub.cfg $Outputs/grub.cfg_pre
                else
                 cp -p /boot/grub/grub.conf $Outputs/grub.conf_pre
                fi
				echo ""
				# -File system disk space usage:
				echo -e "\e[31;43m******* FILE SYSTEM DISK SPACE USAGE and COUNT:`df -TPh|wc -l` *****\e[0m" ||tee -a $Outputs/$VER/`hostname`_$dt
				df -TPh |tee -a $VER/`hostname`_$dt  
				echo ""
				df -hP | column -t|awk {'print $NF'}|grep -v Mounted|sort  >  $VER/pre/df_pre
				mountpoints=( $(awk '$1 !~ /^#/ && $2 ~ /^[/]/ {print $2}' /etc/fstab) )
				for mount in ${mountpoints[@]}; do
				if ! findmnt "$mount" &> /dev/null; then
				echo "$mount is declared in fstab but not mounted"
				fi
				done
				echo -e "\e[31;32mAll the mount declared in fstab are mounted\e[0m"
				echo ""
				  echo -e "\nFstab:\n\n`cat /etc/fstab`" >>  $VER/`hostname`_$dt
                for i in `df -TPH|grep -v Mounted | sort |awk '{print $7}'`
                                do
                                echo -e "\n$i:\n\n`ls -ld $i`" >> $VER/`hostname`_$dt
                                ls -ld $i|awk '{print $3,$4}' >> $VER/pre/mount-permission_pre
                                done
				echo ""
				#-network information
				echo -e "\e[31;43m ********* Network-Information**********\e[0m" |tee -a $VER/`hostname`_$dt
				echo ""
				for i in `ip addr show | awk '/inet.*brd/{print $NF}'`; do echo $i; ip addr show  $i  |  awk '{if ( $1 == "inet" ) { printf "%s%s\n", "IP:",$2; LINE=1 } } END { if ( LINE != 1 ) print "IP:-" }'; /sbin/ethtool $i | egrep -i "Link detected:" | sed 's/\t//'; done | sed '$!N;s/\n/ /;$!N;s/\n/ /' | awk '{ printf "%-10s%-25s%s %s %s\n", $1, $2, $3, $4, $5 }' |tee -a $VER/`hostname`_$dt $VER/pre/linkstatus
				echo ""
				for i in `ip addr show | awk '/inet.*brd/{print $NF}'`; do echo $i; ip addr show  $i |  awk '{if ( $4 == "mtu" ) { printf "%s%s\n", "MTU:",$5; LINE=1 } } END { if ( LINE != 1 ) print "MTU:-" }'; done|  sed '$!N;s/\n/ /'> /$VER/pre/MTU_pre
				
				ip a|grep inet|grep -v inet6 > /$VER/pre/ifconfig_pre
				echo -e "\e[31;43m *********** KernelIP Routing Table and COUNT:`netstat -rnp|wc -l` *********\e[0m" |tee -a $VER/`hostname`_$dt
				netstat -rnp | tee -a $VER/`hostname`_$dt  $VER/pre/netstat-a_pre
				
				echo ""

				service --status-all >> $VER/`hostname`_$dt
				echo -e "\e[31;43m ***** VERIFY ANY APPLICATION PROCESS IS RUNNING*****\e[0m"
                ps -ef|grep -v root |tee -a $VER/`hostname`_$dt
                echo -e "VERIFY ANY APPLICATION PROCESS IS RUNNING"
          
echo -e "\e[1;32m#####################################End######################################\e[0m" |tee -a $VER/`hostname`_$dt

echo  "mail body - server patching before pre_activity for hostname:`hostname` has been completed successfully" | mail -s  "Pre_chceck" -c srikanthtd.aws@gmail.com srikanthtd.linux@gmail.com

elif [ "$1" = "post" ]
                then
                                
echo -e "\e[44;32m#####################################Start the Post Check######################################\e[0m"

echo -e "\e[33mPost-check-Script:`hostname`\e[0m" |tee -a $VER/`hostname`_$dt
echo -e "\e[31;43m***** HOSTNAME INFORMATION *****\e[0m" |tee -a $VER/`hostname`_$dt
				
				echo -e "SERVER NAME     :`hostname`" |tee -a $VER/`hostname`_$dt
				echo -e "KERNEL_INSTALLED:`uname -sr`" |tee -a $VER/`hostname`_$dt
				echo -e "OPERATING_SYSTEM:`cat /etc/redhat-release`" |tee -a $VER/`hostname`_$dt
				echo -e "UPTIME AND  LOAD:`uptime`"|tee -a $VER/`hostname`_$dt
				
				echo -e "\e[31;43m******* FILE SYSTEM DISK SPACE USAGE and COUNT:`df -TPh|wc -l` *****\e[0m" ||tee -a $Outputs/$VER/`hostname`_$dt
				df -TPh |tee -a $VER/`hostname`_$dt  
				echo ""
				
				mountpoints=( $(awk '$1 !~ /^#/ && $2 ~ /^[/]/ {print $2}' /etc/fstab) )
				for mount in ${mountpoints[@]}; do
				if ! findmnt "$mount" &> /dev/null; then
				echo "$mount is declared in fstab but not mounted"
				fi
				done
				echo -e "\e[31;32mAll the mount declared in fstab are mounted\e[0m"
				echo ""
				
df -hP | column -t|awk {'print $NF'}|grep -v Mounted|sort  >  $VER/post/df_post
diff $VER/pre/df_pre $VER/post/df_post
                if [ $? == 0 ]
                then
                echo -e "\e[32mDF OUTPUT LOOKS GOOD\e[0m"
                else
                echo -e "\e[31mMISMATCH BETWEEN PRE & POST DF OUTPUT - PLEASE CHECK AND FIX\e[0m"
                fi
                for i in `df -TPH|grep -v Mounted | sort |awk '{print $7}'`
                do
                echo -e "\n$i:\n\n`ls -ld $i`" > /$VER/post/df
                ls -ld $i|awk '{print $3,$4}' >> /$VER/post/mount-permission_post
                done
diff /$VER/pre/mount-permission_pre /$VER/post/mount-permission_post
                if [ $? == 0 ]
                then
                echo -e "\e[32mDF OUTPUT PERMISSION LOOKS GOOD\e[0m"
                else
                echo -e "\e[31mMISMATCH BETWEEN PRE & POST DF OUTPUT  PERMISSION - PLEASE CHECK AND FIX\e[0m"
                fi
#-network information
				echo -e "\e[31;43m ********* Network-Information**********\e[0m" |tee -a $VER/`hostname`_$dt
				echo ""
				for i in `ip addr show | awk '/inet.*brd/{print $NF}'`; do echo $i; ip addr show  $i |  awk '{if ( $1 == "inet" ) { printf "%s%s\n", "IP:",$2; LINE=1 } } END { if ( LINE != 1 ) print "IP:-" }'; /sbin/ethtool $i | egrep -i "Link detected:" | sed 's/\t//'; done | sed '$!N;s/\n/ /;$!N;s/\n/ /' | awk '{ printf "%-10s%-25s%s %s %s\n", $1, $2, $3, $4, $5 }' |tee -a $VER/`hostname`_$dt /$VER/post/linkstatus
				echo ""

 ip a|grep inet|grep -v inet6 > /$VER/post/ifconfig_post
diff /$VER/pre/ifconfig_pre /$VER/post/ifconfig_post
                if [ $? == 0 ]
                then
                echo -e "\e[32mIFCONFIG OUTPUT LOOKS GOOD\e[0m"
                else
                echo -e "\e[31mMISMATCH BETWEEN PRE & POST IFCONFIG OUTPUT - PLEASE CHECK AND FIX\e[0m"
                fi

                
diff /$VER/pre/linkstatus /$VER/post/linkstatus
              if [ $? == 0 ]
              then
              echo -e "\e[32mLINK STATUS OUTPUT LOOKS GOOD\e[0m"
              else
              echo -e "\e[31mMISMATCH BETWEEN PRE & POST LINKSTATUS OUTPUT - PLEASE CHECK AND FIX\e[0m"
              fi

for i in `ip addr show | awk '/inet.*brd/{print $NF}'`; do echo $i; ip addr show  $i |  awk '{if ( $4 == "mtu" ) { printf "%s%s\n", "MTU:",$5; LINE=1 } } END { if ( LINE != 1 ) print "MTU:-" }'; done|  sed '$!N;s/\n/ /' > /$VER/post/MTU_post
diff /$VER/pre/MTU_pre /$VER/post/MTU_post
                if [ $? == 0 ]
                then
                echo -e "\e[32mMTU OUTPUT LOOKS GOOD\e[0m"
                else
                echo -e "\e[31mMISMATCH BETWEEN PRE & POST MTU OUTPUT - PLEASE CHECK AND FIX\e[0m"
                fi
				
	echo -e "\e[31;43m *********** KernelIP Routing Table and COUNT:`netstat -rnp|wc -l` *********\e[0m" |tee -a $VER/`hostname`_$dt
				netstat -rnp | tee -a $VER/`hostname`_$dt 
				
				echo ""			
netstat -rnp >  /$VER/post/netstat-a_post
diff /$VER/pre/netstat-a_pre /$VER/post/netstat-a_post
                if [ $? == 0 ]
                then
                echo  -e "\e[32mNETSTAT OUTPUT LOOKS GOOD\e[0m"
                else
                echo -e "\e[31mMISMATCH BETWEEN PRE & POST NETSTAT OUTPUT - PLEASE CHECK AND FIX\e[0m"
                fi
echo  "mail body - server patching after post_activity for hostname:`hostname` has been completed successfully" | mail -s  "Post_chceck" -c srikanthtd.aws@gmail.com srikanthtd.linux@gmail.com

else

    echo "use the script with option 'pre' or 'post'"
fi

=======================================================================================================================================================================
#pvs -a --config 'devices { filter = [ "a|.*|" ] }' --noheadings -opv_name,fmt,vg_name | awk 'BEGIN { f = ""; } NF == 3 { n = "\42a|"$1"|\42, "; f = f n; } END { print "Suggested filter line for /etc/lvm/lvm.conf:\n filter = [ "f"\"r|.*|\" ]" }'

# pvs -a --config 'devices { filter = [ "a|.*|" ] }' --noheadings -opv_name| uniq -w 8|sed 's/\([0-9][0-9]\)/*/' | awk 'BEGIN { f = ""; } NF == 1 { n = "\42a|"$1"|\42, "; f = f n; } END { print "Suggested filter line for /etc/lvm/lvm.conf:\n filter = [ "f"\"r|.*|\" ]" }' 