{ host, ... }:
{
  nixpkgs.hostPlatform = host.platform;
  networking.hostName = host.name;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = 6;
}
