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

  outputs =
    {
      nixpkgs,
      nix-darwin,
      home-manager,
      ...
    }:
    let
      system = "aarch64-darwin";
      pkgs = import nixpkgs { inherit system; };
      hosts = import ./modules/hosts;

      mkDarwin =
        host:
        nix-darwin.lib.darwinSystem {
          specialArgs = { inherit host; };

          modules = [
            home-manager.darwinModules.home-manager
            ./modules/default.nix
            ./modules/home.nix
          ];
        };

      darwinConfigurations = builtins.mapAttrs (_: host: mkDarwin host) hosts;
    in
    {
      inherit darwinConfigurations;

      # Host-specific system outputs. Build one explicitly
      # e.g. `nix build .#macbook-pro`
      packages.${system} = builtins.mapAttrs (
        _: configuration: configuration.system
      ) darwinConfigurations;

      # Development-only tools; they are not included in the macOS system output.
      # Enter devShell: `nix develop .#devTools`
      # Run commands within devShell: `nix develop .#devTools --command <command>`
      # Build only: `nix build .#devShells.${system}.devTools`
      devShells.${system}.devTools = pkgs.mkShell {
        packages = [
          home-manager.packages.${system}.default
        ];
      };
    };
}
