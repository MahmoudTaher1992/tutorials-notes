#!/bin/bash

# ============================================================
# Script: generate_content.sh
# Purpose: Automate content generation for description files
# Usage:   ./generate_content.sh toc.txt descriptions/
# ============================================================

TOC_PATH="$1"
DESC_PATH="$2"

# --- Load TOC content ---
TOC_CONTENT=$(cat "$TOC_PATH")
echo "[DEBUG] TOC loaded from: $TOC_PATH"
echo "[DEBUG] Description files root directory: $DESC_PATH"

# --- Traverse all nested files ---
find "$DESC_PATH" -type f | while read -r file; do
    echo "[DEBUG] Checking file: $file"

    # --- Count lines in the file ---
    line_count=$(wc -l < "$file")
    echo "[DEBUG] Line count for $file = $line_count"

    # --- Skip files with more than 20 lines ---
    if [ "$line_count" -gt 20 ]; then
        echo "[INFO] Skipping $file (already has content)"
        continue
    fi

    # --- Build relative path for prompt ---
    REL_PATH=$(realpath --relative-to="$DESC_PATH" "$file")
    PROMPT="Can you please explain this part in details ? $REL_PATH\n\nTable of Contents:\n$TOC_CONTENT"

    # --- Debugging: show only first 6 lines of prompt ---
    echo "[DEBUG] Prompt prepared for $file:"
    echo "--------"
    echo "$PROMPT" | head -n 6
    echo "..."
    echo "--------"

    # --- Send request to LiteLLM server on localhost using Gemini 3 Pro ---
    echo "[DEBUG] Sending request at $(date)"
    RESPONSE=$(jq -n \
      --arg model "gemini/gemini-3-pro-preview" \
      --arg prompt "$PROMPT" \
      '{
        model: $model,
        messages: [{role: "user", content: $prompt}]
      }' | \
      curl -s http://localhost:5839/v1/chat/completions \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer sk-5GGsADJtfvKKY38sRmCHvg" \
        -d @- | jq -r '.choices[0].message.content')
    echo "[DEBUG] Response received at $(date)"


    # --- Debugging: show preview of response ---
    echo "[DEBUG] Response preview:"
    echo "${RESPONSE:0:100}..."

    # --- Save response back into file ---
    if [ -n "$RESPONSE" ]; then
        echo "$RESPONSE" > "$file"
        echo "[INFO] Content written to $file"
    else
        echo "[ERROR] Empty response for $file, skipping write."
    fi
done

echo "[INFO] Processing complete."
