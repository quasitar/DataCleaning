#This function outputs the file "tidyAccel.txt" in your default R directory which contains a combined set of data from the UCI HAR test and training data. It contains a collection of averages for 66 combined accelerometer parameters which correspond to mean and standard deviation measurments accross all 6 activity categories, for all 30 users. Each of the 180 rows are averages of the mean and sd data for each user, and each activity.

run_Analysis <- function(){
  
    #packages used
    library(dplyr)
    library(dplyr)
  
    #create directory for the data if it does not already exist
    if(!file.exists("data")){dir.create("data")}
  
    #url where HAR data is sourced
    filUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

    #download data
    download.file(filUrl, destfile = "./data/Dataset.zip")
  
    #unzip data
    unzip("./data/Dataset.zip")
  
    # File pointers for unzipped HAR dataset
    fil1 <- file("UCI HAR Dataset/features.txt")
    fil2 <- file("UCI HAR Dataset/activity_labels.txt")
    fil3 <- file("UCI HAR Dataset/test/subject_test.txt")
    fil4 <- file("UCI HAR Dataset/test/X_test.txt")
    fil5 <- file("UCI HAR Dataset/test/y_test.txt")
    fil6 <- file("UCI HAR Dataset/train/subject_train.txt")
    fil7 <- file("UCI HAR Dataset/train/X_train.txt")
    fil8 <- file("UCI HAR Dataset/train/y_train.txt")
    
    # store 561 feature names
    feat <- readLines(fil1)
    
    # store 6 activity names
    actLabels <- readLines(fil2)
    
    # user assignments for each test and training sample
    testSubj <- as.numeric(unlist(readLines(fil3)))
    trainSubj <- as.numeric(unlist(readLines(fil6)))
    
    # activity assignments for each test and trianing sample
    testActs <- as.numeric(unlist(readLines(fil5)))
    trainActs <- as.numeric(unlist(readLines(fil8)))
    
    # raw data for all 561 accelerometer features for the test and training data
    testRaw <- readLines(fil4)
    trainRaw <- readLines(fil7)
    
    # close files, we are done with them
    close(fil1)
    close(fil2)
    close(fil3)
    close(fil4)
    close(fil5)
    close(fil6)
    close(fil7)
    close(fil8)

    # store test data as numbers
    for(i in 1:length(testRaw)) {
      
        dat <- data.frame(as.numeric(unlist(str_extract_all (testRaw[i], "\\-*\\d+\\.*\\d*e\\-*\\d*")))) 
        
        if(i == 1) testDat <- dat
        else testDat <- c(testDat,dat)
    }
    
    # store training data as numbers
    for(i in 1:length(trainRaw)) {
      
        dat <- data.frame(as.numeric(unlist(str_extract_all (trainRaw[i], "\\-*\\d+\\.*\\d*e\\-*\\d*")))) 
        
        if(i == 1) trainDat <- dat
        else trainDat <- c(trainDat,dat)
    }

    # put training and test data in DF
    trainDF <- data.frame(matrix(unlist(trainDat), nrow=length(trainDat), byrow=T))
    
    testDF <- data.frame(matrix(unlist(testDat), nrow=length(testDat), byrow=T))
    
    # set column names for DF base on features
    colnames(trainDF) <- feat
    colnames(testDF) <- feat
    
    # remove activity numbner from activity data
    actLabels = tolower(gsub("^[0-9] ","",actLabels))
    
    # map activity name to activity number for training and test data
    testActs <- factor(testActs,levels = unique(testActs), labels = actLabels)

    trainActs <- factor(trainActs,levels = unique(trainActs), labels = actLabels)

    # add activity and user information to dataframe for training and test data
    trainDF <- mutate(trainDF,activity = trainActs)
    trainDF <- mutate(trainDF,user = trainSubj)
    testDF <- mutate(testDF,activity = testActs)
    testDF <- mutate(testDF,user = testSubj)
    
    # merge the training and test data
    fullmergeDat <- merge(trainDF,testDF, all=TRUE)
    
    # create filters to capture on the mean and sd measurements and tidy up the feature names

    # create filters capture on mean and sd features
    meanfilts <- grep("*mean\\(\\)*",feat)
    sdfilts <- grep("*std\\(\\)*",feat)
    
    # combine mean and sd filters
    mnsdFilt <- c(meanfilts,sdfilts)
    # need to add back in the colunms for user, and activity
    mnsdFilt <- sort(c(mnsdFilt, 562, 563))
    
    # create data set, which only has mean and sd parameters
    mergeDat <- fullmergeDat[,mnsdFilt]
    
    # tidy up column names by: removing numbers, spaces, parentheses, dashes, and making the meand and sd stand out
    colnames(mergeDat) <- gsub("^[0-9]* |\\(\\)[-]?|-","",gsub("std","Std",gsub("mean","Mean",colnames(mergeDat))))
    
    # prepare mergeDat for final aggregated summary data
    grpDat <- group_by(mergeDat,user,activity)
    
    # final data is a summary of the mean of all columns by user and activity
    finData <- summarize_all(grpDat,mean)
    
    # convert final data to df
    finData <- data.frame(finData)
    
    # output final summary dataset to .txt file
    write.table(finData,"tidyAccel.txt",row.name=FALSE)

}