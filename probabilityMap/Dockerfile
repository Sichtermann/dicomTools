# Use a base image of Ubuntu
FROM ubuntu:20.04

# Maintainer
LABEL maintainer="YourName <youremail@address.com>"

# Avoid timezone interactive dialog during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update the system and install necessary libraries
RUN apt-get update && apt-get install -y \
    wget \
    libsm6 \
    libxext6 \
    libxrender-dev

# Install FSL
RUN wget -O- https://fsl.fmrib.ox.ac.uk/fsldownloads/fslinstaller.py | python

# Install ANTs
RUN apt-get install -y ants

# Copy your MNI template and script into the container
COPY data/mni/avg152T1.nii /opt/MNI152_T1_2mm.nii.gz
COPY getProbMap.sh /opt

# Make your script executable
RUN chmod +x /opt/getProbMap.sh

# Set working directory
WORKDIR /data
