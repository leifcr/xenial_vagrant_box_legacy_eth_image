#!/bin/bash
echo "Cleaning up"
sleep 1
apt-get -y purge linux-headers-virtual
apt-get -y clean
apt-get -y autoremove

echo "Remove hosts entries"
sed -i '/elastic64/d' /etc/hosts
sed -i '/vagrant.vm/d' /etc/hosts

echo "Removing cleanup script"
sed -i '/cleanup.sh/d' /etc/rc.local
echo "zero'ing data"
sudo dd if=/dev/zero of=/EMPTY bs=1M
sudo rm -f /EMPTY

echo "Shutdown"
rm -f /root/cleanup.sh
poweroff --no-wall
