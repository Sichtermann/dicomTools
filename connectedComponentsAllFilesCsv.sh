#!/bin/bash

# threshold to define island
thresh=0.5

# result file
resultfile="results.csv"

# write header to the result file
echo "filename,num_components,num_components_gt1" > $resultfile

# loop over all files with the suffix _Segm.nii.gz in the current directory
for infile in *_Segm.nii.gz
do
  echo "Processing $infile"

  # output file
  outfile="${infile%.*}_clusters.nii.gz"

  # unique temporary file
  tmpfile=$(mktemp --suffix=".nii.gz")

  # threshold the image
  fslmaths $infile -thr $thresh $tmpfile

  # use cluster to identify islands, and save the output to a temporary file
  cluster_output=$(cluster -i $tmpfile -t 1 --oindex=$outfile)

  # clean up temporary file
  rm $tmpfile

  # count number of islands
  num_components=$(echo "$cluster_output" | awk 'NR>1' | wc -l)

  # count number of islands with a voxel size larger than 1
  num_components_gt1=$(echo "$cluster_output" | awk 'NR>1 && $2>1' | wc -l)

  # write results to the result file
  echo "$infile,$num_components,$num_components_gt1" >> $resultfile
done
