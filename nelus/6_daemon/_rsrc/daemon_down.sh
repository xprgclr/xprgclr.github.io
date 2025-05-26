#!/bin/bash

if [ "$UID" -ne "0" ]
then
  echo "You are NOT root"
  exit 1
fi

rm -f /etc/init.d/simple-daemon
rm -f /etc/init.d/forking-daemon

rm -f /usr/bin/daemon

rm -f /usr/lib/systemd/system/simple-daemon.service
rm -f /usr/lib/systemd/system/forking-daemon.service

rm -rf /var/log/daemon
rm -rf /var/run/daemon
rm -rf ~/daemon


echo "DAEMONS REMOVED"
