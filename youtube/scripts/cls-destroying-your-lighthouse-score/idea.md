# What Is CLS and Why Is It Destroying Your Lighthouse Score?

**Category**: Frontend / Performance
**Difficulty**: Beginner / Intermediate
**Estimated Duration**: 60 sec (Short)
**Date Proposed**: 2026-03-15
**Source Inspiration**: `software/performance/lighthouse/toc.md` — Part I.C, Core Web Vitals — CLS (Cumulative Layout Shift)

---

## Introduction
Cumulative Layout Shift is the Core Web Vital that catches most developers off guard — your page looks fine in your browser, but real users are mis-clicking buttons and losing their reading position because elements are jumping around while the page finishes loading.

---

## Body

### Key Points to Cover
1. What CLS measures — the total amount of unexpected visual movement of page elements during the page's lifetime, scored 0 to 1 (lower is better; good is below 0.1)
2. The most common cause — images without explicit `width` and `height` attributes: the browser allocates no space, content loads and pushes everything down
3. Second most common cause — dynamically injected content (ads, banners, cookie notices) inserted above existing content after the page has rendered
4. The fix for images — always set explicit `width` and `height` on `<img>` tags or use `aspect-ratio` in CSS to reserve the correct space before the image loads
5. The fix for dynamic content — reserve space with a fixed-height placeholder, or inject content below the fold only

### Suggested Code Examples / Demos
- Screen recording or GIF: page loading with an image that has no dimensions — content jumps down visibly
- Before/after HTML: `<img src="hero.jpg">` vs. `<img src="hero.jpg" width="800" height="400">`
- Lighthouse report screenshot showing a poor CLS score with the offending elements highlighted

### Common Pitfalls / Misconceptions
- "CLS only matters for images" — late-loading fonts, web fonts causing FOUT, and injected UI elements all contribute to CLS
- "My page loads fast so CLS must be fine" — CLS and LCP are independent metrics; fast loading does not prevent layout shifts
- Confusing CLS with LCP (loading speed) or INP (interactivity) — each Core Web Vital measures a distinct dimension of user experience

---

## Conclusion / Footer
CLS is the one metric that directly causes users to click the wrong thing. Two-line fix: add `width` and `height` to every image, and never inject content above existing page content after load. Open your Lighthouse report today and check your CLS score — a good score is 0.1 or below.

---

## Notes for Production
- Thumbnail idea: a "BUY NOW" button visually jumping away from a cursor just before a click
- Related video to mention: LCP optimisation, lazy loading images
- Lighthouse tool link to include in description: web.dev/measure
