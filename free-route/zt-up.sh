#!/bin/sh
LOCAL_IP=192.168.31.18
ROUTER_IP=192.168.31.1
LOCAL_NETWORK=192.168.0.0/16
VPN_INTERFACE=ztinterface
GATEWAY=192.168.195.202
ROUTE_TABLE=200
MARK_VALUE=200
SETFILE=/etc/free-route/chnroute.ipset
SETNAME=chn_route

#Create CHN_ROUTE set
ipset restore -f $SETFILE

#Add route table 
ip route flush table $ROUTE_TABLE
ip route add default dev $VPN_INTERFACE via $GATEWAY table $ROUTE_TABLE
ip rule add fwmark $MARK_VALUE table $ROUTE_TABLE

#Add iptables rules
iptables -t mangle -N zt_proxy

#Add local machine
iptables -t mangle -A zt_proxy -d 0/8 -j RETURN
iptables -t mangle -A zt_proxy -d 127/8 -j RETURN
iptables -t mangle -A zt_proxy -d 10/8 -j RETURN
iptables -t mangle -A zt_proxy -d 169.254/16 -j RETURN
iptables -t mangle -A zt_proxy -d 172.16/12 -j RETURN
iptables -t mangle -A zt_proxy -d 192.168/16 -j RETURN
iptables -t mangle -A zt_proxy -d 224/4 -j RETURN
iptables -t mangle -A zt_proxy -d 240/4 -j RETURN

iptables -t mangle -A zt_proxy -s $LOCAL_IP -j RETURN
iptables -t mangle -A zt_proxy -s $ROUTER_IP -j RETURN
iptables -t mangle -A zt_proxy ! -s $LOCAL_NETWORK -j RETURN

iptables -t mangle -A zt_proxy -m set --match-set $SETNAME dst -j RETURN
iptables -t mangle -A zt_proxy -j CONNMARK --restore-mark
iptables -t mangle -A zt_proxy -m mark --mark 0 -j MARK --set-mark $MARK_VALUE
iptables -t mangle -A zt_proxy -j CONNMARK --save-mark

iptables -t mangle -I PREROUTING -j zt_proxy
iptables -t mangle -I OUTPUT -j zt_proxy

iptables -t nat -I POSTROUTING -o $VPN_INTERFACE -j MASQUERADE

# Tips:
# Remember add the following line to /lib/systemd/system/zerotier-one.service
# ExecStartPost=/bin/sh -c 'iptables -t nat -A POSTROUTING -s 192.168.195.0/24 -j MASQUERADE && sleep 5 && echo 0 > /proc/sys/net/ipv4/conf/ztinterface/rp_filter && /etc/free-route/zt-up.sh'
