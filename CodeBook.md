Code Book for Cousera "Getting Data" Course Project
========================================================

This Code Book describes the data file produced by the run_analysis.R script for the Cousera "Getting Data" Course Project. Details of the how the run_analysis.R script works are contained in the accompanying README.md document.

Structure of the data file
--------------------------

File name: "Tidy Means by Subject and Activity.txt"

File contents: tabular data, with each row on a separate line:

 - First row -- header, with name of each column in separate field
 - Subsequent rows -- each represents a separate record of summary statistics (as described in the data dictionary) with each field corresponding to a separate column of the table.

File format: white-space-delimited fields of two types:

 - Text fields -- (Column names and Row IDs) entries set off by double quotes
 - Numeric fields -- possibly signed decimal numbers

The file may be read by R in the current directory using the command:

    read.table("Tidy Means by Subject and Activity.txt", header=TRUE)


Data dictionary
---------------


The columns of the file are identified by the variable names in bold below:

*ID fields, text (can be used as R factors):*

**subjectID** 

- a number between 1 and 30, representing  one of the thirty subjects in the study

**activity**

- a text string, representing one of the activities: WALKING,         WALKING_UPSTAIRS, WALKING_DOWNSTAIRS,  SITTING, STANDING and LAYING

*Data fields, numbers between -1.0 and 1.0, being normalised and unitless, and  expressed as decimals:* 

**timeBodyAccel_mean_Y**

**timeBodyAccel_mean_Z**

**timeBodyAccel_stdDev_X**

**timeBodyAccel_stdDev_Y**

**timeBodyAccel_stdDev_Z**

**timeGravityAccel_mean_X**

**timeGravityAccel_mean_Y**

**timeGravityAccel_mean_Z**

**timeGravityAccel_stdDev_X**

**timeGravityAccel_stdDev_Y**

**timeGravityAccel_stdDev_Z**

**timeBodyAccelJerk_mean_X**

**timeBodyAccelJerk_mean_Y**

**timeBodyAccelJerk_mean_Z**

**timeBodyAccelJerk_stdDev_X**

**timeBodyAccelJerk_stdDev_Y**

**timeBodyAccelJerk_stdDev_Z**

**timeBodyGyro_mean_X**

**timeBodyGyro_mean_Y**

**timeBodyGyro_mean_Z**

**timeBodyGyro_stdDev_X**

**timeBodyGyro_stdDev_Y**

**timeBodyGyro_stdDev_Z**

**timeBodyGyroJerk_mean_X**

**timeBodyGyroJerk_mean_Y**

**timeBodyGyroJerk_mean_Z**

**timeBodyGyroJerk_stdDev_X**

**timeBodyGyroJerk_stdDev_Y**

**timeBodyGyroJerk_stdDev_Z**

**timeBodyAccelMagnitude_mean**

**timeBodyAccelMagnitude_stdDev**

**timeGravityAccelMagnitude_mean**

**timeGravityAccelMagnitude_stdDev**

**timeBodyAccelJerkMagnitude_mean**

**timeBodyAccelJerkMagnitude_stdDev**

**timeBodyGyroMagnitude_mean**

**timeBodyGyroMagnitude_stdDev**

**timeBodyGyroJerkMagnitude_mean**

**timeBodyGyroJerkMagnitude_stdDev**

**freqBodyAccel_mean_X**

**freqBodyAccel_mean_Y**

**freqBodyAccel_mean_Z**

**freqBodyAccel_stdDev_X**

**freqBodyAccel_stdDev_Y**

**freqBodyAccel_stdDev_Z**

**freqBodyAccelJerk_mean_X**

**freqBodyAccelJerk_mean_Y**

**freqBodyAccelJerk_mean_Z**

**freqBodyAccelJerk_stdDev_X**

**freqBodyAccelJerk_stdDev_Y**

**freqBodyAccelJerk_stdDev_Z**

**freqBodyGyro_mean_X**

**freqBodyGyro_mean_Y**

**freqBodyGyro_mean_Z**

**freqBodyGyro_stdDev_X**

**freqBodyGyro_stdDev_Y**

**freqBodyGyro_stdDev_Z**

**freqBodyAccelMagnitude_mean**

**freqBodyAccelMagnitude_stdDev**

**freqBodyAccelJerkMagnitude_mean**

**freqBodyAccelJerkMagnitude_stdDev**

**freqBodyGyroMagnitude_mean**

**freqBodyGyroMagnitude_stdDev**

**freqBodyGyroJerkMagnitude_mean**

**freqBodyGyroJerkMagnitude_stdDev**


- Each of these fields represents a mean of all the corresponding measurements that relate to the given subjectID and activity. The names are mnemonic, based on elements of their origin as further described by the conventions below.


Variable naming conventions and the raw data from which they derive
--------------------------

The naming convention adopted for the numeric variables derives from the original feature names of the raw data set (as described in a constituent file features_info.txt), but here using more readable and tidy names. These names are composed of the following components which together indicate what the underlying measurement is, and here represent the means of multiple measurements grouped by subjectID and activity.

The name components and their meanings are:

**time** -- a signal in the time domain

**freq** -- a signal in the frequency domain, from the application of a Fast Fourier Transform

**Accel** -- deriving from the Accelerometer

**Gyro** -- deriving from the Gyroscope

**Body** -- body acceleration signal

**Gravity** -- gravity acceleration signal

**Jerk** -- Jerk signals derived in time from the body linear acceleration and angular velocity

**Magnitude** -- magnitude of  three-dimensional signals  calculated using the Euclidean norm 

**_mean** -- mean value estimated from signal

**_stdDev** -- standard deviation estimated from signal

**_X _Y _Z** -- for the X, Y and Z axis respectively.

Note: Given the complexity and the number of the names and the components that go into them, it was decided to use some punctuation and mixed case to improve readability. Likewise, the level of abbreviation was chosen to be a balance between using complete words and the verbosity that might result. (Some styles of naming discussed in the lectures might otherwise have indicated full words and no punctuation, but strictly following that style  seems impractical here.)

More details of how these signals were obtained is available in the file features_info.txt in the raw data distribution. 

In the orginal data set, there were in general multiple measurements for each subjectID and activity. In this the tidy data set, the values are means of those measurements, grouped by subjectID and activity.

Many of the variables of the raw data set are not represented in the tidy data set, as the requirement was to capture only those measurements that were themselves means and standard deviation.



References
----------

 1. Project requirements at https://class.coursera.org/getdata-005/human_grading
 2. Raw data set (including original signal and feature descriptions) at 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
 3. Background information about the research at 
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
