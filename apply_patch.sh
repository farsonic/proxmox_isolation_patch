#!/bin/bash

#Install needed files 
apt-get update && apt-get install -y patch

# Backup the original files that we are patching. 
mkdir /root/patch-backup
cp /usr/share/pve-manager/js/pvemanagerlib.js /root/patch-backup/
cp /usr/share/perl5/PVE/Network/SDN/VnetPlugin.pm /root/patch-backup/
cp /usr/share/perl5/PVE/Network/SDN/Zones/Plugin.pm /root/patch-backup/
cp /usr/share/perl5/PVE/Network.pm /root/patch-backup/

# Copy the patch files to the respective directories
curl -k https://raw.githubusercontent.com/farsonic/proxmox_isolation_patch/main/pvemanagerlib.patch -o /var/tmp/pvemanagerlib.patch
curl -k https://raw.githubusercontent.com/farsonic/proxmox_isolation_patch/main/VnetPlugin.patch -o /var/tmp/VnetPlugin.patch
curl -k https://raw.githubusercontent.com/farsonic/proxmox_isolation_patch/main/Plugin.patch -o /var/tmp/Plugin.patch
curl -k https://raw.githubusercontent.com/farsonic/proxmox_isolation_patch/main/Network.patch -o /var/tmp/Network.patch

#Patch each file
patch -p1 /usr/share/pve-manager/js/pvemanagerlib.js /var/tmp/pvemanagerlib.patch
patch -p1 /usr/share/perl5/PVE/Network/SDN/VnetPlugin.pm /var/tmp/VnetPlugin.patch
patch -p1 /usr/share/perl5/PVE/Network/SDN/Zones/Plugin.pm /var/tmp/Plugin.patch
patch -p1 /usr/share/perl5/PVE/Network.pm /var/tmp/Network.patch

echo "Script execution completed."


#cp /root/patch-backup/pvemanagerlib.js /usr/share/pve-manager/js/
#cp /root/patch-backup/VnetPlugin.pm /usr/share/perl5/PVE/Network/SDN/
#cp /root/patch-backup/Zones.pm /usr/share/perl5/PVE/Network/SDN/
#cp /root/patch-backup/Network.pm /usr/share/perl5/PVE/
