#!/bin/bash

if [ "$UID" -ne "0" ]
then
  echo "You are NOT root"
  exit 1
fi

apt update
apt upgrade -y
apt install systemd-timesyncd
systemctl restart systemd-timesyncd
timedatectl
systemctl status systemd-timesyncd --no-pager | tail -n 1

apt-get -y install wget
apt-get -y install xserver-xorg lxde lightdm lxappearance
apt -y install build-essential module-assistant dkms wget

apt -y install lightdm lxde task-lxde-desktop
echo "DISPLAY_MANAGER=lightdm" > /etc/default/display-manager

cp /etc/lightdm/lightdm.conf /etc/lightdm/lightdm.conf.0
cat << BASTA >> /etc/lightdm/lightdm.conf

greeter-session=lxdm-gtk2
user-session=lxde
BASTA