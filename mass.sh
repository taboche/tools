#!/bin/bash

# Detect drives
DRIVE_SDA="/dev/sda"
DRIVE_NVME="/dev/nvme0n1"

# Partition and format /dev/sda
parted -s "$DRIVE_SDA" mklabel gpt
parted -s "$DRIVE_SDA" mkpart ESP fat32 1MiB 513MiB
parted -s "$DRIVE_SDA" set 1 boot on
parted -s "$DRIVE_SDA" mkpart primary ext4 513MiB 100%
mkfs.fat -F32 "${DRIVE_SDA}1"
mkfs.ext4 "${DRIVE_SDA}2"

# Partition and format /dev/nvme0n1
parted -s "$DRIVE_NVME" mklabel gpt
parted -s "$DRIVE_NVME" mkpart primary ext4 1MiB 100%
mkfs.ext4 "${DRIVE_NVME}1"

# Mount partitions
mkdir -p /mnt/boot/efi
mkdir -p /mnt/root
mkdir -p /mnt/scratch
mount "${DRIVE_SDA}1" /mnt/boot/efi
mount "${DRIVE_SDA}2" /mnt/root
mount "${DRIVE_NVME}1" /mnt/scratch

# Inform the user about the completion of the partitioning and formatting
echo "Partitioning and formatting completed successfully. /boot/efi and / partitions created on ${DRIVE_SDA}, /SCRATCH partition created on ${DRIVE_NVME}."

