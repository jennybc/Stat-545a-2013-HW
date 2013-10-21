# We create two containers one to hold the data and another for ploting purposes and to perform other applications on our data without altering the data. Doing so we demonstrate the inheritance structure in our coding scheme.
main.plot.en <- new.env()
plot.en <- new.env(parent=main.plot.en)

# We load the cleaned (binned) data.
evalq({
  adult.data <- read.table("adult_clean_binned.txt", header=TRUE)
}, main.plot.en)

# In our dataset, we identify some kind of relationships or correlations between the observations of continous variables. Let us explore the relationships between numerical variables using a tree-like structure known as a dendrogram. For this, we need to load the following packages:
require(plyr)
require(grid)
require(ggplot2)
require(ggdendro)

# We first identify the numerical variables and then perform correlation between them. Afterwards, we apply hclust function to the results in order to create an object with hierarchical structure that will be used to plot dendrogram.
evalq({
  numerics <- c(1,5,11:13)
  cr <-cor(x=adult.data[numerics],use="pairwise",method="pearson")
  hc <- hclust(dist(cr),method='average')
  ddata <- dendro_data(hc)
  
  plot <- ggplot() + geom_segment(data = segment(ddata), 
                                  aes_string(x = "x", y = "y", xend = "xend", 
                                             yend = "yend"),colour="grey",
                                  lwd = 1)
  plot <- plot + geom_text(data = label(ddata), 
                           aes_string(x = "x", y = "y", label = "label"),
                           fontface=3, colour= "tomato", cex = 3.5, hjust = 1,
                           vjust=0, angle = 0) 
  plot <- plot + scale_y_continuous(expand=c(0.2, 0)) 
  plot <- plot + labs(title="Variable Correlation Clusters\nadult data using Pearson") 
  plot <- plot + theme_bw()+ theme(axis.ticks = element_blank(), 
                                   axis.text.y = element_blank())
  plot <- plot + geom_hline(data = segment(ddata),xintercept = "x", 
                            colour = "orange") + ylab(NULL) + xlab(NULL)
  plot <- plot + coord_flip()
  png(filename="dendrogram.png",units="in", width=9, height= 6, res=300)
  print(plot)
  dev.off()
  },envir=plot.en)

# The plot lists the variables in the left column. The variables are then linked together according to the strength of their relationships. The range of x-axis, (0, 1.5), gives an indication of the level of correlation between variables, with shorter heights indicating stronger correlations. We can observe that hoursPerWeek and educationNum are closely correlated. The variables age and capitalLoss have some higher level of correlation amongst themselves.
# Although, the above correlation defines the relationships between the numerical data, this does not provide true information because much of our data are missing and replaced by 0. But to illustrate the correlation, we plot the relationship between hours per week with the education level ignoring the whether information is accurate or not. 
evalq({
  plot <- ggplot(data=adult.data, aes(x=hoursPerWeek,
                                      y=educationNum,colour=hoursPerWeek)) 
  plot <- plot + geom_point(alpha = 1/10) 
  plot <- plot + ggtitle("Hours per Week vs Level of Education")
  plot <- plot + stat_smooth(method="lm", se=FALSE, colour = "red", size = 1)
  plot <- plot + xlab("Education Level") + ylab("Hours per Week") 
  plot <- plot + theme(legend.position="none") 
  png(filename="hoursWeek_educationNum.png", units="in", width=9, height= 6, res=300)
  print(plot)
  dev.off()
},envir=plot.en)