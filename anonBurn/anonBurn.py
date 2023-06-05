#!/usr/bin/env python3

import os
import pydicom
import numpy as np
from PIL import Image
import pytesseract
from pytesseract import Output
import cv2
import argparse

# Function to recursively search a directory for DICOM files
def find_dicom_files(directory, files=[]):
    for filename in os.listdir(directory):
        path = os.path.join(directory, filename)
        
        if os.path.isfile(path):
            try:
                pydicom.dcmread(path, stop_before_pixels=True)
                files.append(path)
            except:
                continue
        elif os.path.isdir(path):
            find_dicom_files(path, files)
    
    return files

def remove_text(directory, overwrite=False):
    # Find all DICOM files in the directory
    file_paths = find_dicom_files(directory)

    for file in file_paths:
        # Load the DICOM image
        ds = pydicom.dcmread(file)

        # Error handling for file reading
        if ds is None:
            print(f"Could not open the DICOM file: {file}")
            continue

        try:
            # Convert the DICOM image to a NumPy array
            arr = ds.pixel_array.astype('uint8')

            # Create a PIL image from the NumPy array
            img = Image.fromarray(arr)

            # Use pytesseract to get a data dict
            data = pytesseract.image_to_data(img, output_type=Output.DICT)

            # Create an image copy to draw over
            img_cv = cv2.cvtColor(np.array(img), cv2.COLOR_RGB2BGR)

            n_boxes = len(data['level'])
            for i in range(n_boxes):
                # Each 'word' in the OCR output will have a box drawn around it
                (x, y, w, h) = (data['left'][i], data['top'][i], data['width'][i], data['height'][i])

                # Draw the boxes on the image. This will effectively 'erase' the text by
                # replacing it with a constant color (in this case, white)
                cv2.rectangle(img_cv, (x, y), (x + w, y + h), (255, 255, 255), -1)

            # Convert the image back to grayscale
            img_cv_gray = cv2.cvtColor(img_cv, cv2.COLOR_BGR2GRAY)

            # Convert the NumPy array back to a PIL image
            img_erased = Image.fromarray(img_cv_gray)

            # Store the pixel data in the original DICOM file
            ds.PixelData = img_erased.tobytes()

            # Save the DICOM file with a suffix, or overwrite the original file
            if overwrite:
                ds.save_as(file)
            else:
                sanitized_file = file if file.endswith('.dcm') else f"{file}.dcm"
                ds.save_as(sanitized_file.replace('.dcm', '_sanitized.dcm'))

        except Exception as e:
            print(f"An error occurred: {str(e)}")

def main():
    # Create a command-line argument parser
    parser = argparse.ArgumentParser(description="Remove text from DICOM images in a directory")
    parser.add_argument("directory", nargs='?', default='.', help="Path to the directory containing DICOM files")
    parser.add_argument("--overwrite", action='store_true', help="Overwrite the original DICOM files")

    # Parse the command-line arguments
    args = parser.parse_args()

    # Call the function
    remove_text(args.directory, overwrite=args.overwrite)

if __name__ == "__main__":
    main()
