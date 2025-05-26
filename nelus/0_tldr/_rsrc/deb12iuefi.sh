#!/bin/bash

set -x

echo REVISION N8i

echo "\n@@@ build unattended ISO of Debian 12@@@"
echo "@@@ with sudop@@@\n"

if [ "$UID" -eq "0" ]
then
    echo "You are root, exiting.."
    exit 1
fi

echo -e "\n@@@ building.. @@@\n"

sudo apt-get update
sudo apt-get -y upgrade

# next row modified:
sudo apt install -y curl xorriso p7zip-full isolinux
if [ -f "./debian-12.5.0-amd64-netinst.iso" ]
then
    echo ISO already downloaded.
else
    curl -LO https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.5.0-amd64-netinst.iso
fi

sudo rm -rf isofiles
rm -f preseed.cfg preseed.cfg.init

xorriso -osirrox on -indev debian-12.5.0-amd64-netinst.iso -extract / isofiles/

sudo sed -i 's/vesamenu.c32/install/' isofiles/isolinux/isolinux.cfg

curl -L https://www.debian.org/releases/stable/example-preseed.txt -o preseed.cfg

if [ ! -f preseed.cfg.init ]
then
    mv preseed.cfg preseed.cfg.init
fi

cat << 'EOF' > preseed.cfg
#_preseed_V1
d-i debian-installer/language string en
d-i debian-installer/country string EE
d-i debian-installer/locale string en_US.UTF-8
d-i keyboard-configuration/xkb-keymap select us
d-i netcfg/choose_interface select auto
d-i netcfg/get_hostname string bookworm-unattended
d-i netcfg/get_domain string
d-i netcfg/wireless_wep string
d-i mirror/country string manual
d-i mirror/http/hostname string ftp.ee.debian.org
d-i mirror/http/directory string /debian
d-i mirror/http/proxy string
d-i passwd/root-password password Passw0rd
d-i passwd/root-password-again password Passw0rd
d-i passwd/user-fullname string it
d-i passwd/username string it
d-i passwd/user-password password Passw0rd
d-i passwd/user-password-again password Passw0rd
d-i clock-setup/utc boolean true
d-i time/zone string Estonia/Tallinn
d-i clock-setup/ntp boolean true
d-i partman-auto/method string regular
d-i partman-auto/choose_recipe select atomic
d-i partman-partitioning/confirm_write_new_label boolean true
d-i partman/choose_partition select finish
d-i partman/confirm boolean true
d-i partman/confirm_nooverwrite boolean false
d-i partman-md/confirm boolean true
d-i partman-partitioning/confirm_write_new_label boolean true
d-i partman/choose_partition select finish
d-i partman/confirm boolean true
d-i partman/confirm_nooverwrite boolean true
d-i partman/mount_style select traditional
# tasksel tasksel/first multiselect gnome-desktop
tasksel tasksel/first multiselect
d-i apt-setup/cdrom/set-first boolean false
d-i preseed/late_command string \
  in-target apt-get install -y sudo ed openssh-server; \
  in-target cp /etc/group /etc/group.init; \
  in-target sed -i -E 's/(sudo:[x0-9:]+)$/\1it/' /etc/group; \
  in-target sed -i -E '$aIP: \\4' /etc/issue; \
  cp /cdrom/extras/halo /target/root/;

popularity-contest popularity-contest/participate boolean false
d-i grub-installer/only_debian boolean true
d-i grub-installer/bootdev string /dev/sda
d-i finish-install/reboot_in_progress none
EOF

chmod +w -R isofiles/install.amd/
gunzip isofiles/install.amd/initrd.gz
echo preseed.cfg | cpio -H newc -o -A -F isofiles/install.amd/initrd
gzip isofiles/install.amd/initrd
chmod -w -R isofiles/install.amd/
cat isofiles/isolinux/isolinux.cfg | perl -pe 's/^default/# default/' | sudo tee isofiles/isolinux/isolinux.cfg > /dev/null

cat << 'EOF' > tmpfile
set timeout_style=hidden
set timeout=0
set default=1
EOF

sudo mkdir isofiles/extras

##### implant halo script

sudo cat << 'ENDOFSCRIPT' | \
  sudo tee isofiles/extras/halo > /dev/null
#!/bin/bash

if [ "$UID" -ne "0" ]
then
  echo -e "Must be root. Exiting\n"
fi

apt update
apt -y upgrade

echo "HALO SCRIPT DONE.."
ENDOFSCRIPT

cat isofiles/boot/grub/grub.cfg >> tmpfile
sudo rm -f isofiles/boot/grub/grub.cfg
sudo mv tmpfile isofiles/boot/grub/grub.cfg

cd isofiles/
chmod a+w md5sum.txt
if [ ! -f "md5sum.txt.init" ]
then
  sudo cp md5sum.txt md5sum.txt.init
fi
chmod a-w md5sum.txt
cd ..

chmod a+w isofiles/isolinux/isolinux.bin
sudo apt install -y isolinux xorriso
xorriso -as mkisofs \
  -o debi12uefi.iso \
  -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin \
  -c isolinux/boot.cat \
  -b isolinux/isolinux.bin \
  -no-emul-boot \
  -boot-load-size 4 \
  -boot-info-table \
  -eltorito-alt-boot \
  -e 'boot/grub/efi.img' \
  -no-emul-boot \
  -isohybrid-gpt-basdat \
  -r -J \
  isofiles

# echo DON'T WORRY, BE HAPPY!
