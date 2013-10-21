# As we did before, we create an environment to hold the data.
main.selected.en <- new.env()

# We load the cleaned data.
evalq({
  adult.data <- read.table("adult_clean.txt", header=TRUE)
  }, main.selected.en)

# In analyzing data, it is very useful to transform continuous numeric variables into a specific set of meaningful categoric values for subsequent analysis especially to reduce the effects of minor observation errors. This operation is called binning. Lets apply binning to our age variable by first recording the range of this continous data.
evalq({
  print(range(adult.data$age))
  },main.selected.en)

# We observe that the range of age in our dataset is 17 and maximum is 90. Therefore, we apply binning to age variable to categorize it into four distinct intervals that are chosen subjectively as follows:
evalq({
  adult.data$agedesc = ifelse(test = adult.data[,"age"] <= 22, yes = "youth", no = ifelse(test = adult.data[,"age"] > 22 & adult.data[,"age"]  <= 35, yes = "adult", no = ifelse(test = adult.data[,"age"] > 35 & adult.data[,"age"] <= 55, yes = "adultToOld", no = "old")))
},main.selected.en)

# We save the resulting data into a different text file
evalq({
  write.table(adult.data, "adult_clean_binned.txt", sep = "\t", row.names = FALSE)
},main.selected.en)