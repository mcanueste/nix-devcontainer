{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./templater.nix
  ];

  options.nixconf.scripts = {
    enable = lib.mkOption "Custom Scripts";
  };
}
