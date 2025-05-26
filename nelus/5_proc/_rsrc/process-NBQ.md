        Cлышите гул и странные звуки? 
        Oни предвещают, что родится демон. 
        Первый демон и имя ему System-D. 
        Затем из его виртуальной плоти
        родятся другие демоны,
        и начнут заполнять оперативную память 
        и терроризировать процессор..

        https://www.youtube.com/watch?v=6-h6HtqPXNA

Тема "Процессы"
---------------

```
find which .basrc .profile
test while until for do .. done
-lt -le -eq -ge -gt -ne && || ! -a -o
"exec", "fork", ". ./script"
> >> < << | tee
jobs fg bg &
ps aux
nice, top
PID UID GID kill killall 9

$ nano dk
$ cat dk
#! /bin/sh
while test 0
do
sleep 5
echo dai kolbasy!
done
$ ./dk &
[1] 636
$ dai kolbasy!
jodai kolbasy!
bs
[1]+  Running                 ./dk &
$ dai kolbasy!
dai kolbasy!
dai kolbasy!
ps dai kolbasy!
-a
    PID TTY          TIME CMD
    434 pts/1    00:00:00 bash
    636 pts/0    00:00:00 dk
    644 pts/0    00:00:00 sleep
    645 pts/0    00:00:00 ps
$ dai kolbasy!
dai kolbasy!
dai kolbasy!
kill -dai kolbasy!
9dai kolbasy!
 6dai kolbasy!
36
$ ps -a
    PID TTY          TIME CMD
    434 pts/1    00:00:00 bash
    652 pts/0    00:00:00 ps
[1]+  Killed                  ./dk
$
```

Если нет команды, как установить?

Пример: nslookup

```
$ nslookup
-bash: nslookup: command not found
$ sudo apt update && sudo apt upgrade -y
$ sudo apt install -y apt-file
$ sudo apt-file update
$ apt-file search nslookup | grep -P 'bin/'
bind9-dnsutils: /usr/bin/nslookup
$ sudo apt install -y bind9-dnsutils
success
$ nslookup youtube.com 192.168.253.250
```

Пример: netstat

```
$ netstat
-bash: netstat: command not found
$ apt-file search netstat | grep -P 'bin/netstat$'
net-tools: /bin/netstat
$ sudo apt install -y net-tools
Success
$ netstat -tulpan
(Not all processes could be identified, non-owned process info
 will not be shown, you would have to be root to see it all.)
Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      -
tcp        0      0 0.0.0.0:139             0.0.0.0:*               LISTEN      -
tcp        0      0 0.0.0.0:445             0.0.0.0:*               LISTEN      -
tcp        0    628 172.23.225.141:22       172.23.224.1:28374      ESTABLISHED -
tcp6       0      0 :::22                   :::*                    LISTEN      -
tcp6       0      0 :::139                  :::*                    LISTEN      -
tcp6       0      0 :::445                  :::*                    LISTEN      -
udp        0      0 0.0.0.0:68              0.0.0.0:*                           -
udp        0      0 172.23.239.255:137      0.0.0.0:*                           -
udp        0      0 172.23.225.141:137      0.0.0.0:*                           -
udp        0      0 0.0.0.0:137             0.0.0.0:*                           -
udp        0      0 172.23.239.255:138      0.0.0.0:*                           -
udp        0      0 172.23.225.141:138      0.0.0.0:*                           -
udp        0      0 0.0.0.0:138             0.0.0.0:*                           -
udp        0      0 0.0.0.0:5353            0.0.0.0:*                           -
udp        0      0 0.0.0.0:38639           0.0.0.0:*                           -
udp6       0      0 :::5353                 :::*                                -
udp6       0      0 :::33172                :::*                                -
```

Homework
--------

1. create folder /<имя>/
2. add this folder into path
3. activate changes with logout/login
4. place into created folder script 'dai kolbasy'
5. build hanoi towers game from   
   http://kirill.tpt.edu.ee/src/hanoi.c

