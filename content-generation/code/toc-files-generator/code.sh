#!/bin/bash

# ============================================================
# Script: generate_toc_content.sh
# Purpose: Scrape directory for ALL TOC files, combine with prompt,
#          and send requests to LiteLLM server
# Usage:   ./generate_toc_content.sh /path/to/search-directory
# ============================================================

SEARCH_DIR="$1"
PROMPT_FILE="/home/mahmoud-taher/git-repos/tutorials-notes/content-generation/file-structure-prompt.md"

if [ -z "$SEARCH_DIR" ]; then
    echo "[ERROR] Usage: $0 /path/to/search-directory"
    exit 1
fi

# --- Load additional prompt ---
if [ ! -f "$PROMPT_FILE" ]; then
    echo "[ERROR] Prompt file not found: $PROMPT_FILE"
    exit 1
fi
PROMPT_CONTENT=$(cat "$PROMPT_FILE")

# --- Find ALL TOC files ---
TOC_FILES=$(find "$SEARCH_DIR" -type f -iname "*toc*.md")

if [ -z "$TOC_FILES" ]; then
    echo "[ERROR] No TOC files found in $SEARCH_DIR"
    exit 1
fi

# --- Loop over each TOC file ---
for TOC_FILE in $TOC_FILES; do
    BASENAME=$(basename "$TOC_FILE" .md)
    OUTPUT_FILE="$(dirname "$TOC_FILE")/${BASENAME}-files-generation.md"

    # --- Skip if output file already exists ---
    if [ -f "$OUTPUT_FILE" ]; then
        echo "[INFO] Skipping $TOC_FILE (already has $OUTPUT_FILE)"
        continue
    fi

    echo "[INFO] Processing TOC file: $TOC_FILE"

    # --- Load TOC contents ---
    TOC_CONTENT=$(cat "$TOC_FILE")

    # --- Build final prompt ---
    FINAL_PROMPT="Table of Contents from $TOC_FILE:\n$TOC_CONTENT\n\nAdditional Prompt:\n$PROMPT_CONTENT"

    echo "[DEBUG] Sending request for $TOC_FILE at $(date)"
    RESPONSE=$(jq -n \
      --arg model "gemini/gemini-3-pro-preview" \
      --arg prompt "$FINAL_PROMPT" \
      '{
        model: $model,
        messages: [{role: "user", content: $prompt}]
      }' | \
      curl -s http://localhost:5839/v1/chat/completions \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer sk-5GGsADJtfvKKY38sRmCHvg" \
        -d @- | jq -r '.choices[0].message.content')

    echo "[DEBUG] Response received for $TOC_FILE"

    # --- Save response ---
    if [ -n "$RESPONSE" ]; then
        echo "$RESPONSE" > "$OUTPUT_FILE"
        echo "[INFO] Response written to $OUTPUT_FILE"
    else
        echo "[ERROR] Empty response for $TOC_FILE, skipping write."
    fi
done

echo "[INFO] Processing complete."
