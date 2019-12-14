#1
#Зчитуємо тестовий набір данних
test_x<-read.table("UCI HAR Dataset/test/X_test.txt")
test_y<-read.table("UCI HAR Dataset/test/y_test.txt")

#Зчитуємо навчальний набір данних
train_x<-read.table("UCI HAR Dataset/train/X_train.txt")
train_y<-read.table("UCI HAR Dataset/train/y_train.txt")

#Зчитуємо файл з назвами стовпців та обробляємо його
col_names<-read.table("UCI HAR Dataset/features.txt")
names_col<-t(col_names)[2, ]

#Зчитуємо інформації про суб'єктів, які виконували діяльність з тестових данних 
subject_test<-read.table("UCI HAR Dataset/test/subject_test.txt")
#Зчитуємо інформації про суб'єктів, які виконували діяльність з навчальних данних 
subject_train<-read.table("UCI HAR Dataset/train/subject_train.txt")


#Об’єднуємо навчальний та тестовий набори
test<-cbind(subject_test, test_y, test_x)
train<-cbind(subject_train, train_y, train_x)
all_data<-rbind(train, test)
colnames (all_data)<-c("SubjectID", "Activity", names_col)


#2
#Вибір стовпців, що містять середнє значення та стандартне відхилення (mean and standard deviation)
mean_std<-all_data[ , grep("-mean\\(\\)|-std\\(\\)", colnames(all_data))]

#Додаємо стовпці "SubjectID" та "Activity"
mean_std<-cbind(all_data$SubjectID, all_data$Activity, mean_std)
colnames(mean_std)[1:2]<-c("SubjectID", "Activity")

#3
#Використовуємо описові назви діяльностей (activity) для найменування діяльностей у наборі даних
mean_std$ActivityName <- factor(mean_std$Activity,
                                levels = c(1,2,3,4,5,6),
                                labels = c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING")
)
mean_std<-subset(mean_std,select = c(SubjectID, Activity, ActivityName, 3:68))

#4
#Присвоюємо змінним у наборі даних описові імена.
colnames(mean_std) <- gsub("^t", "Time", colnames(mean_std))
colnames(mean_std) <- gsub("^f", "Frequency", colnames(mean_std))
colnames(mean_std) <- gsub("Acc", "Accelerometer", colnames(mean_std))
colnames(mean_std) <- gsub("Gyro", "Gyroscope", colnames(mean_std))
colnames(mean_std) <- gsub("Mag", "Magnitude", colnames(mean_std))

#5
#Створення набору даних із всіх данних
means<-aggregate(.~SubjectID+ActivityName, mean_std, mean)

#Зберігамо все в.csv
write.csv(means, "tidy_dataset.csv", row.names=F)