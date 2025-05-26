#!/bin/bash

if [ "$UID" -ne "0" ]
then
  echo "You are NOT root"
  exit 1
fi

PACKAGE_NAME="php"

if dpkg -l | grep -q "^ii.*$PACKAGE_NAME"; then
    echo "$PACKAGE_NAME уже установлен в системе. Выход из скрипта."
    exit 0
fi

apt install -y php libapache2-mod-php php-mysql
php -v

echo "..................PHP installed successfully"

cat << end > /var/www/html/pi.php
<?php
 phpinfo();
 ?>
end

echo "..................Test PHP Script installed, check the ufo.mars/pi.php"