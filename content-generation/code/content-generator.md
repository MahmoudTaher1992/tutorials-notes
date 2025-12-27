Got it 👍 — you want a script that automates content generation by iterating over description files, checking if they’re empty (≤3 lines), and then sending a structured prompt (with the TOC attached + relative path) to an AI, saving the response back into the file. Let me break this down step by step and give you a working example.

---

## 🛠️ Key Requirements
1. **Inputs:**
   - Path to Table of Contents file (`toc.txt`).
   - Path to directory containing description files.

2. **Logic:**
   - Iterate over all files in the description path.
   - Skip files with more than 3 lines.
   - For each valid file:
     - Create a prompt:  
       `"Can you please explain this part in details ? <relative_path>"`  
       + attach TOC contents.
     - Send prompt to AI (e.g., via `curl` to OpenAI/Microsoft Copilot API).
     - Save the response back into the file.

---

## ⚡ Example Bash Script

```bash
#!/bin/bash

# Paths
TOC_PATH="$1"          # First argument: path to TOC file
DESC_PATH="$2"         # Second argument: path to description files directory

# Read TOC content once
TOC_CONTENT=$(cat "$TOC_PATH")

# Iterate over files in description path
for file in "$DESC_PATH"/*; do
    # Skip if not a regular file
    [ -f "$file" ] || continue

    # Count lines
    line_count=$(wc -l < "$file")

    if [ "$line_count" -gt 3 ]; then
        echo "Skipping $file (already has content)"
        continue
    fi

    # Build prompt
    REL_PATH=$(realpath --relative-to="$DESC_PATH" "$file")
    PROMPT="Can you please explain this part in details ? $REL_PATH\n\nTable of Contents:\n$TOC_CONTENT"

    echo "Processing $file..."

    # Call AI API (example with OpenAI, replace with your endpoint/token)
    RESPONSE=$(curl -s https://api.openai.com/v1/chat/completions \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer $OPENAI_API_KEY" \
      -d "{
        \"model\": \"gpt-4.1-mini\",
        \"messages\": [{\"role\": \"user\", \"content\": \"$PROMPT\"}]
      }" | jq -r '.choices[0].message.content')

    # Save response back into file
    echo "$RESPONSE" > "$file"
done
```

---

## 🔑 Notes
- Replace `https://api.openai.com/v1/chat/completions` with the endpoint you’re using (Copilot, Azure OpenAI, etc.).
- Requires:
  - `jq` for parsing JSON.
  - `realpath` for relative paths.
- Usage:
  ```bash
./generate_content.sh /Users/taher/Desktop/github/tutorials-notes/software/Prometheus/toc.md /Users/taher/Desktop/github/tutorials-notes/software/Prometheus/Prometheus-Study
  ```
- Safety check: skips files with >3 lines.

---

## 🚀 Next Steps
Would you like me to adapt this into **Python** instead of Bash? Python gives you more flexibility (error handling, retries, logging, etc.), while Bash is lightweight but harder to extend.  

👉 Do you prefer a **minimal Bash one-liner style** or a **robust Python script** with better control?