---
name: write-dir-readme
description: Create or update a subdirectory README explaining its role, integration, and how to configure or extend its contents. Use for directory-level documentation requests, not root onboarding guides or general troubleshooting documentation.
---

# Write a Directory README

Write a concise README that lets a contributor understand what belongs in the
target directory and make a supported change without tracing the entire repo.

## Establish the Scope

- Use the directory named in the request or clearly established by the current
  task. Ask for the target only if it remains ambiguous; do not generate READMEs
  throughout the repository by default.
- Read the repository instructions, the target's existing README, and relevant
  parent READMEs before writing. Preserve useful existing explanations.
- Inspect the directory's implementation and its immediate callers or consumers.
  Identify how files are discovered, registered, imported, or selected.
- Match the existing documentation language and tone. In this repository, write
  English documentation and explain the completed change to the user in Korean.

## Choose Useful Content

Use only the sections that help the reader work in this directory:

- **Purpose and boundary:** Explain what the files represent, who consumes them,
  and what belongs elsewhere. Start with a short concrete paragraph.
- **Integration:** Show how data or configuration reaches its consumer when that
  relationship is not obvious. A short code example or flow is enough.
- **Layout:** Include a compact tree when there are distinct responsibilities.
  Group files by role; do not reproduce an exhaustive file listing.
- **Configuration or extension:** State what to inspect and update, including
  any registration required outside this directory. Distinguish filenames,
  registry keys, and values when they serve different purposes.
- **Definition format:** For directories containing structured definitions, show
  one representative example and explain required fields, optional fields, path
  bases, and where the resulting output goes.
- **Verification and limits:** Give the relevant verification command and its
  expected outcome when useful. Describe current constraints and when a different
  mechanism is needed; do not imply planned behavior already exists.

The existing `modules/README.md` illustrates configuration and integration
guidance; `modules/pkgs/README.md` illustrates definition formats and extension
steps. Consult the applicable example if it still exists, and verify its pattern
against the target's actual code rather than copying its domain-specific details.

## Keep Documentation Local

- Put the detail in the target directory's README. Link to parent, sibling, or
  shared documentation for material already owned there.
- Use relative Markdown links resolved from the README's directory. State where
  commands must be run if they assume the repository root.
- Avoid duplicating installation, cleanup, or general debugging guides. Add a
  parent link only when needed for discovery or explicitly requested; do not
  maintain a central inventory of every README.
- Use unnumbered headings and numbered steps only for an ordered procedure.
  Prefer short paragraphs, parallel bullets, and small examples over long tables
  or a fixed template. Omit basic shell tutorials and exhaustive option lists.
- Keep examples consistent with the implementation. Mark illustrative values
  clearly; do not present placeholder hashes or invented options as working data.

## Review the Result

- Verify referenced paths, selectors, fields, defaults, and relative links against
  the current repository. Trace at least the documented registration and consumer
  relationship when describing how to add an item.
- Check that a reader can tell what to edit and what result to expect, without
  confusing a build with activation or a file definition with an installed tool.
- For documentation-only work, inspect the diff and formatting without running
  builds, installers, activation, cleanup, or commands copied from examples.
- Report the README changed and any behavior that could not be verified from
  source. Do not claim runtime validation from a documentation review.
