Project 
====================
Title: "ReadMe for TidyData Project"
------------------

The purpose of this project is to demonstrate the ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. 

The output was to create a R script called run_analysis.R that does the following:

1.Merges the training and the test sets to create one data set.

2.Extracts only the measurements on the mean and standard deviation for each measurement. 

3.Uses descriptive activity names to name the activities in the data set.

4.Appropriately labels the data set with descriptive variable names. 

5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


## Data

The data for the project was collected from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip and unzipped in a folder called Project. The training data is in the /Project/Train folder and the test data is in /Project/Test data. 

- subject*.txt has the volunteer ids
- x*.txt has the various measurements
- y*.txt has the activities 

## The following script demonstrates loading and merging of the test and training data set


```{r}
#load the training and test data set
trainingsubjects<-read.table("./train/subject_train.txt")
trainingdataset<-read.table("./train/X_train.txt")
trainingactivities<-read.table("./train/y_train.txt")

testsubjects<-read.table("./test/subject_test.txt")
testdataset<-read.table("./test/X_test.txt")
testactivities<-read.table("./test/y_test.txt")

mergeddataset<-rbind(trainingdataset,testdataset)
mergedsubjects<-rbind(trainingsubjects,testsubjects)
mergedactivities<-rbind(trainingactivities,testactivities)

```

The data as is does not have headers and hence assigned V+colnumber as the default headers. The file features.txt has the corresponding attribute names. 

## The following script assigns the labels from the features.txt

```{r}
#4Appropriately labels the data set with descriptive variable names. 
features<-read.table("features.txt",as.is = TRUE)#colnames
mergeddataset<-setnames(mergeddataset,old=names(mergeddataset),new=features$V2)
mergedsubjects<-rename(mergedsubjects,c("V1"="volunteerID"))
mergedactivities<-rename(mergedactivities,c("V1"="activity"))
```

The activity information is currently coded as integer. 

## The following script replaces the integer with descriptive activity name

```{r}
activities<-read.table("activity_labels.txt", colClasses="character")
mergedactivities$activity<-unlist(lapply(mergedactivities$activity,function(x){activities[activities$V1==x,]$V2})) 
```

At this time we are only interested in only the measurments with means and standard deviation.

## The following script collects the data in the datasetofinterest data set

```{r}
mergedset<-cbind(mergedsubjects,mergedactivities,mergeddataset)
datasetofinterest<-mergedset[,grep("mean|std|volunteer|activity",names(mergedset))]
```

Finally we are interested in an independent tidy data set with the average of each variable for each activity and each subject.

## The following script demonstrates the final step

```{r}
meltdata<-melt(datasetofinterest,id=c("volunteerID","activity"))
tidydata<-dcast(meltdata,volunteerID + activity ~ variable,mean)
write.table(tidydata,"tidy.txt",row.name=FALSE)
```
