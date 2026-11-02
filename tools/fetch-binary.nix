{ pkgs }:
{
    pname,
    version,
    sources,
    meta ? { },
}:
let
  system = pkgs.stdenvNoCC.hostPlatform.system;
  source = sources.${system} or (throw "${pname} does not provide a binary for ${system}");
in
pkgs.stdenvNoCC.mkDerivation {
  inherit pname version meta;

  src = pkgs.fetchurl {
    inherit (source) url hash;
  };

  dontBuild = true;
  # Some release archives unpack their executable directly into the build directory.
  sourceRoot = ".";
  installPhase = ''
    mkdir -p "$out/bin"
    install -m755 ${pkgs.lib.escapeShellArg source.binary} "$out/bin/${source.name or pname}"
  '';
}
