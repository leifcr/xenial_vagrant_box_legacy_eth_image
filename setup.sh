#!/bin/bash
if grep -Fxq "net.ifnames=0 biosdevname=0" /etc/default/grub
then
  echo "Info: net.ifnames=0 biosdevname=0 is already set in /etc/default/grub"
else
  echo "Adding: net.ifnames=0 biosdevname=0 to /etc/default/grub"
  sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=\"\(.*\)\"/GRUB_CMDLINE_LINUX_DEFAULT=\"\1 net.ifnames=0 biosdevname=0\"/" /etc/default/grub
  sed -i "s/GRUB_CMDLINE_LINUX=\"\(.*\)\"/GRUB_CMDLINE_LINUX=\"\1 net.ifnames=0 biosdevname=0\"/" /etc/default/grub
fi
echo "Replacing enp*s* with eth0"
sed -i 's/enp\ws\w/eth0/g' /etc/network/interfaces
sed -i 's/pre-up sleep 2/pre-up sleep 1/g' /etc/network/interfaces
echo "Updating Grub"
update-grub
echo "Updating ubuntu"
apt-get update
apt-get -y -o Dpkg::Options::="--force-confold" install linux-image-virtual linux-headers-virtual linux-image-extra-virtual
sudo apt-get -y purge linux-image-4.4.0-31-generic linux-image-extra-4.4.0-31-generic
apt-mark hold grub-common grub-pc grub-pc-bin grub2-common
apt-get -y -o Dpkg::Options::="--force-confold" upgrade

echo "Installing guest additions"
wget -q -c http://download.virtualbox.org/virtualbox/5.1.14/VBoxGuestAdditions_5.1.14.iso -O /tmp/VBoxGuestAdditions_5.1.14.iso
sleep 1
mkdir /tmp/vboxadditions
sleep 2
mount /tmp/VBoxGuestAdditions_5.1.14.iso -o loop /tmp/vboxadditions
cd /tmp/vboxadditions && sh VBoxLinuxAdditions.run --nox11
umount /tmp/vboxadditions
# /etc/init.d/vboxadd setup
# chkconfig --add vboxadd
# chkconfig vboxadd on

echo "Cleaning up guest additions"
sleep 1
rm /tmp/VBoxGuestAdditions_5.1.14.iso
rmdir /tmp/vboxadditions

echo "Installing vagrant insecure pub key"
mkdir -p /home/vagrant/.ssh
chmod 0700 /home/vagrant/.ssh
rm /home/vagrant/.ssh/authorized_keys
wget --no-check-certificate https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub -O /home/vagrant/.ssh/authorized_keys
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant /home/vagrant/.ssh

echo "Enabling cleanup to be run after reboot"
sed -i '$i/root/cleanup.sh || exit 1' /etc/rc.local
mv /tmp/cleanup.sh /root/cleanup.sh
chmod a+x /root/cleanup.sh
echo "Reboot"
reboot --no-wall
