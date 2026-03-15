# `git stash`: Save Your Work in 1 Second Without Committing

**Category**: DevOps / Git
**Difficulty**: Beginner
**Estimated Duration**: 30 sec (Short)
**Date Proposed**: 2026-03-15
**Source Inspiration**: `software/git/general.md` — Part III.C, Undoing Mistakes — `stash` as a temporary holding area

---

## Introduction
You are halfway through a feature when a teammate asks you to fix a bug on a different branch right now. `git stash` saves all your uncommitted changes in one command and restores them just as fast — no half-baked commits, no lost work, no context juggling.

---

## Body

### Key Points to Cover
1. The problem — you have uncommitted changes on a feature branch but need to switch branches immediately; Git will not let you switch if there are conflicts, and committing a half-finished feature just to move branches pollutes history
2. `git stash` — snapshots all tracked modified and staged files and reverts the working directory to a clean state, matching the last commit
3. `git switch hotfix-branch` — now you can switch freely and do the urgent work
4. `git switch feature-branch && git stash pop` — returns to the feature branch and restores all stashed changes exactly as they were
5. Bonus: `git stash list` — shows all saved stashes if you forget you have one; `git stash drop` cleans up a stash you no longer need

### Suggested Code Examples / Demos
- Live terminal recording showing all three steps in sequence: stash, switch, fix, switch back, pop
- Show `git status` before stash (dirty working tree) and after stash (clean) — the visual contrast is the payoff
- Show `git stash list` output: `stash@{0}: WIP on feature/login: a1b2c3d Add login form`

### Common Pitfalls / Misconceptions
- `git stash` does not save untracked (new) files by default — use `git stash -u` to include untracked files
- Forgetting you have a stash — always run `git stash list` before starting new work on a branch if you have been stashing frequently
- Stash conflicts on pop — if the branch diverged while the stash was saved, `git stash pop` can produce a merge conflict just like a regular merge; resolve it normally

---

## Conclusion / Footer
Three commands, zero mess: `git stash` to save, switch branches and do the work, `git stash pop` to restore. No more fake commits, no more lost changes. Viewer challenge: next time you get interrupted mid-feature, reach for `git stash` instead of a "WIP" commit.

---

## Notes for Production
- Thumbnail idea: a half-built structure being paused and locked away, then resumed — or a terminal showing the clean `git status` after stashing
- Related video to mention: `git reset` soft vs. hard, writing good commit messages
- Keep the entire demo in the terminal — no slides needed, the commands speak for themselves
