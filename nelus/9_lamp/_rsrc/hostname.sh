#! /bin/bash

# uncomment next row to be verbose (debugging)
# set -x

if [ $# -ne 1 ]
then
   echo "Usage: $0 arg. Exiting.."
   exit 0
fi

if [ "$UID" -ne "0" ]
then
  echo "You are not root. Exiting.."
  exit 1
fi

NEW_HOSTNAME=$1

hostname $NEW_HOSTNAME
hostnamectl set-hostname $NEW_HOSTNAME

UNIXTIMENOW=$(date +%s)
mv /etc/hosts /etc/hosts.$UNIXTIMENOW

# sed -Ei silently does not work:)
cat /etc/hosts.$UNIXTIMENOW | \
  sed -E "s/(^127\.0\.1\.1).*$/\1 $NEW_HOSTNAME/" > \
  /etc/hosts

echo "New hostname: $(hostname)"
echo "New IP addresses: $(hostname -I)"
echo
echo "Relogin or run: '$ exec bash' to actualize the prompt"