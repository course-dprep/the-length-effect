.PHONY: all clean

# paths relative to THIS file (we are in src/data-preparation)
ROOT := ../..
DATA := $(ROOT)/data
TEMP := $(ROOT)/gen/temp

# Build data-prep outputs from here
all: $(TEMP)/aggregated_df.csv

# Step 1: Download data (download.R is in THIS folder)
$(DATA)/listings.csv $(DATA)/reviews.csv: download.R
	Rscript -e "setwd('$(ROOT)'); dir.create('data', recursive = TRUE); source('src/data-preparation/download.R')"

# Step 2: Clean data (clean.R is in THIS folder)
$(TEMP)/aggregated_df.csv: clean.R $(DATA)/listings.csv $(DATA)/reviews.csv
	Rscript -e "setwd('$(ROOT)'); dir.create('gen/temp', recursive = TRUE); source('src/data-preparation/clean.R')"

