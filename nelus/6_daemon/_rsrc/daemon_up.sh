#!/bin/bash

if [ "$UID" -ne "0" ]
then
  echo "You are NOT root"
  exit 1
fi

# PreReq
cd ~
git clone https://github.com/jirihnidek/daemon
sudo apt install -y build-essential cmake

# Copying..
cp daemon/src/daemon.c daemon/src/daemon.c.0
cp daemon/simple-daemon.service daemon/simple-daemon.service.0
cp daemon/forking-daemon.service daemon/forking-daemon.service.0

# Changing
sed -i "s/User=daemoner/User=root/" "$HOME/daemon/simple-daemon.service"
sed -i "s/User=daemoner/User=root/" "$HOME/daemon/forking-daemon.service"
sed -i "s/Debug: /Debug_Roman_KIT23V: /" "$HOME/daemon/src/daemon.c"

# Installing
cd ~/daemon
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr ../
make
make install


# Creating.

cat << end > /etc/init.d/simple-daemon
### BEGIN INIT INFO
# Default-Start:  2 3 4 5
# Default-Stop: 0 1 6
### END INIT INFO
set -e
# Source function library.
. /lib/lsb/init-functions
# Are we running from init?
run_by_init() {
    ([ "$previous" ] && [ "$runlevel" ]) || [ "$runlevel" = S ]
}
start() {
  /usr/bin/daemon -d \
      --conf_file /etc/daemon/daemon.conf \
      --log_file /var/log/daemon.log
}
stop() {
  killall -9 daemon
}
prg="simple-daemon"
export PATH="${PATH:+$PATH:}/usr/local/bin"
case "$1" in
  start)
        echo "STARTING: $prg"
        start
        ;;
  stop)
        echo "STOPPING: $prg"
        stop
        ;;
  restart)
        echo "RESTARTING: $prg"
        start; stop
        ;;
  status)
        echo "QUERING STATUS: $prg"
  ps -A | grep -i daemon
        ;;
  *)
        log_action_msg "Usage: /etc/init.d/$prg {start|stop|restart|status}" || true
        exit 1
esac
exit 0
end

cat << end > /etc/init.d/forking-daemon
#!/bin/sh
### BEGIN INIT INFO
# Default-Start:  2 3 4 5
# Default-Stop: 0 1 6
### END INIT INFO
set -e
# Source function library.
. /lib/lsb/init-functions
# Are we running from init?
run_by_init() {
    ([ "$previous" ] && [ "$runlevel" ]) || [ "$runlevel" = S ]
}
start() {
  /usr/bin/daemon \
       --conf_file /etc/daemon/daemon.conf \
       --log_file /var/log/daemon.log \
       --pid_file /var/run/daemon.pid \
       --daemon
}
stop() {
  /bin/kill -9 `cat /var/run/daemon.pid`
}
prg="forking-daemon"
export PATH="${PATH:+$PATH:}/usr/local/bin"
case "$1" in
  start)
        echo "STARTING: $prg"
        start
        ;;
  stop)
        echo "STOPPING: $prg"
        stop
        ;;
  restart)
        echo "RESTARTING: $prg"
        start; stop
        ;;
  status)
        echo "QUERING STATUS: $prg"
        status_of_proc -p /var/run/daemon.pid /usr/bin/daemon daemon && exit 0 || exit $?
        ;;
  *)
        log_action_msg "Usage: /etc/init.d/daemon {start|stop|restart|status}" || true
        exit 1
esac

exit 0
end

chmod +x /etc/init.d/simple-daemon /etc/init.d/forking-daemon


echo "---------------------------------------------[ Complete ]-------------------"