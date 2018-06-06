#!/bin/bash

REPOHOSTFQDN=

#remove old repos
rm /etc/yum.repos.d/puppetlabs-pc1.repo
yum clean all
rm -rf /var/cache/yum

#create new repo file
echo "[puppetlabs-pc1]
name=Puppet Labs PC1 Repository el 7 - $basearch
baseurl=http://$REPOHOSTFQDN/el/7/PC1/$basearch
gpgkey=http://$REPOHOSTFQDN/keys/RPM-GPG-KEY-puppetlabs-PC1
       http://$REPOHOSTFQDN/keys/RPM-GPG-KEY-puppet-PC1
enabled=1
gpgcheck=1" >> /etc/yum.repos.d/puppet-agent.repo

#clears cache
yum clean all
rm -rf /var/cache/yum

#recompile repolist
yum repolist
