{
  description = "Macflake";

  # See https://nix.dev/manual/nix/2.35/command-ref/new-cli/nix3-flake.html#url-like-syntax
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    # See https://nix.dev/manual/nix/2.35/command-ref/new-cli/nix3-flake.html#flake-inputs
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, ... }:
  let
    host = import ./modules/identity.nix;
    pkgs = import nixpkgs { system = host.platform; };
  in {
    darwinConfigurations.${host.name} = nix-darwin.lib.darwinSystem {
      specialArgs = { inherit host; };

      modules = [
        home-manager.darwinModules.home-manager
        ./modules/default.nix
        ./modules/home.nix
      ];
    };
    packages.${host.platform}.default = self.darwinConfigurations.${host.name}.system;

    # Development-only tools; they are not included in the macOS system output.
    # Enter devShell: `nix develop .#devTools`
    # Build only: `nix build .#devShells.${host.platform}.devTools`
    devShells.${host.platform}.devTools = pkgs.mkShell {
      packages = [
        home-manager.packages.${host.platform}.default
      ];
    };
  };
}
