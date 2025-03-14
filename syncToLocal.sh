#!/usr/bin/env bash

# Change to the directory of the script
cd "$(dirname "${BASH_SOURCE}")";

# Pull the latest changes from the remote repository
# git pull origin main;

# Configuration: specify files or directories to sync from a file
INCLUDE_FILE=".sync"

# Read the include list from the file
if [[ -f "$INCLUDE_FILE" ]]; then
  mapfile -t INCLUDE_LIST < "$INCLUDE_FILE"
else
  echo "Error: Include file $INCLUDE_FILE not found."
  exit 1
fi

function doIt() {
    # Create backup directory with timestamp
    BACKUP_DIR=~/dotfiles_backup_$(date +%Y%m%d_%H%M%S)
    mkdir -p "$BACKUP_DIR"
    echo "Creating backup of current dot files to $BACKUP_DIR..."

    # Backup existing files before syncing
    for item in "${INCLUDE_LIST[@]}"; do
        if [[ -e ~/"$item" ]]; then
            # Create parent directories in backup if needed
            if [[ "$item" == *"/"* ]]; then
                parent_dir=$(echo "$item" | cut -d'/' -f1)
                mkdir -p "$BACKUP_DIR/$parent_dir"
            fi
            
            echo "Backing up: ~/$item"
            cp -rf ~/"$item" "$BACKUP_DIR/"
        fi
    done
    
    echo "Backup completed. Starting sync..."
    echo "Starting sync of specified files and directories to home directory..."

    # Process single-level files/directories
    for item in "${INCLUDE_LIST[@]}"; do
        # Check if path contains separator
        if [[ "$item" != *"/"* ]]; then
            if [[ -e "$item" ]]; then
                echo "Syncing: $item"
                rsync -avh --no-perms "$item" ~
            else
                echo "Warning: $item does not exist, skipping"
            fi
        fi
    done

    # Process nested paths (e.g., .config/nvim)
    for item in "${INCLUDE_LIST[@]}"; do
        if [[ "$item" == *"/"* ]]; then
            parent_dir=$(echo "$item" | cut -d'/' -f1)
            sub_path=$(echo "$item" | cut -d'/' -f2-)
            
            if [[ -e "$item" ]]; then
                # Ensure parent directory exists
                mkdir -p ~/"$parent_dir"
                
                echo "Syncing nested path: $item"
                rsync -avh --no-perms "$item" ~/"$parent_dir"
            else
                echo "Warning: $item does not exist, skipping"
            fi
        fi
    done

    # Reload bash or zsh configuration
    if [[ -f ~/.bash_profile ]]; then
        source ~/.bash_profile
    elif [[ -f ~/.bashrc ]]; then
        source ~/.bashrc
    elif [[ -f ~/.zshrc ]]; then
        source ~/.zshrc
    fi
    
    echo "Sync completed!"
    echo "If you need to restore the backup, use: cp -rf $BACKUP_DIR/* $BACKUP_DIR/.* ~/"
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
    doIt;
else
    read -p "This may overwrite existing files in your home directory. A backup will be created. Are you sure? (y/n) " -n 1;
    echo "";
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        doIt;
    fi;
fi;
unset doIt;