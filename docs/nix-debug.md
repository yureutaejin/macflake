# Nix Debugging

These are compact debugging patterns usable with any Nix Flake. Project-
specific selectors, paths, and expected values are marked **This project**.
For options not listed here, use the official Nix, nix-darwin, or Home Manager
manual.

## Inspect Flake Outputs

```sh
nix flake show <flake-reference>
```

Use this when a Flake selector is unclear. `<flake-reference>` may be `path:.`
for the current repository, a local path, or a remote reference such as
`github:owner/repository`.

**This project:**

```sh
nix flake show path:.
```

Expected useful outputs:

```text
darwinConfigurations.macbook-pro
packages.aarch64-darwin.macbook-pro
devShells.aarch64-darwin.devTools
```

`darwinConfigurations` may display as `unknown`. That is expected: it is a
configuration attribute set, not a buildable derivation.

## Find a Package

Use one of the following to find the attribute to declare as
`pkgs.<attribute>`:

- `nix search nixpkgs <package-name>`
- `nix search github:NixOS/nixpkgs/<version-branch> <package-name>`
- <https://search.nixos.org/packages>

## Evaluate and Build

Check a Flake without activating it:

```sh
nix flake check <flake-reference>
```

Build one explicit output without activating it:

```sh
nix build <flake-reference>#<output>
```

When a repository is evaluated through its Git-based reference (for example,
`.` or `.#<output>`), Nix includes only files tracked by Git. After adding a
new Nix file, track it before using those references. To intentionally test
the full local working tree before tracking a new file, use the explicit local
path reference instead:

```sh
nix flake check path:.
nix build path:.#<output>
```

**This project:** after changing `.nix` files, run:

```sh
nix flake check
nix build .#macbook-pro
sudo darwin-rebuild switch --flake .#macbook-pro
```

For untracked local changes, replace `.` with `path:.` in the check and build
commands above. Do not use `path:.` as a substitute for tracking files before
committing or sharing the configuration.

## Profiles, Generations, and GC Roots

A **profile** is a named collection of store paths. Updating it creates an
immutable **generation**, which permits rollback. A **GC root** is a symlink
or registration that keeps a store path and its dependencies from garbage
collection.

**This project:** important roots are:

| Path                                               | Meaning                              | Expected target                                     |
| -------------------------------------------------- | ------------------------------------ | --------------------------------------------------- |
| `/run/current-system`                              | Active nix-darwin system generation  | `/nix/store/...-darwin-system-...`                  |
| `/etc/profiles/per-user/$USER`                     | Home Manager user package profile    | `/nix/store/...-user-environment` or a profile path |
| `~/.local/state/home-manager/gcroots/current-home` | Active Home Manager generation       | `/nix/store/...-home-manager-generation`            |
| `result`                                           | Most recent local `nix build` output | `/nix/store/...`                                    |

On macOS, `/etc/profiles/per-user/$USER` may be a symlink to its static
profile:

```sh
# Show the profile symlink target.
readlink /etc/profiles/per-user/$USER

# -L: Follow every symlink encountered during the search.
# -H: Follow only the starting profile symlink.
find -H /etc/profiles/per-user/$USER -name nmap
```

Old paths are not retained merely because they are old. They remain while a
current system, profile, Home Manager generation, or local `result` still
references them.

## Garbage Collection

Preview garbage collection before deleting anything:

```sh
nix store gc --dry-run
```

`0 store paths would be deleted` means every current path is protected by a
root; it does not mean cleanup failed. When the preview is acceptable:

```sh
nix store gc
```

Remove old rollback generations only when they are no longer needed:

```sh
sudo nix-collect-garbage -d
```

**This project:** if Home Manager itself is intentionally being removed, first
remove its active generation, then run GC:

```sh
nix develop .#devTools --command home-manager uninstall
nix store gc
```

A later `darwin-rebuild switch --flake .#macbook-pro` recreates Home Manager,
because this Flake still declares it.

## Investigate Unexpected Disk Usage

When GC cannot delete anything but a retained closure is unexpectedly large,
measure the root and trace the dependency:

```sh
nix path-info --closure-size --human-readable <root>
nix why-depends <root> /nix/store/<store-path>
```

**This project:** the active Home Manager root is:

```text
~/.local/state/home-manager/gcroots/current-home
```

For example, `nix why-depends` can reveal which declared package pulled in a
large runtime dependency. Do not remove an active GC root to reclaim space;
remove the owning declaration, apply a new generation, then run GC.
