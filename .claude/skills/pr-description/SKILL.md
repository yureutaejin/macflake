---
name: pr-description
description: Draft a pull request title and description that matches this repository's established PR style. Use when asked to prepare, review, or improve a PR description; do not use to create or publish a PR.
---

# Write PR Description

Draft the PR body from the actual diff and completed validation. Do not create,
edit, or publish a pull request unless the user separately asks for that action.

## Match the repository style

Before drafting, inspect recent merged PR bodies when they are available. This
repository uses concise English sections in this order when applicable:

```markdown
## Summary

<one concise outcome-focused paragraph>

## Changes

- <concrete change>

## Details

<only for implementation context a reviewer needs>

## Validation

- [x] `<command actually run>`
```

Always include `## Summary`. Add `## Changes` for multiple meaningful changes,
`## Details` only when the diff needs architectural or operational context, and
`## Validation` when validation occurred. Omit empty sections and boilerplate.

## Ground the description in evidence

Read the current diff and relevant configuration or documentation before
writing. State outcomes and behavior, not a chronological account of edits.
Use concrete paths, package names, and configuration names only when they help
reviewers understand the change.

In `## Validation`, list only commands that actually ran in this work. Mark a
command with `[x]` only after it succeeded. Do not imply that a build proves
activation, interactive behavior, or an unrun deployment step. If relevant
validation did not run, say so plainly rather than inventing a checklist item.

Return the proposed title and Markdown body. Keep the body ready to paste into
GitHub and do not include a closing signature, generated-by note, or issue
link unless the user provides one.
