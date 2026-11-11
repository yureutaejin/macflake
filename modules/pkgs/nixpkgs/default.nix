{ pkgs }:
[
  # Search packages:
  # - `nix search nixpkgs <package-name>`
  # - `nix search github:NixOS/nixpkgs/<version-branch> <package-name>`
  # - https://search.nixos.org/packages

  # Nix language tools
  pkgs.nixd
  pkgs.nixfmt
  # User tools
  pkgs.nmap
  pkgs.ripgrep
  pkgs.vim
  pkgs.yq
]
