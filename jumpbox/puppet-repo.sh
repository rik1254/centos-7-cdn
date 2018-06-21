#!/bin/bash

#create directory
mkdir -p /var/www/html/puppet/el/7/PC1/x86_64


#reposync
reposync --gpgcheck -l --repoid=puppetlabs-pc1 --download_path=/var/www/html/puppet/el/7/PC1/


#moves repos to correct locations
mv /var/www/html/puppet/el/7/PC1/puppetlabs-pc1/* /var/www/html/puppet/el/7/PC1/x86_64
rm -rf /var/www/html/puppet/el/7/PC1/puppetlabs-pc1


#retrieve gpg keys
curl https://yum.puppetlabs.com/RPM-GPG-KEY-puppet  > /var/www/html/keys/RPM-GPG-KEY-PUPPET-PC1
curl https://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs > /var/www/html/keys/RPM-GPG-KEY-PUPPETLABS-PC1


#create repodata
createrepo /var/www/html/puppet/el/7/PC1/x86_64


#restores selinux context
restorecon -r /var/www/html/
