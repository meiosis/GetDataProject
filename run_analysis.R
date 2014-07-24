# run_analysis.R 
#
# This file defines and runs a function run_analysis() and support functions
# thereto, given that the data set contained in
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# is extracted and present in the current working directory. The function 
# addresses the following requirements: 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation 
#    for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. Creates a second, independent tidy data set with the average of each 
#    variable for each activity and each subject. 
#





#
# runAnalysis() writes the "second" data set as a text file 
# "Tidy Means by Subject and Activity.txt" in the working directory.
#
# It takes no arguments, but the UCI HAR Dataset should be present 
# under that name in the working directory (if not, it attempts to get it)
#
runAnalysis <- function() {
    
    # Make sure dataset is present in working directory (or download)
    checkOrGetDataset()

    # Get single merged, cleaned and subsetted data frame 
    # from the UCI HAR Dataset directory. Columns are:
    #  1 -- SubjectID
    #  2 -- Activity (using labels)
    #  3 and up -- Mean and standard deviation numerical measurements
    mergedCleanData <- getMergedCleanedData("UCI HAR Dataset")
    
    # Derive a tidy data set of means, grouped by first two columns
    tidyMeans <- getTidyMeans(mergedCleanData)

    # Output this tidy data set to CWD
    write.table(tidyMeans, "Tidy Means by Subject and Activity.txt", 
              row.names=FALSE) 
    cat("File 'Tidy Means by Subject and Activity.txt'",
        "successfully output.\n")

}


#
# Check for the "UCI HAR Dataset", otherwise attempt to or download and 
# extract it.
#
checkOrGetDataset <- function() {
  
    if (! file.exists ("UCI HAR Dataset")) {
        cat("UCI HAR Dataset not found in current directory -",
                "attempting to obtain from internet.\n")
        dl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(dl, "getdata_projectfiles_UCI HAR Dataset.zip")
        unzip("getdata_projectfiles_UCI HAR Dataset.zip")
    }
}



# getMergedCleanedData(dataDirectory) returns a data frame comprised of merged, 
# cleaned and subsetted data from the UCI HAR Dataset, meeting the 
# requirements:
#   1. Merges the training and the test sets to create one data set.
#   2. Extracts only the measurements on the mean and standard deviation 
#      for each measurement. 
#   3. Uses descriptive activity names to name the activities in the data set
#   4. Appropriately labels the data set with descriptive variable names. 
# 
# Takes one argument, dataDirectory, which is the path to the top 
# level of the UCI HAR Dataset file hierarchy.
getMergedCleanedData <- function(dataDirectory) {
    
    # Read and process features.txt; get clean names and locations of variables
    # to capture (i.e. of the mean/stdDev measurements)
    processedFeatures <- processFeatures(dataDirectory)
    variableNames <- processedFeatures[[1]]
    variablesToCapture <- processedFeatures[[2]]
    
    
    # Read in raw numeric data sets, using processed features to select 
    # just relevant mean/stddev columns and to use clean names.
    # Skip Inertial Signals since these are not mean/stddev
    xTest <- read.table(paste(dataDirectory, "/test/X_test.txt",  sep=""),
                        col.names=variableNames,
                        colClasses=variablesToCapture) 
    xTrain <- read.table(paste(dataDirectory, "/train/X_train.txt", sep=""),
                         col.names=variableNames,
                         colClasses=variablesToCapture) 
    
        
    # Read in subjects file for each dataset; this is essentially another 
    # column of same length as numeric data.
    subjectTest <- read.table(paste(dataDirectory, "/test/subject_test.txt", 
                                    sep=""),
                              col.names="subjectID", colClasses="factor") 
    subjectTrain <- read.table(paste(dataDirectory, "/train/subject_train.txt",
                                     sep=""),
                               col.names="subjectID", colClasses="factor") 
        
    # Read in activity class file for each dataset; this is essentially another 
    # column of same length as numeric data. Also read in list of activity
    # labels and use them as more descriptive names
    activityTest <- read.table(paste(dataDirectory, "/test/y_test.txt", 
                                     sep=""),
                               col.names="activity", colClasses="factor") 
    activityTrain <- read.table(paste(dataDirectory, "/train/y_train.txt",  
                                      sep=""),
                                col.names="activity", colClasses="factor") 
    activityLabels <- read.table(paste(dataDirectory, "/activity_labels.txt", 
                                       sep=""),
                                 colClasses="character")[,2]
    levels(activityTest[,1]) <- activityLabels
    levels(activityTrain[,1])  <- activityLabels
    
    
    # Now we have all the sets of columns for test and train to make a 
    # composite data frame. Glue them together, with the subject and 
    # activity first, followed by all the numeric data.
    testDF <- cbind(subjectTest, activityTest, xTest)
    trainDF <- cbind(subjectTrain, activityTrain, xTrain)

    
    # Finally, return test and train dataframes, combined
    rbind(testDF, trainDF)
}



#
# processFeatures() returns a list of two vectors of same length and order as 
# input vector, containing:
#    #1 Syntactically clean, human-readable Variable names
#    #2 column classes as used by read.table() and identifying relevant
#       variables pertaining to measurements of means and standard
#       deviations ( containing "numeric" for those, and "NULL" otherwise.
# 
# Takes one argument, dataDirectory, which is the path to the top 
# level of the UCI HAR Dataset file hierarchy.
#
# Detail:
# For #1, reads the list of original feature names in the file
# features.txt and reworks them to: 
#   a) fix what look like typos
#   b) make them syntactically valid, unique variable names for R
#   c) make them more descriptive where the abbreviations used are not 
#      reasonably clear (expand certain abbreviations)
# For #2, identifies the measurements that are means and standard
# deviations, based on their names and the description in features_info.txt.
# Note: this does not include non-summary statistics, such as "meanFreq"
# (frequency components to obtain a mean frequency) or average signal 
# vectors used in angle computations.)
#
processFeatures <- function(dataDirectory) {
    
    # Read in table of "features" from original dataset -- the second column of
    # the table essentially lists what is in each column of the test and train
    # raw data sets.
    features <- read.table(paste(dataDirectory, "/features.txt", sep=""),
                           colClasses="character")[,2]
    
    # Identify features that pertain to mean or standard deviation measurements.
    # They are those that contain the pattern "mean()" or "std()" in the name,
    # but exclude those that are parameters to the angle function (which are
    # presumably not means etc. in their own right).
    locs <- grepl("(mean|std)\\(", features)
    
    # Clean up what look like typos in the original features: i.e. "extra "Body"
    # in fBodyBodyGyroMag-mean() and extra paren in
    # "angle(tBodyAccJerkMean),gravityMean)"
    newNames <- sub("BodyBody", "Body", features)
    newNames <- sub("\\)(.*\\))", "\\1", newNames)
    
    # Now substitute for or remove illegal R characters, i.e. "-(),", and then
    # use make.names() to force syntactically valid names if any drop-offs might
    # have slipped through, as well as to ensure uniqueness of names.
    # ... map e.g. xxx-mean() --> xxx_mean()
    newNames <- gsub("-","_", newNames)         
    # ... map e.g. xxx_mean() --> xxx_mean
    newNames <- gsub("\\(\\)","", newNames)     
    # ... map e.g. angle(a,b) --> angle.a,b.
    newNames <- gsub("[\\(\\)]",".", newNames)  
    # ... map e.g. angle.a,b. --> angle.a,b
    newNames <- sub("\\.$","", newNames)        
    # ... map e.g. angle.a,b --> angle .a.b
    newNames <- gsub(",", ".", newNames)  
    # Should already be clean by now, but just in case:
    newNames <- make.names(newNames, unique=TRUE)  
    
    # Now make names a bit more descriptive, while being conscious of verbosity
    # ... map initial "f" and "t" to "freq" and "time" resp.
    newNames <- sub("^f","freq", newNames) 
    newNames <- sub("^t","time", newNames) 
    # ... expand Acc to Accel, std to stdDev, Mag to Magnitude
    newNames <- sub("Acc","Accel", newNames)
    newNames <- sub("std","stdDev", newNames)
    newNames <- sub("Mag","Magnitude", newNames)
    
    # Now copy these names to output vector, but only those that pertain to 
    # mean/stddevs, others are "NULL"
    summVars <- rep("NULL", length(newNames))
    summVars[locs] <- "numeric"
    
    list(newNames, summVars)
    
}



#
# getTidyMeans() returns a tidy data frame of means grouped by 
# subject and activity
#
# Takes one argument, mergedCleanData, which is the working tidy 
# dataset of runAnalysis()
#
getTidyMeans <- function(mergedCleanData) {
    
    # Compute means of numeric data in columns 3 and up by groups.
    # Restore readable group names and sort by those for a tidy dataset.
    tidyMeans <- aggregate(mergedCleanData[ ,-(1:2)],
                           by=list(mergedCleanData$subjectID, 
                                   mergedCleanData$activity),
                           FUN=mean)
    colnames(tidyMeans)[1:2] <- colnames(mergedCleanData)[1:2]
    reordering <- order(as.numeric(as.character(tidyMeans$subjectID)),
                        tidyMeans$activity)
    tidyMeans[reordering, ]
}



runAnalysis()

