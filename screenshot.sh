#!/bin/zsh
# Set the directory where screenshots will be saved
output_dir=~/Documents/Screenshots
mkdir -p "$output_dir"

# Activate Python virtual environment for spaCy
source ~/spacy_env/bin/activate

# Ensure Tesseract is linked inside the venv
if [ ! -x "$VIRTUAL_ENV/bin/tesseract" ]; then
    echo "[DEBUG] Tesseract not found in venv, linking..."
    ln -sf "$(which tesseract)" "$VIRTUAL_ENV/bin/tesseract"
fi

# Temporary filename based on date/time
temp_filename="screenshot-$(date +%Y%m%d-%H%M%S).png"
temp_filepath="${output_dir}/${temp_filename}"

# Take interactive screenshot (user selects the area)
screencapture -i "${temp_filepath}"

# If the user cancels the screenshot (file does not exist), exit silently to prevent Automator errors
if [ ! -f "${temp_filepath}" ]; then
    rm -f "${temp_filepath}"  # Ensure no leftover files
    exit 0  # Exit gracefully so Automator doesn't complain
fi

# Check if Tesseract is installed inside venv
if [ -x "$VIRTUAL_ENV/bin/tesseract" ]; then
    echo "[DEBUG] Tesseract found in venv. Running OCR..."

    # Run Tesseract OCR on the screenshot and capture output
    ocr_text=$("$VIRTUAL_ENV/bin/tesseract" "${temp_filepath}" stdout 2>/dev/null)

    # Remove any debug-related text before passing it to spaCy
    ocr_text=$(echo "$ocr_text" | sed '/DEBUG_/d')

    # Use spaCy to extract meaningful keywords, remove stopwords & duplicates
    semantic_filename=$(python3 <<EOF
import sys
import spacy

try:
    # Load spaCy model
    nlp = spacy.load('en_core_web_sm')

    # Read input text from Bash
    text = """${ocr_text}""".strip()

    # Process OCR text with spaCy
    doc = nlp(text)

    # Extract meaningful nouns and proper nouns, remove stopwords & deduplicate
    unique_keywords = list(dict.fromkeys(
        [token.text.strip().replace(' ', '_') for token in doc if not token.is_stop and token.pos_ in ["NOUN", "PROPN"]]
    ))

    # Limit to max 5 words
    keywords = unique_keywords[:5]

    # Join keywords into a single string
    result = '_'.join(keywords) if keywords else 'screenshot'

    # Trim filename to 70 characters max
    result = result[:70].rstrip('_')

    # Print the final filename for shell use
    print(result)

except Exception as e:
    print('screenshot')  # Fallback name if spaCy fails
EOF
)

    # Sanitize filename (remove non-alphanumeric characters)
    semantic_filename=$(echo "$semantic_filename" | tr ' ' '_' | sed 's/[^A-Za-z0-9_-]//g')

    # Limit filename length to max 70 characters
    semantic_filename=$(echo "$semantic_filename" | cut -c1-70)

    # Fallback if filename is empty
    if [ -z "$semantic_filename" ]; then
        semantic_filename="screenshot-$(date +%Y%m%d-%H%M%S)"
    fi

    # Rename the screenshot file
    new_filepath="${output_dir}/${semantic_filename}.png"

    # Move the file and check if mv succeeds
    if mv "${temp_filepath}" "${new_filepath}"; then
        echo "Screenshot successfully saved as ${new_filepath}"
    else
        echo "Failed to rename the screenshot. Using default name."
    fi
else
    echo "[ERROR] Tesseract is not installed in the virtual environment."
    echo "Screenshot saved as ${temp_filepath}"
fi