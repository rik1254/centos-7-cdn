#!/bin/bash

CENTOSSOURCE=(base extras updates)
CENTOSLOCAL=(os extras updates)
arrsize=3;


#Download and install the required applications
#install httpd
if [ $(httpd | grep -c "already running") -eq 0 ];
then
        echo "Installing httpd";
        yum -y install httpd;
        systemctl start httpd;
        systemctl enable httpd;
fi
#Download the reposync package
if [ $(rpm -qa | grep -c "yum-utils") -eq 0 ];
then
       echo "Installing yum-utils";
       yum -y install yum-utils;
fi
#Download the createrepo package
if [ $(rpm -qa | grep -c "createrepo") -eq 0 ];
then
        echo "Installing createrepo";
        yum -y install createrepo;
fi



#Make repo directories, reposync and create repodata
for ((i=0;i<arrsize;i++))
do
	mkdir -p /var/www/html/centos/7/${CENTOSLOCAL[i]}/x86_64
	reposync --gpgcheck -l --repoid=${CENTOSSOURCE[i]} --norepopath --download_path=/var/www/html/centos/7/${CENTOSLOCAL[i]}/x86_64
	createrepo /var/www/html/centos/7/${CENTOSLOCAL[i]}/x86_64
done

#Make GPG key diretory and pulls gpg key
mkdir -p /var/www/html/keys
curl http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-7 > /var/www/html/keys/RPM-GPG-KEY-CentOS-7

#restores selinux context
restorecon -r /var/www/html/
