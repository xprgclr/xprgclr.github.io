#!/bin/bash

if [ "$UID" -ne "0" ]
then
  echo "You are NOT root"
  exit 1
fi

PACKAGE_NAME="mariadb-server"

if dpkg -l | grep -q "^ii.*$PACKAGE_NAME"; then
    echo "$PACKAGE_NAME уже установлен в системе. Выход из скрипта."
    exit 0
fi
apt install -y mariadb-server mariadb-client

mysql_secure_installation << eof

n
n


n

eof

echo "..................MariaDB installed successfully"