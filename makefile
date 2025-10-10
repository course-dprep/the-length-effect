ifeq ($(OS),Windows_NT)
  SHELL := /usr/bin/sh    # Git Bash / RTools on Windows
else
  SHELL := /bin/sh        # macOS/Linux
endif

ROOT  ?= .
DP	:= $(ROOT)/src/data-preparation
AN	:= $(ROOT)/src/analysis
DATA	:= $(ROOT)/data
GEN	:= := $(ROOT)/gen
TEMP	:= $(ROOT)/gen/temp
OUT	:= $(ROOT)/gen/output
PAPER	:= $(ROOT)/paper/output


.PHONY: all data-preparation analysis report clean help

all: analysis  

data-preparation:  ## Run data-preparation pipeline
	$(MAKE) -C $(DP)

analysis: data-preparation  ## Run analysis after data-prep
	$(MAKE) -C $(AN)
	
clean:
	R -e "unlink('DATA',  recursive=TRUE, force=TRUE)"
	R -e "unlink('GEN',  recursive=TRUE, force=TRUE)"
	R -e "unlink('PAPER', recursive=TRUE, force=TRUE)"