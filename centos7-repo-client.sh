#!/bin/bash

#add these before executing the script
REPOHOSTIPADDRESS=
REPOHOSTFQDN=
REPOHOSTNAME=

#add bootstrap to /etc/hosts
echo "$REPOHOSTIPADDRESS    $REPOHOSTFQDN       $REPOHOSTNAME" >> /etc/hosts

#remove old repos
rm /etc/yum.repos.d/CentOS-*
rm /etc/yum.repos.d/client-local.repo
yum clean all
rm -rf /var/cache/yum

#create new repo file
echo "[base]
name=Centos LocalRepo
baseurl=http://$REPOHOSTFQDN/centos/\$releasever/os/\$basearch
enabled=1
gpgcheck=1
gpgkey=http://$REPOHOSTFQDN/keys/RPM-GPG-KEY-CentOS-7

[extras]
name=Centos LocalRepo
baseurl=http://$REPOHOSTFQDN/centos/\$releasever/extras/\$basearch
enabled=1
gpgcheck=1
gpgkey=http://$REPOHOSTFQDN/keys/RPM-GPG-KEY-CentOS-7

[updates]
name=Centos LocalRepo
baseurl=http://$REPOHOSTFQDN/centos/\$releasever/updates/\$basearch
enabled=1
gpgcheck=1
gpgkey=http://$REPOHOSTFQDN/keys/RPM-GPG-KEY-CentOS-7" >> /etc/yum.repos.d/client-local.repo

#recompile repolist
yum repolist
