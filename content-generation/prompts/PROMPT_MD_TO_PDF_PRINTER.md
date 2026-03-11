# Prompt: Markdown → PDF Printer (Cornell Notes Style)

> Copy and paste the prompt below, replacing the placeholders in `[BRACKETS]`.
> This prompt produces print-ready, spiral-binding-friendly PDFs from a folder of `.md` files.

---

```
Convert all `.md` files in [SOURCE_DIRECTORY] to PDF and merge them into a single
combined PDF at [SOURCE_DIRECTORY]/[OUTPUT_FILENAME].pdf

## Constraints

- Do NOT install anything into the project repo or modify any project files
- Use a temporary Python virtual environment in /tmp (e.g. /tmp/md2pdf_env)
- Use a temporary directory (/tmp) for all intermediate HTML files
- All dependencies stay in /tmp and can be discarded after the session
- The only output written to the repo is the final .pdf files

## Dependencies to install in the venv

- markdown  — converts .md to HTML (pip install markdown)
- pypdf     — merges individual PDFs into one (pip install pypdf)
- Chrome headless is used for HTML → PDF rendering (no installation needed on macOS)

## Page Layout — Cornell Notes Style

The page is split into two columns:

  LEFT COLUMN (57% width)
  ┌─────────────────────────┐
  │  Content from markdown  │
  │  - bullet               │
  │  - bullet               │
  └─────────────────────────┘
           ║  (vertical divider)
  RIGHT COLUMN (43% width)
  ┌──────────────────────┐
  │                      │  ← blank, for handwritten notes
  │                      │
  └──────────────────────┘

- Left column: markdown content rendered with full typographic hierarchy
- Right column: completely blank white space for handwritten notes
- A bold vertical divider line separates the two columns
- Left binding margin: ~80px (protects text from spiral binding)

## Typography — JetBrains Mono

Font stack: 'JetBrains Mono' (Google Fonts) → 'SF Mono' → 'Menlo' → 'Monaco' → monospace

Font size hierarchy (decreasing with depth):
  H1  (file title)       : 22px, bold
  H2  (major section)    : 17px, bold,   + bottom border
  H3  (subsection)       : 14px, semibold
  H4  (component)        : 12px, semibold, muted color (#555)
  li  (bullet items)     : 11px
  code (inline)          : 10px, background #f0f0f0

Line height: 1.75 — generous for readability and note-taking margin

## PDF Settings

- No header (no page title, no date)
- No footer (no file path, no page number)
- No browser chrome artifacts
- @page margin: 0 (all spacing handled by CSS padding)
- Chrome flag: --no-pdf-header-footer

## Output

- One PDF per .md file:  [topic]_part_N.pdf
- One merged PDF:        [OUTPUT_FILENAME].pdf  (all parts in order)
- Print the total page count after merging

## Full Python Script

Write the script to /tmp/md2pdf.py with the following structure:

```python
import os, subprocess, markdown
from pypdf import PdfWriter

CHROME = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
SRC_DIR = "[SOURCE_DIRECTORY]"
OUT_DIR = SRC_DIR

CSS = """
  @import url('https://fonts.googleapis.com/css2?family=JetBrains+Mono:wght@400;600;700&display=swap');

  * { box-sizing: border-box; margin: 0; padding: 0; }
  @page { margin: 0; }

  body {
    font-family: 'JetBrains Mono', 'SF Mono', 'Menlo', 'Monaco', monospace;
    font-size: 11px; color: #1a1a1a; line-height: 1.75;
  }
  .page {
    display: flex; min-height: 100vh;
    padding: 36px 0 36px 80px;   /* 80px left = binding margin */
  }
  .content {
    width: 57%; padding-right: 28px;
    border-right: 2px solid #333; background: white;
  }
  .content h1  { font-size: 22px; font-weight: 700; border-bottom: 2px solid #333; padding-bottom: 6px; margin-bottom: 20px; }
  .content h2  { font-size: 17px; font-weight: 700; margin-top: 28px; margin-bottom: 4px; border-bottom: 1px solid #ccc; padding-bottom: 3px; }
  .content h3  { font-size: 14px; font-weight: 600; color: #2c3e50; margin-top: 20px; margin-bottom: 4px; }
  .content h4  { font-size: 12px; font-weight: 600; color: #555; margin-top: 14px; margin-bottom: 4px; }
  .content ul  { padding-left: 18px; margin: 3px 0 6px 0; }
  .content li  { margin: 2px 0; font-size: 11px; }
  .content strong { color: #c0392b; }
  .content code   { background: #f0f0f0; padding: 1px 4px; border-radius: 2px; font-size: 10px; }
  .content hr     { border: none; border-top: 1px solid #eee; margin: 16px 0; }
  .content blockquote { border-left: 3px solid #ccc; padding-left: 12px; color: #666; font-style: italic; margin: 8px 0; }
  .notes-col { flex: 1; background: white; }
"""

md_parser = markdown.Markdown(extensions=["tables", "fenced_code"])
files = sorted(f for f in os.listdir(SRC_DIR) if f.endswith(".md"))
pdf_paths = []

for fname in files:
    src      = os.path.join(SRC_DIR, fname)
    stem     = os.path.splitext(fname)[0]
    html_out = f"/tmp/{stem}.html"
    pdf_out  = os.path.join(OUT_DIR, f"{stem}.pdf")

    with open(src) as f:
        raw = f.read()

    md_parser.reset()
    body = md_parser.convert(raw)

    html = f"""<!DOCTYPE html><html><head><meta charset="utf-8">
<style>{CSS}</style></head>
<body><div class="page">
  <div class="content">{body}</div>
  <div class="notes-col"></div>
</div></body></html>"""

    with open(html_out, "w") as f:
        f.write(html)

    result = subprocess.run([
        CHROME,
        "--headless=new", "--no-sandbox", "--disable-gpu",
        "--no-pdf-header-footer",
        f"--print-to-pdf={pdf_out}",
        html_out
    ], capture_output=True, text=True)

    status = "✓" if result.returncode == 0 else "✗"
    print(f"{status} {fname} → {stem}.pdf")
    if result.returncode == 0:
        pdf_paths.append(pdf_out)

# Merge
merged = os.path.join(OUT_DIR, "[OUTPUT_FILENAME].pdf")
writer = PdfWriter()
for p in pdf_paths:
    writer.append(p)
with open(merged, "wb") as f:
    writer.write(f)
print(f"\n✓ Merged → [OUTPUT_FILENAME].pdf ({writer.get_num_pages()} pages)")
```

## Setup Commands

Run in this exact order:

```bash
# 1. Create isolated venv in /tmp (discarded on reboot)
python3 -m venv /tmp/md2pdf_env

# 2. Install dependencies
/tmp/md2pdf_env/bin/pip install markdown pypdf --quiet

# 3. Write the script to /tmp/md2pdf.py (fill in placeholders first)

# 4. Run
/tmp/md2pdf_env/bin/python3 /tmp/md2pdf.py
```

## Configurable Parameters (quick reference)

| Parameter          | Location in script       | Default       | Notes                              |
|--------------------|--------------------------|---------------|------------------------------------|
| Left binding margin| `.page` padding-left     | `80px`        | Increase for wider spiral binding  |
| Content width      | `.content` width         | `57%`         | Decrease to give more notes space  |
| Base font size     | `body` font-size         | `11px`        | Scale all sizes proportionally     |
| Line height        | `body` line-height       | `1.75`        | More space between lines = easier to read |
| Divider color      | `.content` border-right  | `#333`        | Change to lighter grey if preferred|
| Highlight color    | `.content strong` color  | `#c0392b`     | Red — for **Unique:** markers      |
| Notes column blank | `.notes-col` background  | `white`       | Set to lined: repeating-linear-gradient |

## Variations

### Add ruled lines to the notes column
Replace `.notes-col` styles with:
```css
.notes-col {
  flex: 1;
  background-image: repeating-linear-gradient(
    to bottom, transparent, transparent 30px, #d0d0d0 30px, #d0d0d0 31px
  );
  background-position: 0 31px;
}
```

### Dark theme (for digital reading, not printing)
```css
body { background: #1e1e1e; color: #d4d4d4; }
.content { background: #1e1e1e; border-right-color: #555; }
.notes-col { background: #252526; }
.content h1, .content h2 { border-color: #555; color: #e8e8e8; }
.content h3 { color: #9cdcfe; }
.content h4 { color: #808080; }
.content strong { color: #f48771; }
.content code { background: #2d2d2d; color: #ce9178; }
```

### Wider binding margin (e.g. for 3-hole punch)
Change `.page` padding-left from `80px` to `110px`.

## Platform Notes

- macOS: Chrome path is `/Applications/Google Chrome.app/Contents/MacOS/Google Chrome`
- Linux: Chrome path is typically `/usr/bin/google-chrome` or `/usr/bin/chromium-browser`
- Windows: Chrome path is `C:\Program Files\Google\Chrome\Application\chrome.exe`
  and use `--headless` instead of `--headless=new` for older versions
```

---

## Example Usage

```
Convert all `.md` files in:
  /Users/taher/Desktop/github/tutorials-notes/software/backend/caching/toc-anthropic

to PDF, merge into: caching_complete.pdf

Source directory: /Users/taher/Desktop/github/tutorials-notes/software/backend/caching/toc-anthropic
Output filename:  caching_complete
```
