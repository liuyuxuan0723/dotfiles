#!/usr/bin/env bash

# Script to sync specified dot files and directories from home directory to current directory
# Skips directories larger than 2MB

# Create backup directory
BACKUP_DIR="dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# File size limit (bytes): 2MB = 2*1024*1024 = 2097152 bytes
SIZE_LIMIT=2097152

# Configuration: specify files or directories to sync from a file
INCLUDE_FILE=".sync"

# Read the include list from the file
if [[ -f "$INCLUDE_FILE" ]]; then
  mapfile -t INCLUDE_LIST < "$INCLUDE_FILE"
else
  echo "Error: Include file $INCLUDE_FILE not found."
  exit 1
fi

echo "Starting sync of dot files and directories..."

# Backup existing dot files and directories in current directory
echo "Backing up existing dot files and directories to $BACKUP_DIR..."
find . -maxdepth 1 -name ".*" | grep -v "^\.$" | xargs -I{} cp -rf {} "$BACKUP_DIR/" 2>/dev/null

# Function to check if item is in include list
in_include_list() {
  local item="$1"
  
  for include in "${INCLUDE_LIST[@]}"; do
    if [[ "$item" == "$include" ]]; then
      return 0
    fi
  done
  
  return 1
}

# Process each item in INCLUDE_LIST
for include in "${INCLUDE_LIST[@]}"; do
  item="$HOME/$include"
  
  # Check if item exists
  if [[ ! -e "$item" ]]; then
    echo "Warning: $item does not exist, skipping"
    continue
  fi
  
  # Check if item is a directory and its size
  if [[ -d "$item" ]]; then
    dir_size=$(du -sb "$item" | cut -f1)
    
    if [[ $dir_size -gt $SIZE_LIMIT ]]; then
      echo "Excluding: $include (directory size $(du -sh "$item" | cut -f1) exceeds 2MB limit)"
      continue
    fi
  fi
  
  # Execute copy
  echo "Syncing: $include"
  cp -rf "$item" .
done

echo "Sync completed!"
echo "To restore backup, use: cp -rf $BACKUP_DIR/* $BACKUP_DIR/.* ."