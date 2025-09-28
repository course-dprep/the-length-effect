R=Rscript --vanilla
S=src/analysis

.PHONY: all clean download explore prep analysis

# Run the whole pipeline (ends with analysis)
all: analysis

# 1) Download raw IMDb data  -> two RDS files
data/raw/title_basics.rds data/raw/title_ratings.rds: $(S)/download_data.R
	$(R) $(S)/download_data.R

# 2) Data exploration/cleaning -> two cleaned RDS files
data/explore/title_basics_clean.rds data/explore/title_ratings_clean.rds: \
	$(S)/data_exploration.R \
	data/raw/title_basics.rds data/raw/title_ratings.rds
	$(R) $(S)/data_exploration.R

# 3) Data preparation/merge -> one processed RDS
data/processed/movies_prepared.rds: \
	$(S)/data_preparation.R \
	data/explore/title_basics_clean.rds data/explore/title_ratings_clean.rds
	$(R) $(S)/data_preparation.R

# 4) Data analysis (no artifact; just run after processed data exists)
analysis: $(S)/data_analysis.R data/processed/movies_prepared.rds
	$(R) $(S)/data_analysis.R

# Convenience targets
download: data/raw/title_basics.rds data/raw/title_ratings.rds
explore:  data/explore/title_basics_clean.rds data/explore/title_ratings_clean.rds
prep:     data/processed/movies_prepared.rds

# Clean generated files
clean:
	rm -f data/raw/*.rds data/explore/*.rds data/processed/*.rds
