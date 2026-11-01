# Workflow

## Scope and Verification

- For explanations or diagnosis, inspect and report; change files when the
  user requests implementation.
- When asked to edit only without execution, do not run Nix evaluation,
  builds, activation, or the configured shell scripts.
- For documentation-only edits, review links, examples, and the diff; do not
  run Nix builds.
- For Nix changes, run `nix flake check` and, when output behavior changes,
  build the affected registered host with `nix build .#<host-key>`.
- Nix evaluation, builds, and development shells may download dependencies
  and consume store space. Use checks proportionate to the change.
- Report which checks actually ran and any limitations. Build success does
  not prove successful activation or interactive shell behavior.

## Activation and Cleanup

- Run `darwin-rebuild switch`, uninstallers, garbage collection, or generation
  deletion only when the user explicitly requests those operations.
- Preserve existing home-directory files. Do not force dotfile replacement
  or source the user's shell configuration as a test.
- For disk-usage questions, inspect GC roots and dependency closures before
  recommending removal. A retained path is not automatically required forever.

## Git and Flake Inputs

- Do not stage, commit, or push changes unless requested.
- Git-based Flakes omit untracked files. If a new file prevents validation,
  report the cause or use an explicit `path:.` evaluation after checking
  which local files it would include; do not stage files automatically.
- Preserve unrelated staged and unstaged changes.
- Do not update Flake inputs or `flake.lock` unless required by the requested
  dependency change. Review any resulting lockfile diff.
