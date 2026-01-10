{ config, pkgs, ... }:

{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  # Reference the starship config file
  home.file.".config/starship/starship.toml".source = ../config/starship.toml;
}
