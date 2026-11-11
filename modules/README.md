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
├── pkgs/        # user package lists grouped by source
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
- **User packages:** Update the source-specific lists under `pkgs/`. See
  [Package Sources](pkgs/README.md) for the supported package paths and their
  registration steps.
- **Shell:** Update `shell/zshrc` for the complete managed `.zshrc`.
  `shell/zsh.nix` links it into the user's home directory.
- **Configuration files:** Add a source file under `configs/` and map its
  destination path in `configs/config.nix`; Home Manager links it into the
  user's home directory.

Before switching, follow the project verification guidance in
[Nix debugging](../docs/nix-debug.md). It also explains when newly added files
require local `path:.` validation.
