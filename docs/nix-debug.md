# Nix Debugging

This page covers general Nix inspection and cleanup commands. It is not specific to this macflake repository.

## Inspect Flake Outputs

`nix flake show <flake-reference>` evaluates a flake and prints the attributes it exposes through `outputs`. It is an output-discovery command: use it to find names and paths such as `packages.aarch64-darwin.default`, `checks.<system>`, or a project-specific `darwinConfigurations.myMac` before referring to them from another command.

It does **not** build an output or activate a nix-darwin configuration. Evaluation can still fail when an output contains an invalid Nix expression, so it is also useful as a quick structural check.

```sh
# Inspect this repository's outputs. `path:.` makes the local flake explicit.
nix flake show path:.

# Inspect outputs published by the nix-darwin 26.05 branch.
nix flake show github:nix-darwin/nix-darwin/nix-darwin-26.05

# Include output trees for systems other than the current machine.
nix flake show --all-systems github:nix-darwin/nix-darwin/nix-darwin-26.05

# Machine-readable representation, useful with jq or a script.
nix flake show --json path:.
```

The remote reference has the form `github:<owner>/<repository>/<revision>`. Therefore the nix-darwin reference is `github:nix-darwin/nix-darwin/nix-darwin-26.05` (not `github:nix=darwin/...`).

## Profiles and Generations

A profile is a named set of top-level Nix packages. A generation is an immutable revision of that profile: every update creates a new generation, allowing rollback. The `profile` or `system` link points to the active generation; `*-N-link` entries are older generations.

```text
/nix/var/nix/profiles/per-user/root/profile
  -> profile-3-link                 # active Nix root profile

/nix/var/nix/profiles/system
  -> system-2-link                  # active nix-darwin system, when installed
```

List user and system profiles:

```sh
find /nix/var/nix/profiles/per-user \
  -mindepth 2 -maxdepth 2 -type l -name profile -print
find /nix/var/nix/profiles \
  -maxdepth 1 -type l -name 'system*' -print
```

Choose one profile or active system to inspect:

```sh
TARGET=/nix/var/nix/profiles/per-user/root/profile
# TARGET=/run/current-system
```

## Inspect a Profile

```sh
# Top-level packages directly registered in a normal Nix profile.
sudo nix-env --query --installed --profile "$TARGET"

# Total closure size of the selected target.
nix path-info --closure-size --human-readable "$TARGET"

# Individual store paths in the closure, sorted by size.
nix path-info --recursive --size --human-readable "$TARGET" | sort -h -k2

# Dependency tree of the selected target.
nix-store -q --tree "$TARGET" | less

# GC roots that retain a specific store path.
nix-store -q --roots /nix/store/<store-path>

# Why the selected target depends on a specific store path.
nix why-depends "$TARGET" /nix/store/<store-path>
```

For a nix-darwin system generation, the Flake configuration is the source of truth for intentionally declared packages. Profile queries are most useful for normal Nix user/root profiles.

## Garbage Collection

```sh
# Remove an unneeded local build-result link; this does not delete its store output immediately.
rm -f result

# Preview and remove store paths that no active system, profile, or result link uses.
nix store gc --dry-run
nix store gc

# Choose one policy while continuing to use Nix:
# Delete all old rollback generations, then garbage-collect.
sudo nix-collect-garbage -d

# Or keep rollback generations from the last 30 days.
sudo nix-collect-garbage --delete-older-than 30d
```

### Remove Home Manager State

Home Manager's active generation is a GC root, so normal garbage collection
does not remove it. If you intentionally want to stop using Home Manager,
remove its active state first, then run GC:

```sh
# `home-manager` is available only in this repository's development shell.
nix develop .#devTools --command home-manager uninstall
nix store gc
```

This does not remove the Home Manager declaration from this Flake. A later
`darwin-rebuild switch` using this configuration activates Home Manager again.
