I have a structured Table of Contents (TOC) for a study guide. 
I want you to generate a bash script that I can run on Ubuntu to automatically create a directory and file hierarchy based on this TOC.

Requirements:
1. Each "Part" in the TOC should become a directory. 
   - Directories must be numbered sequentially starting with 001, 002, 003, etc.
   - The directory name should include the Part number and a short descriptive title (e.g., "001-Observability-Fundamentals").
   
2. Each "Section" (A, B, C, etc.) inside a Part should become a file.
   - Files must be numbered sequentially within their Part (001, 002, 003, etc.).
   - The filename should include the section number and a short descriptive title (e.g., "001-Introduction-to-Observability.md").
   - Use `.md` extension for Markdown files.

3. Inside each file:
   - The first line should be a Markdown H1 heading (`#`) with the section title.
   - Optionally, include the bullet points from the TOC under that heading as starter content.
   -  don't add any descriptions please

4. The script should:
   - Create a root directory (e.g., "OpenTelemetry-Study").
   - Create all numbered subdirectories and files inside it.
   - Use `mkdir` for directories and `echo` for file content.

5. The output must be a complete bash script that I can copy, paste, and run directly in Ubuntu.

Here is my TOC:
[PASTE YOUR TOC HERE]

Generate the bash script according to these rules.
