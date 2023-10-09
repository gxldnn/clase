#!/bin/bash

#// SFTP ACCESS SCRIPT
read user
read domain
CHROOTDIR=/var/www/$domain
useradd -m -d $CHROOTDIR $user
if [ ! -f "$CHROOTDIR/.ssh/id_rsa" ]; then
    sudo -u $user ssh-keygen -t rsa -b 4096 -N "" -f "$CHROOTDIR/.ssh/id_rsa"
fi
chmod 700 "$CHROOT_DIR/.ssh"
chmod 600 "$CHROOT_DIR/.ssh/authorized_keys"
cat "$CHROOT_DIR/.ssh/id_rsa.pub" >> "$CHROOT_DIR/.ssh/authorized_keys"