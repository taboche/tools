#!/bin/bash

# Set variables for disks
DISK_SDA="/dev/sda"
DISK_NVME="/dev/nvme0n1"  # Adjust based on your actual NVMe device name

# Read MAAS resources file
resources=$(jq . "$MAAS_RESOURCES_FILE")

# Define your desired custom layout here
# Example: Use GPT partition table, create a 500GB root partition on sda,
# and use the remaining space on nvme for a data partition
layout=$(jq '
{
  "layout": {
    "'$DISK_SDA'": {
      "type": "disk",
      "ptable": "gpt",
      "boot": true,
      "partitions": [
        { "name": "sda1", "size": "500GiB" }
      ]
    },
    "'$DISK_NVME'": {
      "type": "disk",
      "ptable": "gpt",
      "partitions": [
        { "name": "nvme1", "size": "remaining" }
      ]
    }
  }
}
')

# Write the layout to the output file
echo "$layout" > "$MAAS_STORAGE_CONFIG_FILE"

exit 0
