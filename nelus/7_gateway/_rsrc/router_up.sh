#! /bin/bash

# Are you root?

if test `id -u` -ne 0
then
  echo "ur not root bro"
  exit 1
fi

if test -f /etc/network/interfaces.0
then
  echo "restore your machine to inital state"
  exit 2
fi

# Configure NIC interfaces:

cp /etc/network/interfaces /etc/network/interfaces.0

cat << BASTA > /etc/network/interfaces
# The loopback network interface
auto lo
iface lo inet loopback

allow-hotplug enp0s3
iface enp0s3 inet dhcp

allow-hotplug enp0s8
iface enp0s8 inet static
        address 10.0.10.1
        netmask 255.255.255.0
        gateway 10.0.10.1
        dns-search google.com
        dns-nameservers 10.0.10.1
BASTA
systemctl restart networking
systemctl status networking --no-pager

# Configure DHCP:

apt install dnsmasq -y
cp /etc/dnsmasq.conf /etc/dnsmasq.conf.0
cat << BASTA >> /etc/dnsmasq.conf
interface=enp0s8
address=/ufo.mars/10.0.10.1
dhcp-range=enp0s8,10.0.10.20,10.0.10.25,12h
BASTA
systemctl restart dnsmasq
systemctl status dnsmasq --no-pager

# The last number is how long the DHCP leases are good for.
# dns names for local machines:

cp /etc/hosts /etc/hosts.0
cat << BASTA >> /etc/hosts
10.0.10.1       ufo.mars
10.0.10.20      ufo0.mars
10.0.10.21      ufo1.mars
10.0.10.22      ufo2.mars
10.0.10.23      ufo3.mars
10.0.10.24      ufo4.mars
10.0.10.25      ufo5.mars
BASTA

systemctl restart dnsmasq
systemctl status dnsmasq --no-pager

# Firewall:

apt install -y iptables

cat << BASTA > /etc/network/if-up.d/00-firewall
#!/bin/sh
# Reload the iptables rules and activate forwarding

set -e

# delete all existing rules.
iptables -Z             # zero counters
iptables -F             # flush (delete) rules

iptables -t mangle -F
iptables -X             # delete all extra chains

# If you want to clear the chains, then clear the chains:
iptables --policy INPUT   ACCEPT;
iptables --policy OUTPUT  ACCEPT;
iptables --policy FORWARD ACCEPT;

# Masquerade.
iptables -t nat -A POSTROUTING -o enp0s3 -j MASQUERADE

# Enable routing.
echo 1 > /proc/sys/net/ipv4/ip_forward
BASTA
chmod +x /etc/network/if-up.d/00-firewall
/etc/network/if-up.d/00-firewall