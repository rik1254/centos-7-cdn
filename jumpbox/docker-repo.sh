#!/bin/bash

#make required directory
mkdir -p /var/www/html/docker/docker-ce-stable

#reposync
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
reposync --repoid=docker-ce-stable

#moves repo to correct location
mv ~/docker-ce-stable/Packages /var/www/html/docker/docker-ce-stable

#retrieve gpg key
curl https://download.docker.com/linux/centos/gpg > /var/www/html/keys/RPM-GPG-KEY-DOCKER

#createrepo
createrepo /var/www/html/docker/docker-ce-stable

#restores selinux context
restorecon -r /var/www/html/
