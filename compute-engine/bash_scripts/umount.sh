#!/bin/bash

# Variables
DISK_DEVICE="/dev/sdb"
MOUNT_POINT=$1

# Function to check if the disk is mounted
check_disk_mounted() {
  mount | grep -w "$DISK_DEVICE" > /dev/null 2>&1
  return $?
}

# Unmount the disk if it is mounted
if check_disk_mounted; then
  echo "Disk $DISK_DEVICE is currently mounted at $MOUNT_POINT. Unmounting..."
  sudo umount $DISK_DEVICE

  if [ $? -eq 0 ]; then
    echo "Disk $DISK_DEVICE unmounted successfully."
  else
    echo "Failed to unmount disk $DISK_DEVICE."
  fi
else
  echo "Disk $DISK_DEVICE is not mounted."
fi