---
paths:
  - "flake.nix"
  - "flake.lock"
  - "modules/**/*.nix"
  - "tools/**/*.nix"
---

# Nix Configuration

- Keep host identity values in `modules/hosts/` and register hosts explicitly
  in `modules/hosts/default.nix`.
- The registry key selects a Flake output; `host.name` sets the macOS hostname.
  Do not assume those names are identical.
- Check both host platforms and the Flake's platform grouping when adding
  hosts. The current package and development-shell outputs target
  `aarch64-darwin`; a new host file alone does not add another output platform.
- Keep system options in nix-darwin modules and user options inside the
  Home Manager user configuration. Imports must use the correct module scope.
- Keep development-only tools in `devShells`; do not add them to the deployed
  system or user package lists unless requested.
- Prefer suitable nixpkgs packages. External binary files under
  `modules/pkgs/` return data attribute sets consumed by `tools/fetch-binary.nix`.
- Pin external binaries by version, release URL, platform, and verified hash.
  The hash covers the downloaded asset; `binary` is its unpacked executable
  path. Confirm the archive layout and helper support before adding a format.
- Keep dotfile destinations explicit and avoid forced overwrites.
- Do not bump `system.stateVersion` or `home.stateVersion` merely because
  dependencies are updated; review migration implications separately.
- Reuse existing helpers and module boundaries; add abstractions only when
  the requested change needs them.
