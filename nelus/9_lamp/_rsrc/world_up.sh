#!/bin/bash

if [ "$UID" -ne "0" ]
then
  echo "You are NOT root"
  exit 1
fi

wget https://downloads.mysql.com/docs/world-db.tar.gz
cat world-db.tar.gz | gzip -d | tar xf -
mysql -u root < world-db/world.sql
mysql -e "show databases;"

rm -f world-db.tar.gz

echo "..................WorldDatabase installed successfully"