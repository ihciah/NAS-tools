#!/bin/sh

# This script will be executed when client is up. All key value pairs (except
# password) in ShadowVPN config file will be passed to this script as
# environment variables.

# Turn on IP forwarding
sysctl -w net.ipv4.ip_forward=1

# Configure IP address and MTU of VPN interface
ip addr add $net dev $intf
ip link set $intf mtu $mtu
ip link set $intf up

# Turn on NAT over VPN
iptables -t nat -A POSTROUTING -o $intf -j MASQUERADE
iptables -I FORWARD 1 -i $intf -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -I FORWARD 1 -o $intf -j ACCEPT

# Direct route to VPN server's public IP via current gateway
ip route add $server via $(ip route show 0/0 | sed -e 's/.* via \([^ ]*\).*/\1/')

# Shadow default route using two /1 subnets
#ip route add   0/1 dev $intf
#ip route add 128/1 dev $intf

ip route add 149.154.160.0/20 dev $intf
ip route add 149.154.164.0/22 dev $intf
ip route add 91.108.4.0/22 dev $intf
ip route add 91.108.56.0/22 dev $intf
ip route add 91.108.8.0/22 dev $intf
ip route add 149.154.172.0/22 dev $intf
ip route add 91.108.12.0/22 dev $intf
ip route add 91.108.20.0/22 dev $intf
ip route add 91.108.36.0/23 dev $intf
ip route add 91.108.38.0/23 dev $intf

ip route add 8.8.8.8/32 dev $intf
ip route add 1.1.1.1/32 dev $intf

echo $0 done
