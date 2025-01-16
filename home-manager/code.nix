{
  imports = [
    ./common
  ];

  config = {
    nixconf = rec {
      username = "code";
      stateVersion = "24.05";
      flakePath = "/home/${username}/nixconf";

      scripts.enable = true;

      editor = {
        neovim = true;
      };

      packages = {
        terraform = true;
        gcloud = true;
        kubectl = true;
        k9s = true;
        k3d = true;
        helm = true;
        argo = true;
      };
    };
  };
}
