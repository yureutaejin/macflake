---
paths:
  - "README.md"
  - "**/README.md"
  - "modules/**/*.md"
  - "docs/**/*.md"
---

# Documentation

- Write concise English consistent with the existing documentation.
- Keep installation and application guidance in the root README, shared
  guides in `docs/`, and directory-specific guidance in the relevant
  directory's README. Update existing documentation where it lives and link
  to it instead of duplicating it.
- Keep `docs/nix-debug.md` useful across Nix projects. Label project-specific
  examples and explain when a command is useful and what its result means.
- Explain concepts such as profiles, generations, and GC roots where needed;
  omit basic shell tutorials and exhaustive option lists.
- Use unnumbered section headings. Number lists only when step order matters.
- Use compact directory trees showing responsibilities, not every file.
- Check command selectors and file references against the current code.
  Distinguish evaluation, building, activation, and cleanup in examples.
- Describe implemented behavior as current and proposed features as planned.
