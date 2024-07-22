#!/bin/bash

#Install needed files 
apt update
apt install patch 

# Backup the original files that we are patching. 
mkdir /root/patch-backup
cp /root/pve-manager/



# Directories where the patches will be copied
MANAGER_DIR="/usr/share/pve-manager/js/"
NETWORK_DIR="/usr/share/perl5/PVE/Network/SDN/"
ZONE_DIR="/usr/share/perl5/PVE/Network/SDN/"
COMMON_DIR="/usr/share/perl5/PVE/"

# Patch file names in the current directory
MANAGER_PATCH_FILE="manager.patch"
NETWORK_PATCH_FILE="network.patch"
ZONE_PATCH_FILE="zone.patch"
COMMON_PATCH_FILE="common.patch"

# Copy the patch files to the respective directories
curl -k https://raw.githubusercontent.com/farsonic/proxmox_isolation_patch/main/common.patch -o $COMMON_DIR
curl -k https://raw.githubusercontent.com/farsonic/proxmox_isolation_patch/main/network.patch -o $NETWORK_DIR
curl -k https://raw.githubusercontent.com/farsonic/proxmox_isolation_patch/main/manager.patch -o $MANAGER_DIR


# Function to prompt for confirmation
prompt_to_patch() {
    local PATCH_DIR=$1
    local PATCH_FILE=$2
    local PATCH_NAME=$3

    read -p "Do you want to apply the $PATCH_NAME patch? (y/n): " choice
    case "$choice" in
        y|Y )
            echo "Applying $PATCH_NAME patch..."
            (cd $PATCH_DIR && patch -p1 < $PATCH_FILE)
            if [ $? -eq 0 ]; then
                echo "$PATCH_NAME patch applied successfully."
            else
                echo "Failed to apply $PATCH_NAME patch."
            fi
            ;;
        n|N ) echo "Skipping $PATCH_NAME patch.";;
        * ) echo "Invalid choice. Skipping $PATCH_NAME patch.";;
    esac
}

# Prompt the user and apply the patches if confirmed
prompt_to_patch $MANAGER_DIR "manager.patch" "manager"
prompt_to_patch $NETWORK_DIR "network.patch" "network"
prompt_to_patch $COMMON_DIR "common.patch" "common"

echo "Script execution completed."
