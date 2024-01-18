# Requires running as Administrator

try {
    # Get the system drive letter from environment variable
    $systemDrive = $env:SystemDrive.Trim(':')

    # Get the disk number for the system drive
    $diskNumber = Get-Partition -DriveLetter $systemDrive | Select-Object -ExpandProperty DiskNumber

    # Get the partition for the system drive
    $partition = Get-Partition -DiskNumber $diskNumber -PartitionNumber 1

    # Get the maximum size available for extension
    $maxSize = Get-PartitionSupportedSize -DriveLetter $systemDrive

    # Check if there is space to extend
    if ($maxSize.SizeMax -gt $partition.Size) {
        # Extend the system drive partition
        Resize-Partition -DriveLetter $systemDrive -Size $maxSize.SizeMax
        Write-Host "System drive ($systemDrive) extended successfully."
    } else {
        Write-Host "No unallocated space available to extend the system drive ($systemDrive)."
    }
} catch {
    Write-Host "An error occurred: $_"
}

