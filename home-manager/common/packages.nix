{
  pkgs,
  lib,
  config,
  ...
}: {
  options.nixconf.packages = {
    aws = lib.mkEnableOption "AWS CLI";
    azure = lib.mkEnableOption "Azure CLI";
    cfssl = lib.mkEnableOption "CFSSL";
    digital-ocean = lib.mkEnableOption "Digital Ocean CLI";
    gcloud = lib.mkEnableOption "Google Cloud CLI";
  };

  config = {
    home.packages = pkgs.libExt.filterNull [
      # some must haves
      pkgs.lsof
      pkgs.lshw
      pkgs.pciutils
      pkgs.rsync
      pkgs.fd
      pkgs.ripgrep
      pkgs.ncdu
      pkgs.jq
      pkgs.traceroute
      pkgs.hyperfine
      pkgs.entr
      pkgs.ffmpegthumbnailer
      pkgs.just
      pkgs.bottom

      (pkgs.libExt.mkIfElseNull config.nixconf.packages.aws pkgs.awscli2)
      (pkgs.libExt.mkIfElseNull config.nixconf.packages.azure pkgs.azure-cli)
      (pkgs.libExt.mkIfElseNull config.nixconf.packages.cfssl pkgs.cfssl)
      (pkgs.libExt.mkIfElseNull config.nixconf.packages.digital-ocean pkgs.doctl)
      (pkgs.libExt.mkIfElseNull config.nixconf.packages.gcloud (
        pkgs.google-cloud-sdk.withExtraComponents [
          pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin
          pkgs.google-cloud-sdk.components.kubectl-oidc
          pkgs.google-cloud-sdk.components.terraform-tools
          pkgs.google-cloud-sdk.components.docker-credential-gcr
        ]
      ))
    ];
  };
}
