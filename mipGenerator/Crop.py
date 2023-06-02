# -*- coding: utf-8 -*-
"""
Created on Thu Jul 23 16:32:18 2020

@author: Sichtermann
"""
from __future__ import print_function
import cv2
import glob, os
# import numpy as np
# import argparse
# import random as rng


os.chdir(r"G:\Datasets\022_DeepAn\cropped_PNG\MIPs_pos_segm") # which folder?
os.makedirs(".\MIPs_cropped", exist_ok=True)
  
        
def crop_by_value(file):
    img = cv2.imread(file)
    width, height = img.shape[:2]
    print(file, width, height)

    y1=0
    y2=height
    x1=4
    x2=width-2


    crop_img = img[y1:y2, x1:x2]
    result=cv2.imwrite(r".\MIPs_cropped\%s_cropped.png"% file, crop_img)
    if result==True:
      print("Fixed cropping succesful")
    else:
      print("Fixed cropping not succesful")
    return crop_img
    

def crop_black(img_croppedByValue, filename):
    
    gray = cv2.cvtColor(img_croppedByValue,cv2.COLOR_BGR2GRAY)
    _,thresh = cv2.threshold(gray,1,255,cv2.THRESH_BINARY)
    
    contours,hierarchy = cv2.findContours(thresh,cv2.RETR_EXTERNAL,cv2.CHAIN_APPROX_SIMPLE)
    cnt = contours[0]
    x,y,w,h = cv2.boundingRect(cnt)
    crop_img = img_croppedByValue[y:y+h,x:x+w]
    result=cv2.imwrite(r".\MIPs_cropped\%s_cropped_woBlack.png"% filename,crop_img)
    if result==True:
      print("File saved successfully")
    else:
      print("Error in saving file")
  
def getBoundingBox(file):
    img = cv2.imread(file)
    img_gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    contours, hierarchy = cv2.findContours(img_gray, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)         
        # Approximate contours to polygons + get bounding rects and circles
    contours_poly = [None]*len(contours)
    boundRect = [None]*len(contours)
    boundRectYolo = [None]*len(contours)
    #center = [None]*len(contours)
    #radius = [None]*len(contours)
    for i, c in enumerate(contours):
        contours_poly[i] = cv2.approxPolyDP(c, 3, True)
        boundRect[i] = cv2.boundingRect(contours_poly[i])
        #centers[i], radius[i] = cv2.minEnclosingCircle(contours_poly[i]) # this would be if we want to have a circle  
        boundRectYolo[i]=reformatBoundRect(boundRect[i])    
        print ('original', boundRect[i])
        print ('reformatted', boundRectYolo[i])
        BoundingBoxTxt(file, boundRectYolo[i], '0')
        
    return boundRectYolo


def BoundingBoxTxt(file_name, BoundBoxYolo, classNumber):
    os.makedirs(".\BoundingBoxes", exist_ok=True)
    fileWoExt = os.path.splitext(os.path.basename(file_name))[0]
    # Open the file in append & read mode ('a+')
    fullName = ".\\BoundingBoxes\\" + fileWoExt + ".txt"
    with open(fullName, "a+") as file_object:
        # Move read cursor to the start of file.
        file_object.seek(0)
        # If file is not empty then append '\n'
        data = file_object.read(100)
        if len(data) > 0:
            file_object.write("\n")
        #Tuple to string
        #BoundBoxYoloStr = ' '.join(BoundBoxYolo)
        #print (BoundBoxYoloStr)
        # Append text at the end of file        
        file_object.write(classNumber + " " + str(BoundBoxYolo [0]) + " " + str(BoundBoxYolo [1]) + " " + str(BoundBoxYolo [2]) + " " + str(BoundBoxYolo [3]))
    
def reformatBoundRect(boundRect): #reformat for Yolo
    #get outward borders of rectangle
    x1 = boundRect[0]
    y1 = boundRect[1]
    width = boundRect[2]
    height = boundRect[3] 
    x2 = x1+width
    y2 = y1+height
    #get center of rectangle
    xCenter = (x1+x2)/2
    yCenter = (y1+y2)/2

    boundRectYolo= (round(xCenter), round(yCenter), width+1, height+1)
    return boundRectYolo
    

def greyToBW(file):
    im_gray = cv2.imread(file, cv2.IMREAD_GRAYSCALE)
    thresh = 1
    im_bw = cv2.threshold(im_gray, thresh, 255, cv2.THRESH_BINARY)[1]
    cv2.imwrite(('..\\MIPs_pos_segm_bw\\' + file), im_bw)
    
def colorToGrey(file):
    color = cv2.imread(file)
    grey = cv2.cvtColor(color, cv2.COLOR_BGR2GRAY)
    cv2.imwrite(('..\\MIPs_pos_segm_grey\\' + file), grey)
    

## Run cropping
#for file in glob.glob("*.pgm"):
    #cropped = img_croppedByValue=crop_by_value(file)
    #crop_black(img_croppedByValue, file)
    
## Run Boundig Box generation of mask    
# for file in glob.glob("*.png"):
#     BoundBox=getBoundingBox(file)
    
# ## Grey to BW
# for file in glob.glob("*.png"):
#     greyToBW(file)
    
## Color to Grey
for file in glob.glob("*.png"):
    colorToGrey(file)
    
    
#BoundBox=getBoundingBox(r"G:\Datasets\022_DeepAn\Datastore_segmentationProblem\MIPs_segm\result_A_003_segmented_120.pgm_cropped.png")