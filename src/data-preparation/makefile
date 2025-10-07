DATA := ../../data
TEMP := ../../gen/temp

.PHONY: all
all: $(DATA)/title_basics.csv $(DATA)/title_ratings.csv

#Step 1: Download data
$(DATA)/title_basics.csv $(DATA)/title_ratings.csv: download_data.R
	R -e "dir.create('$(DATA)')"
	Rscript --vanilla download_data.R
	
#Step 2:Clean data
$(TEMP)/title_basics_clean.csv: clean_data.R $(DATA)/title_basics.csv 
$(TEMP)/title_ratings_clean.csv: clean_data.R $(DATA)/title_ratings.csv
	R -e "dir.create('$(TEMP)', recursive = T)"
	Rscript --vanilla clean_data.R