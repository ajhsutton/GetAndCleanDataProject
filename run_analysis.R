# Coursera: Getting and Cleaning Data
# Course Project:
# Requirements: 
#      You should create one R script called run_analysis.R that does the following.
#      - Merges the training and the test sets to create one data set.
#      - Extracts only the measurements on the mean and standard deviation for each measurement. 
#      - Uses descriptive activity names to name the activities in the data set
#      - Appropriately labels the data set with descriptive variable names. 
#      - Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
# ------------------------------------------------------------------------------
#1. Merges the training and the test sets to create one data set.
# The folliwng code performs the following operations:
#  - Generate Activity & Feature labels from supplied files
#  - Get the Test and Train data
#      - Merge the Activity, Subject and Test/Train data 

# Open the data set from the working directory  
dir_name <- "UCI HAR Dataset"

# -----------------
# Get Labels
# Get Activity Labels
activityFile <- paste(dir_name,"activity_labels.txt",sep="/");
activityIndex <- read.table(activityFile, 
                            col.names = c("Activity","ActivityLabel"),
                            colClasses = c("factor","character"))  

# Get Features Labels
featureLabelFile <- paste(dir_name,"features.txt",sep="/");
featureIndex <- read.table(featureLabelFile, 
                           col.names = c("Feature","FeatureLabel"),
                           colClasses = c("factor","character"))  
# -----------------
# Get Test data Set
testDir <-paste(dir_name,"test",sep="/") 
# Test Data
testFile <- paste(testDir,"X_test.txt",sep="/")
# Use the list of features extracted from "features.txt" as Col Names
testData <- read.table(testFile,
                       colClasses = "numeric")
# Activity Data
testActivityFile <- paste(testDir,"y_test.txt",sep="/")
testActivityData <- read.table(testActivityFile,
                               col.names = "Activity",
                               colClasses = "integer")
# Subject Data
testSubjectFile <- paste(testDir,"subject_test.txt",sep="/")
testSubjectData <- read.table(testSubjectFile,
                              col.names = "Subject",
                              colClasses = "integer")
# Form a single data set by clipping Activity, Subject and Data
testDataSet <- cbind(testActivityData,testSubjectData,testData)

# -----------------
# Get Train data Set
trainDir <-paste(dir_name,"train",sep="/") 
# Get the Subject, Activity and Data
# Train Data
trainFile <- paste(trainDir,"X_train.txt",sep="/")
trainData <- read.table(trainFile)
# Activity Data
trainActivityFile <- paste(trainDir,"y_train.txt",sep="/")
trainActivityData <- read.table(trainActivityFile)
# Subject Data
trainSubjectFile <- paste(trainDir,"subject_train.txt",sep="/")
trainSubjectData <- read.table(trainSubjectFile)

# Form a single data set with Activity, Subject and Train Data
trainDataSet <- cbind(trainActivityData,trainSubjectData,trainData)

# # -----------------
# # Merge Test and Train Data Sets
mergedDataSet <- testDataSet

# ------------------------------------------------------------------------------
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
#    - Measurements on mean will contain string "-mean()"
#    - Measurements on standard deviation will contain string "-std()"
# Search the Feature labels for "-mean()" & "-std()" using regex
featureColNums <- grep("\\.*-(mean|std){1}\\(\\)",featureIndex[,2])
# Include added 'Default columns' for Activity, Acvitiy Label & Subject
numDefaultCols <- 3
defColsNums <- 1:numDefaultCols
# Select columns
extractedcolNums <-c(defColsNums,featureColNums + numDefaultCols)
extractedData <- mergedDataSet[,extractedcolNums]
extractedFeatureLabels <- featureIndex[featureColNums,2]

# ------------------------------------------------------------------------------
# 3. Uses descriptive activity names to name the activities in the data set
# Rename Activity Names to lower Camle Case
# -----------------
# Helper functions: Could be re-written in regex
toUpperCamelCase <- function(varName,sep = " "){
     stringList <- strsplit(varName,sep)
     capitaliseFirstLetter <- function(s){
          paste(substring(s, 1, 1),
               tolower(substring(s, 2)),
               sep = "")
     }
     newStringList <- sapply(stringList,capitaliseFirstLetter)   
     newString <- paste(newStringList,collapse = "")
}
toLowerCamelClass <- function(varName,sep = " "){
     upperVarName <- toUpperCamelCase(varName,sep)
     # lower case first letter
     paste(tolower(substring(upperVarName, 1, 1)),
           substring(upperVarName, 2),
           sep = "")
}
# -----------------
# Rename the the Activities in lower Camel Case
activityIndex[,2] <- sapply(activityIndex[,2],toLowerCamelClass,sep = "_")
# Merge Activity names into data set
activityDataSet <- merge(activityIndex,extractedData)
# Remove the Activity number
activityDataSet <- activityDataSet[,-1]
# USe the plyr package to order the data
library(plyr)
orderedDataSet <- arrange(activityDataSet,ActivityLabel, Subject)
# ------------------------------------------------------------------------------
# 4. Appropriately label the data set with descriptive variable names.
# Relabel column names to "lower Camel Class" and apply rules
#    - Remove "()" and "-"
#    - t-> "time" & f -> "frequency"
#    - .mean -> Mean
#    - .std -> Std
#    - Remove duplicate "Body" entries
#    - Acc -> "Acceleration"
#    - Gyro -> "Gyroscopic"
#    - Mag -> "Magnitude"
extractedFeatureLabels <- gsub("mean","Mean",extractedFeatureLabels)
extractedFeatureLabels <- gsub("std","StandardDeviation",extractedFeatureLabels)
extractedFeatureLabels <- gsub("-","",extractedFeatureLabels)
extractedFeatureLabels <- gsub("\\(\\)","",extractedFeatureLabels)
extractedFeatureLabels <- gsub("^t","time",extractedFeatureLabels)
extractedFeatureLabels <- gsub("^f","frequency",extractedFeatureLabels)
extractedFeatureLabels <- gsub("(Body)+","Body",extractedFeatureLabels)
extractedFeatureLabels <- gsub("Acc","Acceleration",extractedFeatureLabels)
extractedFeatureLabels <- gsub("Gyro","Gyroscopic",extractedFeatureLabels)
extractedFeatureLabels <- gsub("Mag","Magnitude",extractedFeatureLabels)

# ------------------------------------------------------------------------------
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
ind <- list(orderedDataSet$ActivityLabel,orderedDataSet$Subject)
outputDataset <- aggregate(orderedDataSet[,4:ncol(orderedDataSet)],ind,FUN = mean,na.rm = TRUE)
colnames(outputDataset) <- c("Activity","Subject",extractedFeatureLabels)

# ------------------------------------------------------------------------------
# Write out the 'Tidy Data Set'
# Data can be read into R Studio using tidyData <- read.table("tidyData.txt",header =TRUE)
filename <- "tidyData.txt"
write.table(outputDataset,filename,row.names =FALSE)