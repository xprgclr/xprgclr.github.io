#!/bin/bash

if [ "$UID" -ne "0" ]
then
  echo "You are NOT root"
  exit 1
fi

rm -f world-db.tar.gz
rm -rf world-db

mysql -u root -e "DROP DATABASE IF EXISTS world;"
mysql -u root -e "show databases;"

echo "..................WorldDatabase removed successfully"