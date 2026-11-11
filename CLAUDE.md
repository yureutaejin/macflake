# Macflake

Nix Flakes, nix-darwin, and Home Manager configure macOS environments.
Prefer Nix packages; Homebrew integration is optional and requires an
explicit configuration change.

## Working Principles

- Keep changes small and scoped to the user's request.
- Read the current implementation before describing or modifying it.
- Preserve existing user changes and follow nearby conventions.
- Distinguish configuration changes, build verification, and activation.
- Reply in Korean; follow the existing language of edited documents.
- Keep credentials, tokens, and private keys out of Git and the Nix store.

## Project References

Read documentation relevant to the task before making changes:

- [README.md](README.md): installation, application, and cleanup.
- [docs/](docs/): shared guides, including debugging and troubleshooting.
- For directory-specific guidance, look for `README.md` in the directory
  being changed and its parent directories up to the repository root. Read
  the relevant ones; follow their links when further detail is needed.

Keep directory-specific documentation alongside its code rather than
maintaining an exhaustive list of README paths here.

## Agent Configuration

This project's `.claude/` directory is the authoritative location for
project-specific agent configuration. Keep project rules in `.claude/rules/`
and project skills in `.claude/skills/`; do not add project guidance to global
agent configuration directories.

Read `.claude/rules/workflow.md` for every task. Nix and documentation rules
in that directory are scoped to their respective file paths. Use a relevant
project skill from `.claude/skills/` when its description matches the task.
