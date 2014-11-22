  # read in the TEST data, particpants and activity labels

Test.Subject <- read.table("Data/UCI HAR Dataset/test/subject_test.txt")
Test.Data <- read.table("Data/UCI HAR Dataset/test/X_test.txt")
Test.Act.Labels <- read.table("Data/UCI HAR Dataset/test/y_test.txt")

  # read in the TRAIN data, particpants and activity labels

Train.Subject <- read.table("Data/UCI HAR Dataset/train/subject_train.txt")
Train.Data <- read.table("Data/UCI HAR Dataset/train/X_train.txt")
Train.Act.Labels <- read.table("Data/UCI HAR Dataset/train/y_train.txt")

  # Create 2 seperate data frames for the TEST data and the TRAIN data

  #Create the Headers for all of the Data
DataHeaders <- read.table("Data/UCI HAR Dataset/features.txt")
Characters <- paste(DataHeaders[,2])
header <- c("ParticipantID", "Activity", Characters)


#dfTest <- data.frame(ParticipantID = numeric(2947), Activity = numeric(2947),TestData = numeric(2947))
dfTest <- cbind(Test.Subject,Test.Act.Labels,Test.Data)
dfTrain <- cbind(Train.Subject,Train.Act.Labels,Train.Data)
AllData <- rbind(dfTrain, dfTest)
#names(dfTest) <- header
#names(dfTrain) <- header
names(AllData) <- header

#2 Filter the observatons that contain mean() or std()

filtered <- AllData[, grepl("mean()|std()|ID|Activity" , names(AllData),fixed=FALSE)]

#3 & 4 Adding descriptive activity labels

labels <- readLines("Data/UCI HAR Dataset/activity_labels.txt")
i <- 0
for (i in 1:length(filtered[,1])) {
  for (j in 1:6){
    if (filtered[i,2] == j) { 
     filtered[i,2] <- labels[j]
    }}}

#5 create a second, independent tidy data set with the average of each variable for each activity and each subject. 

Tidy <- ddply(melt(filtered, id.vars=c("ParticipantID", "Activity")), .(ParticipantID,Activity), summarise, ReadingMean=mean(value))

#Write tidy dataset to file

write.csv(Tidy, file = "Tidy.txt",row.names = FALSE)

write.csv(tidy.mean, file = "tidy.mean.txt",row.names = FALSE)
