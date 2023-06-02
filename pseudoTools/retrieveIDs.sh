#!/bin/bash

# Array of patient IDs
patient_ids=(
1010500001503372
1010500001098203
1010500001511777
# add all the other Patient IDs here
)

# Loop over each Patient ID
for patient_id in "${patient_ids[@]}"
do
    # Create a query file for this Patient ID
    echo "(0008,0052) CS [STUDY]" > query.dcm
    echo "(0010,0020) LO [$patient_id]" >> query.dcm
    echo "(0020,000D) UI []" >> query.dcm

    # Query the PACS for the Study Instance UID
    study_uid=$(findscu -k @query.dcm -aec AE_TITLE -aet TS_retriever -s 10.156.160.10 11112 | grep "(0020,000D)" | cut -d "[" -f 2 | cut -d "]" -f 1)

    # If the study UID was found, retrieve the study
    if [ -n "$study_uid" ]; then
        echo "(0008,0052) CS [STUDY]" > retrieve.dcm
        echo "(0020,000D) UI [$study_uid]" >> retrieve.dcm
        movescu -k @retrieve.dcm -aec AE_TITLE -aet YOUR_AE_TITLE -s 10.156.160.10 11112 -od retrievedFiles
    fi
done
