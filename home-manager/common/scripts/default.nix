{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./templater.nix
  ];

  options.nixconf.scripts = {
    enable = lib.mkEnableOption "Custom Scripts";
  };
}
