#! /bin/bash

# root ?

if test `id -u` -ne 0
then
  echo "ur not root bro"
  exit 1
fi

# place

place=$(pwd)
time=$(date +%s)

# install

echo "ServerName 127.0.0.1" >> /etc/apache2/apache2.conf
a2enmod ssl
systemctl restart apache2
mkdir ssl
cd ssl
openssl req -new -x509 -days 1461 -nodes -out cert.pem -keyout cert.key -subj "/C=EE/ST=Harju/L=Tallinn/O=Global Security/OU=IT osakond/CN=test.t412.local/CN=test"
mkdir /etc/certificate
cp * /etc/certificate

if [ -f /etc/apache2/conf-available/ssl-params.conf.0 ]
then
  echo "/etc/apache2/conf-available/ssl-params.conf.0 exists"
else
  cp /etc/apache2/conf-available/ssl-params.conf /etc/apache2/conf-available/ssl-params.conf.0
fi

cat << BASTA > /etc/apache2/conf-available/ssl-params.conf
SSLCipherSuite EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH
    SSLProtocol All -SSLv2 -SSLv3 -TLSv1 -TLSv1.1
    SSLHonorCipherOrder On
    Header always set X-Frame-Options DENY
    Header always set X-Content-Type-Options nosniff
    # Requires Apache >= 2.4
    SSLCompression off
    SSLUseStapling on
    SSLStaplingCache "shmcb:logs/stapling-cache(150000)"
    # Requires Apache >= 2.4.11
    SSLSessionTickets Off
BASTA
if [ -f /etc/apache2/sites-available/default-ssl.conf.0 ]
then
  echo "/etc/apache2/sites-available/default-ssl.conf.0 exists"
else
  cp /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf.0
fi
cat /etc/apache2/sites-available/default-ssl.conf.0 | \
    perl -pe 's#^\s+SSLCertificateFile.*$#        SSLCertificateFile      /etc/certificate/cert.pem#'  |  \
    perl -pe 's#^\s+SSLCertificateKeyFile.*$#        SSLCertificateKeyFile   /etc/certificate/cert.key#'  >  \
    /etc/apache2/sites-available/default-ssl.conf
cat /etc/apache2/sites-available/default-ssl.conf | grep -P "^\s+SSLCert"
a2enmod headers
a2enconf ssl-params
a2ensite default-ssl
apache2ctl configtest
systemctl restart apache2
systemctl status apache2 --no-pager

cd $place
echo "Success (SSL certificate activated)"
