{ host, inputs, ... }:
{
  users.users.${host.user.name}.home = host.user.home;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.${host.user.name} =
      { pkgs, inputs, ... }:
      let
        nixpkgsPackages = import ./pkgs/nixpkgs { inherit pkgs; };
        githubPackages = import ./pkgs/github { inherit pkgs; };
        flakePackages = import ./pkgs/flakes { inherit pkgs inputs; };
      in
      {
        imports = [
          ./shell/zsh.nix
          ./configs/config.nix
        ];

        home.stateVersion = "26.05";

        home.packages = nixpkgsPackages ++ githubPackages ++ flakePackages;
      };
  };
}
