# 1. Merges the training and the test sets to create one data set. 

# 1a. Load the zip file into the work folder and unzip it
#     download and extract the zip file only once

file_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zip_file <- "UCI HAR Dataset.zip"
extract_folder <- "UCI HAR Dataset"

if(!file.exists(extract_folder)) {
  if(!file.exists(zip_file)) {
    download.file(file_url,destfile=zip_file,method="curl")
  }
  unzip(zip_file)
}

# 1b. Headers for X data are stored in features.txt
#     A list of column names can be extracted from the second column (V2)

file_features <- paste(extract_folder, "/features.txt", sep="")
features <- read.table(file_features)
x_colnames <- features$V2

# 1c. Read X and Y data files
#     X contains rows with 561 columns
#     Y contains 1 column with the type
#     subject contains 1 column with the subject number

file_x_test <- paste(extract_folder, "/test/X_test.txt", sep="")
file_y_test <- paste(extract_folder, "/test/y_test.txt", sep="")
file_subject_test <- paste(extract_folder, "/test/subject_test.txt", sep="")
file_x_train <- paste(extract_folder, "/train/X_train.txt", sep="")
file_y_train <- paste(extract_folder, "/train/y_train.txt", sep="")
file_subject_train <- paste(extract_folder, "/train/subject_train.txt", sep="")

x_test <- read.table(file_x_test)
colnames(x_test) <- x_colnames
y_test <- read.table(file_y_test)
colnames(y_test) <- c("activity")
subject_test <- read.table(file_subject_test)
colnames(subject_test) <- c("subject")
type_test <- rep("test", nrow(subject_test))

x_train <- read.table(file_x_train)
colnames(x_train) <- x_colnames
y_train <- read.table(file_y_train)
colnames(y_train) <- c("activity")
subject_train <- read.table(file_subject_train)
colnames(subject_train) <- c("subject")
type_train <- rep("train", nrow(subject_train))

# 1d. Merge the columns of subject, Y, type and X

test_data <- cbind(subject_test, y_test, type=type_test, x_test)
train_data <- cbind(subject_train, y_train, type=type_train, x_train)

# 1e. Create one dataset from the test and train dataset

all_data <- rbind(test_data, train_data)


# 2. Extracts only the measurements on the mean and standard deviation for each measurement.

# 2a. Determine all column names with mean() or std() in it

mean_std_colnames <- grep("mean\\(\\)|std\\(\\)", x_colnames, value=TRUE)

# 2b. Extract mean and std columns

data_extract <- all_data[ , c("subject", "activity", "type", mean_std_colnames)]


# 3. Uses descriptive activity names to name the activities in the data set

# 3a. Activity labels are stored in activity_labels.txt
#     A list of activity labels can be extracted from the second column (V2)

file_activity_labels <- paste(extract_folder, "/activity_labels.txt", sep="")
activity_labels <- read.table(file_activity_labels)
activity <- activity_labels$V2

# 3b. Replace the number in the activity column with the text value of the activity label

data_extract[,'activity'] <- activity[data_extract[,'activity']]


# 4. Appropriately labels the data set with descriptive variable names.
#    Is already done in step 1


# 5. From the data set in step 4, creates a second, independent tidy data set 
#    with the average of each variable for each activity and each subject.

data_mean <- aggregate(data_extract[, 4:ncol(data_extract)], 
                       list(subject=data_extract$subject, 
                            activity=data_extract$activity, 
                            type=data_extract$type),
                       mean)

# 6. Write table

write.table(data_mean, file="mean_data.txt", row.names=FALSE)


