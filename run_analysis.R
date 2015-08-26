#Here are the data for the project:
#https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
#You should create one R script called run_analysis.R that does the following. 
#1) Merges the training and the test sets to create one data set.
#2) Extracts only the measurements on the mean and standard deviation for each measurement. 
#3) Uses descriptive activity names to name the activities in the data set
#4) Appropriately labels the data set with descriptive variable names. 
#5) Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

setwd("C:/Users/Pei-Chun/Documents/R/Course 3/course-project")

#download data
library(httr) 
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
file <- "instancia.zip"
download.file(url, file)

#unzip and create folders
rawdata <- "UCI HAR Dataset"
results <- "results"
print("unzip file")
unzip(file, list = FALSE, overwrite = TRUE) 
dir.create(results)


#getting feature names
wd<-getwd()
rawfolder<-paste(wd,rawdata,sep="/")
print("Getting feature names")
features <- read.table(paste(rawfolder,"features.txt",sep="/"),stringsAsFactors=F)

#getting train data
print("Getting train data")
    subject_train <- read.table(paste(rawfolder,"train/subject_train.txt",sep="/"),stringsAsFactors=F,col.name="id")
    y_train <- read.table(paste(rawfolder,"train/y_train.txt",sep="/"),stringsAsFactors=F,col.name="Activity")
    x_train <- read.table(paste(rawfolder,"train/X_train.txt",sep="/"),stringsAsFactors=F,col.name=features$V2)
    train <- cbind(subject_train,y_train,x_train)

#getting test data
print("Getting test data")
subject_test <- read.table(paste(rawfolder,"test/subject_test.txt",sep="/"),stringsAsFactors=F,col.name="id")
y_test <- read.table(paste(rawfolder,"test/y_test.txt",sep="/"),stringsAsFactors=F,col.name="Activity")
x_test <- read.table(paste(rawfolder,"test/X_test.txt",sep="/"),stringsAsFactors=F,col.name=features$V2)
test <- cbind(subject_test,y_test,x_test)

#save the resulting data in the indicated folder
saveresults <- function (data,name){
    print(paste("saving results", name))
    file <- paste(results, "/", name,".csv" ,sep="")
    write.csv(data,file)
}

### required activities ###

#1) Merges the training and the test sets to create one data set.
library(plyr)
data <- rbind(train, test)
data <- arrange(data, id)

#2) Extracts only the measurements on the mean and standard deviation for each measurement.
mean_and_std <- data[,c(1,2,grep("std", colnames(data)), grep("mean", colnames(data)))]
saveresults(mean_and_std,"mean_and_std")

#3) Uses descriptive activity names to name the activities in the data set
activity_labels <- read.table(paste(rawfolder,"activity_labels.txt",sep="/"),stringsAsFactors=F)
data$Activity <- factor(data$Activity, levels=activity_labels$V1, labels=activity_labels$V2)

#5) Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
tidy_dataset <- ddply(mean_and_std, .(id, Activity), colMeans)
colnames(tidy_dataset)[-c(1:2)] <- paste(colnames(tidy_dataset)[-c(1:2)], "_mean", sep="")
saveresults(tidy_dataset,"tidy_dataset")

#4) Appropriately labels the data set with descriptive variable names.
tidy_dataset$Activity <- as.character(tidy_dataset$Activity)
for (i in 1:6){
    tidy_dataset$Activity[tidy_dataset$Activity == i] <- as.character(activity_labels[i,2])}
