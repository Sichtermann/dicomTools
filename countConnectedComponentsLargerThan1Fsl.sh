#!/bin/bash

# input file
infile=$1

# threshold to define island
thresh=0.5

# output file
outfile="clusters.nii.gz"

# temporary file
tmpfile="tmp.nii.gz"

# threshold the image
fslmaths $infile -thr $thresh $tmpfile

# use cluster to identify islands, and save the output to a temporary file
cluster_output=$(cluster -i $tmpfile -t 1 --oindex=$outfile)

# print full output from cluster
echo "$cluster_output"

# clean up temporary file
rm $tmpfile

# count number of islands with a voxel size larger than 1
num_islands=$(echo "$cluster_output" | awk 'NR>1 && $2>1' | wc -l)
echo "Number of islands with a voxel size larger than 1: $num_islands"

