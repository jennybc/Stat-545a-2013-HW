# As we did before, we create an environment to hold the data.
main.variable.en <- new.env()

# We load the cleaned binned data.
evalq({
  adult.data <- read.table("adult_clean_binned.txt", header=TRUE)
}, main.variable.en)

# We keep certain variables in our data and remove the redundant ones as follows:
evalq({
  adult.data <- data.frame(adult.data[,c("age", "workclass", "education", "educationNum", "maritalStatus", "occupation", "relationship", "race", "sex", "nativeCountry")])
},main.variable.en)

# We save the resulting data into a different text file
evalq({
  write.table(adult.data, "adult_clean_selected.txt", sep = "\t", row.names = FALSE)
},main.variable.en)