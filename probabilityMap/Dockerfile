# Use a base image that includes FSL and ANTs
FROM nipreps/fmriprep:latest

# Maintainer
LABEL maintainer="YourName <youremail@address.com>"

# Update the system and install necessary libraries
RUN apt-get update && apt-get install -y \
    libsm6 \
    libxext6 \
    libxrender-dev

# Copy your MNI template and script into the container
COPY data/mni/avg152T1.nii /opt/MNI152_T1_2mm.nii.gz
COPY your_script.sh /opt

# Make your script executable
RUN chmod +x /opt/your_script.sh

# Set working directory
WORKDIR /data
