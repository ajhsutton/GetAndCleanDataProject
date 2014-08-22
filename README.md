# GetAndCleanDataProject
======================
## Submission: ajsutton
###Course Project: Coursera Getting and Cleaning Data


### Introduction
This project includes the files and data required for the "Getting and Cleaning Data" Course Project.
The aim of the project is the generation of a 'clean' data set based upon version #1 of the "Human Activity Recognition Using Smartphones Dataset" data set from:
>Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
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

### Instructions
<ol>
<li> The data set should be downloaded into the working director (the directory containing "run_analysis.R"). The original data is available from: 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
Specifically, the data set should be in a directory called: "UCI HAR Dataset" </li>

<li>execute at terminal "R -f run_analysis.R </li>

<li>Two new files will be written:
  * tidyData.txt containing the tidy data set. This file can be imported into R using the command: "tidyData <- read.table("tidyData.txt",header =TRUE)"
  *codeBook_data.txt which contains interpretation information for the parameters/features in the tidyData.txt set.
</li>
</ol>

###  Initial Data Set
The data set contains derived time and frequency domain feature vector relating to measurements taken from the accelerometer and gyroscopic while by 30 subject participated in 6 activities: 
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

###  Output Data Set
The data analysis creates a second, independent data set showing the average of each feature variable for each activity and each subject. This data is derived from feature vector contained within the original data set. 

The output data is contained in a file **tidyData.txt**.
 
The guideline of a "Wide" Tidy data set has been followed in data generation, where:
1. Each variable forms a column.
2. Each observation forms a row.
3. Each type of observational unit forms a table.. 
4. Fixed variables come first (namely Activity and Subject).

For further information on Tidy Data processes applied, please see:
* [Hadley Wickham's Tidy Data paper](http://vita.had.co.nz/papers/tidy-data.pdf), or
* [David Hood's course project page](https://class.coursera.org/getdata-006/forum/thread?thread_id=43)

Feature labels use [lower Camel Class representation](http://en.wikipedia.org/wiki/CamelCase) of Feature and variable names to increase readability (as recommended by, for example, the [Google Jasa Style Guide](https://google-styleguide.googlecode.com/svn/trunk/javaguide.html)).

###  Data Processing
The data is processed in the following steps:

1. The data set metadata is imported from the "UCI HAR Dataset" top level files:
  - activity_labels.txt contains the labels and activity code
  - features.txt contains the labels for each feature in the data set.
2. For each of the "test" and "train" data sets, the "X" data and "y" subject information are imported and combined into a single data frame using cbind()
3. The "test" and "train" data sets are combined into a single data set using rbind()
4. Measurements relating to the mean or standard deviation of a parameter are extracted using a Regular Expression
  - regex string: "\\.*-(mean|std){1}\\(\\)" 
  - The regex will search for feature labels containing 1 instance of either "mean" or "std" followed by "()"
  - Identified labels are returned using "grep()"
  - Measurement data is subsetted based upon labels returned by the regex, plus Activity and Subject data
5/ Activity names are converted to lowerCamelClass
  - Helper functions are included for conversion to Upper and Lower Camel Case
  - Lower Camel Case was selected due to increase readability for long names
6. Activity data is sorted first alphabetically by activity and then numerically, by subject number.</li>
7. Regular expressions are used to convert the feature names into human readable, lower camel case representation without abbreviation [as recommended in Coursera "Getting and Cleaning Data" lecture: Components of Tidy Data]  
  - Punctuation such as "( )" & "-" are removed.
  - Abbreviations are expanded 
    * mean -> Mean
    * std -> StandardDeviation
    * Acc -> Acceleration
    * Gyro -> Gyroscope
    * Mag -> Magnitude
  - time ("^t") and frequency ("^f") features are explicitly identified 
  - *NOTE: No unit information was available with the data set at the time of processing.*
8. A new summary data set is constructed for each feature: 
  - Measurements are groups by (activity, subject).
  - The mean of each group (ie. activity & subject) is computed.
  - a new "tidy" data set is formed from the computed means.
9. The new, tidy data is written to a file "tidyData.txt" using the command: write.table(outputDataset,filename,row.names =FALSE)"
  - The data may be read into R using: read.table("tidyData.txt",header =TRUE)
10. A summary code book is written to a new file "codeBook_data.txt"
  - The file contains each feature in the new data set, plus a summary of the data format.
  