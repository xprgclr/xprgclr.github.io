#!/bin/bash

if [ "$UID" -ne "0" ]
then
  echo "You are NOT root"
  exit 1
fi

apt autoremove --purge mariadb-server mariadb-client -y

echo "..................MariaDB removed successfully"