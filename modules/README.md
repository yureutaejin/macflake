# Modules

`flake.nix` imports the host registry from `modules/hosts/`, creates one
`darwinConfiguration` for each registered host, and passes that host's values
to the shared modules as `host`.

```text
modules/hosts/default.nix
  → registered host definitions
  → flake.nix / mkDarwin
  → modules/default.nix + modules/home.nix
```

Both shared modules receive the selected host as a function argument:

```nix
{ host, ... }:
```

The host value supplies its macOS hostname, target platform, user name, and
home directory.

## Layout

```text
modules/
├── hosts/       # registered Mac hosts and their identity values
├── configs/     # files linked into the user's home directory
├── pkgs/        # definitions for externally fetched binaries
├── shell/       # shell integration and shell configuration
├── default.nix  # shared nix-darwin system settings
└── home.nix     # Home Manager user configuration and package selection
```

## Configure a Host

Add or update `hosts/<host>.nix`, then register its key in
`hosts/default.nix`. Confirm:

- `name`: the macOS hostname set by nix-darwin.
- `platform`: the Nix target system, currently `aarch64-darwin` for Apple
  Silicon Macs.
- `user.name` and `user.home`: the existing macOS account managed by Home
  Manager.

The registry key is the Flake selector. For example, the `macbook-pro` key is
used by:

```sh
nix build .#macbook-pro
sudo darwin-rebuild switch --flake .#macbook-pro
```

## Configure the Environment

- **System settings:** Update `default.nix` for shared nix-darwin settings,
  such as Nix options and hostname configuration.
- **User packages:** Update `home.packages` and the external-binary filename
  list in `home.nix`. For a GitHub-release binary, define its URL, version,
  platform source, and hash under `pkgs/`. See [External Binary
  Packages](pkgs/README.md).
- **Shell:** Update `shell/zshrc` for the complete managed `.zshrc`.
  `shell/zsh.nix` links it into the user's home directory.
- **Configuration files:** Add a source file under `configs/` and map its
  destination path in `configs/config.nix`; Home Manager links it into the
  user's home directory.

After editing, run `nix flake check` and build the intended host before
switching it.
