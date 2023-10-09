#!/bin/bash

# Define the username
user="abel"
CHROOT_DIR="/var/www/$domain

# Create the user if it doesn't exist
sudo useradd -m -d $CHROOTDIR $user

# Generate an SSH key pair for the user if it doesn't exist
if [ ! -f "$CHROOTDIR/.ssh/id_rsa" ]; then
    sudo -u $user ssh-keygen -t rsa -b 4096 -N "" -f "$CHROOTDIR/.ssh/id_rsa"
fi

# Ensure proper permissions
sudo chmod 700 "$CHROOTDIR/.ssh"
sudo chmod 600 "$CHROOTDIR/.ssh/authorized_keys"

# Add the public key to authorized_keys
cat "$CHROOTDIR/.ssh/id_rsa.pub" | sudo tee -a "$CHROOTDIR/.ssh/authorized_keys"

# Restart SSH service
sudo systemctl restart sshd
