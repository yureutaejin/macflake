# External Binary Packages

This directory groups the packages installed for the user by their source.
Prefer a suitable nixpkgs package before defining a release binary or adding
an external Flake input.

## Layout

```text
modules/pkgs/
├── README.md
├── flakes/
│   └── default.nix       # Outputs selected from external Flake inputs
├── github/
│   ├── default.nix       # GitHub release packages to install
│   └── starship.nix      # GitHub release URL, hash, and executable path
└── nixpkgs/
    └── default.nix       # Installed packages selected from nixpkgs
```

There are three package paths in this project:

- **nixpkgs packages:** Select `pkgs.<attribute>` in `nixpkgs/default.nix`.
  Nixpkgs already defines the derivation, for example `pkgs.ripgrep`.
- **GitHub release binaries:** Add a data file under `github/`, such as
  `github/starship.nix`. The `fetchBinary` helper in
  `tools/fetch-binary.nix` downloads the pinned release asset, verifies its
  hash, and turns it into an installed package.
- **External Flake packages:** Declare the source Flake under `inputs` in the
  root `flake.nix`, then select its package output in `flakes/default.nix`.
  `modules/home.nix` imports that file and adds its returned package list to
  `home.packages`.

Packages supplied by another Flake live in `flakes/`. Their source and version
are declared under `inputs` in the root `flake.nix`, so `flake.lock` can pin
them. `flakes/default.nix` selects the appropriate outputs and returns the
packages installed by Home Manager. For example, it returns Mole's default
package for the current host platform. This project deliberately does not add
these packages as `pkgs.*` overlays.

Each `github/<name>.nix` file is data only: it returns an attribute set that
describes one GitHub release binary. `tools/fetch-binary.nix` turns that data
into a Nix derivation, downloads the asset, verifies its hash, unpacks a
recognised archive, and installs the executable in `$out/bin`.

## Definition Format

```nix
{
  pname = "example";
  version = "1.2.3";

  sources.aarch64-darwin = {
    url = "https://example.com/downloads/example-1.2.3-aarch64-apple-darwin.tar.gz";
    hash = "sha256-<SRI-base64-hash>";
    binary = "example";

    # Optional: use this when the installed command should have another name.
    # name = "example-command";
  };

  # Optional Nix package metadata.
  # meta = { description = "..."; };
}
```

Required fields:

- `pname`: package name used in the Nix store output name.
- `version`: upstream release version.
- `sources.<system>`: release asset for a supported Nix system. This project
  currently uses `aarch64-darwin`.
- `url`: immutable release-asset URL.
- `hash`: SRI-form SHA-256 hash of the downloaded asset, for example
  `sha256-U2LajLKSj5jzzg/9ppfPD43nAIHbAA2uMW1tOkBPbPA=`.
- `binary`: executable path after the archive is unpacked, relative to the
  unpacked build directory. For an archive containing `bin/example`, use
  `binary = "bin/example"`.

The helper uses Nix's normal unpack phase. `.tar.gz` release assets such as
Starship are unpacked before its install phase copies `binary` to
`$out/bin/${name or pname}`. `dontBuild = true` skips compilation only; it
does not skip unpacking.

## Add a Binary

1. Find the official release asset for the target platform.
2. Create `modules/pkgs/github/<name>.nix` using the format above.
3. Obtain the downloaded asset's Nix hash. For example:

   ```sh
   nix store prefetch-file --json <release-asset-url>
   ```

   Copy its `hash` value into the definition. Do not use a checksum for a
   different archive or platform.
4. Add the release package to the list returned by `github/default.nix`:

   ```nix
   [
     (fetchBinary (import ./starship.nix))
     (fetchBinary (import ./example.nix))
   ];
   ```
5. Track the new file with Git, then verify it:

   ```sh
   nix flake check
   nix build .#macbook-pro
   ```

After `darwin-rebuild switch --flake .#macbook-pro`, Home Manager exposes the
installed executable through the user's Nix profile.

## Limits

This helper currently targets one executable from a conventional release
archive. Packages that require compilation, multiple outputs, unusual archive
layouts, runtime patching, or custom dependencies should receive a dedicated
Nix derivation instead of extending this small helper indiscriminately.
