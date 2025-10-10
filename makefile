# ---- Makefile (root, no sub-make) ----
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
MAKEFLAGS += --no-builtin-rules
.ONESHELL:

ROOT  := .
DP    := $(ROOT)/src/data-preparation
DATA  := $(ROOT)/data
GEN   := $(ROOT)/gen
TEMP  := $(GEN)/temp
OUT   := $(GEN)/output
PAPER := $(ROOT)/paper/output

export PROJECT_ROOT := $(abspath $(ROOT))

# артефакты
RAW_BAS   := $(DATA)/title.basics.csv
RAW_RATE  := $(DATA)/title.ratings.csv
CLEAN_BAS := $(TEMP)/title.basics_clean.csv
CLEAN_RATE:= $(TEMP)/title.ratings_clean.csv
FIL_BAS   := $(TEMP)/title.basics_filtered.csv
MERGED    := $(TEMP)/merged_data.csv
FINAL     := $(OUT)/movies_final_clean.csv
REPORT    := $(PAPER)/report.html

.PHONY: all report clean
.DEFAULT_GOAL := all

all: $(REPORT)

# директории
$(DATA) $(GEN) $(TEMP) $(OUT) $(PAPER):
	mkdir -p $@

# 1) download
$(RAW_BAS) $(RAW_RATE): $(DP)/download_data.R | $(DATA)
	Rscript --vanilla "$(DP)/download_data.R"

# 2) clean
$(CLEAN_BAS) $(CLEAN_RATE): $(DP)/clean_data.R $(RAW_BAS) $(RAW_RATE) | $(TEMP)
	Rscript --vanilla "$(DP)/clean_data.R"

# 3) filter
$(FIL_BAS) $(MERGED): $(DP)/filter_data.R $(CLEAN_BAS) $(CLEAN_RATE) | $(TEMP)
	Rscript --vanilla "$(DP)/filter_data.R"

# 4) merge
$(FINAL): $(DP)/merge_data.R $(FIL_BAS) $(CLEAN_RATE) | $(OUT)
	Rscript --vanilla "$(DP)/merge_data.R"
	@test -f "$@" || { echo "ERROR: expected artifact not found: $@"; exit 1; }

# 5) report (force HTML, no LaTeX)
$(REPORT): $(FINAL) | $(PAPER)
	Rscript -e "dir.create('$(PAPER)', recursive = TRUE, showWarnings = FALSE); \
	            rmarkdown::render('Deliverables_updated.Rmd', \
	                              output_format = 'html_document', \
	                              output_file   = 'report.html', \
	                              output_dir    = '$(PAPER)')"

report: $(REPORT)

clean:
	Rscript -e "unlink('$(DATA)',  recursive = TRUE, force = TRUE)"
	Rscript -e "unlink('$(GEN)',   recursive = TRUE, force = TRUE)"
	Rscript -e "unlink('$(PAPER)', recursive = TRUE, force = TRUE)"
