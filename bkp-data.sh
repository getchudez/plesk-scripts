#!/bin/bash
#
# Version: V1.0 - 07-10-2014
# Author: Gustavo Etchudez - mail: getchudez@yandex.com
# URL: https://github.com/getchudez
#
# This script will do a backup of specific path of virtual host and virtual mail to local disk or remote server by rsync + ssh.
# You should define local and remote path and remote host where you want to copy your information.
# If you want to use remote option you should get ssh key defnied to could copy files to remote server.
#
#
R_HOST=""
F_VHOSTS="/var/www/vhosts/"
F_VMAIL="/var/qmail/mailnames/"
BACKUP_VHOSTS="/data/backups/vhosts/"
BACKUP_VMAIL="/data/backups/vmail/"
RSYNC_BIN=$(which rsync)

if [ "$1" == "LOCAL" ];then
  echo $RSYNC_BIN -apzh --delete $F_VHOSTS $BACKUP_VHOSTS
  echo $RSYNC_BIN -apzh --delete $F_VMAIS $BACKUP_VMAIL
fi

case "$1" in
	local)
		echo $RSYNC_BIN -apzh --delete $F_VHOSTS $BACKUP_VHOSTS
		echo $RSYNC_BIN -apzh --delete $F_VMAIS $BACKUP_VMAIL
		;;
	remote)
		echo $RSYNC_BIN -apzh -e ssh --delete $F_VHOSTS $R_HOST:$BACKUP_VHOSTS
		echo $RSYNC_BIN -apzh -e ssh --delete $F_VMAIS $R_HOST:$BACKUP_VMAIL
		;;
	*)
		echo $"Usage: $0 {local|remote}"
		echo "    local: sync files to local file system"
		echo "    remote: sync files to remote server by rsync + ssh"
		RETVAL=1
esac
exit $RETVAL
