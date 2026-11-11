{ pkgs, inputs }:
[
  inputs.mole.packages.${pkgs.stdenv.hostPlatform.system}.default
]
