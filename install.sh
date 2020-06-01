#! /bin/bash

echo "Arch Installer"
fdisk /dev/sda
  g # clear the in memory partition table
  n # new partition# partition number 1
  1 
  # default, start immediately after preceding partition
  # default - start at beginning of disk 
  +100M # 512 MB boot parttion
  t
  n # new partition
  2 # partion number 2 # primary partitio
    # default, start immediately after preceding partition

  w # write the partition table
  q # and we're done

# Format the partitions
mkfs.ext4 /dev/sda2
mkfs.fat -F32 /dev/sda1

# Initate pacman keyring
pacman-key --init
pacman-key --populate archlinux
pacman-key --refresh-keys

# Mount the partitions
mount /dev/sda2 /mnt
mkdir -pv /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi

# Install Arch Linux
echo "Starting install.."
echo "Installing Arch Linux, KDE with Konsole and Dolphin and GRUB2 as bootloader" 
pacstrap /mnt base base-devel zsh grml-zsh-config grub os-prober intel-ucode efibootmgr dosfstools freetype2 fuse2 mtools iw wpa_supplicant dialog xorg xorg-server xorg-xinit mesa xf86-video-intel plasma konsole dolphin

# Generate fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Copy post-install system cinfiguration script to new /root
cp -rfv post-install.sh /mnt/root
chmod a+x /mnt/root/post-install.sh

# Chroot into new system
echo "After chrooting into newly installed OS, please run the post-install.sh by executing ./post-install.sh"
echo "Press any key to chroot..."
read tmpvar
arch-chroot /mnt /bin/bash

# Finish
echo "If post-install.sh was run succesfully, you will now have a fully working bootable Arch Linux system installed."
echo "The only thing left is to reboot into the new system."
echo "Hey ! himanshu this one finished executing .do your thing now."
