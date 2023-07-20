#!/bin/bash
#####################################################
# script for spliting the magnitude images from the 4DFlow MRI Images. 
# @copyright: Rahul Kumar (RK): CICbiomaGUNE,MF&B
# 

# Script working for FSL6.0.1
##################################################

# Find filename
NIFTIFILE=$(ls *nii.gz)
echo "File $NIFTIFILE found"

# remove the left part selecting phase
fslroi $NIFTIFILE phase_$NIFTIFILE 0 120 0 128 0 128 0 20

# Correct pixel size 
fslchpixdim phase_$NIFTIFILE 2.5 2.5 2.5  0

# Perform maximum intensity projection (4DFlow-MRI are multicomponent images.)
# Extract the max intensity of the pixels from the magnitude image and write it to .txt file
fslstats $NIFTIFILE -R | awk '{print $2}' > max_intensity_$NIFTIFILE.txt
# fslmaths phase_$NIFTIFILE -max max_$NIFTIFILE
# fslmaths $NIFTIFILE.nii.gz -thr 2678.876709 -bin mip.nii.gz


# Merge the slices along one component and then take the maximum
fslmerge -t merged_$NIFTIFILE phase_$NIFTIFILE
fslmaths merged_$NIFTIFILE -Tmax mip_$NIFTIFILE

####################################################
echo " "
echo "phase file :  phase_$NIFTIFILE"
echo " "
echo "merged file :" merged_$NIFTIFILE.nii.gz
echo " "
echo "max file :" mip_$NIFTIFILE.nii.gz
echo " "
echo "NORMAL TERMINATION -> Great"
echo " "
