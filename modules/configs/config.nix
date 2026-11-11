let
  configFiles = {
    ".config/starship.toml" = ./starship.toml;
  };
in
{
  home.file = builtins.mapAttrs (_: source: { inherit source; }) configFiles;
}
