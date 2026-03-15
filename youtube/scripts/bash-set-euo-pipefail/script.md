# Every Bash Script Needs This Line

**Tone:** Serious / Educational
**Duration:** ~30 seconds

| Sentence | Type |
|----------|------|
| By default, bash silently swallows errors and keeps running. | Hook |
| One line makes every bash script fail loudly instead of quietly. | Title Reveal |
| Add `set -euo pipefail` as line two of every bash script you write. | Introduction |
| `-e` exits the script the moment any command fails. | Body – Point 1 |
| `-u` treats any undefined variable as an error and stops immediately. | Body – Point 2 |
| `-o pipefail` makes a failing pipe command fail the entire pipeline. | Body – Point 3 |
| Without these flags, a failed copy can silently delete your source file. | Conclusion |
| Open your last bash script — does line two have `set -euo pipefail`? | CTA |
