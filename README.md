# Getting and Cleaning Data Course Project

by: Gerhard Messelink
date: june 14 2017

## 1. Merges the training and the test sets to create one data set. 

Checking the files in the zipfile we can use the following source files:

  - features.txt - for column names of X file
  - test/subject_test.txt - for the subject column
  - test/y_test.txt - for the activity column
  - test/X_test.txt - for the measurements
  - train/subject_train.txt - for the subject column
  - train/y_train.txt - for the activity column
  - train/X_train.txt - for the measurements

To keep the information for each row if it was part of the test or train set I created an
extra column with type train or test in same number of rows as the subject column.


## 2. Extracts only the measurements on the mean and standard deviation for each measurement.

Analysing the headers from features.txt it seems like the headers that contain mean() and std()
are the headers with the mean and standard deviation in it.
So collect the dedicated columnames in mean_std_colnames using grep with a regular expression:
"mean\\(\\)|std\\(\\)", using double backslash to escape the "()"

## 3. Uses descriptive activity names to name the activities in the data set

Activity numbers are replaced with the labels from activity_labels.txt. As the labels are ordered
matching the numbers in the first column we can set activities with the second column.
Then use `data_extract[,'activity'] <- activity[data_extract[,'activity']]` to replace
values in the activity column.


## 4. Appropriately labels the data set with descriptive variable names.

Columns for subject, activity and type are set, measurement columns are set from features.txt.
Was thinking of removing the () from the colnames but I think it is better if they match the
names used in the original dataset.

## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

All values from column 4 to the end are agregated. I chose to also keep the type of dataset in the set but it depends on the later usage of the set if this is needed.

