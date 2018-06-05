#!/bin/bash

#remove old versions
yum remove docker \
docker-client \
docker-client-latest \
docker-common \
docker-latest \
docker-latest-logrotate \
docker-logrotate \
docker-selinux \
docker-engine-selinux \
docker-engine

#install docker
yum -y install docker-ce

systemctl start docker
systemctl enable docker
