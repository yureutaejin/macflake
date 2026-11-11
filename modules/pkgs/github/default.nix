{ pkgs }:
let
  fetchBinary = import ../../../tools/fetch-binary.nix { inherit pkgs; };
in
[
  (fetchBinary (import ./starship.nix))
]
