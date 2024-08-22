# Variables
TEXFILE = report.tex
OUTDIR = build
BASEFILE = $(basename $(TEXFILE))
BCFFILE = $(OUTDIR)/$(BASEFILE).bcf
TEXOUT = $(OUTDIR)/$(BASEFILE).pdf

# Default target
all: $(TEXOUT)

# Create output directory
$(OUTDIR):
	mkdir -p $(OUTDIR)

# Initial lualatex run to generate .bcf file
$(BCFFILE): $(TEXFILE) | $(OUTDIR)
	lualatex -output-directory=$(OUTDIR) $(TEXFILE)

# Biber run to process the bibliography
bibliography: $(BCFFILE)
	biber --input-directory $(OUTDIR) --output-directory $(OUTDIR) $(BASEFILE)

# Final lualatex runs to integrate bibliography
$(TEXOUT): bibliography
	lualatex -output-directory=$(OUTDIR) $(TEXFILE)
	lualatex -output-directory=$(OUTDIR) $(TEXFILE)

# Clean up auxiliary files
clean:
	rm -rf $(OUTDIR)

.PHONY: all clean bibliography
