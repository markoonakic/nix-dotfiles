{ config, pkgs, lib, ... }:

{
  programs.zsh = {
    enable = true;

    # Enable vi mode
    defaultKeymap = "viins";

    # Environment variables
    sessionVariables = {
      EDITOR = "nvim";
      LANG = "en_US.UTF-8";
      STARSHIP_CONFIG = "${config.home.homeDirectory}/.config/starship/starship.toml";
    };


    # Oh My Zsh configuration
    oh-my-zsh = {
      enable = true;
      plugins = [
        "kubectl"
        "sudo"
        "git"
      ];
    };

    # Additional plugins (not in OMZ)
    plugins = [
      {
        name = "fzf-tab";
        src = pkgs.fetchFromGitHub {
          owner = "Aloxaf";
          repo = "fzf-tab";
          rev = "c7fb028ec0bbc1056c51508602dbd61b0f475ac3";
          sha256 = "sha256-Qv8zAiMtrr67CbLRrFjGaPzFZcOiMVEFLg1Z+N6VMhg=";
        };
      }
      {
        name = "zsh-autocomplete";
        src = pkgs.fetchFromGitHub {
          owner = "marlonrichert";
          repo = "zsh-autocomplete";
          rev = "24.09.04";
          sha256 = "sha256-9sJcQWWdxQJWtFr0W7QJKdDlnJOUGxY3lNQEYb+Mfhw=";
        };
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "0.8.0";
          sha256 = "sha256-iJdWopZwHpSyYl5/FQXEW7gl/SrKaYDEtTH9cGP7iPo=";
        };
      }
      {
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.7.0";
          sha256 = "sha256-KLUYpUu4DHRumQZ3w59m9aTW6TBKMCXl2UcKi4uMd7w=";
        };
      }
    ];

    # Shell aliases
    shellAliases = {
      # Basic
      cl = "clear";
      cdl = "cd && cl";

      # Zoxide
      z = "zi";

      # Modern replacements (bat and eza are guaranteed to be installed via Home Manager)
      cat = "bat";
      ls = "eza --color=always --icons";
      l = "eza --color=always --icons --long";
      la = "eza --color=always --icons --long --all";
      ll = "eza --color=always --icons --long --header";
      tree = "eza --tree --color=always --icons";

      # Editor
      v = "nvim";
      vim = "nvim";

      # Git shortcuts
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gpl = "git pull";

      # Python
      py = "python3";

      # Kubernetes
      k = "kubectl";
    };

    # Additional initialization
    initContent = ''
      # Vi mode timeout
      export KEYTIMEOUT=1

      # Enable completion
      autoload -Uz compinit && compinit
    '';
  };
}
