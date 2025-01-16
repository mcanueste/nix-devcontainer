{pkgs, ...}: {
  imports = [
    ./templater.nix
  ];

  options.nixconf.scripts = {
    enable = pkgs.libExt.mkEnabledOption "Custom Scripts";
  };
}
