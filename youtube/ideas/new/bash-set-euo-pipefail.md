# The One Bash Trick Every Developer Should Know: `set -euo pipefail`

**Category**: DevOps / Shell Scripting
**Difficulty**: Beginner
**Estimated Duration**: 60 sec (Short)
**Date Proposed**: 2026-03-15
**Source Inspiration**: `software/shell-bash/toc.md` — Shell scripting best practices and error handling

---

## Introduction
By default, a bash script silently swallows errors and keeps running. Every CI/CD pipeline script, deployment script, and automation tool should start with three flags that make bash fail loudly and stop immediately — saving you from partial deployments and silent data corruption.

---

## Body

### Key Points to Cover
1. The problem with default bash — a failed command (e.g., a typo in a filename, a missing directory) returns a non-zero exit code, bash ignores it, and the script continues as if nothing happened
2. `-e` — exit immediately when any command returns a non-zero exit code
3. `-u` — treat any reference to an undefined variable as an error and exit (catches typos like `$ENVIROMENT` instead of `$ENVIRONMENT`)
4. `-o pipefail` — if any command in a pipe (`cmd1 | cmd2`) fails, the whole pipe fails; without it, only the exit code of the last command in the pipe is checked
5. The one-liner to memorise: put `set -euo pipefail` on line 2 of every bash script, right after the shebang

### Suggested Code Examples / Demos
- Script without the flags: `cp important-file.txt /wrong/path/` followed by `rm important-file.txt` — the copy fails silently, the delete succeeds, data is lost
- Same script with `set -euo pipefail` — stops at the failed `cp`, file is safe
- Undefined variable demo: `echo $UNDEFINED_VAR` — with `-u` this errors immediately instead of printing an empty string

### Common Pitfalls / Misconceptions
- `set -e` alone is not enough — a failing command inside a pipe still passes without `-o pipefail`
- "My script uses intentional failures" — wrap expected-to-fail commands with `|| true` to explicitly opt out: `risky_command || true`
- Thinking this is only for advanced scripts — this is a first-line safety net for any script, beginner or expert

---

## Conclusion / Footer
Three flags, one line, zero excuses. Add `set -euo pipefail` to every bash script you write from today. Viewer challenge: open the last bash script you wrote — does it have this line? If not, add it now.

---

## Notes for Production
- Thumbnail idea: a bash script with a bright red `set -euo pipefail` highlighted on line 2
- Related video to mention: bash pipes and redirection, writing CI/CD pipeline scripts
- Note: `set -u` can break scripts that intentionally use unset variables — show the `${VAR:-default}` pattern as the safe alternative
