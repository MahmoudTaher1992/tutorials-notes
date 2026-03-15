# The Art of the Small PR: Why Nobody Reviews Your Giant Pull Requests

**Category**: Backend / Engineering Practice
**Difficulty**: Beginner
**Estimated Duration**: 60 sec (Short)
**Date Proposed**: 2026-03-15
**Source Inspiration**: `software/code-review/best-practices-toc.md` — Part III.A, The Art of the Small PR; Part II.C, PR Size Guidelines

---

## Introduction
The single biggest driver of slow, low-quality code review is PR size. Reviewers skim large PRs, miss real bugs, and delay approvals — and the data consistently shows that smaller, focused pull requests get reviewed faster, more thoroughly, and merged with fewer defects.

---

## Body

### Key Points to Cover
1. The reviewer psychology problem — a 1200-line PR triggers cognitive overload; reviewers rubber-stamp rather than genuinely review, and context-switching cost makes them deprioritise it
2. The 400-line rule of thumb — PRs over ~400 lines of changed code see a steep drop in review quality; most experienced teams aim for 200 lines or fewer per PR
3. One PR, one concern — a PR should answer one question: "what problem does this solve?" If it solves two problems it should be two PRs
4. How to split a large feature — vertical slicing: PR 1 adds the data model, PR 2 adds the API endpoint, PR 3 adds the UI; each is independently reviewable and deployable
5. The hidden benefit — smaller PRs are easier to revert when something goes wrong in production

### Suggested Code Examples / Demos
- Show a GitHub PR diff with 1200 lines — scroll past it quickly to make the volume visceral
- Show the same feature split into three focused PRs of ~200 lines each
- A PR description template: "What: ..., Why: ..., How to test: ..." — one sentence each

### Common Pitfalls / Misconceptions
- "I can't split this, it's all one feature" — most features can be split by layer (data, logic, presentation) even if they feel coupled
- "Small PRs create more overhead" — the overhead of one extra PR open is far less than the cost of a missed bug or a week-long review delay
- Confusing PR size with commit size — these are separate concerns; a PR can have many small commits

---

## Conclusion / Footer
Reviewers are humans with limited attention. Give them 200 lines with clear context and they will find every bug. Give them 1200 lines and they will approve it just to clear the queue. Keep PRs small, focused, and easy to revert.

---

## Notes for Production
- Thumbnail idea: a scale — tiny PR with a green checkmark on one side, giant PR with a clock/hourglass on the other
- Related video to mention: writing good commit messages, code review best practices for reviewers
