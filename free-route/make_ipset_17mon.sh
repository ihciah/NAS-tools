#!/bin/bash
VPN_SERVER=x.x.x.x

CHN_ROUTE=china_ip_list.txt

SETNAME=chn_route
SETFILE=chnroute.ipset

if [ ! -f $CHN_ROUTE ]; then 
 wget "https://github.com/17mon/china_ip_list/raw/master/china_ip_list.txt" -O $CHN_ROUTE
fi 

sed "s/^/add $SETNAME /;1i create $SETNAME hash:net family inet hashsize 2048 maxelem 65536" $CHN_ROUTE > $SETFILE
echo "" >> $SETFILE
echo "add $SETNAME 127.0.0.0/8" >> $SETFILE
echo "add $SETNAME 192.168.0.0/16" >> $SETFILE
echo "add $SETNAME 172.16.0.0/16" >> $SETFILE
echo "add $SETNAME 172.16.0.0/16" >> $SETFILE
echo "add $SETNAME $VPN_SERVER" >> $SETFILE
