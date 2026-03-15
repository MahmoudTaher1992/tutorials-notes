# `.toBe()` vs. `.toEqual()` in Jest: They Are Not the Same

**Category**: Backend / Testing
**Difficulty**: Beginner
**Estimated Duration**: 60 sec (Short)
**Date Proposed**: 2026-03-15
**Source Inspiration**: `software/testing/jest/toc.md` — Part II.B, The `expect` API & Common Matchers

---

## Introduction
Using the wrong equality matcher in Jest silently passes tests that should fail — and it is the most common beginner mistake in JavaScript testing. One matcher checks identity, the other checks value, and knowing the difference will save you from false-green test suites.

---

## Body

### Key Points to Cover
1. `.toBe()` uses `Object.is()` under the hood — it checks reference identity, not value equality
2. For primitives (strings, numbers, booleans) both matchers behave identically — `expect(2 + 2).toBe(4)` works fine
3. For objects and arrays, `.toBe()` compares memory addresses — two objects with identical content are still different references and the test fails
4. `.toEqual()` performs a deep recursive value comparison — it checks that every property matches, regardless of reference
5. The one-sentence rule: use `.toBe()` for primitives, `.toEqual()` for objects and arrays

### Suggested Code Examples / Demos
- Primitive: `expect(5).toBe(5)` — passes with both
- Object trap: `expect({ a: 1 }).toBe({ a: 1 })` — fails; `expect({ a: 1 }).toEqual({ a: 1 })` — passes
- Array trap: `expect([1, 2]).toBe([1, 2])` — fails; `expect([1, 2]).toEqual([1, 2])` — passes
- Show the Jest output diff for the failing `.toBe()` case so viewers recognise the error message

### Common Pitfalls / Misconceptions
- Assuming `.toBe()` is always stricter and therefore "better" — it is not stricter for objects, it is just wrong
- Using `.toEqual()` for everything — fine for correctness but `.toBe()` is more expressive for primitives and signals intent clearly
- Confusing `.toStrictEqual()` with `.toEqual()` — `.toStrictEqual()` also checks that objects have the same type and rejects `undefined` properties

---

## Conclusion / Footer
One rule: primitives get `.toBe()`, objects and arrays get `.toEqual()`. Check your existing tests — if you are using `.toBe()` on any object or array assertion, you have a test that lies to you.

---

## Notes for Production
- Thumbnail idea: `{ a: 1 } === { a: 1 }` with a red cross, `toEqual` with a green tick
- Related video to mention: Jest mocking with `jest.fn()`, the AAA test pattern
- Keep the code font large — this is a Short, not a tutorial
