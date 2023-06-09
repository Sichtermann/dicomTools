# Welcome to dicomTools!

Welcome to the dicomTools repository, a comprehensive toolkit for handling DICOM files. This repository provides a collection of shell scripts and other tools that can be used to perform various operations on DICOM files, such as counting islands, reorganizing folder structures, generating probability maps, and working with pseudo files.

## Directory Structure

This repository contains four main directories each with specific tools:

1. `countIslands`: This directory contains tools for counting islands in segmentation DICOM files. The scripts included are:
   - `connectedComponentsAllFilesCsv.sh`
   - `countIslandsAll_Fsl.sh`
   - `countIslandsLarger1_Fsl.sh`

2. `organizing`: This directory contains tools for organizing DICOM files and folders. The scripts included are:
   - `reorganizeFolderStructure.sh` - Reorganize DICOM files according to your needs in a folder structure dependent on DICOM meta data.
   - `reorganizeFolderStructureParallel.sh` - Parallelized for better speed (not tested).

3. `probabilityMap`: This directory contains tools for generating probability maps from DICOM files. The scripts included are:
   - `getProbMap.sh`

   This directory also includes a Dockerfile and docker-compose file for setting up a Docker environment to run these tools.

4. `pseudoTools`: This directory contains tools for working with pseudo DICOM files. The scripts and files included are:
   - `extractFromPseudo.sh` - Extract IDs from your pseudo-table. Pseudo table could come from CTP (https://mircwiki.rsna.org/index.php?title=MIRC_CTP)
   - `listPIDs.sh` - List all Patient IDs from a folder with DICOM files.
   - `retrieveIDs.sh` - Retrieve DICOM data. (not tested)

## Getting Started

To start using these tools, clone this repository to your local machine, navigate to the desired directory, and run the respective shell scripts according to your needs. Make sure to have the necessary software and dependencies installed for each tool.

## Contributing

Contributions are welcome! If you have improvements to these tools or additional tools to add, feel free to open a pull request or issue.

## License

This project is open source and available under [INSERT LICENSE HERE].

## Contact

If you have any questions or comments, please feel free to reach out to me.
