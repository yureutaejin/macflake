---
name: optimize-project-docs
description: Audit and streamline this repository's Markdown documentation and code comments by assigning recurring guidance to the right canonical location. Use when asked to reduce duplication, clarify documentation ownership, or turn stable project conventions into agent rules.
---

# Optimize Project Docs

Improve documentation structure without erasing information that is useful in
context. Treat an audit as read-only unless the user asks to apply the proposed
changes.

## Discover the project's documentation model

Before reviewing content, read `AGENTS.md`, `CLAUDE.md`, contributor guidance,
and scoped rule files. Identify the project's existing ownership model rather
than imposing one.

Inventory the requested scope with fast file and text searches. Include hidden
instruction Markdown when relevant. Inspect code comments alongside the
documentation they explain, and trace each documented workflow to its caller or
consumer before recommending a move.

## Assign one canonical home

Classify recurring statements by their audience and purpose:

- Put durable instructions for coding agents in project guidance or scoped
  rules. Only promote decisions that should affect future implementation; do
  not turn a one-off example or product fact into a universal rule.
- Keep user-facing onboarding, application, activation, cleanup, and shared
  troubleshooting in the repository's established public documentation.
- Keep configuration formats, registration steps, and extension details in the
  README nearest to the code they describe. Link outward for material owned by
  another document instead of restating it.
- Keep code comments that explain local rationale, invariants, surprising
  behavior, or non-obvious implementation constraints. A nearby command
  example can remain when it materially aids use of that declaration.

Use links and short references for secondary locations. Preserve an explicitly
requested convention even if it is stylistically unusual.

## Review duplication deliberately

For each repeated idea, decide whether it is:

1. Necessary contextual repetition, such as a verification command in a
   package-addition procedure and a root onboarding guide.
2. A short pointer to the canonical document, which should stay concise.
3. Redundant prose that can be replaced by a link or removed.
4. A stable implementation convention that belongs in an agent rule.

Report the canonical location, affected files, and why a repeated statement is
kept, moved, shortened, or left alone. Do not remove comments merely because a
README covers the same broad topic.

## Apply changes safely

When edits are authorized, keep the change set scoped to the agreed findings.
Update all renamed headings and Markdown link labels. Do not move operational
instructions into hidden agent rules if human users still need them.

For documentation-only edits, verify links, command selectors, referenced
paths, and the diff against the implementation. Do not run builds or activation
commands solely to validate prose. For code-comment-only edits, use the
project's normal formatting or validation requirements only when they apply.
