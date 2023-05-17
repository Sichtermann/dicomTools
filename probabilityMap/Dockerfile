# Use a base image that includes FSL and ANTs
FROM nipreps/fmriprep:latest

# Maintainer
LABEL maintainer="YourName <youremail@address.com>"

# Update the system and install necessary libraries
RUN apt-get update && apt-get install -y \
    libsm6 \
    libxext6 \
    libxrender-dev

# Install the MNI152 template
RUN wget -P /opt https://fsl.fmrib.ox.ac.uk/fsldownloads/standard/MNI152_T1_2mm_brain.nii.gz

# Copy your script into the container
COPY getProbMap.sh /opt

# Make your script executable
RUN chmod +x /opt/getProbMap.sh

# Set working directory
WORKDIR /data