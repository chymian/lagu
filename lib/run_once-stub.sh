#!/bin/bash
# Run once to reset services
#

export  DEBIAN_FRONTEND=noninteractive
NOT_EXECUTED=/root/.run_once_not_yet


# setting hostname
HOSTNAME=rig-`ip link show |grep ether|awk '{ print $2 }'|cut -d: -f4,5,6|tr -d ":"`

echo setting hostname to $HOSTNAME
echo $HOSTNAME > /etc/hostname
/bin/hostname -F /etc/hostname

cat <<EOF > /etc/hosts
127.0.0.1       localhost
127.0.1.1       $HOSTNAME

# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
EOF


# needed programs & upgrade
echo "Installing dependencies & upgrade"
#apt_swap
\apt-get -y --force-yes install btrfs-tools e2fsprogs python ssh cloud-guest-utils apt-transport-https git apt screen tmux
\apt -y full-upgrade

# sshd-keys
echo recreating ssh-keys
service ssh stop
rm -f /etc/ssh/*key*
dpkg-reconfigure openssh-server


# dhcp-leases
echo removing dhcp-leases
dhclient -r eth0
rm -f /var/lib/dhcp/*

# cleaning udev-ruls
echo cleaning udev-rules
rm -f /etc/udev/rules.d/*

# clean apt
echo cleaning apt
apt-get clean
rm -f /var/lib/apt/lists/*

# grow partition root
echo growing Root-Partition
FS=`mount |grep " / "|awk '{ print $5 }'`
PART=`mount |grep " / "|awk '{ print $1 }'`
DISK=`echo $PART | cut -c 1-8`
PART_NUM=`echo $PART |cut -c 9`
growpart $DISK $PART_NUM

case $FS in
    ext2,ext3,ext4)
	resize2fs $PART
	;;
    btrfs)
	btrfs filesystem resize max /
	;;
esac

# change root password
echo root:.pw_lagu | chpasswd

# install mining software
useradd -m -s /bin/bash lagu
echo lagu:lagu |chpasswd

cd ~lagu
git clone https://github.com/chymian/lagu.git

mkdir -pm 700 .ssh
mkdir -p .config
cd .config
git clone https://github.com/chymian/dotfiles.git

cd ~lagu
chown -R lagu. .

su -l -c lagu/lib/install.sh lagu

rm $NOT_EXECUTED
reboot
exit 0
