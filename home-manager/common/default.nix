{
  inputs,
  outputs,
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./editor
    ./scripts
    ./shell

    ./git.nix
    ./packages.nix
    ./theme.nix
  ];

  options.nixconf = {
    username = lib.mkOption {
      type = lib.types.str;
      default = "code";
      description = "Username";
    };

    stateVersion = lib.mkOption {
      type = lib.types.str;
      default = "24.05";
      description = "Nix State Version";
    };

    flakePath = lib.mkOption {
      type = lib.types.str;
      default = "/home/${config.nixconf.username}/nixconf";
      description = "Full path to flake for NH CLI";
    };
  };

  config = {
    nixpkgs = {
      overlays =
        lib.attrsets.attrValues outputs.overlays
        ++ [
          # You can also add overlays exported from other flakes:
          # inputs.nixgl.overlays.default # install packages directly from outputs instead
        ];

      config = {
        allowUnfree = true;
      };
    };

    home = {
      username = config.nixconf.username;
      homeDirectory = "/home/${config.nixconf.username}";
    };

    # Set state version, not really important as we are using flakes
    home.stateVersion = config.nixconf.stateVersion;

    nix = {
      # Nix CLI version
      package = lib.mkDefault pkgs.nixVersions.latest;

      # Run garbage collection daily (for home profile)
      gc = {
        automatic = true;
        frequency = "daily";
        options = "--delete-older-than 3d";
      };

      settings = {
        # Enable flakes
        experimental-features = ["nix-command" "flakes"];

        # Don't warn about dirty git state
        warn-dirty = false;

        # Optimize store after each build
        auto-optimise-store = false;

        # Avoid unwanted garbage collection when using nix-direnv
        keep-outputs = true;
        keep-derivations = true;

        # Add user to the trusted users
        trusted-users = [config.nixconf.username];
      };

      # flake registry defaults to nixpkgs (unstable in this case)
      registry.nixpkgs.flake = inputs.nixpkgs;
    };

    # Enable settings to make it work better on standalone hm installations
    targets.genericLinux.enable = true;

    # Set flakes path for nh
    home.sessionVariables.FLAKE = config.nixconf.flakePath;
    home.packages = [
      # Better nix tools
      pkgs.nh
      pkgs.nvd
      pkgs.nix-output-monitor

      # Install home-manager CLI
      pkgs.home-manager
    ];
  };
}
