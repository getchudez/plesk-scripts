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
HOSTNAME_BIN=$(which hostname)
RSYNC_BIN=$(which rsync)
L_HOST=`$HOSTNAME_BIN -a`
R_HOST="srvremote"
F_VHOSTS="/var/www/vhosts/"
F_VMAIL="/var/qmail/mailnames/"
BACKUP_VHOSTS="/data/backups/vhosts/"
BACKUP_VMAIL="/data/backups/vmail/"
R_BACKUP_VHOSTS="/data/backups/$L_HOSTNAME-weekly-vhosts/"
R_BACKUP_VMAIL="/data/backups/$L_HOSTNAME-weekly-mailnames/"

case "$1" in
	local)
		$RSYNC_BIN -apzh --delete $F_VHOSTS $BACKUP_VHOSTS
		$RSYNC_BIN -apzh --delete $F_VMAIL $BACKUP_VMAIL
		;;
	remote)
		$RSYNC_BIN -apzh -e ssh --delete $F_VHOSTS $R_HOST:$R_BACKUP_VHOSTS
		$RSYNC_BIN -apzh -e ssh --delete $F_VMAIL $R_HOST:$R_BACKUP_VMAIL
		;;
	*)
		echo $"Usage: $0 {local|remote}"
		echo "    local: sync files to local file system"
		echo "    remote: sync files to remote server by rsync + ssh"
		RETVAL=1
esac
exit $RETVAL
