#!/bin/bash

if test `id -u` -ne 0
then
  echo "ur not root bro"
  exit 1
fi

set -x

# 2.On gateway machine only:
Allow to use facter:
apt install -y ruby facter
facter

# 1. On gateway and systemresque machines.
dhclient enp0s3 -r
dhclient enp0s3
ip a
ip r
ping 8.8.8.8 -c 1
ping google.com -c 1
cat /etc/resolv.conf

# 3. Also interested in:
cat /etc/issue
dmesg | grep eth
cat /etc/network/interfaces
cat /etc/dnsmasq.conf | tail
cat /etc/resolv.conf