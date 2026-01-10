#!/usr/bin/env bash
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Detect platform
detect_platform() {
    local os=$(uname -s)
    local arch=$(uname -m)

    case "$os" in
        Darwin)
            if [ "$arch" = "arm64" ]; then
                echo "aarch64-darwin"
            else
                echo "x86_64-darwin"
            fi
            ;;
        Linux)
            if [ "$arch" = "aarch64" ] || [ "$arch" = "arm64" ]; then
                echo "aarch64-linux"
            else
                echo "x86_64-linux"
            fi
            ;;
        *)
            error "Unsupported operating system: $os"
            exit 1
            ;;
    esac
}

# Check if Nix is installed
check_nix() {
    if command -v nix &> /dev/null; then
        return 0
    else
        return 1
    fi
}

# Source Nix environment
source_nix() {
    if [ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
    elif [ -f ~/.nix-profile/etc/profile.d/nix.sh ]; then
        . ~/.nix-profile/etc/profile.d/nix.sh
    fi
}

# Install Nix using Determinate Systems installer
install_nix() {
    info "Installing Nix using Determinate Systems installer..."
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | \
        sh -s -- install --no-confirm

    # Source Nix after installation
    source_nix

    success "Nix installed successfully"
}

# Enable flakes
enable_flakes() {
    local nix_conf_dir="$HOME/.config/nix"
    local nix_conf="$nix_conf_dir/nix.conf"

    mkdir -p "$nix_conf_dir"

    if [ -f "$nix_conf" ]; then
        if ! grep -q "experimental-features" "$nix_conf"; then
            info "Enabling flakes in $nix_conf..."
            echo "experimental-features = nix-command flakes" >> "$nix_conf"
        else
            info "Flakes already enabled"
        fi
    else
        info "Creating $nix_conf with flakes enabled..."
        echo "experimental-features = nix-command flakes" > "$nix_conf"
    fi
}

# Install Home Manager
install_home_manager() {
    info "Installing Home Manager..."
    nix run nixpkgs#home-manager -- --version &> /dev/null || {
        info "Home Manager will be installed on first use"
    }
}

# Apply Home Manager configuration
apply_home_manager() {
    local config=$1

    info "Applying Home Manager configuration: $config"

    # Check if we're in the right directory
    if [ ! -f "flake.nix" ]; then
        error "flake.nix not found. Please run this script from the nix-dotfiles directory."
        exit 1
    fi

    nix run nixpkgs#home-manager -- switch --flake ".#$config"

    success "Home Manager configuration applied"
}

# Set zsh as default shell
set_default_shell() {
    local zsh_path

    # Find nix-managed zsh
    zsh_path=$(command -v zsh || echo "")

    if [ -z "$zsh_path" ]; then
        warn "Could not find zsh in PATH. Skipping default shell setup."
        return
    fi

    # Check if zsh is already the default
    if [ "$SHELL" = "$zsh_path" ]; then
        info "Zsh is already the default shell"
        return
    fi

    info "Setting zsh as default shell..."

    # Add to /etc/shells if not present
    if [ "$(uname -s)" = "Darwin" ]; then
        if ! grep -q "$zsh_path" /etc/shells 2>/dev/null; then
            info "Adding $zsh_path to /etc/shells (requires sudo)..."
            echo "$zsh_path" | sudo tee -a /etc/shells > /dev/null
        fi
    fi

    # Change default shell
    chsh -s "$zsh_path" || {
        warn "Failed to change default shell. You may need to run: chsh -s $zsh_path"
    }
}

# Main installation process
main() {
    echo ""
    info "🚀 Nix Dotfiles Installation"
    echo ""

    # Detect platform
    local platform=$(detect_platform)
    local hostname=$(hostname -s)

    info "Detected platform: $platform"
    info "Hostname: $hostname"

    # Determine configuration
    local config="marko@linux"
    if [[ "$platform" == *"darwin"* ]]; then
        config="marko@$hostname"
    fi

    info "Using configuration: $config"
    echo ""

    # Check if Nix is installed
    if check_nix; then
        local nix_version=$(nix --version | head -n1)
        info "Nix already installed ($nix_version)"
        source_nix
    else
        install_nix
    fi

    # Enable flakes
    enable_flakes

    # Install and apply Home Manager
    install_home_manager
    apply_home_manager "$config"

    # Set zsh as default shell
    set_default_shell

    echo ""
    success "✅ Installation complete!"
    echo ""
    info "Next steps:"
    echo "  1. Restart your terminal or run: exec zsh"
    echo "  2. Verify installation with: home-manager --version"
    echo "  3. Update configuration: edit files in $(pwd)"
    echo "  4. Apply changes: home-manager switch --flake .#$config"
    echo ""
}

# Run main function
main
