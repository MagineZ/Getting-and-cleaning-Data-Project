downloads data and unzips/n
loads features.txt for the name of features
loads X_train.txt, y_train.txt, subject_train.txt
X_train using the name of features as columns
y_train contains the activity labels
subject_train contains the ids
Merge train id, activity, and features as a table: train 
loads X_test.txt, y_test.txt, subject_test.txt
X_test using the name of features as columns
y_test contains the activity labels
subject_test contains the ids
Merge test id, activity, and features as a table: test
rearrange the data using id
loads activity_labels.txt
changes the data activity row to use the activity labels
saves the mean and std into mean_and_std.txt
saves the tidy dataset into tidy_dataset.txt
