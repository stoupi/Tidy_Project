library(data.table)
library(dplyr)

setwd(dir = 'C:/UserData/Z003C6UX/Documents/-- R-PROGRAMMATION/Tidy_Projectdata/')

# Read datasets

X_test <- fread(paste0(getwd(),"/data/test/X_test.txt"))
y_test <- fread(paste0(getwd(),"/data/test/y_test.txt"))

X_train <- fread(paste0(getwd(),"/data/train/X_train.txt"))
y_train <- fread(paste0(getwd(),"/data/train/y_train.txt"))

features <- fread(paste0(getwd(),"/data/features.txt"))
activity_label <- fread(paste0(getwd(),"/data/activity_labels.txt"))

# 1. Merges the training and the test sets to create one data set.

X_merged <- rbind(X_train,X_test)
y_merged <- rbind(y_train,y_test)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
tidy_dataset <- select(X_merged, contains("mean")|contains("std"))


# 4. Appropriately labels the data set with descriptive variable names. 
names(X_merged) <- features$V2

# 3. Uses descriptive activity names to name the activities in the data set
y_merged_activity <- merge(x = y_merged, y = activity_label, by.x = "V1", by.y = "V1", all = FALSE)

tidy_dataset <- tidy_dataset %>%
        mutate(activity = y_merged_activity$V2)

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
subject_test <- fread(paste0(getwd(),"/data/test/subject_test.txt"))
subject_train <- fread(paste0(getwd(),"/data/train/subject_train.txt"))
subject_merged <- rbind(subject_train,subject_test)

names(subject_merged) <- "subject"
tidy_dataset <- cbind(tidy_dataset,subject_merged)

tidy_dataset_2 <- tidy_dataset[, lapply(.SD, FUN=mean), by=.(activity, subject)]
write.table(tidy_dataset_2, file = "tidy_dataset.txt", sep = "\t",
            col.names = TRUE)



