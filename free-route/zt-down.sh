#!/bin/sh
VPN_INTERFACE=ztinterface
ROUTE_TABLE=200
MARK_VALUE=200
SETNAME=chn_route

#Delete iptables rules
iptables -t mangle -D PREROUTING -j zt_proxy
iptables -t mangle -D OUTPUT -j zt_proxy
iptables -t mangle -F zt_proxy
iptables -t mangle -X zt_proxy

iptables -t nat -D POSTROUTING -o $VPN_INTERFACE -j MASQUERADE

#Delete route table
ip rule del fwmark $MARK_VALUE table $ROUTE_TABLE
ip route flush table $ROUTE_TABLE

#Delete CHN_ROUTE set
ipset destroy $SETNAME
