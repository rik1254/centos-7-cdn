#!/bin/bash

FOLDERS=(7/PC1 7 7/dependencies 7/products)
REPOS=(puppetlabs-pc1 puppet puppetlabs-deps puppetlabs-products)

if [ ${#FOLDERS[@]} -eq ${#REPOS[@]} ]
then
	arr_size=${#FOLDERS[@]}
	#make directories
	for i in "${FOLDERS[@]}"
	do
		mkdir -p /var/www/html/puppet/el/$i/x86_64
	done


	#reposync
	for ((i=0;i<arr_size;i++))
	do
		reposync --gpgcheck -l --repoid=${REPOS[i]} --download_path=/var/www/html/puppet/el/${FOLDERS[i]}/
	done
	

	#moves repos to correct locations
	for ((i=0;i<arr_size;i++))
	do
		mv /var/www/html/puppet/el/${FOLDERS[i]}/${REPOS[i]}/* /var/www/html/puppet/el/${FOLDERS[i]}/x86_64
		rm -rf /var/www/html/puppet/el/${FOLDERS[i]}/${REPOS[i]}
	done

	#retrieve gpg keys
	curl https://yum.puppetlabs.com/RPM-GPG-KEY-puppet  > /var/www/html/keys/RPM-GPG-KEY-PUPPET-PC1


	#create repodata
	for ((i=0;i<arr_size;i++))
	do
		createrepo /var/www/html/puppet/el/${FOLDERS[i]}/${REPOS[i]}
	done


	#restores selinux context
	restorecon -r /var/www/html/
else
	echo "The arrays do not match length and will fail the script!"
fi
