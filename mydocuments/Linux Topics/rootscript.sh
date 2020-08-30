#Bash Routines Test
cp /.profile /home/kkasi/.profile.`date '+%Y%m%d'`
cp /.bashrc /home/kkasi/.bashrc.`date '+%Y%m%d'`
if [ `grep -i exec /.profile | grep -i bash | wc -l` -eq 1 ]
then
echo "Bash Routine Already present"
else
cat >>/.profile <<EOF
# Invokes the /bin/bash as root's start up shell only if /usr is mounted
if [ -f /bin/bash ]
then
exec /bin/bash
fi
# end
EOF
fi  
#setting HISTSIZE
if [ `grep -i "HISTSIZE" /.bashrc|wc -l` -eq 1 ]
then
echo "HISTSIZE Parameter present - setting default value for it"
perl -ni -e 'print unless /HISTSIZE=/' /.bashrc 
cat >>/.bashrc <<EOF
export HISTSIZE=5000
EOF
else
cat >>/.bashrc <<EOF
export HISTSIZE=5000
EOF
fi
#setting SHELL
if [ `grep -i "SHELL" /.bashrc|wc -l` -eq 1 ]
then
echo "SHELL Parameter present - setting default value for it"
perl -ni -e 'print unless /SHELL=/' /.bashrc 
cat >>/.bashrc <<EOF
export SHELL=/bin/bash
EOF
else
cat >>/.bashrc <<EOF
export SHELL=/bin/bash
EOF
fi
#setting PS1
if [ `grep -i "PS1" /.bashrc|wc -l` -eq 1 ]
then
echo "PS1 Parameter present - setting default value for it"
perl -ni -e 'print unless /PS1=/' /.bashrc 
cat >>/.bashrc <<EOF
export PS1="\u@\h # "
EOF
else
cat >>/.bashrc <<EOF
export PS1="\u@\h # "
EOF
fi
#setting HISTTIMEFORMAT
if [ `grep -i "HISTTIMEFORMAT" /.bashrc|wc -l` -eq 1 ]
then
echo "HISTTIMEFORMAT Parameter present - setting default value for it"
perl -ni -e 'print unless /HISTTIMEFORMAT=/' /.bashrc 
cat >>/.bashrc <<EOF
export HISTTIMEFORMAT="%h/%d - %H:%M:%S "
EOF
else
cat >>/.bashrc <<EOF
export HISTTIMEFORMAT="%h/%d - %H:%M:%S "
EOF
fi
