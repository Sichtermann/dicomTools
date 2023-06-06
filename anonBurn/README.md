# DICOM Text Removal Script

This Python script is used to remove all text from DICOM (.dcm) images. It reads DICOM files, identifies the text in the image using Tesseract OCR, and then effectively erases the text by painting over it. The sanitized image data is then stored back in the original DICOM format.

## Requirements

The script requires the following Python packages:

- pydicom
- PIL
- pytesseract
- cv2

Additionally, Tesseract OCR must be installed on your machine.

## Installation

1. **Install Tesseract OCR:**

    - **Ubuntu:**

        ```shell
        sudo apt update
        sudo apt install tesseract-ocr
        sudo apt install libtesseract-dev
        ```

    - **Windows:**

        Download the installer from the [GitHub releases](https://github.com/UB-Mannheim/tesseract/wiki).

2. **Install Required Python Packages:**

    Use pip to install the required Python packages.

    ```shell
    pip install pydicom
    pip install pillow
    pip install opencv-python-headless
    pip install pytesseract
    ```
    

    ```bash
    chmod +x anonBurn.py
    ```    

## Usage

    ```bash
    anonBurn.py path_to_your_folder --overwrite
    ```
    or
    ```bash
    anonBurn.py path_to_your_folder
    ```

    This will create a new DICOM file in the same location, with the same name as the original file but with a '_sanitized' suffix. The new file will be the same as the original, but with all text removed.

## Limitations

The DICOM image is converted to grayscale during the text removal process. There might be a loss in the pixel data during this conversion process. If the exact format needs to be preserved, more advanced image processing techniques might be needed to selectively remove the text while preserving the original pixel data.

Always ensure you are complying with all applicable legal and ethical guidelines when handling medical data.
