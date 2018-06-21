#!/bin/bash

#make required directory
mkdir -p /var/www/html/epel/pub/epel/7/x86_64

#reposync
reposync --gpgcheck -l --repoid=epel --norepopath --download_path=/var/www/html/epel/7/x86_64

#moves repo to correct location
#mv ~/var/www/html/epel/epel/* /var/www/html/epel/pub/epel/7/x86_64

#retrieve gpg key
curl http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7 > /var/www/html/keys/RPM-GPG-KEY-EPEL-7

#createrepo
createrepo /var/www/html/epel/pub/epel/7/x86_64

#restores selinux context
restorecon -r /var/www/html/


