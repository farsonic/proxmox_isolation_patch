#!/bin/bash

#Install needed files 
apt-get update && apt-get install -y patch

# Backup the original files that we are patching. 
mkdir /root/patch-backup
cp /usr/share/pve-manager/js/pvemanagerlib.js /root/patch-backup/
cp /usr/share/perl5/PVE/Network/SDN/VnetPlugin.pm /root/patch-backup/
cp /usr/share/perl5/PVE/Network/SDN/Zones.pm /root/patch-backup/
cp /usr/share/perl5/PVE/Network.pm /root/patch-backup/

# Copy the patch files to the respective directories
curl -k https://raw.githubusercontent.com/farsonic/proxmox_isolation_patch/main/manager.patch -o /var/tmp/manager.patch
curl -k https://raw.githubusercontent.com/farsonic/proxmox_isolation_patch/main/network.patch -o /var/tmp/network.patch
curl -k https://raw.githubusercontent.com/farsonic/proxmox_isolation_patch/main/zones.patch -o /var/tmp/zones.patch
curl -k https://raw.githubusercontent.com/farsonic/proxmox_isolation_patch/main/common.patch -o /var/tmp/common.patch

patch -p1 /usr/share/pve-manager/js/pvemanagerlib.js /var/tmp/manager.patch
patch -p1 /usr/share/perl5/PVE/Network/SDN/VnetPlugin.pm /var/tmp/network.patch
patch -p1 /usr/share/perl5/PVE/Network/SDN/Zones.pm /var/tmp/zones.patch
patch -p1 /usr/share/perl5/PVE/Network.pm /var/tmp/common.patch

echo "Script execution completed."
