if(!file.exists("data")){dir.create("data")}
filUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(filUrl, destfile = "./data/Dataset.zip")

unzip("./data/Dataset.zip")

fil1 <- file("UCI HAR Dataset/features.txt")
fil2 <- file("UCI HAR Dataset/activity_labels.txt")
fil3 <- file("UCI HAR Dataset/test/subject_test.txt")
fil4 <- file("UCI HAR Dataset/test/X_test.txt")
fil5 <- file("UCI HAR Dataset/test/y_test.txt")
fil6 <- file("UCI HAR Dataset/train/subject_train.txt")
fil7 <- file("UCI HAR Dataset/train/X_train.txt")
fil8 <- file("UCI HAR Dataset/train/y_train.txt")

feat <- readLines(fil1)
actLabels <- readLines(fil2)

testSubj <- as.numeric(unlist(readLines(fil3)))
trainSubj <- as.numeric(unlist(readLines(fil6)))

testActs <- as.numeric(unlist(readLines(fil5)))
trainActs <- as.numeric(unlist(readLines(fil8)))

testRaw <- readLines(fil4)
trainRaw <- readLines(fil7)

close(fil1)
close(fil2)
close(fil3)
close(fil4)
close(fil5)
close(fil6)
close(fil7)
close(fil8)

class(testRaw)

library(stringr)

for(i in 1:length(testRaw)) {
    dat <- data.frame(as.numeric(unlist(str_extract_all (testRaw[i], "\\-*\\d+\\.*\\d*e\\-*\\d*")))) 
    if(i == 1) testDat <- dat
    else testDat <- c(testDat,dat)
  
}

for(i in 1:length(trainRaw)) {
  dat <- data.frame(as.numeric(unlist(str_extract_all (trainRaw[i], "\\-*\\d+\\.*\\d*e\\-*\\d*")))) 
  if(i == 1) trainDat <- dat
  else trainDat <- c(trainDat,dat)
  
}

actLabels = tolower(gsub("^[0-9] ","",actLabels))

trainDF <- data.frame(matrix(unlist(trainDat), nrow=length(trainDat), byrow=T))

testDF <- data.frame(matrix(unlist(testDat), nrow=length(testDat), byrow=T))

colnames(trainDF) <- feat
colnames(testDF) <- feat

testActs <- factor(testActs,levels = unique(testActs), labels = actLabels)

trainActs <- factor(trainActs,levels = unique(trainActs), labels = actLabels)

library(dplyr)

trainDF <- mutate(trainDF,activity = trainActs)
trainDF <- mutate(trainDF,user = trainSubj)
testDF <- mutate(testDF,activity = testActs)
testDF <- mutate(testDF,user = testSubj)

fullmergeDat <- merge(trainDF,testDF, all=TRUE)


meanfilts <- grep("*mean\\(\\)*",feat)
sdfilts <- grep("*std\\(\\)*",feat)

mnsdFilt <- c(meanfilts,sdfilts)
mnsdFilt <- sort(c(mnsdFilt, 562, 563))

mergeDat <- fullmergeDat[,mnsdFilt]

colnames(mergeDat) <- gsub("^[0-9]* |\\(\\)[-]?|-","",gsub("std","Std",gsub("mean","Mean",colnames(mergeDat))))

grpDat <- group_by(mergeDat,user,activity)
finData <- summarize_all(grpDat,mean)

finData <- data.frame(finData)

write.table(finData,"tidyAccel.txt",row.name=FALSE)
