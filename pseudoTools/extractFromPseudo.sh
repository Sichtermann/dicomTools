#!/bin/bash

# Input and output files
input_file="input.txt"
output_file="output.txt"
output_anon_file="output_anon.txt"
map_file="map.csv"  # Define map.csv as a variable
json_file="opensearch_query.json"

# Clear the output files
> "$output_file"
> "$output_anon_file"

# Start the JSON file
echo '{
  "query": {
    "terms": {
      "00100020 PatientID_keyword": [' > "$json_file"

# Read each line from the input file
first_id=true
while IFS= read -r original_id
do
    echo "Processing Original Patient ID: $original_id"

    # Find the line in the CSV file
    line=$(grep "$original_id" $map_file)

    if [ -z "$line" ]; then
        echo "No match found in CSV for Original Patient ID: $original_id"
    else
        echo "Matched Line: $line"

        # Extract the trial Patient ID
        trial_id=$(echo $line | cut -d ',' -f 2 | tr -d '()="')

        echo "Extracted Trial Patient ID: $trial_id"

        # Write the original and trial Patient IDs to the output file
        echo "Original Patient ID: $original_id, Trial Patient ID: $trial_id" >> "$output_file"
        
        # Write only the trial Patient ID to the anonymous output file
        echo "$trial_id" >> "$output_anon_file"

        # Write the trial Patient ID to the JSON file
        if $first_id ; then
            echo "    \"$trial_id\"" >> "$json_file"
            first_id=false
        else
            echo "    ,\"$trial_id\"" >> "$json_file"
        fi
    fi
done < "$input_file"

# Finish the JSON file
echo '    ]
  }
}' >> "$json_file"
