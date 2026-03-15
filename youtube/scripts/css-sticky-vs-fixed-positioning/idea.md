# CSS `position: sticky` vs. `position: fixed`: The Difference Is the Scroll Container

**Category**: Frontend / CSS
**Difficulty**: Beginner / Intermediate
**Estimated Duration**: 60 sec (Short)
**Date Proposed**: 2026-03-15
**Source Inspiration**: `software/css/toc.md` — CSS positioning: sticky, fixed, relative, absolute

---

## Introduction
`sticky` and `fixed` both keep elements visible while the user scrolls, but developers waste hours debugging `sticky` that silently stops working because of one CSS rule on a parent element they never touched. Understanding the scroll container concept resolves this instantly.

---

## Body

### Key Points to Cover
1. `position: fixed` — positioned relative to the browser viewport; completely removed from the document flow; always visible regardless of scrolling; never affected by parent styles
2. `position: sticky` — positioned relative to its nearest scrolling ancestor (not always the viewport); stays within the bounds of its parent container; still part of the document flow
3. The one rule that breaks `sticky` silently — if any ancestor element has `overflow: hidden`, `overflow: auto`, or `overflow: scroll` set, that ancestor becomes the scroll container and `sticky` is constrained to it (often an invisible zero-height box)
4. How to debug it — open DevTools, inspect parent elements for any `overflow` value that is not `visible`; remove or change it, and `sticky` comes back to life
5. When to use each — `fixed`: global navbars, floating action buttons, cookie banners that must always be on screen. `sticky`: table headers, section headings that scroll with content until they reach the top

### Suggested Code Examples / Demos
- Side-by-side demo: a sticky header that works, then show the same with `overflow: hidden` on a parent — it disappears
- DevTools highlight: computed styles on the parent showing the offending `overflow` value
- Code snippet: `position: sticky; top: 0;` — note that `top` (or `left`/`right`/`bottom`) is required or sticky does nothing

### Common Pitfalls / Misconceptions
- Forgetting to set `top`, `left`, `bottom`, or `right` on a sticky element — without a threshold value, sticky never activates
- Expecting sticky to work outside its parent container — a sticky element stops at its parent's bottom edge by design
- Using `fixed` when you need `sticky` for a table header — `fixed` removes the element from flow and the table layout breaks

---

## Conclusion / Footer
`fixed` = always on screen, viewport-relative. `sticky` = scrolls normally until it hits a threshold, then sticks — but only within its scroll container. If your `sticky` is not working, the answer is almost always an `overflow` on a parent. Check it in DevTools.

---

## Notes for Production
- Thumbnail idea: side-by-side browser windows — one with a working sticky header, one with it missing after scrolling
- Related video to mention: CSS `position: absolute` vs. `relative`, CSS stacking context and `z-index`
