#! /bin/bash

# Are you root?

if test `id -u` -ne 0
then
  echo "ur not root bro"
  exit 1
fi

rm -f /etc/network/if-up.d/00-firewall

# delete all existing rules.
iptables -Z             # zero counters
iptables -F             # flush (delete) rules

iptables -t mangle -F
iptables -X             # delete all extra chains

# If you want to clear the chains, then clear the chains:
iptables --policy INPUT   ACCEPT;
iptables --policy OUTPUT  ACCEPT;
iptables --policy FORWARD ACCEPT;

apt autoremove --purge iptables -y

mv /etc/hosts.0 /etc/hosts
apt autoremove --purge dnsmasq -y

mv /etc/network/interfaces.0 /etc/network/interfaces

systemctl restart networking
systemctl status networking --no-pager