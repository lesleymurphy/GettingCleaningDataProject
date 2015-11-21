# GettingCleaningDataProject
Course project for the Coursera Course Getting and Cleaning Data

We were supplied with three separate training and test files; one that contained the subject information, one contained the activity information, and one contained data obtained from accelerometer and gyroscope in their cellphones.

We were tasked with combining all six files and creating a clean dataset that then only included data columns that had the mean or standard deviation of the particular measurements.

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones is the link to a description of the research project

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip is the link to the data used in this project

This repo included this README.md file, a codebook, and the R script to create the tidy dataset and a second dataset that gives the average for each data column grouped by the Subject and Activity.

The R script starts with loading packages and the files (train_x, train_y, train_sub, test_x, test_y, test_sub, and a file that gives the names for the activities). ID columns are added so that sorting and merging will be done properly.

Then the train and test files are merged and the columns of data that have mean or std (standard deviation) were selected.
The mean and standard deviation files are then merged.
The data column variable names are cumbersome and messy, so several lines clean those up.

The three files, data, y, and sub (renamed to values, activities, and subjects) are then brought together.

The numbers in the activities are converted to the activity names and the data.frame sorted by Subject and activity.

Lastly, all column names are set to lower case, per class instructions for tidy names.

A second code then takes the tidy data.frame, groups the data by Subject and Activity and returns the average of all the columns of variables, written into a table that is saved into the working directory.



