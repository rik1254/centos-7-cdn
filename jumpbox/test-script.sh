#!/bin/bash
CENTOSSOURCE=(base extras updates)
CENTOSLOCAL=(os extras updates)
arrsize=3;


#install httpd
#if [ $(httpd | grep -c "already running") -eq 0 ];
#then
#        echo "Installing httpd";
#        yum -y install httpd;
#        systemctl start httpd;
#        systemctl enable httpd;
#fi


#make local directories
#for i in "${CENTOSLOCAL[@]}"
#do
#        mkdir -p /var/www/html/centos/7/$i/x86_64
#done

#mkdir -p /var/www/html/keys


#reposync from source
#if [ $(rpm -qa | grep -c "yum-utils") -eq 0 ];
#then
#        echo "Installing yum-utils";
#        yum -y install yum-utils;
#fi

#for i in "${CENTOSSOURCE[@]}"
#do
#        reposync --gpgcheck -l --repoid=$i --download_path=/var/www/html/centos
#done


echo 'Hello'
for ((i=0;i<arrsize;i++))
do
        echo 'Hello 2';
	#mv -f /var/www/html/centos/${CENTOSSOURCE[i]}/ /var/www/html/centos/7/${CENTOSLOCAL[i]}/x86_64;
        #rm -rf /var/www/html/centos/${CENTOSSOURCE[i]};
done
