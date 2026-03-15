# React key Prop: It Is Not What You Think

**Tone:** Serious / Educational
**Duration:** ~30 seconds

| Sentence | Type |
|----------|------|
| Using index as a React key creates silent state bugs in your UI. | Hook |
| Here is how the key prop controls component state, not just performance. | Title Reveal |
| `key` is React's identity marker for a component instance across renders. | Introduction |
| Same key means same component — local state is fully preserved. | Body – Point 1 |
| Different key means a new component is mounted — state resets completely. | Body – Point 2 |
| Deleting an item shifts all indices, which silently corrupts component state. | Body – Point 3 |
| Always use stable, unique IDs from your data as the key prop. | Conclusion |
| Search your code for `key={index}` — every match is a potential bug. | CTA |
