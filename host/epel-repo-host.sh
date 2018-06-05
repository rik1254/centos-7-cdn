#!/bin/bash

#make required directory
mkdir -p /var/www/html/epel/7/x86_64

#reposync
yum-config-manager --add-repo http://dl.fedoraproject.org/pub/epel/7/x86_64
reposync -p /var/www/html/epel

#moves repo to correct location
mv ~/docker-ce-stable/Packages /var/www/html/docker/docker-ce-stable

#retrieve gpg key
curl https://download.docker.com/linux/centos/gpg > /var/www/html/keys/RPM-GPG-KEY-DOCKER

#createrepo
createrepo /var/www/html/epel/7/x86_64

#restores selinux context
restorecon -r /var/www/html/
