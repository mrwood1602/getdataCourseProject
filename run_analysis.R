#
# You should create one R script called run_analysis.R that does the following. 
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement. 
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#


# Read in features, subjects, and activities for training and test sets and the original feature labels.
train_features <- read.table("./UCI HAR Dataset/train/X_train.txt")
train_subjects <- read.table("./UCI HAR Dataset/train/subject_train.txt")
train_activities <- read.table("./UCI HAR Dataset/train/y_train.txt")

test_features <- read.table("./UCI HAR Dataset/test/X_test.txt")
test_subjects <- read.table("./UCI HAR Dataset/test/subject_test.txt")
test_activities <- read.table("./UCI HAR Dataset/test/y_test.txt")

original_labels <- read.table("./UCI HAR Dataset/features.txt")
original_labels <- as.character(original_labels[[2]])


# Merge training and test sets
merged_features <- rbind(train_features, test_features)
merged_subjects <- rbind(train_subjects, test_subjects)
merged_activities <- rbind(train_activities, test_activities)
names(merged_features) <- make.names(original_labels)

# Merge subjects, activities, and features into one frame
merged_frame <- cbind(merged_subjects, merged_activities, merged_features)


# Extract features that deal with mean and std deviation of measurements
col_index <- grep("mean|std",original_labels)
subset_features0 <- merged_frame[c(1,2,col_index+2)]

# Convert Activity id to Activity name
# 1 WALKING
# 2 WALKING_UPSTAIRS
# 3 WALKING_DOWNSTAIRS
# 4 SITTING
# 5 STANDING
# 6 LAYING
conversion_vec <- c("Walking","Walking_Upstairs","Walking_Downstairs","Sitting","Standing","Laying")
subset_features <- subset_features0
for ( i in 1:length(subset_features0[[2]])){
     subset_features[i,2] <- conversion_vec[subset_features0[i,2]]
}


# Clean labels to remove metacharacters

# initialize new vectors to avoid growing inside for loop (this is supposed to help performance)
cleaned_labels1 <- numeric(length=length(original_labels))
cleaned_labels2 <- numeric(length=length(original_labels))

# loop through all the original labels and remove metacharacters
for (i in 1:length(original_labels)) {
     cleaned_labels1[i] <- gsub("\\.| |\\(|\\)", "", original_labels[i])
     cleaned_labels2[i] <- gsub("-|,","_", cleaned_labels1[i])
}

# Just in case I missed something use make.names to force labels to behave
cleaned_labels <- make.names(cleaned_labels2)
subset_labels <- cleaned_labels[col_index]

names(subset_features) <- c("SubjectID","Activity",subset_labels)

write.table(subset_features,file="./UCI HAR Dataset/Subsetted features to include mean and std only.txt",row.names=FALSE)

temp1 <- split(subset_features, interaction(subset_features[[1]],subset_features[[2]]))

summary_means <- as.data.frame(t(sapply(temp1,function(x) colMeans(x[,subset_labels]))))

summary_rows <- data.frame(do.call(rbind,strsplit(row.names(summary_means), "\\.")))
names(summary_rows) <- c("SubjectID","Activity")

summary_frame <- cbind(summary_rows, summary_means)
write.table(summary_frame, file="./UCI HAR Dataset/Mean of subsetted features per subject per activity.txt",row.names=FALSE)