#!/bin/bash

# ============================================================
# Script: summarize_files.sh
# Purpose: Iterate over nested files, append content to prompts,
#          send request to LiteLLM server, save summaries
# Usage:   ./summarize_files.sh /path/to/search-directory
# ============================================================

SEARCH_DIR="$1"

# --- Hardcoded prompt file paths (replace with real ones) ---
PROMPT_FILE_1="/home/mahmoud-taher/git-repos/tutorials-notes/content-generation/prompts/summarizing.md"
PROMPT_FILE_2="/home/mahmoud-taher/git-repos/lumina-notes/AI/prompts/studying/tools/summarization/concise/prompt.md"
PROMPT_FILE_3="/home/mahmoud-taher/git-repos/lumina-notes/AI/prompts/studying/tools/studying/guidelines.md"

# --- Validate input ---
if [ -z "$SEARCH_DIR" ]; then
    echo "[ERROR] Usage: $0 /path/to/search-directory"
    exit 1
fi

# --- Check prompt files exist ---
for PROMPT_FILE in "$PROMPT_FILE_1" "$PROMPT_FILE_2" "$PROMPT_FILE_3"; do
    if [ ! -f "$PROMPT_FILE" ]; then
        echo "[ERROR] Prompt file not found: $PROMPT_FILE"
        exit 1
    fi
done

PROMPT_CONTENT_1=$(cat "$PROMPT_FILE_1")
PROMPT_CONTENT_2=$(cat "$PROMPT_FILE_2")
PROMPT_CONTENT_3=$(cat "$PROMPT_FILE_3")

# --- Find ALL markdown files ---
FILES=$(find "$SEARCH_DIR" -type f -iname "*.md")

if [ -z "$FILES" ]; then
    echo "[ERROR] No markdown files found in $SEARCH_DIR"
    exit 1
fi

# --- Loop over each file ---
for FILE in $FILES; do
    BASENAME=$(basename "$FILE" .md)
    OUTPUT_FILE="$(dirname "$FILE")/${BASENAME}.summary.md"

    # --- Skip if output file already exists ---
    if [ -f "$OUTPUT_FILE" ]; then
        echo "[INFO] Skipping $FILE (already has $OUTPUT_FILE)"
        continue
    fi

    echo "[INFO] Preparing to process file: $FILE"

    # --- Countdown 3 → 1 ---
    for i in {3..1}; do
        echo "[INFO] Processing starts in $i..."
        sleep 1
    done

    # --- Load file contents ---
    FILE_CONTENT=$(cat "$FILE")

    # --- Build final prompt ---
    FINAL_PROMPT="File: $FILE\n\n$FILE_CONTENT\n\n---\nPrompt 1:\n$PROMPT_CONTENT_1\n\nPrompt 2:\n$PROMPT_CONTENT_2\n\nPrompt 3:\n$PROMPT_CONTENT_3"

    echo "[DEBUG] Sending request for $FILE at $(date)"
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

    echo "[DEBUG] Response received for $FILE"

    # --- Save response ---
    if [ -n "$RESPONSE" ]; then
        echo "$RESPONSE" > "$OUTPUT_FILE"
        echo "[INFO] Summary written to $OUTPUT_FILE"
    else
        echo "[ERROR] Empty response for $FILE, skipping write."
    fi
done

echo "[INFO] Processing complete."
