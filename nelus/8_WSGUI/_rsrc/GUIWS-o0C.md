## Show eth0 IP before GUI greeter asks your password

```bash
$ cat /etc/lightdm/lightdm.conf | grep -P "^[^#]"
[LightDM]
[Seat:*]
greeter-session=lightdm-gtk-greeter
greeter-hide-users=false
display-setup-script=/usr/local/bin/question
autologin-user=pi
[XDMCPServer]
[VNCServer]

$ cat /etc/lightdm/lightdm-gtk-greeter.conf | grep -P "^[^#]"
[greeter]
background=/usr/share/rpd-wallpaper/temple.jpg

$ cat /usr/local/bin/question
#! /bin/bash
TXT=`ip a show dev eth0 | grep -oP "(\d{1,3}\.?){4}/\d{2}"`
zenity --info --title "my IP address:" --text "$TXT"
```

## Adding GUI

```bash
#!/bin/bash

if [ "$UID" -ne "0" ]
then
  echo "You are NOT root"
  exit 1
fi

apt update
apt upgrade -y
apt install systemd-timesyncd
systemctl restart systemd-timesyncd
timedatectl
systemctl status systemd-timesyncd --no-pager | tail -n 1

apt-get -y install wget
apt-get -y install xserver-xorg lxde lightdm lxappearance
apt -y install build-essential module-assistant dkms wget

apt -y install lightdm lxde task-lxde-desktop
echo "DISPLAY_MANAGER=lightdm" > /etc/default/display-manager

cp /etc/lightdm/lightdm.conf /etc/lightdm/lightdm.conf.0
cat << BASTA >> /etc/lightdm/lightdm.conf

greeter-session=lxdm-gtk2
user-session=lxde
BASTA

systemctl restart lightdm
```

### Links

1. https://wiki.ubuntu.com/LightDM
2. https://ubuntuforums.org/showthread.php?t=2186061
   
   Ah zeeenity?! .. Obi-Wan Kenobi?.. Now, that's a name I've not heard in a long time. A long time.

   Star Wars: Episode IV - A New Hope (1977)