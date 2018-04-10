### Introduction

This folder contains an R script called "runAnalysis.R" to help combine training and test data from the Human Activity Recognition Using Smartphones Dataset from UCI. 

The output of the "runAnalysis.R" script is a 180 row data set which is outputted to "tidyAccel.txt". The text file contains average values for each of the 68 column headings grouped by the user and the activity which occured during the use of the phone. The script downloads the necessary data, and it stores it locally to run the analysis.

Data file size is 60MB.

Details about the data and the data cleaning are provided in the "CodeBook.md" file.

### Instructions

The "runAnalysis.R" file contains a function runAnalysis() which takes no parameters.

Note, the following packages are sourced in the executable:

library(stringr)
library(dplyr)

Please be sure they are installed before you try and run the script.

To execute the file:

1. Place the "runAnalysis.R" file in your default R directory.

2. Execute the following commands in your R terminal:
   source("run_Analysis.R")
   run_Analysis()
3. Once execution is complete, the file "tidyAccel.txt" will be generated in your default R directory.

