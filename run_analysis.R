## Create one R script called run_analysis.R that does the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# I have used two packages, data.table and reshape2

# My all data is in data subfolder, so if you want to execute it should be at same path.

library("data.table")
## reshape library is required for dcast and melt
library("reshape2")

# All the features are now read into fVector.
fVector <- read.table("data/UCI HAR Dataset/features.txt")[,2]
# Now Fvector has 561 values and 477 levels

# Extract only the measurements on the mean and standard deviation for each measurement.
fmeanStd <- grepl("mean|std", fVector)

# Different human activites are given in activity_labels.txt
activities <- read.table("data/UCI HAR Dataset/activity_labels.txt")[,2]
 # After above statement, activities has six values such as LAYING SITTING STANDING WALKING WALKING_DOWNSTAIRS WALKING_UPSTAIRS

# Now training set data need to be loaded
# Load and process X_train & y_train data.
xtrain <- read.table("data/UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("data/UCI HAR Dataset/train/y_train.txt")
train <- read.table("data/UCI HAR Dataset/train/subject_train.txt")


# Similalry load the testing data from X_test & y_test data.
xtest <- read.table("data/UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("data/UCI HAR Dataset/test/y_test.txt")
test<- read.table("data/UCI HAR Dataset/test/subject_test.txt")

##show(xdata)
#Now give labels to xtest and xtrain
names(xtrain) = fVector
names(xtest) = fVector

# Extract only the measurements on the mean and standard deviation for each measurement.
xtrain = xtrain[,fmeanStd]
xtest = xtest[,fmeanStd]

# Load activity labels in training and test
ytrain[,2] = activities[ytrain[,1]]
ytest[,2] = activities[ytest[,1]]

#Give Labels to both
names(ytrain) = c("Activity_ID", "Activity_Label")
names(ytest) = c("Activity_ID", "Activity_Label")

# for trainign and test set i used label subject
names(train) = "subject"
names(test) = "subject"


# Bind the training data
train_data <- cbind(as.data.table(train), ytrain, xtrain)

# Bind data
test_data <- cbind(as.data.table(test), ytest, xtest)


# Merge test and train data
test_train = rbind(test_data, train_data)

id_labels   = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(test_train), id_labels)
melt_data      = melt(test_train, id = id_labels, measure.vars = data_labels)

# Apply mean function to dataset using dcast function
tidy_data   = dcast(melt_data, subject + Activity_Label ~ variable, mean)


# Writing into same folder in which r file is there.
write.table(tidy_data, file = "./tidy_data.txt", row.name=FALSE)