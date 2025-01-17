{
  imports = [
    ./common
  ];

  config = {
    nixconf = rec {
      username = "code";
      stateVersion = "24.05";
      flakePath = "/home/${username}/nixconf";
    };
  };
}
