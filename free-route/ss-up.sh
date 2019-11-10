#!/bin/sh
LOCAL_IP=192.168.31.18
ROUTER_IP=192.168.31.1
LOCAL_NETWORK=192.168.0.0/16
REDIR_PORT=7777
ROUTE_TABLE=200
MARK_VALUE=200
SETFILE=/etc/free-route/chnroute.ipset
SETNAME=chn_route

#Create CHN_ROUTE set
ipset restore -f $SETFILE

#Add route table 
ip route flush table $ROUTE_TABLE
ip route add default dev $VPN_INTERFACE table $ROUTE_TABLE
ip rule add fwmark $MARK_VALUE table $ROUTE_TABLE

#Add iptables rules
iptables -t nat -N shadowsocks_proxy

#Add private dest
iptables -t nat -A shadowsocks_proxy -d 0/8 -j RETURN
iptables -t nat -A shadowsocks_proxy -d 127/8 -j RETURN
iptables -t nat -A shadowsocks_proxy -d 10/8 -j RETURN
iptables -t nat -A shadowsocks_proxy -d 169.254/16 -j RETURN
iptables -t nat -A shadowsocks_proxy -d 172.16/12 -j RETURN
iptables -t nat -A shadowsocks_proxy -d 192.168/16 -j RETURN
iptables -t nat -A shadowsocks_proxy -d 224/4 -j RETURN
iptables -t nat -A shadowsocks_proxy -d 240/4 -j RETURN

#Add local src
iptables -t nat -A shadowsocks_proxy -s $LOCAL_IP -j RETURN
iptables -t nat -A shadowsocks_proxy -s $ROUTER_IP -j RETURN
iptables -t nat -A shadowsocks_proxy ! -s $LOCAL_NETWORK -j RETURN

iptables -t nat -A shadowsocks_proxy -m set --match-set $SETNAME dst -j RETURN
iptables -t nat -A shadowsocks_proxy ! -p icmp -j REDIRECT --to-ports $REDIR_PORT

iptables -t nat -A PREROUTING ! -p icmp -j shadowsocks_proxy
iptables -t nat -A OUTPUT ! -p icmp -j shadowsocks_proxy

