find /lib*/ -iname "*.so*" -type f -exec  rpm -qf {} 2>&1  \; | grep "not owned by any package"|grep -v "vmware-tools"
find /usr/lib*/ -iname "*.so*" -type f -exec  rpm -qf {} 2>&1  \; | grep "not owned by any package"|grep -v "vmware-tools"
