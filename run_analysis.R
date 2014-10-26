rm()
setwd("C:/Users/Megha/Desktop/Yogesh/Courses/Getting and Cleaning Data/Project")
library(data.table)
library(plyr)
library(reshape2) 

#load the training and test data set
trainingsubjects<-read.table("./train/subject_train.txt")
trainingdataset<-read.table("./train/X_train.txt")
trainingactivities<-read.table("./train/y_train.txt")

testsubjects<-read.table("./test/subject_test.txt")
testdataset<-read.table("./test/X_test.txt")
testactivities<-read.table("./test/y_test.txt")

#1 Merges the training and the test sets to create one data set.
mergeddataset<-rbind(trainingdataset,testdataset)
mergedsubjects<-rbind(trainingsubjects,testsubjects)
mergedactivities<-rbind(trainingactivities,testactivities)


#4Appropriately labels the data set with descriptive variable names. 
features<-read.table("features.txt",as.is = TRUE)#colnames
mergeddataset<-setnames(mergeddataset,old=names(mergeddataset),new=features$V2)
mergedsubjects<-rename(mergedsubjects,c("V1"="volunteerID"))
mergedactivities<-rename(mergedactivities,c("V1"="activity"))

#3 Uses descriptive activity names to name the activities in the data set
#activities<-read.table("activity_labels.txt",as.is = TRUE)
activities<-read.table("activity_labels.txt", colClasses="character")
#activities<-read.table("activity_labels.txt")
mergedactivities$activity<-unlist(lapply(mergedactivities$activity,function(x){activities[activities$V1==x,]$V2})) 

#combine the subject,activity,and measurements data 
mergedset<-cbind(mergedsubjects,mergedactivities,mergeddataset)

#2 Extracts only the measurements on the mean and standard deviation for each measurement. 
datasetofinterest<-mergedset[,grep("mean|std|volunteer|activity",names(mergedset))]

#DT<-data.table(datasetofinterest)
#meltdata<-melt(DT,id=c("volunteerID","activity"))

meltdata<-melt(datasetofinterest,id=c("volunteerID","activity"))
tidydata<-dcast(meltdata,volunteerID + activity ~ variable,mean)
write.table(tidydata,"tidy.txt",row.name=FALSE)

