#!/bin/sh
CHN_ROUTE=/home/ihciah/projects/free-route/china_ip_list.txt
VPN_NETWORK=192.168.100.0/24
VPN_SERVER=x.x.x.x

SETNAME=chn_route
SETFILE=chnroute.ipset

ipset create $SETNAME hash:net
while read line; do
        ipset add $SETNAME $line;
done < $CHN_ROUTE
ipset add $SETNAME $VPN_SERVER
ipset add $SETNAME $VPN_NETWORK
ipset add $SETNAME 127.0.0.1
ipset add $SETNAME 172.16.0.0/12
ipset add $SETNAME 192.168.0.0/16

ipset save $SETNAME -f $SETFILE
