# Jest: .toBe() vs .toEqual()

**Tone:** Serious / Educational
**Duration:** ~30 seconds

| Sentence | Type |
|----------|------|
| Your test suite passes — but it might be lying to you. | Hook |
| Here is the Jest matcher mistake that creates false-green tests. | Title Reveal |
| `.toBe()` uses `Object.is()` — it checks reference identity, not value. | Introduction |
| For primitives like numbers and booleans, both matchers behave identically. | Body – Point 1 |
| For objects, `.toBe()` compares memory addresses, not content. | Body – Point 2 |
| `expect({ a: 1 }).toBe({ a: 1 })` will fail every single time. | Body – Point 3 |
| Use `.toBe()` for primitives and `.toEqual()` for objects and arrays. | Conclusion |
| Search your tests for `.toBe()` on any object assertion — fix it now. | CTA |
