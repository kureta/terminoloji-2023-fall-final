# Variables
TEX_FILE = src/report.tex
REF_FILE = src/bibliography/references.bib
BUILD_DIR = build
OUT_DIR = output
BASE_NAME = $(basename $(notdir $(TEX_FILE)))
BBLFILE = $(BUILD_DIR)/$(BASE_NAME).bbl
PDF_OUT = $(OUT_DIR)/$(BASE_NAME).pdf
PDF_BUILT = $(BUILD_DIR)/$(BASE_NAME).pdf

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
	lualatex -output-directory=$(BUILD_DIR) $(TEX_FILE)
	biber --input-directory $(BUILD_DIR) --output-directory $(BUILD_DIR) $(BASE_NAME)

# Final lualatex runs to integrate bibliography
$(PDF_BUILT): $(TEX_FILE) $(BBLFILE)
	lualatex -output-directory=$(BUILD_DIR) $(TEX_FILE)
	# First run says `Package biblatex Warning: Please rerun LaTeX.`
	lualatex -output-directory=$(BUILD_DIR) $(TEX_FILE)

$(PDF_OUT): $(PDF_BUILT) | $(OUT_DIR)
	cp $(PDF_BUILT) $(PDF_OUT)

# Clean up auxiliary files
clean:
	rm -rf $(BUILD_DIR)
	rm -rf $(OUT_DIR)

.PHONY: all clean
