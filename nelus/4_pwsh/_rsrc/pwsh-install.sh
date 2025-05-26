#! /bin/bash

if test `id -u` -ne 0
then
  echo "ur not root bro"
  exit 1
fi

batcat $0

apt-get update
apt-get install -y wget
wget https://github.com/PowerShell/PowerShell/releases/download/v7.4.0//powershell_7.4.0-1.deb_amd64.deb
dpkg -i powershell_7.4.0-1.deb_amd64.deb
apt-get install -f
rm powershell_7.4.0-1.deb_amd64.deb