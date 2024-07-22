#!/bin/bash

# Directories where the patches will be copied
MANAGER_DIR="/root/pve-manager"
NETWORK_DIR="/root/pve-network"
COMMON_DIR="/root/pve-common"

# Patch file names in the current directory
MANAGER_PATCH_FILE="manager.patch"
NETWORK_PATCH_FILE="network.patch"
COMMON_PATCH_FILE="common.patch"

# Create directories if they do not exist
mkdir -p $MANAGER_DIR
mkdir -p $NETWORK_DIR
mkdir -p $COMMON_DIR

# Copy the patch files to the respective directories
cp $MANAGER_PATCH_FILE $MANAGER_DIR/
cp $NETWORK_PATCH_FILE $NETWORK_DIR/
cp $COMMON_PATCH_FILE $COMMON_DIR/

# Function to prompt for confirmation
prompt_to_patch() {
    local PATCH_DIR=$1
    local PATCH_FILE=$2
    local PATCH_NAME=$3

    read -p "Do you want to apply the $PATCH_NAME patch? (y/n): " choice
    case "$choice" in
        y|Y )
            echo "Applying $PATCH_NAME patch..."
            if patch -p1 -d $PATCH_DIR < $PATCH_DIR/$PATCH_FILE; then
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
