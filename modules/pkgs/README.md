# External Binary Packages

This directory contains package definitions for release binaries that are not
being installed from `nixpkgs`. Prefer `pkgs.<attribute>` in
`modules/home.nix` when a package is available and suitable in nixpkgs.

Each `pkgs/<name>.nix` file is data only: it returns an attribute set that
describes one release binary. `tools/fetch-binary.nix` turns that data into a
Nix derivation, downloads the asset, verifies its hash, unpacks a recognised
archive, and installs the executable in `$out/bin`.

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
2. Create `modules/pkgs/<name>.nix` using the format above.
3. Obtain the downloaded asset's Nix hash. For example:

   ```sh
   nix store prefetch-file --json <release-asset-url>
   ```

   Copy its `hash` value into the definition. Do not use a checksum for a
   different archive or platform.
4. Add the filename without `.nix` to `binaryPackages` in
   `modules/home.nix`:

   ```nix
   binaryPackages = map (name:
     fetchBinary (import (./pkgs + "/${name}.nix"))
   ) [
     "starship"
     "example"
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
