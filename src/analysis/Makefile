SHELL := /usr/bin/sh
ROOT  ?= ../..
OUT  := ../../gen/output
TEMP := ../../gen/temp
PAPER := ../../paper/output
A := ../../src/analysis

.PHONY: all
all: $(PAPER)/Final_result_lm.png

$(PAPER)/Final_result_lm.png: lm_main_effect.R $(OUT)/movies_final_clean.csv
	Rscript -e "dir.create('$(PAPER)')"
	Rscript --vanilla lm_main_effect.R

clean: 
	R -e "unlink('../../gen/out', recursive = TRUE)"
	R -e "unlink('../../paper/output', recursive = TRUE)"