# Tailwind Dark Mode: `media` vs. `class` Strategy — Which One Should You Use?

**Category**: Frontend / CSS
**Difficulty**: Beginner / Intermediate
**Estimated Duration**: 60-90 sec (Short)
**Date Proposed**: 2026-03-15
**Source Inspiration**: `software/css/tailwind.md` — Part III.E, Dark Mode configuration and usage strategies

---

## Introduction
Tailwind gives you two dark mode strategies and picking the wrong one means you either lose the ability to give users a manual toggle, or you ship unnecessary JavaScript on every page load. This Short settles the decision in under 90 seconds.

---

## Body

### Key Points to Cover
1. The `media` strategy — Tailwind applies dark mode styles automatically when the user's OS is set to dark mode; zero JavaScript required, no toggle possible
2. The `class` strategy — dark mode activates when a `dark` class is present on the `<html>` element; requires one line of JS to toggle, gives full programmatic control
3. How to configure each — one line in `tailwind.config.js`: `darkMode: 'media'` vs. `darkMode: 'class'`
4. The decision rule — no toggle needed? Use `media`. Need a toggle (or want to persist user preference)? Use `class`
5. Quick demo of the `class` toggle: `document.documentElement.classList.toggle('dark')`

### Suggested Code Examples / Demos
- Show `tailwind.config.js` for both strategies side by side
- A simple card component using `dark:bg-gray-900 dark:text-white` utility classes
- The three-line JS toggle button implementation for the `class` strategy

### Common Pitfalls / Misconceptions
- Forgetting to add `dark:` variants to components — the config alone does nothing without `dark:` utilities in markup
- Using `class` strategy without persisting the preference to `localStorage` — the toggle resets on page refresh
- Thinking `media` strategy can be overridden at runtime — it cannot; it is read-only from the OS

---

## Conclusion / Footer
One config line is all it takes, but the choice matters. `media` for zero-JS automatic respect of OS preference. `class` for a manual toggle with full control. Viewer challenge: check your `tailwind.config.js` right now — are you using the right strategy for your UX requirements?

---

## Notes for Production
- Thumbnail idea: split screen — moon icon (dark) on left, sun icon (light) on right, config snippet in center
- Related video to mention: Tailwind responsive breakpoints, CSS custom properties for theming
- Note: Tailwind v4 changes the dark mode config syntax slightly — worth mentioning if targeting v4 users
