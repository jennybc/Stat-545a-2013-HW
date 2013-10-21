## one Makefile to make them all

all : aggregatePlot	mapPlot	dendrogramPlot	rmdToHtml

adult_clean : 01_dataTransformation.R
	Rscript 01_dataTransformation.R

adult_clean_binned : adult_clean 02_variableBining.R
	Rscript 02_variableBining.R

adult_clean_selected : adult_clean_binned 03_variableSelections.R
	Rscript 03_variableSelections.R

aggregatePlot : adult_clean_binned 04_aggregatePlot.R
	Rscript 04_aggregatePlot.R

mapPlot : adult_clean_selected 05_mapPlot.R
	Rscript 05_mapPlot.R

dendrogramPlot : adult_clean_binned 06_dendrogramPlot.R
	Rscript 06_dendrogramPlot.R;	rm -rf *.pdf

rmdToHtml: all stat545a-2013-hw06_mohdabulbasher-abd.Rmd
	Rscript -e "knitr::knit2html('stat545a-2013-hw06_mohdabulbasher-abd.Rmd')";	rm -r stat545a-2013-hw06_mohdabulbasher-abd.md

.PHONY : clean
clean :
	rm -rf adult_clean*.txt *.png *.pdf *.md *.html figure