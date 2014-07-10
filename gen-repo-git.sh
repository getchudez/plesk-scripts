#!/bin/bash
#
# Version: V1.0 - 07-10-2014
# Author: Gustavo Etchudez - mail: getchudez@yandex.com
# URL: https://github.com/getchudez
#
#
# This script is used to create a git repo from existing domain at Plesk 11 or higher. This is used at DEV environment.
# This script only work for main domain, is not support subdomain.
#
# How to use: 
# - You should create a .gitignore file at /var/www/vhosts/domain.com/httpdocs/.gitignore if you need to ignore some paths
# Example of .gitgnore:
#
# /imgs
# /cache
# /wp-includes
# .htaccess
#
# - You need to run the following command as root user:
# ./gen-repo-git.sh domain.com
#
# This will create repo and set correct owner for files.
#
#

DOMAIN=$1
USERDOM=`cat /etc/passwd|grep "/$DOMAIN:" | cut -d: -f1`

chmod 755 /var/www/vhosts/$DOMAIN
su - git -c "umask 002 ; cd /var/www/repo-git ; mkdir $DOMAIN ; cd $DOMAIN ; git --bare init ; GIT_WORK_TREE=/var/www/vhosts/$DOMAIN/httpdocs/ git add ."
chmod 710 /var/www/vhosts/$DOMAIN
umask 002

cd /var/www/repo-git/$DOMAIN
GIT_WORK_TREE=/var/www/vhosts/$DOMAIN/httpdocs/ git commit -m 'Initial Commit'
chown -R git:developers *

echo "int main(void)
{
        setuid(0);
        system (\"GIT_WORK_TREE=/var/www/vhosts/$DOMAIN/httpdocs git checkout -f\");
        system (\"find /var/www/vhosts/$DOMAIN/httpdocs/ -uid 0 -exec chown $USERDOM:psacln {} \\\;\");
        system (\"chown $USERDOM:psaserv /var/www/vhosts/$DOMAIN/httpdocs/\");
}
" > hooks/post-receive.c

echo "int main(void)
{
        setuid(0);
        system (\"chmod 775 -R /var/www/repo-git/$DOMAIN/objects/*\");
        system (\"chmod 775 -R /var/www/repo-git/$DOMAIN/logs/*\");
}
" > hooks/pre-receive.c

cd hooks
gcc post-receive.c -o post-receive
gcc pre-receive.c -o pre-receive
chmod ug+s post-receive pre-receive
