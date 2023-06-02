#!/bin/bash

# An associative array to store unique patient IDs
declare -A patient_ids

# Loop over all DICOM files in the current directory and its subdirectories
while IFS= read -r -d '' dicom_file
do
    # Use dcmdump to get the Patient ID (tag 0010,0020)
    patient_id=$(dcmdump "$dicom_file" | grep "(0010,0020)" | cut -d "[" -f 2 | cut -d "]" -f 1)

    # If this patient ID has not been seen before, print it and add it to the array
    if [ -z "${patient_ids[$patient_id]}" ]; then
        echo ""
        patient_ids[$patient_id]=1
    fi
done < <(find . -name "*.dcm" -print0)
