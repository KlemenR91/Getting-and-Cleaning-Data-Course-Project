##Libraries
library(dplyr)
#Create directory for data if data directory doesn't exists
if(!file.exists("./data")){
    dir.create("./data")    
}


##DOWNLOAD DATA
#Download and unzip file. Remove zip file
setwd("./data")
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,destfile="./data.zip")
unzip(zipfile="data.zip")
file.remove("data.zip")


##READ DATA
#Read train data
x_train <- data.frame(read.table("./UCI HAR Dataset/train/X_train.txt"))
y_train <- data.frame(read.table("./UCI HAR Dataset/train/Y_train.txt"))
subject_train <- data.frame(read.table("./UCI HAR Dataset/train/subject_train.txt"))

#Read test data
x_test <- data.frame(read.table("./UCI HAR Dataset/test/X_test.txt"))
y_test <- data.frame(read.table("./UCI HAR Dataset/test/Y_test.txt"))
subject_test <- data.frame(read.table("./UCI HAR Dataset/test/subject_test.txt"))

# Read features and activity labels
features <- data.frame(read.table('./UCI HAR Dataset/features.txt'))

# Reading activity labels:
activity_Labels = data.frame(read.table('./UCI HAR Dataset/activity_labels.txt'))


#RENAMING DATA
#Renaming collumn names
names(x_train) <- features[,2]
names(x_test) <- features[,2]
names(y_train) <- "activityID"
names(y_test) <- "activityID"
names(subject_train) <- "subjectID"
names(subject_test) <- "subjectID"
names(activity_Labels) <- c("activityID", "activity") 


##MERGE DATA
#Merge train data
train_data <- cbind(y_train,subject_train,x_train)

#Merge test data
test_data <- cbind(y_test,subject_test,x_test)

#Merge test & train data
my_data <- rbind(train_data,test_data)

##GET MEAN AND STD DATA
#Search for collumn names that contains words mean
meanData <- grep("mean", names(my_data))

#Search for collumn names that contains words std
stdData <- grep("std", names(my_data))

#Merge mean and std rows
msCols <- sort(c(stdData,meanData))

#Get mean and std data
msData <- my_data[,c(1,2,msCols)]

#Clean names
names(msData) <- gsub("-"," ",names(msData))
names(msData) <- gsub("mean()", "Mean", names(msData))
names(msData) <- gsub("std()", "Std", names(msData))

#Add activity to msData
msDataActivity <-  merge(msData, activity_Labels, by='activityID', all.x=TRUE)


##CREATE SECOND TIDY SET
#calculate mean for subject and activity
tidySet2 <- aggregate(msData$subjectID + msData$activityID, msData, mean)

#Add activity to 
tidySet2 <- merge(tidySet2, activity_Labels, by='activityID', all.x=TRUE)

#Save second tidy set
write.table(tidySet2, "tidySet2.txt", row.name=FALSE)






