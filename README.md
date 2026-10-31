# Mac Flake

## Project Layout

```text
macflake/
├── .gitignore
├── PLAN.md
├── README.md
├── flake.nix
├── flake.lock
├── hosts/
│   └── myMac/
│       ├── default.nix
│       └── identity.nix    # host, user, and Home Manager user values to customize
└── result -> /nix/store/... # optional local symlink created by `nix build`
```

## Host and User Configuration

Customize this Mac's host name, platform, account name, home directory, and Home Manager user settings in `modules/identity.nix`. Keep secrets out of the repository and Nix store.

## Quick Start

1. Install Nix [^install-nix]

```sh
curl -fsSL https://nixos.org/nix/install | sh
```

2. Enable Nix Flakes [^enable-flakes]

Add the following to your Nix configuration file (usually `~/.config/nix/nix.conf` or `/etc/nix/nix.conf`):

```conf
experimental-features = nix-command flakes
```

```bash
# Verify that flakes are enabled
$ nix config show | grep flake
```

3. Check and build the configuration

```sh
nix flake check
nix build
```

4. Apply changes

```sh
sudo darwin-rebuild switch --flake .#myMac
```

If it is the first time applying changes, use the below

```sh
sudo ./result/sw/bin/darwin-rebuild switch --flake .#myMac
```

## Common Commands

```sh
# Create missing lock file entries for this Flake.
nix flake lock

# Build this Mac configuration without applying changes.
darwin-rebuild build --flake .#myMac

# Show this configuration's active system generation.
readlink /run/current-system
```

`/run/current-system` points to the active nix-darwin system generation. It is a GC root and is not removed by `nix store gc`.

For Nix profiles, generations, disk usage, dependency inspection, and garbage collection, see [Nix Debugging](docs/nix-debug.md).

## Cleanup

```sh
# Remove this project's local build-result link.
rm -f result
```

To remove the active Home Manager generation before garbage collection, without
installing the Home Manager CLI globally:

```sh
nix develop .#devTools --command home-manager uninstall
nix store gc
```

A later `darwin-rebuild switch` with this Flake activates Home Manager again.

```sh
# Stop using this project's nix-darwin environment; keeps Nix itself installed.
sudo darwin-uninstaller

# After the uninstaller: inspect the remaining nix-darwin system-profile links.
sudo find /nix/var/nix/profiles -maxdepth 1 -type l -name 'system*' -print

# After verifying they all belong to this retired setup: remove this project's first generation.
sudo rm /nix/var/nix/profiles/system \
  /nix/var/nix/profiles/system-1-link
```

After removing the project-specific profile links, use the garbage collection procedure in [Nix Debugging](docs/nix-debug.md#garbage-collection) to reclaim unreferenced store paths.

[^install-nix]: [Nix installation guide](https://nixos.org/download.html). Used Nix 2.35.4 in this project.

[^enable-flakes]: [Enabling Flakes](https://nixos.wiki/wiki/Flakes)
