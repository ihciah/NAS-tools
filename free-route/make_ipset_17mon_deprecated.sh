#!/bin/bash
VPN_SERVER=x.x.x.x

CHN_ROUTE=china_ip_list.txt

SETNAME=chn_route
SETFILE=chnroute.ipset

if [ ! -f $CHN_ROUTE ]; then 
 wget "https://github.com/17mon/china_ip_list/raw/master/china_ip_list.txt" -O $CHN_ROUTE
fi 

ipset create $SETNAME hash:net
while read line; do
        ipset add $SETNAME $line;
done < $CHN_ROUTE
ipset add $SETNAME $VPN_SERVER
ipset add $SETNAME 127.0.0.0/8
ipset add $SETNAME 172.16.0.0/12
ipset add $SETNAME 192.168.0.0/16

ipset save $SETNAME -f $SETFILE
