#!/bin/bash

clear
echo "first we will figure out which disk we are going to make a partition on."
echo ''
sleep 1
echo "press enter when ready."
read waiting

clear
sudo lsblk

echo 'which drive do we want to create the partition on?'
echo "this should be in format /dev/sdx"
read drive

clear
echo "$drive is this what you selected?"
echo ''
echo 'do not continue otherwise.'
read waiting

clear
echo "make a partition here that we will use to encrypt"
sudo fdisk $drive

clear
lsblk

echo ""
echo "where did we make the partition at? format is /dev/sdxx"
read partition

clear
echo "so the drive is $drive and the partition is $partition?"
read waiting

clear
sudo blkid
echo ""
echo "i need the partition uuid. format -- just the letters / digits inside the quotes"
read partid

clear
echo 'where did we want to mount this bad boy?'
read location

clear
echo 'what would we want that drive to be called when its mapped?'
read name

clear 
echo "and one last thing, think of a key name."
read keyname

clear 
echo 'super last chance.'
echo "we are mounting $partition a luks device named $name with location $location"
echo "partition id: $partid"
echo "key name: $keyname"
read waiting

clear
echo 'going to start making changes now.'
sleep 2

sudo cryptsetup -y -v luksFormat /dev/disk/by-partuuid/$partid

sudo cryptsetup luksOpen /dev/disk/by-partuuid/$partid $name

dd if=/dev/urandom of=/home/$USER/.$keyname bs=512 count=8

sudo mkfs.ext4 /dev/mapper/$name

sudo cryptsetup luksAddKey /dev/disk/by-partuuid/$partid ~/.$keyname

touch ~/add_me_to_crypttab
echo "$name /dev/disk/by-partuuid/$partid /home/$USER/.$keyname luks" >> /home/$USER/add_me_to_crypttab

touch ~/add_me_to_fstab
echo "/dev/mapper/$name $location ext4 defaults 0 0" > /home/$USER/add_me_to_fstab

echo "two last steps"
echo ""
sleep 1
echo "there are two files which need to have their text transferred and are labeled accordingly."
read waiting
