#!/bin/bash
#
# Version: V1.0 - 07-10-2014
# Author: Gustavo Etchudez - mail: getchudez@yandex.com
# URL: https://github.com/getchudez
#
# This script will clean old backup of MySQL created by bkp-mysql.sh
#
#
BACKUP_DIR="/data/backup/mysql"
RETDAY="6"

find $BACKUP_DIR -mtime +$RETDAY -exec rm -f {} \;
