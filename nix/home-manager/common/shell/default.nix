{pkgs, ...}: let
  enable = {
    enable = true;
    enableBashIntegration = true;
  };
in {
  imports = [
    ./bash.nix
  ];

  options.nixconf.shell = {
    starship = pkgs.libExt.mkEnabledOption "Starship";
  };

  config = {
    programs = {
      direnv = builtins.removeAttrs enable ["enableFishIntegration"]; # fish integration enabled by default

      eza =
        enable
        // {
          git = true;
          icons = "auto";
        };

      fzf =
        enable
        // {
          defaultCommand = "${pkgs.fd}/bin/fd --type f";
          fileWidgetCommand = "${pkgs.fd}/bin/fd --type f";
          fileWidgetOptions = [
            "--preview '${pkgs.bat}/bin/bat --style=numbers --color=always --line-range :500 {}'"
          ];
          changeDirWidgetCommand = "${pkgs.fd}/bin/fd --type d";
          changeDirWidgetOptions = ["--preview '${pkgs.tree}/bin/tree -C {} | head -200'"];
        };

      yazi =
        enable
        // {
          keymap = {};
          settings = {};
        };

      zoxide = enable;

      starship =
        enable
        // {
          settings = {
            scan_timeout = 10;
            add_newline = true;
            # format = "$all"; # Disable default prompt format
            battery = {disabled = true;};
            fill = {disabled = true;};
          };
        };

      # fish wants to generate man cache for every lang for no reason...
      man.generateCaches = false;
    };
  };
}
