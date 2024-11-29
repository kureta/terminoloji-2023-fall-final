# Variables
TEXFILE = src/report.tex
REF_FILE = src/bibliography/references.bib
BUILD_DIR = build
OUT_DIR = output
BASEFILE = $(basename $(notdir $(TEXFILE)))
BCFFILE = $(BUILD_DIR)/$(BASEFILE).bcf
BBLFILE = $(BUILD_DIR)/$(BASEFILE).bbl
PDF_OUT = $(OUT_DIR)/$(BASEFILE).pdf
PDF_BUILT = $(BUILD_DIR)/$(BASEFILE).pdf

# Default target
all: $(PDF_OUT)

# Create build directory
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Create out directory
$(OUT_DIR):
	mkdir -p $(OUT_DIR)

# Biber run to process the bibliography
$(BBLFILE): $(REF_FILE) | $(BUILD_DIR)
	lualatex -output-directory=$(BUILD_DIR) $(TEXFILE)
	biber --input-directory $(BUILD_DIR) --output-directory $(BUILD_DIR) $(BASEFILE)

# Final lualatex runs to integrate bibliography
$(PDF_BUILT): $(TEXFILE) $(BBLFILE)
	lualatex -output-directory=$(BUILD_DIR) $(TEXFILE)

$(PDF_OUT): $(PDF_BUILT) | $(OUT_DIR)
	cp $(PDF_BUILT) $(PDF_OUT)

# Clean up auxiliary files
clean:
	rm -rf $(BUILD_DIR)
	rm -rf $(OUT_DIR)

.PHONY: all clean
