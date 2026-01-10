{ config, pkgs, ... }:

{
  # Git configuration
  programs.git = {
    enable = true;
    userName = "Marko Nakic";
    userEmail = "marko@markonakic.xyz";

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };

  # Bat configuration (cat replacement)
  programs.bat = {
    enable = true;
    config = {
      theme = "TwoDark";
    };
  };

  # direnv for project environments
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # fzf configuration
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # zoxide configuration (modern cd)
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}
