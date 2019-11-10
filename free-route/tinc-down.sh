#!/bin/sh
VPN_INTERFACE=tunnel
ROUTE_TABLE=200
MARK_VALUE=200
SETNAME=chn_route

#Delete iptables rules
iptables -t mangle -D PREROUTING -j tinc_proxy
iptables -t mangle -D OUTPUT -j tinc_proxy
iptables -t mangle -F tinc_proxy
iptables -t mangle -X tinc_proxy

iptables -t nat -D POSTROUTING -o $VPN_INTERFACE -j MASQUERADE

#Delete route table
ip rule del fwmark $MARK_VALUE table $ROUTE_TABLE
ip route flush table $ROUTE_TABLE

#Delete CHN_ROUTE set
ipset destroy $SETNAME
