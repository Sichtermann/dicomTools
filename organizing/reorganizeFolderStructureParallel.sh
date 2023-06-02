#!/bin/bash

process_file() {
  file=$1
  dest_dir=$2

  # Check if the file is a DICOM file using the DICM magic code
  if [ "$(head -c 132 "$file" | tail -c 4)" == "DICM" ]; then
    # Extract the necessary metadata from the DICOM file
    study_date=$(dcmdump "$file" 2>/dev/null | grep "StudyDate" | cut -d "[" -f2 | cut -d "]" -f1)
    modality=$(dcmdump "$file" 2>/dev/null | grep "Modality" | cut -d "[" -f2 | cut -d "]" -f1)
    series_uid=$(dcmdump "$file" 2>/dev/null | grep "SeriesInstanceUID" | cut -d "[" -f2 | cut -d "]" -f1)

    # Create a new folder structure based on the extracted metadata
    new_folder="$dest_dir/$study_date/$modality/$series_uid"

    # Create the new folder if it doesn't exist and move the DICOM file into it
    mkdir -p "$new_folder"
    mv "$file" "$new_folder/"
    echo "Moved $file to $new_folder/"
  fi
}

export -f process_file

# Prompt for source and destination directories
read -p "Enter the path to the source directory containing DICOM files: " src_dir
read -p "Enter the path to the destination directory for the new folder structure: " dest_dir

# Check if the source directory exists
if [ ! -d "$src_dir" ]; then
  echo "Error: Source directory does not exist."
  exit 1
fi

# Create the destination directory if it doesn't exist
mkdir -p "$dest_dir"

# Determine the number of available CPU cores
num_cores=$(nproc)

# Find all files in the source directory and process them in parallel
find "$src_dir" -type f | xargs -I {} -P $num_cores bash -c 'process_file "$@"' _ {} "$dest_dir"

echo "DICOM files have been reorganized."
