# We create two containers one to hold the data and another for ploting purposes and to perform other applications on our data without altering the data. Doing so we demonstrate the inheritance structure in our coding scheme.
main.plot.en <- new.env()
plot.en <- new.env(parent=main.plot.en)

# We load the cleaned (selected) data.
evalq({
  adult.data <- read.table("adult_clean_selected.txt", header=TRUE)
}, main.plot.en)

# We load the following packages.
require(plyr)
require(ggplot2)
require(ggmap)
require(mapproj)

# We copy map data into plot.en container
evalq({
  map.world <- map_data(map = "world")
},envir=plot.en)

# Let us draw a map using ggplot2. We first note that the countries in adult data need to be mapped with regions in the map data. Therefore, several issues need to be handled properly:
#1- some countries in our data does not exist in map data, for example Scotland. We merge these countries with their closest neighbours.
#2- names of countries are different or abbreviated in both data, for example USA is used in map data and it is renamed to United-States in adult data.
#3- countries in adult data are misspelled or are not complete, for example in our data there is a country named by south but we do not have enough information to guess whether it is the south korea or the south africa. Another example, the country Outlying-US(Guam-USVI-etc) does not have any proper match with map data.
evalq({
  adult.data$nativeCountry <- gsub("(Outlying-US\\(Guam-USVI-etc\\))", NA, adult.data$nativeCountry)
  adult.data$nativeCountry <- gsub("England", "UK", adult.data$nativeCountry)
  adult.data$nativeCountry <- gsub("Scotland", "UK", adult.data$nativeCountry)
  adult.data$nativeCountry <- gsub("Hong", "China", adult.data$nativeCountry)
  adult.data$nativeCountry <- gsub("Taiwan", "China", adult.data$nativeCountry)
  adult.data$nativeCountry <- gsub("Trinadad&Tobago", "Tobago", adult.data$nativeCountry)
  adult.data$nativeCountry <- gsub("United-States", "USA", adult.data$nativeCountry)
  adult.data$nativeCountry <- gsub("Puerto-Rico", "Puerto Rico", adult.data$nativeCountry)
  adult.data$nativeCountry <- gsub("Holand-Netherlands", "Netherlands", adult.data$nativeCountry)
  adult.data$nativeCountry <- gsub("El-Salvador", "El Salvador", adult.data$nativeCountry)
  adult.data$nativeCountry <- gsub("Dominican-Republic", "Dominican Republic", adult.data$nativeCountry)
  adult.data$nativeCountry <- gsub("Columbia", "Colombia", adult.data$nativeCountry)
  adult.data$nativeCountry <- gsub("South", "South Korea", adult.data$nativeCountry)
  adult.data <- na.omit(adult.data)
},plot.en)

# After we address the above shortcomings let's begin to plot our first world map.
evalq({
  plot <- ggplot(map.world, aes(x = long, y = lat, group = group, 
                                fill = region))
  plot <- plot + ggtitle("World, filled with regions")
  plot <- plot + geom_polygon() + theme(legend.position="none")
  plot <- plot + xlab("Longitude") + ylab("Latitude")
  png(filename="worldmap.png", units="in", width=9, height= 6, res=300)
  print(plot)
  dev.off()
},envir=plot.en)

# Interestingly, we can also represent the filled countries that are only recorded in adult data as follows:
evalq({
  map.world$availableCountry <- ifelse(test=map.world$region %in% 
                                       adult.data$nativeCountry,yes="yes",
                                       no="no")
  
  plot <- ggplot(map.world, aes(x = long, y = lat, group = group, 
                                fill = availableCountry))
  plot <- plot + ggtitle("World, filled with interested countries")
  plot <- plot + geom_polygon() + theme(legend.position="none") 
  plot <- plot + xlab("Longitude") + ylab("Latitude")
  png(filename="worldmap_interestedcountries.png", units="in", width=9, 
      height= 6, res=300)
  print(plot)
  dev.off()
  },envir=plot.en)

# Let us perform more fancy work by plotting the world map according to the median age per country.
evalq({
  tmp.df <- ddply(adult.data, ~ nativeCountry, summarise, 
                  medianAge=median(age), meanAge = mean(age))
  map.world <- merge(x=map.world, y=tmp.df, by.x= "region", by.y="nativeCountry",all=TRUE)
  map.world$medianAge[is.na(map.world$medianAge)] <- 0 # other countries median
                                                       # are set to 0
  map.world$meanAge[is.na(map.world$meanAge)] <- 0     # other countries mean
                                                       # are set to 0
  map.world <- arrange(map.world,order)   # We need to sort the map.world data 
                                          # according to the order variable for    
                                          # the purpose of plotting 
  plot <- ggplot(map.world, aes(x = long, y = lat, group = group, 
                                fill =medianAge))
  plot <- plot + ggtitle("Median age for specific countries")
  plot <- plot + geom_polygon() + scale_fill_gradientn("Median Age",
                                                       colours=rainbow(7),
                                                       limits=c(10,60))
  plot <- plot + xlab("Longitude") + ylab("Latitude")
  png(filename="worldmap_medianAge.png", units="in", width=9, height= 6, 
      res=300)
  print(plot)
  dev.off()
  },envir=plot.en)