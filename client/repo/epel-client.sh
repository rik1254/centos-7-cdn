#!/bin/bash

REPOHOSTFQDN=

#remove old repos
rm /etc/yum.repos.d/epel.repo
yum clean all
rm -rf /var/cache/yum

#create new repo file
echo "[epel]
name=Extra Packages for Enterprise Linux $releasever - $basearch
baseurl=http://$REPOHOSTFQDN/epel/pub/epel/$releasever/$basearch
gpgkey=http://$REPOHOSTFQDN/keys/RPM-GPG-KEY-EPEL-7
enabled=1
gpgcheck=1" >> /etc/yum.repos.d/epel.repo

#clears cache
yum clean all
rm -rf /var/cache/yum

#recompile repolist
yum repolist
