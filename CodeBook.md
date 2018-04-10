### Introduction

This file describes the new data generated from the Human Activity Recognition Using Smartphones Dataset from UCI. The enclosed file "run_Analysis.R" has a function which combines the test and training data, and provides a summary of that data for analysis.

UCI HAR file size is 60MB
tidyAccel.txt file size is 220 KB

### Data Code Book

The "tidyAccel.txt" file contains a combined set of data from the UCI HAR test and training data. It contains a collection of averages for 66 combined accelerometer parameters which correspond to mean and standard deviation measurments accross all 6 activity categories, for all 30 users. Each of the 180 rows are averages of the mean and sd data for each user, and each activity.

"./UCI HAR Dataset/README.txt" contains more specific details on the data including a reference to their source.

"./UCI HAR Dataset/features_info.txt" contains information about the 66 accelerometer parameters, plus the other parameters which were not pulled into this data set.

"tidyAccel.txt" structure:

There are a total of 68 columns. 

Col 1 = The user number which identifies the unique user that generated the data. There are 30 total users, numbered 1-30. 

Col 2 = The activity the user was engaged in when the data was taken. There are 6 total activites which are described in "./UCI HAR Dataset/README.txt". 

Col 3-68 = The average values for the mean and sd parametres measeured by the acclerometer for each user during each activity. These are described in "./UCI HAR Dataset/features_info.txt". Note: parentheses and dashes were removed as part of the tidy process, but the main naming structure reamins intact.

The first line of the file contains the column names, and there are 30*6 = 180 total rows in the dataset, for a total of 181 lines.


### Cleaning Process

This section describes the process of preparing the data for the "tidyAccel.txt" file. 

1. Download and unzip the UCI HAR dataset
2. Load 8 files necessary for compiling the combined dataset
3. Store the file data into data structures for manipulation
4. Add the activity and user information to the test and training data
5. Merge the test and training datasets into one dataframe
6. Create filters to only filter out feature names where they contain "mean()", or "std()"
7. Filter merged data on column names which contain "mean()", or "std()"
8. Tidy up column names by reomoving parentheses, spaces, and dashes. 
9. Use dplyr to aggregate data by user and activity
10. Create summary table which contains averages of all 66 parameters by user and activity.
11. Send final summary data frame to text file
