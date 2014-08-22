GetAndCleanDataProject
======================
Course Project: Coursera Getting and Cleaning Data

This project includes the files and data required for the "Getting and Cleaning Data" Course Project.
The aim of the project is the generation of a 'clean' data set based upon version #1 of the "Human Activity Recognition Using Smartphones Dataset" data set from:
Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory
DITEN - Universit‡ degli Studi di Genova.
Via Opera Pia 11A, I-16145, Genoa, Italy. 

The data set should be downloaded into the working director (the directory containing "run_analysis.R"). The original data is available from: 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
Specifically, the data set should be in a directory called: "UCI HAR Dataset"

The course project data processing stages are executed by running the R script: "run_analysis.R"
The "run_analysis.R" script requires the following R libraries:
- plyr
- stats

*** Instructions ***
1. The data set should be downloaded into the working director (the directory containing "run_analysis.R"). The original data is available from: 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
Specifically, the data set should be in a directory called: "UCI HAR Dataset"

2. execute at terminal "R -f run_analysis.R

3. Two new files will be written:
  - tidyData.txt containing the tidy data set. This file can be imported into R using the command
    "tidyData <- read.table("tidyData.txt",header =TRUE)"
  - codeBook_data.txt which contains interpretation information for the parameters/features in the tidyData.txt set.
  
*** Initial Data Set ***
The data set contains derived parameters & summary statistics for the linear (accelerometer) and angular (gyroscopic) acceleration generated by 30 subject over 6 activities: 
- WALKING, 
- WALKING UPSTAIRS,
- WALKING_DOWNSTAIRS,
- SITTING,
- STANDING, and
- LAYING 
 
The data files of interest within the UCI HAR Dataset are:
- /test/X_test.txt contains derived products from the raw test data
- /test/y_test.txt describes the participant
- /train/X_train.txt contains derived products from the raw test data
- /train/y_train.txt describes the participant

*** Output Data Set ***
The output data set is derived from processing the summary statistics information contained within the original data set.
 
The output data follows the guidelines of a "Wide" Tidy data set []. 
Feature labels use lower Camel Class representation [http://en.wikipedia.org/wiki/CamelCase].
  
 
*** Data Processing ***
The data is processed in the following steps:

1. The data set metadata is imported from the "UCI HAR Dataset" top level files:
  - activity_labels.txt contains the labels and activity code
  - features.txt contains the labels for each feature in the data set.
2. For each of the "test" and "train" data sets, the "X" data and "y" subject information are imported and combined into a single data frame using cbind()
3. The "test" and "train" data sets are combined into a single data set using rbind()
4. Measurements relating to the mean or standard deviation of a parameter are extracted using a Regular Expression
  - regex string: "\\.*-(mean|std){1}\\(\\)" 
  - The regex will search for feature labels containing 1 instance of either "mean" or "std" followed by "()"
5. Activity names are converted to lowerCamelClass
6. Activity data is sorted alphabetically based upon activity and numerically based upon subject number.
7. Regular expressions are used to convert the feature names into human readable, lower camel case representation without abbreviation [as recommended in Coursera "Getting and Cleaning Data" lecture: Components of Tidy Data,  
8. A new summary data set is constructed for each feature: 
  - Measurements are sorted by (activity, subject)
  - The mean of each feature is computed for each activity and subject
  - a new data set is formed from the computed means.
 9. The new, tidy data is written to a file "tidyData.txt" using the command:
  write.table(outputDataset,filename,row.names =FALSE)"
  - The data may be read into R using 
  read.table("tidyData.txt",header =TRUE)
10. A summary code book is written to a new file "codeBook_data.txt"
  - The file contains each feature in the new data set, plus a summary of the data format.
  