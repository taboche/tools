#!/bin/bash

# Check if lspci and lstopo commands are available
# if ! command -v lspci &> /dev/null || ! command -v lstopo &> /dev/null
# then
#     echo "lspci and lstopo commands are required for this script."
#     exit 1
# fi

# # Get NUMA node information
# echo "Gathering NUMA node information..."
# lstopo-no-graphics --of console

# # List all PCI devices
# echo "Listing all PCI devices..."
# lspci

# # Mapping PCI devices to NUMA nodes
# echo "Mapping PCI devices to NUMA nodes..."
# for device in $(lspci | cut -d ' ' -f 1); do
#     numa_node=$(cat /sys/bus/pci/devices/0000:${device}/numa_node)
#     echo "Device ${device} is on NUMA node ${numa_node}"
# done
#!/bin/bash

# Check if required commands are available
# if ! command -v lscpu &> /dev/null || ! command -v lspci &> /dev/null
# then
#     echo "lscpu and lspci commands are required for this script."
#     exit 1
# fi

# Function to get PCI bridges for a NUMA node
get_pci_bridges_for_numa() {
    local numa_node=$1
    echo "PCI Bridges for NUMA node $numa_node:"
    lspci -D | grep -i bridge | while read -r line; do
        pci_device=$(echo "$line" | cut -d ' ' -f 1)
        device_numa_node=$(cat /sys/bus/pci/devices/${pci_device}/numa_node 2>/dev/null)
        if [[ "$device_numa_node" == "$numa_node" ]]; then
            echo "$pci_device"
        fi
    done
}

# Get the list of NUMA nodes
numa_nodes=$(lscpu | grep "NUMA node(s)" | awk '{print $NF}')

# Iterate over each NUMA node
for (( numa_node=0; numa_node<numa_nodes; numa_node++ ))
do
    echo "NUMA Node: $numa_node"
    echo "CPUs:"
    cat /sys/devices/system/node/node${numa_node}/cpulist
    echo ""
    get_pci_bridges_for_numa $numa_node
    echo ""
done

