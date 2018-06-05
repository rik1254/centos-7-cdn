#!/bin/bash

export PATH=$PATH:/usr/local/bin

yum install -y vim git epel-release

# get repos

rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
yum install -y "https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm"

yum install -y puppet-agent
yum install -y puppetserver

cp config/puppetserver      /etc/sysconfig/puppetserver
cp config/puppetserver.conf /etc/puppetlabs/puppetserver/conf.d/puppetserver.conf

systemctl enable puppetserver
systemctl start puppetserver

source /etc/profile

# ------------------------------------------------------------
# install postgresql

yum install -y postgresql96-server
yum install -y postgresql96-contrib

/usr/pgsql-9.6/bin/postgresql96-setup initdb

systemctl enable postgresql-9.6
systemctl start postgresql-9.6

sudo -u postgres psql -c "CREATE ROLE puppetdb WITH LOGIN NOCREATEDB NOSUPERUSER PASSWORD 'puppetdb';"
sudo -u postgres psql -c "CREATE DATABASE puppetdb ENCODING 'UTF8' OWNER 'puppetdb';"
sudo -u postgres psql -c "CREATE EXTENSION pg_trgm;"

cat <<EOF > /var/lib/pgsql/9.6/data/pg_hba.conf
local all  postgres ident
local all  all      ident
host  all  postgres 127.0.0.1/32 md5
host  all  postgres 0.0.0.0/0    reject
host  all  all      127.0.0.1/32 md5
host  all  all      ::1/128      md5
EOF

systemctl restart postgresql-9.6

# ------------------------------------------------------------
# install puppetdb

puppet resource package puppetdb ensure=latest

cat <<EOF >> /etc/puppetlabs/puppetdb/conf.d/database.ini
subname = //localhost:5432/puppetdb
username = puppetdb
password = puppetdb
EOF

puppet resource package puppetdb-termini ensure=latest
puppet resource service puppetdb ensure=running enable=true

# ------------------------------------------------------------
# intregrate puppetdc into puppet master

CONF=$(puppet config print confdir)

cat <<EOF > "${CONF}/puppetdb.conf"
[main]
  server_urls = https://${HOSTNAME}:8081
EOF

cat <<EOF >> ${CONF}/puppet.conf
storeconfigs = true
storeconfigs_backend = puppetdb
reports = store,puppetdb
EOF

ROUTES=$(puppet master --configprint route_file)

cat <<EOF > $ROUTES
---
master:
  facts:
    terminus: puppetdb
    cache: yaml
EOF

chown -R puppet:puppet $CONF $ROUTES

systemctl restart puppetserver

puppet resource package puppet-client-tools ensure=latest

# ------------------------------------------------------------
# install r10k

yum install -y ruby
gem install bundler

bundle install

# install local software repo

yum install -y yum-utils
yum install -y createrepo
yum install -y httpd

puppet resource service httpd ensure=running enable=true

# kill all the firewalls

puppet resource service firewalld ensure=stopped enable=false
