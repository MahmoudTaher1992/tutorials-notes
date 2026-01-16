# Common Pitfalls ("Gotchas")

- **Missing Symbols**
    - Seeing hex addresses (`0x4f3a...`) instead of function names
    - Stripped binaries vs. JIT symbols (e.g., Java `.map` files, Node.js `--perf-basic-prof`)
- **Missing/Broken Stacks**
    - Incomplete flame graphs or `[unknown]` frames
    - **The Frame Pointer Issue**: `-fomit-frame-pointer` compiler optimization breaking stack walking
    - Solutions: DWARF debug info, ORC (Oops Rewind Capability), or re-compiling with frame pointers
