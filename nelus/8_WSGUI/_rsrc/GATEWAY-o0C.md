## **BUILDING GATEWAY**

ISO:

  + debi12uefi.oso
  + systemrescue cd

### **Virtualisation:**

+ Host mode: Hyper-V, 
+ Host OS: W10-20270, 
+ Build Hyper-V Switch: "Default" -- Default Switch
+ Build Hyper-V Switch: "GWX"    -- Private Switch
  
Hardware configuration:

+ RAM 1024MB
+ NIC1, (Connected to default switch),
+ NIC2 (Connected to Private Network "GWX")

router-up

```bash
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

allow-hotplug eth0
iface eth0 inet dhcp

allow-hotplug eth1
iface eth1 inet static
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
interface=eth1
address=/ufo.mars/10.0.10.1
dhcp-range=eth1,10.0.10.20,10.0.10.25,12h
BASTA
systemctl restart dnsmasq
systemctl status dnsmasq --no-pager

# The last number is how long the DHCP leases are good for.
# dns names for local machines:

cp /etc/hosts /etc/hosts.0
cat << BASTA > /etc/hosts
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
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

# Enable routing.
echo 1 > /proc/sys/net/ipv4/ip_forward
BASTA
chmod +x /etc/network/if-up.d/00-firewall
/etc/network/if-up.d/00-firewall
```

router-down

```bash
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
```

### **Test Connection**

Rescue Client .. test connection (systemrescuecd ISO, live CD):

Worst case -- (nothing works)
```
  % ifconfig eth0 10.0.10.100 up
  % route add default gw 10.0.10.1
  % cat /etc/resolv.conf
```
Best case -- Internet is functional with SystemRescueCD.

**Note:**

On rescue machine. To reach rescue machine from putty:
```
# systemctl stop iptables
# passwd
```
## **Report this:**

1. On gateway and systemresque machines.

    ```bash
    #!/bin/bash

    dhclient eth0 -r
    dhclient eth0
    ip a
    ip r
    ping 8.8.8.8 -c 1
    ping google.com -c 1
    cat /etc/resolv.conf
    ```
2. On gateway machine only:

    Allow to use facter:
    ```
    apt install -y ruby facter
    facter
    ```
3. Also interested in:

    ```bash
    #!/bin/bash -x
    cat /etc/issue
    dmesg | grep eth
    cat /etc/network/interfaces
    cat /etc/dnsmasq.conf | tail
    cat /etc/resolv.conf
    ```
## **LINKS**

  1. https://medium.com/@cpt_midnight/static-ip-in-debian-9-stretch-acb4e5cb7dc1

  2. https://debian-administration.org/article/23/Setting_up_a_simple_Debian_gateway