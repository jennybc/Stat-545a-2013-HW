STAT 545A Homework 6
========================================================
In this project, we will use adult data set which is available from this [`website`](http://archive.ics.uci.edu/ml/datasets/Adult). The data is already being transformed and cleaned. However, we need to perform further cleanings to demonstrate the results that we obtained.

### How to replicate my analysis?
* Download the following files into an empty directory:

    - Input data: [`adult_raw.txt`](https://github.com/atante/Stat-545a-2013-HW/blob/master/adult_raw.txt)
    - Scripts: [`01_dataTransformation.R`](https://github.com/atante/Stat-545a-2013-HW/blob/master/01_dataTransformation.R), [`02_variableBining.R`](https://github.com/atante/Stat-545a-2013-HW/blob/master/02_variableBining.R), [`03_variableSelections.R`](https://github.com/atante/Stat-545a-2013-HW/blob/master/03_variableSelections.R), [`04_aggregatePlot.R`](https://github.com/atante/Stat-545a-2013-HW/blob/master/04_aggregatePlot.R), [`05_mapPlot.R`](https://github.com/atante/Stat-545a-2013-HW/blob/master/05_mapPlot.R), and [`06_dendrogramPlot.R`](https://github.com/atante/Stat-545a-2013-HW/blob/master/06_dendrogramPlot.R)
    - Makefile: [`Makefile`](https://github.com/atante/Stat-545a-2013-HW/blob/master/Makefile)
    - R `markdown` file: [`stat545a-2013-hw06_mohdabulbasher-abd.Rmd`](https://github.com/atante/Stat-545a-2013-HW/blob/master/stat545a-2013-hw06_mohdabulbasher-abd.Rmd)

* After you have downloaded all the files, you can manage to run scripts that does the followings:

    - Transforming the `adult` data.
    - Plotting simple figures using `ggplot2`.
    - Plotting world map using `ggplot2`.
    - Plotting dendrogram using `ggplot2`.
    - Creating HTML from R `markdown`.
    
### Transforming the `adult` data
* We have three scripts that perform cleanings:

    - `01_dataTransformation.R`. This script cleans the raw data `adult_raw.txt`. To run this script, in a shell write `make adult_clean`. You should see a new data named by [`adult_clean.txt`](https://github.com/atante/Stat-545a-2013-HW/blob/master/adult_clean.txt).
    - `02_variableBining.R`. This script performs age binning on `adult_clean.txt`. Thus it depends on `01_dataTransformation.R`. The resulted data is required by `04_aggregatePlot.R` and `06_dendrogramPlot.R`. To run this script, in a shell write `make adult_clean_binned`. You should see a new data named by [`adult_clean_binned.txt`](https://github.com/atante/Stat-545a-2013-HW/blob/master/adult_clean_binned.txt).
    - `03_variableSelections.R`. This script selects important variables and removes the redundant ones on `adult_clean_binned.txt`. Thus it depends on `02_variableBining.R`. This data is required by `05_mapPlot.R`. To run this script, in a shell write `make adult_clean_selected`. You should see a new data named by [`adult_clean_selected.txt`](https://github.com/atante/Stat-545a-2013-HW/blob/master/adult_clean_selected.txt).

### Plotting simple figures using `ggplot2`
* In a shell write `make aggregatePlot` and it will run `04_aggregatePlot.R` script that depends on `02_variableBining.R` script which subsequently depends on `01_dataTransformation.R`. You should see the followings:

    - [`allInone.png`](allInone.png) that illustrates on how to put several figures onto one panel.
    - [`barplot_educationByagedesc.png`](barplot_educationByagedesc.png) that represents education level with specific age intervals
    - [`barplot_educationByemptype.png`](barplot_educationByemptype.png) which represents the type of employment with level of educations.
    - [`barplot_educationBymarital.png`](barplot_educationBymarital.png) which represents the status of relationships with level of educations.
    - [`barplot_educationByobs.png`](barplot_educationByobs.png) which represents the education level per gender.
    - [`barplot_educationByobsprop.png`](barplot_educationByobsprop.png) which represents the proportions of each gender according to their level of education.
    - [`barplot_educationByrace.png`](barplot_educationByrace.png) which represents the number of educated people based on their ethnicity.
    - [`boxplot_educationByage.png`](boxplot_educationByage.png) which represents an overview of how the age variable is distributed with gender.

### Plotting world map using `ggplot2`    
* In a shell write `make mapPlot` and it will run `05_mapPlot.R` script that depends on `03_variableSelections.R` script which subsequently depends on `02_variableBining.R` and `01_dataTransformation.R`. You should see the followings:

    - [`worldmap.png`](worldmap.png) which represents the world map filled with regions.
    - [`worldmap_interestedcountries.png`](worldmap_interestedcountries.png) which represents the filled countries that are only recorded in adult data.
    - [`worldmap_medianAge.png`](worldmap_medianAge.png) which represents the world map according to the median age per country.


### Plotting dendrogram using `ggplot2`    
* In a shell write `make dendrogramPlot` and it will run `06_dendrogramPlot.R` script that depends on `02_variableBining.R` script which subsequently depends on `01_dataTransformation.R`. You should see the followings:

    - [`dendrogram.png`](dendrogram.png) a dendrogram figure that identifies correlations between the observations of continous variables.
    - [`hoursWeek_educationNum.png`](hoursWeek_educationNum.png) that demonstrates the relationship between hours per week with the education level.

### Creating HTML from R `markdown`.
To create this HTML file, give this command in a shell `make rmdToHtml` and you should see the html file [`stat545a-2013-hw06_mohdabulbasher-abd.html`](stat545a-2013-hw06_mohdabulbasher-abd.html).

### Conclusion
* To run all the scripts in one command, write in a shell `make` or `make all` and you should see after running the pipeline:

    - `adult_clean.txt`.
    - `adult_clean_binned.txt`.
    - `adult_clean_selected.txt`.
    - `allInone.png`.
    - `barplot_educationByagedesc.png`.
    - `barplot_educationByemptype.png`.
    - `barplot_educationBymarital.png`.
    - `barplot_educationByobs.png`.
    - `barplot_educationByobsprop.png`.
    - `barplot_educationByrace.png`.
    - `boxplot_educationByage.png`.
    - `worldmap.png`.
    - `worldmap_interestedcountries.png`.
    - `worldmap_medianAge.png`.
    - `dendrogram.png`.
    - `hoursWeek_educationNum.png`.
    
* To re-run the scripts or remove the outputs, write in a shell `make clean`.
