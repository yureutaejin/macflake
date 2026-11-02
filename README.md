# Mac Flake

Reproducible macOS, powered by Nix Flakes

```mermaid
flowchart TB
    subgraph nix["Nix-based Environment Management"]
        direction TB
        flakes["Nix Flakes<br/>Package Management"]
        darwin["nix-darwin<br/>Nix modules for macOS"]
        home["home-manager<br/>User Environment"]
        brew["nix-homebrew<br/>Homebrew installation"]
    end

    subgraph git["Git"]
        direction TB
        flakeNix["flake.nix"]
        flakeLock["flake.lock"]
        modules["modules/*.nix"]
        gitEtc["..."]
    end

    subgraph mac["MacOS (Apple Silicon)"]
        direction TB
        shell["Shell"]
        binary["Binary"]
        package["Package"]
        config["Configuration"]
    end

    nix ~~~ mac

    flakes ~~~ darwin
    home ~~~ brew

    git --> nix
    nix --> mac

    style mac fill:#1e293b,stroke:#3b82f6,color:#fff
    style nix fill:#111820,stroke:#2563eb,color:#fff
    style flakes fill:#303030,stroke:#555,color:#fff
    style darwin fill:#303030,stroke:#555,color:#fff
    style home fill:#303030,stroke:#555,color:#fff
    style brew fill:#303030,stroke:#555,color:#fff
    style git fill:#171717,stroke:#555,color:#fff
```

## Configure Your Environment

> [!IMPORTANT]
> Before starting, configure `modules/hosts/` for your own Mac.
> See step 3 in the Quick Start section.

See [Modules configuration](modules/README.md) for the host registry, package,
shell, and dotfile configuration structure. Keep secrets out of the repository
and Nix store.

## Quick Start

1. Install Nix [^nix-version]

Refer to [Nix installation guide](https://nixos.org/download.html)

```sh
curl -fsSL https://nixos.org/nix/install | sh
```

2. Enable Nix Flakes [^enable-flakes]

Add the following to your Nix configuration file (usually `~/.config/nix/nix.conf` or `/etc/nix/nix.conf`)

Refer to https://nixos.wiki/wiki/Flakes

```conf
experimental-features = nix-command flakes
```

```bash
# Verify that flakes are enabled
$ nix config show | grep flake
```

3. Add your host-specific configuration in `modules/hosts/<host>.nix` and register it in `modules/hosts/default.nix`.
4. Check and build the configuration

```sh
nix flake check
nix build .#macbook-pro
```

5. Apply changes to your Mac. Replace `<profile>` with the host key from
   `modules/hosts/default.nix` when targeting another host.

```sh
sudo darwin-rebuild switch --flake .#<profile>
```

If it is the first time applying changes, use the below

```sh
sudo ./result/sw/bin/darwin-rebuild switch --flake .#<profile>
```

6. Show current system generation

`/run/current-system` points to the active nix-darwin system generation.
(It is a GC root and is not removed by `nix store gc`.)

```sh
readlink /run/current-system
```

## Cleanup

```sh
# Remove this project's local build-result link.
rm -f result
```

To remove the active Home Manager generation before garbage collection, without
installing the Home Manager CLI globally:

```sh
nix run home-manager/release-26.05 -- uninstall
# or
nix develop .#devTools --command home-manager uninstall
```

A later `darwin-rebuild switch` with this Flake activates Home Manager again.

```sh
# Stop using this project's nix-darwin environment; keeps Nix itself installed.
sudo darwin-uninstaller

# After the uninstaller: inspect the remaining nix-darwin system-profile links.
sudo find /nix/var/nix/profiles -maxdepth 1 -type l -name 'system*' -print

# After verifying they all belong to this retired setup: remove this project's first generation.
sudo rm /nix/var/nix/profiles/system*

# Run garbage collection to remove unreferenced store paths.
nix store gc
# Remove old generations also not referenced by any profile.
nix-collect-garbage -d
```

## (Optional) Extensions

### VS Code Extension

- `jnoortheen.nix-ide`

[^nix-version]: Used Nix 2.35.4 in this project.
