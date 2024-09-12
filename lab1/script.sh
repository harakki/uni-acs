#!/bin/bash

# Get system info
os_name=$(grep '^NAME=' /etc/os-release | awk -F= '{print $2}' | tr -d '"')
os_version=$(grep '^VERSION=' /etc/os-release | awk -F= '{print $2}' | tr -d '"')

# Get kernel info
kernel_version=$(uname -r)
kernel_arch=$(uname -m)

# Get CPU info
cpu_model=$(grep '^model name' /proc/cpuinfo | uniq | awk -F: '{print $2}' | sed -e 's/^[ \t]*//' -e ':a;N;$!ba;s/\n/,/g')
cpu_frequency=$(grep '^cpu MHz' /proc/cpuinfo | uniq | awk -F: '{print $2}' | sed -e 's/^[ \t]*//' -e ':a;N;$!ba;s/\n/,/g')
cpu_cores=$(grep '^cpu cores' /proc/cpuinfo | uniq | awk -F: '{print $2}' | sed -e 's/^[ \t]*//' -e ':a;N;$!ba;s/\n/,/g')
cpu_cache=$(grep '^cache size' /proc/cpuinfo | uniq | awk -F: '{print $2}' | sed -e 's/^[ \t]*//' -e ':a;N;$!ba;s/\n/,/g')

# Get RAM info
ram_size=$(free -h | awk '/Mem: / {print $2}')
ram_used=$(free -h | awk '/Mem: / {print $3}')
ram_available=$(free -h | awk '/Mem: / {print $7}')

# Get network configuration data
node_name=$(uname -n)
local_ip_address=$(ip -o -4 addr show | awk '{print $2 ": " $4}' | sed -n ':a;N;${s/\n/, /g;p};ba')
adapter_speed=$(ethtool eth0 2> /dev/null | grep 'Speed:' | awk -F: '{print $2}')
mac_address=$(ip link show | awk '/ether/ {print $2}')

# Get drive data
mount_point=$(df -h / | sed -n '2p' | awk '{print $6}')
partition_size=$(df -h / | sed -n '2p' | awk '{print $2}')
used_memory=$(df -h / | sed -n '2p' | awk '{print $3}')
free_memory=$(df -h / | sed -n '2p' | awk '{print $4}')

# Output all data
echo "os name              : ${os_name}"
echo "os version           : ${os_version}"
echo "kernel version       : ${kernel_version}"
echo "kernel architecture  : ${kernel_arch}"
echo "cpu model            : ${cpu_model}"
echo "cpu MHz              : ${cpu_frequency}"
echo "cpu cores            : ${cpu_cores}"
echo "cpu cache (per core) : ${cpu_cache}"
echo "ram size             : ${ram_size}"
echo "used ram             : ${ram_used}"
echo "free ram             : ${ram_available}"
echo "host name            : ${node_name}"
echo "local ip addresses   : ${local_ip_address}"
echo "mac                  : ${mac_address}"
echo "adapter speed        : ${adapter_speed/ }"
echo "system mount point   : ${mount_point}"
echo "partition size       : ${partition_size}"
echo "memory used          : ${used_memory}"
echo "free memory          : ${free_memory}"
