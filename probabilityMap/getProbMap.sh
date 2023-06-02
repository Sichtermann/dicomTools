#!/bin/bash

# Define directories and template
input_dir="mris"
segmentation_dir="segs"
output_transform_dir="_out"
template_image="mni/avg152T1.nii" # assuming this is the name and it's in your current directory

# Loop over all files in input_dir
for input_image in $input_dir/*.nii.gz
do
    # Remove directory and extension from filename
    base_name=$(basename $input_image .nii.gz)
    
    # Define output names
    output_transform_prefix="${output_transform_dir}/${base_name}_transform_"
    output_warped_image="${output_transform_dir}/${base_name}_warped.nii.gz"
    
    # Step 1: Co-register original MRI to MNI152 template and apply transformation
    antsRegistrationSyN.sh -d 3 -f $template_image -m $input_image -o $output_transform_prefix -t r
    antsApplyTransforms -d 3 -i $input_image -r $template_image -t ${output_transform_prefix}1Warp.nii.gz -o $output_warped_image
    
    # Step 2: Apply same transformation to aneurysm segmentation
    segmentation_image="${segmentation_dir}/${base_name}_segmentation.nii.gz"
    output_transformed_segmentation="${output_transform_dir}/${base_name}_transformed_segmentation.nii.gz"
    antsApplyTransforms -d 3 -i $segmentation_image -r $template_image -t ${output_transform_prefix}1Warp.nii.gz -o $output_transformed_segmentation
done

# Step 3: Create a probability map
output_probability_map="${output_transform_dir}/probability_map.nii.gz"
fslmaths $output_transform_dir/*_transformed_segmentation.nii.gz -Tmean $output_probability_map
