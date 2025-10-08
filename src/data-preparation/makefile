ROOT := ../..
DATA := ../../data
TEMP := ../../gen/temp
OUT := ../../gen/output

.PHONY: all
all: $(OUT)/movies_final_clean.csv

#Step 1: Download data
$(DATA)/title.basics.csv $(DATA)/title.ratings.csv: download_data.R
	Rscript -e "dir.create('$(DATA)')"
	Rscript --vanilla download_data.R
	
#Step 2:Clean data
$(TEMP)/title.basics_clean.csv $(TEMP)/title.ratings_clean.csv: clean_data.R $(DATA)/title.basics.csv $(DATA)/title.ratings.csv
	Rscript -e "dir.create('$(TEMP)', recursive = TRUE, showWarnings = FALSE)"
	Rscript --vanilla clean_data.R

#Step 3: Filter data
$(TEMP)/title.basics_filtered.csv $(TEMP)/title.ratings_clean.csv: filter_data.R $(TEMP)/title.basics_clean.csv $(TEMP)/title.ratings_clean.csv
	Rscript -e "dir.create('$(TEMP)', recursive = TRUE, showWarnings = FALSE)"
	Rscript --vanilla filter_data.R
	
# Step 4: Final merged DATA
$(OUT)/movies_final_clean.csv: merge_data.R  $(TEMP)/title.basics_filtered.csv $(TEMP)/title.ratings_clean.csv
	Rscript -e "dir.create('$(OUT)', recursive = TRUE, showWarnings = FALSE)"
	Rscript --vanilla merge_data.R 
	
clean:
    R -e "unlink('../../data', recursive = TRUE)"
    R -e "unlink('../../gen/temp', recursive = TRUE)"