{ host, ... }:
{
  users.users.${host.user.name}.home = host.user.home;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${host.user.name} =
      { pkgs, ... }:
      let
        fetchBinary = import ../tools/fetch-binary.nix { inherit pkgs; };
        binaryPackages = map (name: fetchBinary (import (./pkgs + "/${name}.nix"))) [
          # Files in ./pkgs, without the .nix extension.
          "starship"
        ];
      in
      {
        imports = [
          ./shell/zsh.nix
          ./configs/config.nix
        ];

        home.stateVersion = "26.05";

        home.packages = [
          # Search package:
          # - `nix search nixpkgs <package-name>`
          # - `nix search github:NixOS/nixpkgs/<version-branch> <package-name>`
          # - https://search.nixos.org/packages
          pkgs.nixfmt
          pkgs.nmap
          pkgs.ripgrep
          pkgs.vim
          pkgs.yq

        ]
        ++ binaryPackages;
      };
  };
}
