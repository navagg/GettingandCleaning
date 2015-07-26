# GettingandCleaning

## In the run_analysis.R
#### First note that: I have put UCI HAR dataset into data folder. So path used in R file is same. if you change that then path need to be changed accordingly.
#### I first loaded data.table and reshape2
#### Then I read features and extracted mean or std using grepl command.
#### Then I read activities.txt
####I then loaded both training and testing data
#### I have given them labels and then extracted mean and std values
#### I coulmn bind train data and test data
#### test and train data is then row bind to get one dataset.
#### I used melt and dcast function to generate finally tidy_data, which i finally wrote into file.


#### Details about variables is in codebook.txt file
