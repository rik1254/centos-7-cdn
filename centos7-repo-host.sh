#!/bin/bash

#install httpd
yum -y install httpd
systemctl start httpd
systemctl enable httpd

#make directories
mkdir -p /var/www/html/keys
mkdir -p /var/www/html/centos/7/os/x86_64
mkdir -p /var/www/html/centos/7/extras/x86_64
mkdir -p /var/www/html/centos/7/updates/x86_64

#reposync
yum -y install yum-utils
reposync -p /var/www/html/centos

#moves repos to correct locations
mv /var/www/html/centos/base/Packages /var/www/html/centos/7/os/x86_64
mv /var/www/html/centos/extras/Packages /var/www/html/centos/7/extras/x86_64
mv /var/www/html/centos/updates/Packages /var/www/html/centos/7/updates/x86_64

#retrieves gpg key
curl http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-7 > /var/www/html/keys/RPM-GPG-KEY-CentOS-7

#create repodata
yum -y install createrepo
createrepo /var/www/html/centos/7/os/x86_64
createrepo /var/www/html/centos/7/extras/x86_64
createrepo /var/www/html/centos/7/updates/x86_64

#restores selinux context
restorecon -r /var/www/html/
