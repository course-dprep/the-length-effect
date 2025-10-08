ROOT := ../..
OUT  := ../../gen/output
TEMP := ../../gen/temp
PAPER := ../../paper/output
A := ../../src/analysis

.PHONY: all
all: $(PAPER)/Final_result_lm.pdf

$(PAPER)/Final_result_lm.pdf: $(A)/lm_main_effect.R $(OUT)/movies_final_clean.csv | $(PAPER)
	Rscript -e "dir.create('$(PAPER)')"
	Rscript --vanilla lm_main_effect.R

