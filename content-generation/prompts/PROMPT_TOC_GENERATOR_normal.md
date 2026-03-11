# Prompt: Detailed TOC Generator

> Copy and paste the prompt below, replacing the placeholders in `[BRACKETS]`.

---

```
I want you to create a detailed Table of Contents (study guide) for: [TOPIC]

## Style & Format Rules

1. **Hierarchical numbered structure** — use `###` for major sections, `####` for subsections, and `- X.X.X` bullet points for items
2. **Depth level** — TOC items only, no explanations or deep details. Each bullet is a topic title, optionally with a short dash-separated clarification (e.g., "- 3.2.1 Sliding window counter — tracks requests in a rolling time window")
3. **Split into multiple files** — each file must NOT exceed 200 lines. Name them `[topic]_part_1.md`, `[topic]_part_2.md`, etc.
5. **Header per file** — each file starts with the guide title and "Part N: [Section Name]"

## Content Approach: The "Ideal/Angel" Method

Structure the TOC in two phases:

### Phase 1: The Ideal [TOPIC]
Define every component/aspect that a perfect, complete [TOPIC] would have — the platonic ideal. This should be framework-agnostic and technology-agnostic. Organize by logical categories (e.g., Foundation, Core, Data, API, Operations, etc.).

### Phase 2: Specific Implementations
For each major implementation/framework/tool of [TOPIC], map it against the Ideal:
- Items identical to the Ideal → reference as "→ Ideal §X.X"
- Items **unique** to that implementation → mark as "**Unique: [feature]** — [brief description]"
- Only expand on what's different or missing from the Ideal

This avoids repetition and highlights what makes each implementation special.

## Completeness Check

Before writing, list ALL sections you plan to cover in a table format:
| # | Section | Category |
And ask: "Anything to add/remove/rearrange before I write?"

Think hard about what might be missing. Consider the topic from these angles:
- Foundations & theory
- Core functionality
- Data/storage concerns
- API/interface design
- Security & protection
- Infrastructure & scaling
- Developer experience & tooling
- Operations & observability
- Advanced/cutting-edge patterns
- Real-world scenarios & anti-patterns

## Implementations to Cover
[LIST THE SPECIFIC FRAMEWORKS/TOOLS/LIBRARIES YOU WANT COVERED]

## Output Location
Write files to: [DIRECTORY PATH]
```

---

## Example Usage

```
I want you to create a detailed Table of Contents (study guide) for: Message Queues & Event Streaming

[...style rules as above...]

## Implementations to Cover
- RabbitMQ
- Apache Kafka
- AWS SQS / SNS
- Redis Streams
- NATS
- Google Pub/Sub
- Azure Service Bus

## Output Location
Write files to: /path/to/tutorials-notes/software/messaging/
```
