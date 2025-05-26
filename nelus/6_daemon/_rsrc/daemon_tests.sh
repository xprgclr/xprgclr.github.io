#!/bin/bash

if [ "$UID" -ne "0" ]
then
  echo "You are NOT root"
  exit 1
fi

echo -n > /var/log/daemon/daemon.log

echo "Wait ~ 6 Seconds plz..........."

# SIMPLE DAEMON
# first way
echo "................................................."
echo "............ SIMPLE DAEMON ......................"
echo "................................................."

echo "method 1/3... (native)"
systemctl start simple-daemon
systemctl stop simple-daemon 
sleep 1

# second way
echo "method 2/3...(using service)"
service simple-daemon start
service simple-daemon stop
sleep 1

# third way
echo "method 3/3...(by creating scripts)"
/etc/init.d/simple-daemon start
/etc/init.d/simple-daemon stop
sleep 1

echo "................................................."
echo "............ STATUS SIMPLE DAEMON................"
echo "................................................."

systemctl status simple-daemon

#----------------------------------------------------------------------------------------

# FORKING DAEMON
# first way
echo "................................................."
echo "............STATUS FORKING DAEMON ..............."
echo "................................................."

echo "method 1/3... (native)"
systemctl start forking-daemon
systemctl stop forking-daemon
sleep 1

# second way
echo "method 2/3...(using service)"
service forking-daemon start
service forking-daemon stop
sleep 1

# third way
echo "method 3/3...(by creating scripts)"
/etc/init.d/forking-daemon start
/etc/init.d/forking-daemon stop
sleep 1

echo "................................................."
echo "............ STATUS ............................."
echo "................................................."

systemctl status forking-daemon



echo "................................................."
echo "............ DONE ..............................."
echo "................................................."

# Showing
cat /var/log/daemon/daemon.log