# For a particular project, we usually end up analyzing a collection of data, transforming it and storing different forms of information about the data. It is convenient to introduce encapsulation which packages all of our data into a container that is used at a later time and thus protecting our raw data. In this project, we use R's environment concept and give it a name as below:
main.en <- new.env()

# After that, data is placed into the container and we can access the data using $ notations. However, to operate on variables within an environment without using the $ notation we can use evalq(). For example, let us load our data in main.en container and assign the variables with suitable names as follows:
evalq({  
  adult.data <- read.table("adult_raw.txt")
  #adult.data <- read.table("adult_raw.txt", sep = ",", strip.white = TRUE)
  names(adult.data) <- c("age", "workclass", "fnlwgt", "education", "educationNum", "maritalStatus", "occupation", "relationship", "race", "sex", "capitalGain", "capitalLoss", "hoursPerWeek", "nativeCountry", "grossIncome")
}, main.en)

# We remove "," from each value in the data and change the mode of the following variables to numerics: age, fnlwgt, educationNum, capitalGain, capitalLoss, and hoursPerWeek
evalq({
  adult.data$age <- as.numeric(gsub(",","", adult.data$age))
  adult.data$workclass <- gsub(",","", adult.data$workclass)
  adult.data$fnlwgt <- as.numeric(gsub(",","", adult.data$fnlwgt))
  adult.data$education <- gsub(",","", adult.data$education)
  adult.data$educationNum <- as.numeric(gsub(",","", adult.data$educationNum))
  adult.data$maritalStatus <- gsub(",","", adult.data$maritalStatus)
  adult.data$occupation <- gsub(",","", adult.data$occupation)
  adult.data$relationship <- gsub(",","", adult.data$relationship)
  adult.data$race <- gsub(",","", adult.data$race)
  adult.data$sex <- gsub(",","", adult.data$sex)
  adult.data$capitalGain <- as.numeric(gsub(",","", adult.data$capitalGain))
  adult.data$capitalLoss <- as.numeric(gsub(",","", adult.data$capitalLoss))
  adult.data$hoursPerWeek <- as.numeric(gsub(",","", adult.data$hoursPerWeek))
  adult.data$nativeCountry <- gsub(",","", adult.data$nativeCountry)
  adult.data$grossIncome <- gsub(",","", adult.data$grossIncome)
},main.en)

# Our data is already being cleaned and the missing values are filled with either '?', for categorial values, or 0, for numerical data. However, we treate any '?' as missing values and remove them from the data.
evalq({
  adult.data$workclass <- gsub("[?]", NA, adult.data$workclass)
  adult.data$education <- gsub("[?]", NA, adult.data$education)
  adult.data$maritalStatus <- gsub("[?]", NA, adult.data$maritalStatus)
  adult.data$occupation <- gsub("[?]", NA, adult.data$occupation)
  adult.data$relationship <- gsub("[?]", NA, adult.data$relationship)
  adult.data$race <- gsub("[?]", NA, adult.data$race)
  adult.data$sex <- gsub("[?]", NA, adult.data$sex)
  adult.data$nativeCountry <- gsub("[?]", NA, adult.data$nativeCountry)
  adult.data <- na.omit(adult.data)
},main.en)

# Now, let us explore the transformed data to discover various insightful knowledge such as dimensions, the variables names, its boundaries, its characteristics...etc.
evalq({
  head(adult.data)
  tail(adult.data)
  dim(adult.data) 
  names(adult.data)
  str(adult.data)
  summary(adult.data)
},main.en)

# To obtain more detailed summary of the numerical data, we apply the basicStats() function from fBasics package.
require(fBasics)
evalq({
  basicStats(adult.data$age)
},main.en)

# We save the cleaned data for the purpose of analysis
evalq({
  write.table(adult.data, "adult_clean.txt", sep = "\t", row.names = FALSE)
},main.en)