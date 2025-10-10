<<<<<<< HEAD
ifeq ($(OS),Windows_NT)
  SHELL := /usr/bin/sh    # Git Bash / RTools on Windows
else
  SHELL := /bin/sh        # macOS/Linux
endif

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

=======
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

>>>>>>> e257472105d9e65f249447f2ab2d4671cd381cce
clean: 
	R -e "unlink('../../gen/out', recursive = TRUE)"
	R -e "unlink('../../paper/output', recursive = TRUE)"