#!/bin/bash
echo "Installing vagrant insecure pub key"
mkdir -p /home/vagrant/.ssh
chmod 0700 /home/vagrant/.ssh
rm /home/vagrant/.ssh/authorized_keys
wget --no-check-certificate https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub -O /home/vagrant/.ssh/authorized_keys
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant /home/vagrant/.ssh
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
