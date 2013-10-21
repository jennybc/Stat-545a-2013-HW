# We create two containers one to hold the data and another for ploting purposes and to perform other applications on our data without altering the data. Doing so we demonstrate the inheritance structure in our coding scheme.
main.plot.en <- new.env()
plot.en <- new.env(parent=main.plot.en)

# We load the cleaned (binned) data.
evalq({
  adult.data <- read.table("adult_clean_binned.txt", header=TRUE)
  }, main.plot.en)

# We require the following packages.
require(plyr)
require(ggplot2)

# Let us plot our first figure which depicts the education level per gender
evalq({
  edulevelPergender <- ddply(.data = adult.data,
                             .variables= ~ educationNum + sex, 
                             .fun = function(x){count <- nrow(x)
                                                return(data.frame(count))
                                                })
  plotbar <- ggplot(adult.data, aes(x=factor(education),fill=factor(sex)))
  plotbar <- plotbar + ggtitle("Education level per gender") 
  plotbar <- plotbar + geom_bar(position="dodge") + coord_flip() 
  plotbar <- plotbar + xlab("Education") + ylab("Number of observations")
  plotbar <- plotbar + scale_fill_discrete(name = "Gender")
  png(filename="barplot_educationByobs.png", units="in", width=9, height= 6, 
      res=300)
  print(plotbar)
  dev.off()
  }, envir=plot.en)

# We see that the above figure does not represent the ratio of each gender with the level of education in the dataset for that particular gender. Therefore, we use proportions of each gender in the dataset according to their level of education and re-plot the results.
evalq({
  nPerSex <- count(df=adult.data, ~ sex)
  adult.data.modified <- ddply(adult.data, ~ education + sex, 
                               summarise,proportion= length(education))
  adult.data.modified$proportion = ifelse(test= adult.data.modified$sex=="Male"
                                          ,yes=adult.data.modified$proportion
                                          /nPerSex$freq[2], 
                                          no=adult.data.modified$proportion
                                          /nPerSex$freq[1])
  plotbarprop <- ggplot(adult.data.modified, aes(x=factor(education),
                                                 y=proportion, 
                                                 fill=factor(sex)))
  plotbarprop <- plotbarprop + ggtitle("Education level per gender")
  plotbarprop <- plotbarprop + geom_bar(position = "dodge") + coord_flip()
  plotbarprop <- plotbarprop + xlab("Education") + ylab("Proportion")
  plotbarprop <- plotbarprop + scale_fill_discrete(name = "Gender")
  png(filename="barplot_educationByobsprop.png", units="in", width=9, 
      height= 6, res=300)
  print(plotbarprop)
  dev.off()
  }, envir=plot.en)

# Now, we observe similar proportions for each gender with the level of education. In fact, females are more educated in some levels such as at 11th grade. This piece of information did not reveal to us in our previous figure.

# We use boxplot that provides a graphical overview of how the observations of a particular variable, age in our case, are distributed per gender.
evalq({
  plotbox <- ggplot(adult.data) + aes(x= factor(agedesc),y = age) 
  plotbox <- plotbox + geom_boxplot(aes(fill=sex),outlier.colour="red",
                                    outlier.shape=4)
  plotbox <- plotbox + ggtitle("Education level with Age per gender")
  plotbox <- plotbox + xlab("Education") + ylab("Age")
  plotbox <- plotbox + scale_fill_discrete(name = "Gender") +  coord_flip() 
  png(filename="boxplot_educationByage.png", units="in", width=9, height= 6, 
      res=300)
  print(plotbox)
  dev.off()
  }, envir=plot.en)

# Here we plot education level with specific age intervals.
evalq({
  p1 <- ggplot(adult.data) + aes(education, fill= factor(sex)) 
  p1 <- p1 + ggtitle("Education level with each Age interval per gender")
  p1 <- p1 + geom_bar() + xlab("Education") + ylab("Number of observations")
  p1 <- p1 + scale_fill_discrete(name = "Gender") + coord_flip() 
  p1 <- p1 + facet_wrap(~ agedesc) 
  png(filename="barplot_educationByagedesc.png", units="in", width=9, 
      height= 6, res=300)
  print(p1)
  dev.off()
  }, envir=plot.en)

# Plotting the number of educated people based on their ethnicity.
evalq({
  p2 <- ggplot(adult.data) + aes(education, fill= race) 
  p2 <- p2 + ggtitle("Education level with Race")
  p2 <- p2 + geom_bar() + xlab("Education") + ylab("Number of observations")
  p2 <- p2 + scale_fill_brewer("Race") + coord_flip()  
  png(filename="barplot_educationByrace.png", units="in", width=9, height= 6, 
      res=300)
  print(p2)
  dev.off()
  }, envir=plot.en)

# Gradient colors are not a convenient solution in plotting the above figure. We plot the status of relationships with level of educations and we use palette option:
evalq({
  p3 <- ggplot(adult.data) + aes(education, fill= maritalStatus)
  p3 <- p3 + ggtitle("Education level with Marital Status")
  p3 <- p3 + geom_bar() + xlab("Education") + ylab("Number of observations")
  p3 <- p3 + scale_fill_brewer("Marital Status",palette="Dark2") + coord_flip()
  png(filename="barplot_educationBymarital.png", units="in", width=9, 
      height= 6, res=300)
  print(p3)
  dev.off()
  }, envir=plot.en)

#  Exploring the type of employment with level of educations:
evalq({
  p4 <- ggplot(adult.data) + aes(education, fill= workclass) 
  p4 <- p4 + ggtitle("Education level with Employment type")
  p4 <- p4 + geom_bar() + xlab("Education") + ylab("Number of observations")
  p4 <- p4 + scale_fill_brewer("Work Class",palette="Dark2")+ coord_flip()
  png(filename="barplot_educationByemptype.png", units="in", width=9, 
      height= 6, res=300)
  print(p4)
  dev.off()
  }, envir=plot.en)

# gridExtra is an interesting package that puts several figures onto one panel. As an example:
require(gridExtra)
evalq({
  png(filename="allInone.png", units="in", width=12, height= 8, res=300)
  print(grid.arrange(plotbox,p2, p3, p4, ncol=2, main="Plotting in one panel"))
  dev.off()
  },envir=plot.en)