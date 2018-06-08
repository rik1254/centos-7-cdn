#!/bin/bash

REPOHOSTFQDN=

#remove old repos
rm /etc/yum.repos.d/docker-ce.repo
yum clean all
rm -rf /var/cache/yum

#create new repo file
echo "[docker-ce]
name=Docker LocalRepo
baseurl=http://$REPOHOSTFQDN/docker/docker-ce-stable
enabled=1
gpgcheck=1
gpgkey=http://$REPOHOSTFQDN/keys/RPM-GPG-KEY-DOCKER" >> /etc/yum.repos.d/docker-ce.repo


#clears cache
yum clean all
rm -rf /var/cache/yum

#recompile repolist
yum repolist
