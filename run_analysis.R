rm(list = ls())
DATA_DIRECTORY <- "UCI HAR Dataset"

stopifnot(file.exists(DATA_DIRECTORY))

library(dplyr)

X_TRAIN_DIR <- paste(DATA_DIRECTORY, "/train/X_train.txt", sep = "")
Y_TRAIN_DIR <- paste(DATA_DIRECTORY, "/train/y_train.txt", sep = "")
SUBJECT_TRAIN_DIR <- paste(DATA_DIRECTORY, "/train/subject_train.txt", sep = "")
X_TEST_DIR <- paste(DATA_DIRECTORY, "/test/X_test.txt", sep = "")
Y_TEST_DIR <- paste(DATA_DIRECTORY, "/test/y_test.txt", sep = "")
SUBJECT_TEST_DIR <- paste(DATA_DIRECTORY, "/test/subject_test.txt", sep = "")
FEATURES_DIR <- paste(DATA_DIRECTORY, "/features.txt", sep = "")
ACTIVITY_LABELS_DIR <- paste(DATA_DIRECTORY, "/activity_labels.txt", sep = "")

x_train <- read.table(X_TRAIN_DIR)
y_train <- read.table(Y_TRAIN_DIR)
subject_train <- read.table(SUBJECT_TRAIN_DIR)

x_test <- read.table(X_TEST_DIR)
y_test <- read.table(Y_TEST_DIR)
subject_test <- read.table(SUBJECT_TEST_DIR)

xData <- rbind(x_train, x_test)
yData <- rbind(y_train, y_test)
subjectData <- rbind(subject_train, subject_test)

features <- read.table(FEATURES_DIR)
mean_sd_features <- grep("-(mean|std)\\(\\)", features[, 2])

xData <- xData[, mean_sd_features]
names(xData) <- features[mean_sd_features, 2]

activities <- read.table(ACTIVITY_LABELS_DIR)
yData[, 1] <- activities[yData[, 1], 2]
names(yData) <- "Activity"

names(subjectData) <- "Subject"
tidy_mean_std <- data.frame(xData, yData, subjectData)

tidy_avg <- tidy_mean_std %>%
  group_by(Subject, Activity) %>%
  summarise_all(funs(mean))

write.table(tidy_avg, "tidy_dataset.txt", row.name=FALSE)