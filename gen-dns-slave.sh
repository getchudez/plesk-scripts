#!/bin/bash
#
# Version: V1.0 - 07-10-2014
# Author: Gustavo Etchudez - mail: getchudez@yandex.com
# URL: https://github.com/getchudez
#
#
# This script is used to get all DNS zone from server where you execute, create a DNS file as slaves and copy this to slave server defined.
# I wrote this because I have two plesk servers with their master DNS zones and wanted to resolve all zones at all servers.
# You should get ssh key defnied to could copy files and execute reload to remote server.
# Remember to add at MASTER server any SLAVE IP address to could transfer zones.
#
#

HOMEPATH="/home/scripts/dns"
MASTERSIP="192.168.0.1;"
MASTER="websrv01"
SLAVE="websrv02"
EMAIL="support@domain"

/usr/bin/mysql -N -uadmin -p`cat /etc/psa/.psa.shadow` psa -e "SELECT name FROM dns_zone WHERE status='0';" > $HOMEPATH/tmp-list.txt

cat $HOMEPATH/tmp-list.txt | uniq > $HOMEPATH/list.txt

echo "" > $HOMEPATH/zones-slave-to-$MASTER.txt

for zone in `cat $HOMEPATH/list.txt`;do
        echo "zone \"$zone\" {" >> $HOMEPATH/zones-slave-to-$MASTER.txt
        echo "  type slave;" >> $HOMEPATH/zones-slave-to-$MASTER.txt
        echo "  file \"slaves/$zone\";" >> $HOMEPATH/zones-slave-to-$MASTER.txt
        echo "  masters {" >> $HOMEPATH/zones-slave-to-$MASTER.txt
        echo "          $MASTERSIP" >> $HOMEPATH/zones-slave-to-$MASTER.txt
        echo "  };" >> $HOMEPATH/zones-slave-to-$MASTER.txt
        echo "};" >> $HOMEPATH/zones-slave-to-$MASTER.txt
done

echo "" >> $HOMEPATH/zones-slave-to-$MASTER.txt

scp -q $HOMEPATH/zones-slave-to-$MASTER.txt $SLAVE:$HOMEPATH/zones-to-slave-$MASTER.txt
ssh $SLAVE "cp /var/named/chroot/etc/named.conf.slaves /var/named/chroot/etc/named.conf.slaves.bkp"
ssh $SLAVE "rm -f /var/named/chroot/etc/named.conf.slaves"
ssh $SLAVE "cp /home/scripts/dns/zones-to-slave-$MASTER.txt /var/named/chroot/etc/named.conf.slaves"

OUTCHECK=`/bin/mktemp`

ssh $SLAVE "named-checkconf" > $OUTCHECK

if [ "$?" == 0 ];then
  ssh $SLAVE "service named restart"
else
  ssh $SLAVE "rm -f /var/named/chroot/etc/named.conf.slaves"
  ssh $SLAVE "cp /var/named/chroot/etc/named.conf.slaves.bkp /var/named/chroot/etc/named.conf.slaves"
  echo "Something is going wrong with named configuration" | mailx -s "Error at named configuration" -a $OUTCHECK $EMAIL
  rm -f $OUTCHECK
fi
