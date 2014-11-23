getdataCourseProject
====================

# Repository for Course Project for Coursera Getting and Cleaning Data class

The program run_Analysis.R reads in activity data from Samsung Galaxy S Smartphones.
This data was collected from several subjects that performed multiple activities
in controlled experiments. This program assumes that you have downloaded the data from:
http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.zip
and unzipped it into your working directory (or changed your working directory to where it
was unzipped).

The downloaded data has been previously split into a training set and a cross-validation
or test set. The first thing this program does is combine the two sets into one larger set.

The program then subsets columns based on their names. It picks out mean and standard
deviation calculations by finding columns names that contain "mean" or "std". It was a
concious choice to only subset the lowercase "mean" and "std" as these are direct calculations
on raw data, the "Mean" values appear to be calculations using these calculations.

Next the program cleans the column names, removing periods, spaces, parentheses and replacing 
dashes, commas with underscores.

This tidy dataset is then written to the file system.

Lastly the program finds the mean value of each feature on a per subject and per activity basis, and 
this summary dataset is written to the file system as well.
