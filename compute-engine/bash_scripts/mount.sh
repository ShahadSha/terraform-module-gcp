#!/bin/bash

# Variables
DISK_DEVICE="/dev/sdb"
MOUNT_POINT=$1

# Function to check if the disk is already attached
check_disk_attached() {
  lsblk -o NAME | grep -w "$(basename $DISK_DEVICE)" > /dev/null 2>&1
  return $?
}

# Function to check if the disk is already mounted
check_disk_mounted() {
  mount | grep -w "$DISK_DEVICE" > /dev/null 2>&1
  return $?
}

# Check if the disk is already attached
if check_disk_attached; then
  echo "Disk $DISK_DEVICE is already attached."
else
  echo "Disk $DISK_DEVICE is not attached."
  exit 1
fi

# Check if the disk is already mounted
if check_disk_mounted; then
  echo "Disk $DISK_DEVICE is already mounted."
else
  # Create mount point if it doesn't exist
  if [ ! -d "$MOUNT_POINT" ]; then
    sudo mkdir -p "$MOUNT_POINT"
  fi

  # Check if the disk is formatted
  if ! sudo blkid $DISK_DEVICE > /dev/null 2>&1; then
    echo "Formatting the disk $DISK_DEVICE as ext4."
    sudo mkfs.ext4 $DISK_DEVICE
  fi

  # Mount the disk
  echo "Mounting the disk $DISK_DEVICE to $MOUNT_POINT."
  sudo mount $DISK_DEVICE $MOUNT_POINT

  # Update /etc/fstab to mount the disk on reboot
  if ! grep -qs "$MOUNT_POINT" /etc/fstab; then
    echo "$DISK_DEVICE $MOUNT_POINT ext4 defaults 0 0" | sudo tee -a /etc/fstab
  fi

  echo "Disk $DISK_DEVICE mounted successfully at $MOUNT_POINT."
fi