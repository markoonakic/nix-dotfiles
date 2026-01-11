{ config, pkgs, lib, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # Dependencies for Mason (prettier, eslint, formatters, etc.)
    extraPackages = with pkgs; [
      nodejs_latest  # Required for npm-based Mason packages
    ];
  };

  # Clone funky-nvim on activation
  home.activation.cloneNvimConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    NVIM_DIR="${config.home.homeDirectory}/.config/nvim"
    REPO="https://github.com/markoonakic/funky-nvim.git"

    if [ ! -d "$NVIM_DIR/.git" ]; then
      echo "Cloning funky-nvim configuration..."
      $DRY_RUN_CMD ${pkgs.git}/bin/git clone --depth 1 "$REPO" "$NVIM_DIR"
    else
      echo "funky-nvim already cloned at $NVIM_DIR"
    fi
  '';
}
