написать bash скрипт с общей структурой, которую мы будем использовать и в дальнейшем

```bash
# 1. секция запуска

# этот скрипт на bash
#! /bin/bash

# этот скрипт на языке Python
#! /usr/bin/env python

# 2. секция режима выполнения

set -x   # activate debugging from here
..
set +x   # stop debugging from here

# 3. секция проверки ты корень? (пацан сказал, пацан сделал)

if [ "$UID" -ne "0" ]
then
  echo -e "Must be root. Exiting\n"
  exit 1
fi

# старый стиль

if test `id -u` -ne 0
then
  echo "ur not root bro"
  exit 1
fi

# 3. запоминаем этот момент до конца скрипта

MOMENT=$(date +%s)
PLACE=$(pwd)

# 4. если мы собираемся портить файл, сделаем backup

if [ -f "interfaces" ]
then
  cp interfaces interfaces.$MOMENT
fi

# 5. вернем систему к состоянию до выполнения скрипта

  удалить 10 юзеров из файла

  1. с помощью deluser
  2. c помощью userdel

# 6. выполним поставленную задачу

  создать 10 юзеров из файла

  1. с помощью adduser
  2. c помощью useradd

# 7. вернемся в точку запуска

cd $PLACE
echo "скрипт $0 закончился"
```
----------

Список литературы

https://tldp.org/LDP/Bash-Beginners-Guide/

* * *

P.S. нашел материал за прошлый год:

Manually:

```bash
# addgroup team
Adding group `team' (GID 1001) ...
Done.

# adduser --ingroup team potato
Adding user `potato' ...
...
New password:
Retype new password:
passwd: password updated successfully
Changing the user information for potato
Enter the new value, or press ENTER for the default
        Full Name []: astronomer
        Room Number []: earth
        Work Phone []: 123
        Home Phone []: 000
        Other []: funky
Is the information correct? [Y/n] y
# echo "=== last record in /etc/group ==="
=== last record in /etc/group ===
# cat /etc/group | tail -n 1
team:x:1001:
# echo "=== last record in /etc/group ==="
=== last record in /etc/group ===
# cat /etc/group | tail -n 1
team:x:1001:
# echo "=== last record in /etc/passwd ==="
=== last record in /etc/passwd ===
# cat /etc/passwd | tail -n 1
potato:x:1001:1001:astronomer,earth,123,000,\
  funky:/home/potato:/bin/bash
# echo "=== list of /home directory  ==="
=== list of /home directory  ===
# ls -l /home
total 8
drwxr-xr-x 17 it       it  4096 Nov  3 06:56 it
drwxr-xr-x  2 potato   team 4096 Nov  4 06:41 potato
Now removing

# deluser potato
Removing user `potato' ...
Warning: group `team' has no more members.
Done.
# delgroup team
Removing group `team' ...
Done.
# rm -rf /home/potato/
# echo "=== last record in /etc/group ==="
=== last record in /etc/group ===
# cat /etc/group | tail -n 1
geoclue:x:123:
# echo "=== last record in /etc/passwd ==="
=== last record in /etc/passwd ===
# cat /etc/passwd | tail -n 1
geoclue:x:114:123::/var/lib/geoclue:/usr/sbin/nologin
# echo "=== list of /home directory  ==="
=== list of /home directory  ===
# ls -l /home
total 4
drwxr-xr-x 17 it it 4096 Nov  3 06:56 it
As we intend to create many users with script, let's build the list of users with ed.

touch band
ed band
0
a
Woody
Buzz
Jessie
Bullseye
Potato
Rex
Slinky
Hamm
Dolly
BoPeep
.
wq
63
```

We need to learn how to loop over the list of our users (file named "band"):

```bash
#!/bin/bash

for i in $(cat band)
do
    echo $i 2>&1 | cat > /dev/null
done
```

Finally:

script up-band

```bash
#!/bin/bash

if test `id -u` -ne 0
then
  echo "ur not root bro"
  exit 1
fi

addgroup team
for i in $(cat band)
do
    adduser --ingroup team $i << BASTA 2>&1 | cat > /dev/null
$i
$i
$i




y
BASTA
done

echo "=== last record in /etc/group ==="
cat /etc/group | tail -n 1
echo "=== last records in /etc/passwd ==="
cat /etc/passwd | tail -n $(cat band | wc -l)
echo "=== list of /home directory  ==="
ls -l /home
```

script down-band

```bash
#!/bin/bash

if test `id -u` -ne 0
then
  echo "ur not root bro"
  exit 1
fi

for i in $(cat band)
do
    deluser $i
    rm -rf /home/$i
done
delgroup team

echo "=== last record in /etc/group ==="
cat /etc/group | tail -n 1
echo "=== last record in /etc/passwd ==="
cat /etc/passwd | tail -n 1
echo "=== list of /home directory  ==="
ls -l /home
```