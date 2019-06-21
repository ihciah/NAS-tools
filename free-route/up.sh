#!/bin/sh
VPN_GATEWAY=192.168.100.1
LOCAL_IP=192.168.31.18
ROUTER_IP=192.168.31.1
LOCAL_NETWORK=192.168.31.0/24
VPN_INTERFACE=tunnel
ROUTE_TABLE=200
MARK_VALUE=200
SETFILE=/etc/free-route/chnroute.ipset
SETNAME=chn_route

#Create CHN_ROUTE set
ipset restore -f $SETFILE

#Add route table 
ip route flush table $ROUTE_TABLE
ip route add default via $VPN_GATEWAY dev $VPN_INTERFACE table $ROUTE_TABLE
ip rule add fwmark $MARK_VALUE table $ROUTE_TABLE

#Add iptables rules
iptables -t mangle -N tinc_proxy

#Add local machine
iptables -t mangle -A tinc_proxy -s $LOCAL_IP -j RETURN
iptables -t mangle -A tinc_proxy -s $ROUTER_IP -j RETURN
iptables -t mangle -A tinc_proxy ! -s $LOCAL_NETWORK -j RETURN

iptables -t mangle -A tinc_proxy -m set --match-set $SETNAME dst -j RETURN
iptables -t mangle -A tinc_proxy -j CONNMARK --restore-mark
iptables -t mangle -A tinc_proxy -m mark --mark 0 -j MARK --set-mark $MARK_VALUE
iptables -t mangle -A tinc_proxy -j CONNMARK --save-mark

iptables -t mangle -I PREROUTING -j tinc_proxy
iptables -t mangle -I OUTPUT -j tinc_proxy

iptables -t nat -I POSTROUTING -o $VPN_INTERFACE -j MASQUERADE

