# Why `key` in React Lists Is Not Just for Performance — It Affects State

**Category**: Frontend / React
**Difficulty**: Intermediate
**Estimated Duration**: 60-90 sec (Short)
**Date Proposed**: 2026-03-15
**Source Inspiration**: `software/react/toc.md` — component reconciliation and the `key` prop

---

## Introduction
Most developers think the `key` prop is a performance hint React uses for diffing — but it also controls whether a component's local state is preserved or destroyed when the list changes. Using array index as a key is not just a lint warning; it causes real, visible bugs.

---

## Body

### Key Points to Cover
1. What `key` actually does — it is React's identity marker for a component instance; same key = same component (state preserved), different key = new component (state reset)
2. The index-as-key bug — a list of input fields each with local state (typed text); delete the first item; the typed text from item 2 now appears in item 1's slot because indices shifted but state did not
3. Why stable unique IDs fix it — with a real ID as the key, React knows exactly which component is which regardless of position, and state follows the item correctly
4. The second use case — intentionally resetting component state by changing the key: `<UserForm key={userId} />` re-mounts cleanly when the user changes, no manual state cleanup needed
5. The rule: never use array index as key for lists that can be reordered, filtered, or have items removed

### Suggested Code Examples / Demos
- Side-by-side: list rendered with `key={index}` vs. `key={item.id}` — delete an item, observe the state mismatch in the index version
- The deliberate reset pattern: `<Form key={selectedId} />` to force a fresh mount on ID change
- Show the React DevTools highlighting component re-mounts when key changes

### Common Pitfalls / Misconceptions
- "The lint rule is just being pedantic" — it is warning about a real state bug, not a style preference
- "Index is fine for static lists" — true only if the list never reorders, filters, or removes items; that is a fragile assumption
- Thinking `key` is passed as a prop to the child component — it is not; `props.key` is always `undefined` inside the child

---

## Conclusion / Footer
`key` is not a performance hint — it is a component identity declaration. Use stable, unique IDs from your data. If you need to reset a component's state, change its key intentionally. Viewer challenge: search your codebase for `key={index}` — each one is a potential state bug waiting to surface.

---

## Notes for Production
- Thumbnail idea: two lists side by side — one with garbled state after deletion, one clean
- Related video to mention: React reconciliation algorithm, `useEffect` cleanup
- Keep the demo extremely visual — state bugs are more compelling shown than explained
