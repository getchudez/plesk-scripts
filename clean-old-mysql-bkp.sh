#!/bin/bash
#
# Version: V1.0.1 - 07-10-2014
# Author: Gustavo Etchudez - mail: getchudez@yandex.com
# URL: https://github.com/getchudez
#
# This script will clean old backup of MySQL created by bkp-mysql.sh
#
#
BACKUP_DIR="/data/backups/mysql"
RETDAY="6"
FIND_BIN=$(which find)

$FIND_BIN $BACKUP_DIR -type d -mtime +$RETDAY -exec rm -f {} \;
