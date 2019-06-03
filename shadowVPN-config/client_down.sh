#!/bin/sh

# This script will be executed when client is down. All key value pairs (except
# password) in ShadowVPN config file will be passed to this script as
# environment variables.

# Turn off IP forwarding
#sysctl -w net.ipv4.ip_forward=0

# turn off NAT over VPN
iptables -t nat -D POSTROUTING -o $intf -j MASQUERADE
iptables -D FORWARD -i $intf -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -D FORWARD -o $intf -j ACCEPT

# Restore routing table
ip route del $server
ip route del 149.154.160.0/20
ip route del 149.154.164.0/22
ip route del 91.108.4.0/22
ip route del 91.108.56.0/22
ip route del 91.108.8.0/22
ip route del 149.154.172.0/22
ip route del 91.108.12.0/22
ip route del 91.108.20.0/22
ip route del 91.108.36.0/23
ip route del 91.108.38.0/23

ip route del 8.8.8.8/32
ip route del 1.1.1.1/32

echo $0 done
