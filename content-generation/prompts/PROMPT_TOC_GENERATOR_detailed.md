I want you to create an ultra-detailed, hyper-granular Table of Contents (study guide) for: [TOPIC]

## Style & Format Rules

1. **Extreme Hierarchical Depth (4-5 Levels)** — You must deconstruct the topic down to microscopic levels. Use the following exact numbering and markdown structure:
   - `## X.0` Level 1: Major Domain (e.g., ## 3.0 Data Management)
   - `### X.X` Level 2: Sub-domain/Core Concept (e.g., ### 3.2 Caching Strategies)
   - `#### X.X.X` Level 3: Specific Component (e.g., #### 3.2.1 Eviction Policies)
   - `- X.X.X.X` Level 4: Granular Mechanism (e.g., - 3.2.1.1 Least Frequently Used (LFU))
   - `  - X.X.X.X.X` Level 5: Niche detail/parameter (e.g.,   - 3.2.1.1.1 O(1) time complexity implementation using doubly linked lists)
2. **Density over Exposition** — TOC items ONLY. No paragraphs or deep explanations. Use short, dash-separated clarifications (as shown in the Level 5 example above) to justify the extreme depth without bloating the word count.
3. **Strict Pagination (Max 200 lines)** — Because of the 4-5 level depth, files will fill up fast. Split the output into multiple files. NO file may exceed 200 lines. Name them `[topic]_part_1.md`, `[topic]_part_2.md`, etc. (It is okay if a single Level 1 Domain spans multiple files).
4. **Header per file** — Each file must start with `# [Guide Title] - Part N: [Section Name]`

## Content Approach: The "Ideal/Angel" Method

Structure the TOC in two distinct phases:

### Phase 1: The Ideal [TOPIC]
Define every component, architecture layer, and edge-case that a perfect, platonic ideal of [TOPIC] would have. This must be framework/technology-agnostic. Push the depth to 4-5 levels by breaking down internal mechanics, lifecycle stages, memory management, theoretical limits, etc.

### Phase 2: Specific Implementations
For each major framework/tool listed below, map it against the Ideal. Do NOT recreate the 5-level hierarchy if it matches the Ideal.
- Identical to Ideal → reference it: "→ See Ideal §X.X.X.X"
- **Unique/Divergent** → mark as "**Unique: [feature]** — [brief description]"
- Only drill down into 4-5 levels here if the specific tool has a highly complex, unique internal mechanism not covered in Phase 1.

## Completeness Check

Before writing the actual files, list ALL Level 1 and Level 2 sections you plan to cover in a table format:
| # | Major Domain (L1) | Core Concept (L2) | Est. Max Depth (1-5) |
After printing the table, pause and ask: **"Anything to add/remove/rearrange before I generate the files?"**

Think aggressively about what might be missing to achieve Level 5 depth. View the topic through these lenses:
- Mathematical foundations & theoretical limits
- Internal mechanics (memory, CPU, network allocation)
- Granular API/interface specifications
- Micro-security (bit-level, specific attack vectors)
- Edge-case scaling & distributed bottlenecks
- Specific telemetry, metrics, and tracing hooks
- Obscure anti-patterns and failure modes

## Implementations to Cover in Phase 2
[LIST THE SPECIFIC FRAMEWORKS/TOOLS/LIBRARIES YOU WANT COVERED]

## Output Location
Write files to: [DIRECTORY PATH]