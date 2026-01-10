{
  description = "Marko's Nix Dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }: {
    # macOS configuration (M1 Mac named "kurton")
    homeConfigurations."marko@kurton" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.aarch64-darwin;
      modules = [ ./home.nix ];
    };

    # Linux server configuration (generic x86_64)
    homeConfigurations."marko@linux" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [ ./home.nix ];
    };

    # Devcontainer configuration (minimal, used by nix-dev-init containers)
    homeConfigurations."marko@devcontainer" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [
        ./home.nix
        {
          # Minimal config for containers - disable heavy features
          home.packages = with nixpkgs.legacyPackages.x86_64-linux; [
            git
            # Add only essential tools for containers
          ];
        }
      ];
    };
  };
}
