####Getting and Cleaning Data Course Project####
##Lesley Murphy November 2015##

#####################################################
##Must produce a tidy data set with a GitHub repository with script, codebook, and a README.md explaining how it all fits together
##
##Script must be called "run_analysis.R"
##
##Process:
##1) Merge two sets of data: train and test
##
##Each set has y- and x- and subject-; these files have the activities, data values, and the subject index, respectively
##x- file has 561 values per row, which are defined by the 'features' file.
##
##Activity labels for the y- files are in the main folder in "activity_labels"

##set working directory
setwd("./UCI HAR Datset")
      
##load all required libraries/ dplyr must be loaded after plyr to avoid interactions between packages
library(plyr);library(dplyr)
library(tidyr)
library(data.table)

##Read in all necessary files and add column names##
features<-read.delim("./features.txt", header=FALSE, sep = ".")
tidy.name.vector <- make.names(features[,1], unique=TRUE)

train_x<-read.delim("./train/X_train.txt", header=FALSE, sep = "")
colnames(train_x)<- tidy.name.vector

train_y<-read.table("./train/Y_train.txt", header=FALSE)
colnames(train_y)<- "Activity"

train_sub<-read.table("./train/subject_train.txt", header=FALSE)
colnames(train_sub)<-"Subject"

##Add ID column to all three datasets so that merging will be clean
train_x2<-mutate(train_x, ID=c(1:7352))
train_y2<-mutate(train_y, ID=c(1:7352))
train_sub2<-mutate(train_sub, ID=c(1:7352))

##Repeat steps on the test set###
##Load data
test_x<-read.delim("./test/X_test.txt", header=FALSE, sep = "")
colnames(test_x)<-tidy.name.vector

test_y<-read.table("./test/Y_test.txt", header=FALSE)
colnames(test_y)<-"Activity"

test_sub<-read.table("./test/subject_test.txt", header=FALSE)
colnames(test_sub)<-"Subject"

##Add ID column to all three datasets
test_x2<-mutate(test_x, ID=c(7353:10299))
test_y2<-mutate(test_y, ID=c(7353:10299))
test_sub2<-mutate(test_sub, ID=c(7353:10299))

##merge training with test
values<-merge(train_x2, test_x2, all=TRUE)
values<-arrange(values, ID)

activities<-merge(train_y2, test_y2, all=TRUE)
activities<-arrange(activities, ID)

subjects<-merge(train_sub2, test_sub2, all=TRUE)
subjects<-arrange(subjects, ID)

##Select only the columns of data that we want, specifically the mean and std columns
data_mean<-select(values, contains("mean"))
data_std<-select(values, contains ("std"))

##Add ID column into data_mean and data_std as those were not selected
data_mean2<-mutate(data_mean, ID=c(1:10299))
data_std2<-mutate(data_std, ID=c(1:10299))

##merge the three datasets,  using ID to keep them in order, then remove so it does not appear in final dataset
data<-merge(data_mean2, data_std2, by="ID")

##Pause to clean up the column names of the many values
names(data)<-gsub("[[:digit:]]", "", names(data))
names(data)<-sub("X.", "", names(data))
names(data)<-sub("mean..", "mean", names(data))
names(data)<-sub("std..", "std", names(data))
names(data)<-sub("meaneq..", "meaneq", names(data))

labels<-merge(subjects, activities, by = "ID")
df<-merge(labels, data, by = "ID")
df<-select(df, -(ID))

###Replace Activity numbers with activity names
df$Activity[df$Activity == 1] <- "Walking"
df$Activity[df$Activity == 2] <- "Walking_Upstairs"
df$Activity[df$Activity == 3] <- "Walking_Downstairs"
df$Activity[df$Activity == 4] <- "Sitting"
df$Activity[df$Activity == 5] <- "Standing"
df$Activity[df$Activity == 6] <- "Laying"

#Sort df by Subject and Activity to have a tidy dataset

df<-arrange(df, Subject, Activity)

##Now we have tidy dataset

######################################################################################
##Create "second, independent tidy data set with the average of each variable for each activity and each subject"##
##So need to group by Subject and Activity and find average for each variable

second<- group_by(df, Subject, Activity) %>%
        summarise_each(funs(mean))

write.table(second, file = "CleaningData.txt", row.names=FALSE)
#####################################################################################################
