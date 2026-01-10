# Nix Dotfiles

Personal dotfiles managed by [Home Manager](https://github.com/nix-community/home-manager), running standalone (works with nix-darwin on macOS and on Linux servers).

## Features

- ✅ **Declarative dotfiles** - All configuration in version control
- ✅ **Cross-platform** - Same config on macOS and Linux
- ✅ **Reproducible** - Exact package versions via `flake.lock`
- ✅ **Zsh + Oh My Zsh** - Managed declaratively with plugins
- ✅ **Modern CLI tools** - bat, eza, ripgrep, fd, fzf, zoxide
- ✅ **Neovim** - Auto-clones [funky-nvim](https://github.com/markoonakic/funky-nvim) config
- ✅ **Starship prompt** - Custom prompt configuration
- ✅ **Git configuration** - Author info and preferences
- ✅ **direnv** - Automatic project environment loading

## Quick Start

### Installation

```bash
# Clone the repository
git clone git@github.com:markoonakic/nix-dotfiles.git ~/.config/nix-dotfiles
cd ~/.config/nix-dotfiles

# Run the installer
./install.sh
```

The installer will:
1. Detect your platform (macOS or Linux)
2. Install Nix if not already present
3. Enable flakes support
4. Apply your Home Manager configuration
5. Set zsh as your default shell

### One-Command Bootstrap (from GitHub)

```bash
curl -fsSL https://raw.githubusercontent.com/markoonakic/nix-dotfiles/main/install.sh | bash
```

## Configurations

This repository provides three Home Manager configurations:

### `marko@kurton` (macOS - M1 Mac)
```bash
home-manager switch --flake ~/.config/nix-dotfiles#marko@kurton
```

### `marko@linux` (Linux servers)
```bash
home-manager switch --flake ~/.config/nix-dotfiles#marko@linux
```

### `marko@devcontainer` (Containers - minimal)
Used by [nix-dev-init](https://github.com/markoonakic/nix-dev-init) containers. Contains only essential tools to keep image size small.

## Repository Structure

```
nix-dotfiles/
├── flake.nix              # Entry point - defines Home Manager configurations
├── flake.lock             # Locked dependency versions
├── home.nix               # Main configuration - imports modules
├── modules/
│   ├── shell.nix          # Zsh + Oh My Zsh + plugins + aliases
│   ├── tools.nix          # Tool configurations (git, bat, direnv, fzf, zoxide)
│   ├── starship.nix       # Starship prompt
│   └── neovim.nix         # Neovim + funky-nvim clone
├── config/
│   └── starship.toml      # Starship prompt configuration
├── install.sh             # Bootstrap script
└── README.md              # This file
```

## Daily Commands

### Update Configuration

```bash
# Edit configuration
nvim ~/.config/nix-dotfiles/home.nix

# Apply changes
cd ~/.config/nix-dotfiles
home-manager switch --flake .#marko@kurton  # macOS
# or
home-manager switch --flake .#marko@linux   # Linux
```

### Manage Generations

```bash
# List all generations
home-manager generations

# Rollback to previous generation
home-manager switch --rollback

# Remove old generations (free disk space)
nix-collect-garbage -d
```

### Update Packages

```bash
# Update flake inputs (nixpkgs, home-manager)
nix flake update

# Apply updates
home-manager switch --flake .#marko@kurton
```

## Customization

### Adding Packages

Edit `home.nix` and add packages to `home.packages`:

```nix
home.packages = with pkgs; [
  # Existing packages...

  # Add new packages
  htop
  jq
  yq
];
```

### Adding Aliases

Edit `modules/shell.nix` and add to `shellAliases`:

```nix
shellAliases = {
  # Existing aliases...

  # Add new aliases
  myalias = "my-command";
};
```

### Git Configuration

Edit `modules/tools.nix`:

```nix
programs.git = {
  enable = true;
  userName = "Your Name";
  userEmail = "your@email.com";

  extraConfig = {
    # Add git settings here
  };
};
```

## Included Tools

### Shell
- **zsh** - Default shell with vi mode
- **Oh My Zsh** - Plugin framework
- **Starship** - Fast, customizable prompt

### Development
- **neovim** - Text editor (funky-nvim config auto-cloned)
- **git** + **gh** - Version control
- **nodejs** - Node.js runtime
- **python3** - Python runtime

### Modern CLI
- **bat** - Better `cat` with syntax highlighting
- **eza** - Better `ls` with icons
- **ripgrep** - Fast grep alternative
- **fd** - Fast find alternative
- **fzf** - Fuzzy finder
- **zoxide** - Smart cd replacement
- **btop** - Resource monitor

### Tools
- **direnv** - Automatic environment loading
- **kubectl** - Kubernetes CLI

## SSH Keys

SSH keys are **not** managed by Nix (kept manual for security). When setting up a new machine:

1. Run `./install.sh` to get your dotfiles
2. Copy SSH keys to `~/.ssh/` or generate new ones
3. Git cloning via SSH works immediately

## Relationship with nix-darwin

On macOS, this uses **standalone Home Manager** which coexists peacefully with nix-darwin:

- **nix-darwin** (`/etc/nix-darwin/`) - System-level configuration
- **Home Manager** (`~/.config/nix-dotfiles/`) - User-level configuration

They don't conflict. nix-darwin manages system settings, Home Manager manages your personal environment.

## Troubleshooting

### Flakes not enabled error
```bash
# Enable flakes manually
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

### Command not found after installation
```bash
# Restart your shell
exec zsh
```

### Home Manager activation fails
```bash
# Check for errors
home-manager switch --flake .#marko@kurton --show-trace

# Dry run to see what would change
home-manager switch --flake .#marko@kurton --dry-run
```

## Learn More

- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Nix Flakes](https://nixos.wiki/wiki/Flakes)
- [nix.dev Tutorials](https://nix.dev/)
- [Nix Package Search](https://search.nixos.org/packages)

## Related Projects

- [nix-dev-init](https://github.com/markoonakic/nix-dev-init) - Project initialization with direnv + container workflows
- [funky-nvim](https://github.com/markoonakic/funky-nvim) - Neovim configuration

## License

MIT
