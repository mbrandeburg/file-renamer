#!/bin/bash

# Check if the folder name is provided as a flag
if [ $# -eq 0 ]; then
  echo "Usage: $0 -f <folder_name>"
  exit 1
fi

# Initialize variables
folder_name=""
current_date=$(date +"%Y-%m-%d")

# Parse command line arguments
while getopts "f:" opt; do
  case "$opt" in
    f)
      folder_name="$OPTARG"
      ;;
    *)
      echo "Usage: $0 -f <folder_name>"
      exit 1
      ;;
  esac
done

# Check if the provided folder exists
if [ ! -d "$folder_name" ]; then
  echo "Folder '$folder_name' does not exist."
  exit 1
fi

# Function to get user confirmation
get_confirmation() {
  read -p "Do you want to rename this file and others in its directory? (y/n): " response
  case "$response" in
    [yY])
      return 0
      ;;
    *)
      exit 1
      ;;
  esac
}


# Iterate over files in the folder and rename them
for file in "$folder_name"/*; do
  if [ -f "$file" ]; then
    # Show the proposed new name to the user and get confirmation
    echo "Example file to be renamed: $file"
    get_confirmation
    break
  fi
done


# Iterate over files in the folder and rename them
for file in "$folder_name"/*; do
  if [ -f "$file" ]; then
    # Extract the file extension
    extension="${file##*.}"

    # Remove trailing whitespace from the filename
    filename=$(basename "$file" | sed -e 's/^[ \t]*//')

    # Rename the file with the date appended
    new_filename="${filename%.*}_${current_date}.${extension}"

    # # Show the proposed new name to the user and get confirmation
    # echo "Proposed new name: $new_filename"
    # get_confirmation
    # if [ $? -eq 0 ]; then

    # Perform the actual renaming
    mv "$file" "$folder_name/$new_filename"
    echo "Renamed: $file -> $new_filename"
    # fi
  fi
done

echo "File renaming complete."
