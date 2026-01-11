{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  # User info
  home.username = "marko";
  home.homeDirectory = if pkgs.stdenv.isDarwin
    then "/Users/marko"
    else "/home/marko";
  home.stateVersion = "24.11";

  # Import modules
  imports = [
    ./modules/shell.nix
    ./modules/tools.nix
    ./modules/starship.nix
    ./modules/neovim.nix
  ];

  # Universal CLI tools (language runtimes are per-project via flakes)
  home.packages = with pkgs; [
    # Version control
    git

    # Modern CLI tools
    bat
    eza
    ripgrep
    fd
    fzf
    zoxide
  ];
}
