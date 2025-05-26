#!/bin/bash

if [ "$UID" -ne "0" ]
then
  echo "You are NOT root"
  exit 1
fi

apt autoremove --purge php libapache2-mod-php php-mysql -y
echo "..................PHP Removed successfully"

rm  -f /var/www/html/pi.php
echo "..................Test PHP Script deleted"