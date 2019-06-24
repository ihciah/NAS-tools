#!/bin/bash
VPN_SERVER=x.x.x.x

CHN_ROUTE=chnroute.txt

SETNAME=chn_route
SETFILE=chnroute.ipset

curl 'http://ftp.apnic.net/apnic/stats/apnic/delegated-apnic-latest' | grep ipv4 | grep CN | awk -F\| '{ printf("%s/%d\n", $4, 32-log($5)/log(2)) }' > $CHN_ROUTE
sed "s/^/add $SETNAME /;1i create $SETNAME hash:net family inet hashsize 4096 maxelem 65536" $CHN_ROUTE > $SETFILE
echo "add $SETNAME 127.0.0.0/8" >> $SETFILE
echo "add $SETNAME 192.168.0.0/16" >> $SETFILE
echo "add $SETNAME 172.16.0.0/16" >> $SETFILE
echo "add $SETNAME 172.16.0.0/16" >> $SETFILE
echo "add $SETNAME $VPN_SERVER" >> $SETFILE
