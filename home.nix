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

  # Global packages (replaces mise global config)
  home.packages = with pkgs; [
    # Development
    nodejs_latest
    python3

    # Modern CLI tools
    btop
    bat
    eza
    ripgrep
    fd
    fzf
    zoxide

    # Version control
    git
    gh

    # Kubernetes
    kubectl
  ];
}
