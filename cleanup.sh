#!/bin/bash
echo "Installing guest additions"
wget -c http://download.virtualbox.org/virtualbox/5.0.24/VBoxGuestAdditions_5.0.24.iso -O /tmp/VBoxGuestAdditions_5.0.24.iso
mkdir /tmp/vboxadditions
mount /tmp/VBoxGuestAdditions_5.0.24.iso -o loop /tmp/vboxadditions
cd /tmp/vboxadditions && sh VBoxLinuxAdditions.run --nox11
umount /tmp/vboxadditions
# /etc/init.d/vboxadd setup
# chkconfig --add vboxadd
# chkconfig vboxadd on
echo "Cleaning up"
sleep 1
rm /tmp/VBoxGuestAdditions_5.0.24.iso
rmdir /tmp/vboxadditions
apt-get -y purge linux-headers-virtual
apt-get -y clean
apt-get -y autoremove
echo # Removing cleanup
sed -i '/cleanup.sh/d' /etc/rc.local
echo "Shutdown"
rm -f /root/cleanup.sh
poweroff --no-wall
