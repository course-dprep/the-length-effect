R      := Rscript --vanilla
MAKE   := make
DP     := src/data-preparation
AN     := src/analysis
DATA   := data
TEMP   := gen/temp
OUT    := gen/output


.PHONY: all data-preparation analysis report clean help

all: analysis  

data-preparation:  ## Run data-preparation pipeline
	$(MAKE) -C $(DP)

analysis: data-preparation  ## Run analysis after data-prep
	$(MAKE) -C $(AN)