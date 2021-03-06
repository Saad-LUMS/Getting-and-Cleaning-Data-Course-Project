library(plyr)

# Step 1: Merging the training and test sets to create one data set.

x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")

x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")

# creating 'x' data set.
x_data <- rbind(x_train, x_test)

# creating 'y' data set.
y_data <- rbind(y_train, y_test)

# creating 'subject' data set.
subject_data <- rbind(subject_train, subject_test)

# Step 2: Extracting only the measurements on the mean and standard deviation for each measurement.

features <- read.table("features.txt")

# getting only columns with mean() or std() in their names.
mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])

# subsetting the desired columns.
x_data <- x_data[, mean_and_std_features]

# correcting the column names.
names(x_data) <- features[mean_and_std_features, 2]

# Step 3: Using descriptive activity names to name the activities in the data set.

activities <- read.table("activity_labels.txt")

# updating values with correct activity names.
y_data[, 1] <- activities[y_data[, 1], 2]

# correctting column name.
names(y_data) <- "activity"

# Step 4: Appropriately labelling the data set with descriptive variable names.

# correcting column name.
names(subject_data) <- "subject"

# binding all the data in a single data set.
all_data <- cbind(x_data, y_data, subject_data)

# Step 5: Creating a second, independent tidy data set with the average of each variable for each activity and each subject.

# 66 <- 68 columns but last two (activity & subject)
tidy_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(tidy_data, "tidy_data.txt", row.name=FALSE)