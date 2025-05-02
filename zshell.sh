#!/bin/bash
#==============================================================================
#
#   ███████╗███████╗██╗  ██╗    ███████╗███████╗████████╗██╗   ██╗██████╗ 
#   ╚══███╔╝██╔════╝██║  ██║    ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗
#     ███╔╝ ███████╗███████║    ███████╗█████╗     ██║   ██║   ██║██████╔╝
#    ███╔╝  ╚════██║██╔══██║    ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝ 
#   ███████╗███████║██║  ██║    ███████║███████╗   ██║   ╚██████╔╝██║     
#   ╚══════╝╚══════╝╚═╝  ╚═╝    ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝     
#
#==============================================================================
#
# Ultimate ZSH Setup Script
# Author: Claude
# Description: Sets up ZSH with Oh My Zsh, Powerlevel10k theme and essential plugins
# 
# Usage: ./zshell.sh [options]
#   Options:
#     -h, --help     Display this help message
#     -y, --yes      Skip confirmation prompts (non-interactive mode)
#     -q, --quiet    Minimal output, only errors and success messages
#     -v, --verbose  Show detailed output for debugging
#
#==============================================================================

# Exit if any command fails
set -e

# Script configuration variables
INTERACTIVE=true
QUIET=false
VERBOSE=false

# Color codes for prettier output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
PURPLE='\033[0;35m'
RESET='\033[0m'

# Function to print section headers
print_header() {
    local text="$1"
    local length=${#text}
    local line=$(printf '%*s' "$length" | tr ' ' '=')
    echo -e "\n${BLUE}$line${RESET}"
    echo -e "${BLUE}$text${RESET}"
    echo -e "${BLUE}$line${RESET}\n"
}

# Function to print success messages
print_success() {
    echo -e "${GREEN}✓ $1${RESET}"
}

# Function to print info messages
print_info() {
    echo -e "${YELLOW}➜ $1${RESET}"
}

# Function to print error messages
print_error() {
    echo -e "${RED}✗ $1${RESET}"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to backup file if it exists
backup_file() {
    if [ -f "$1" ]; then
        local backup="$1.backup.$(date +%Y%m%d%H%M%S)"
        print_info "Backing up $1 to $backup"
        cp "$1" "$backup"
    fi
}

# Function to display help message
show_help() {
    cat << EOF
Usage: $0 [options]

Options:
  -h, --help     Display this help message
  -y, --yes      Skip confirmation prompts (non-interactive mode)
  -q, --quiet    Minimal output, only errors and success messages
  -v, --verbose  Show detailed output for debugging
EOF
}

# Function to confirm actions with the user
confirm_action() {
    local message="$1"
    local default="$2"
    
    if [ "$INTERACTIVE" = false ]; then
        return 0
    fi
    
    local prompt
    if [ "$default" = "y" ]; then
        prompt="[Y/n]"
    else
        prompt="[y/N]"
    fi
    
    echo -e "\n${YELLOW}$message $prompt${RESET}"
    read -r response
    
    case "$response" in
        [yY][eE][sS]|[yY])
            return 0
            ;;
        [nN][oO]|[nN])
            return 1
            ;;
        "")
            if [ "$default" = "y" ]; then
                return 0
            else
                return 1
            fi
            ;;
        *)
            echo -e "${RED}Invalid response. Please answer yes or no.${RESET}"
            confirm_action "$message" "$default"
            ;;
    esac
}

# Parse command line arguments
parse_arguments() {
    while [ $# -gt 0 ]; do
        case "$1" in
            -h|--help)
                show_help
                exit 0
                ;;
            -y|--yes)
                INTERACTIVE=false
                ;;
            -q|--quiet)
                QUIET=true
                ;;
            -v|--verbose)
                VERBOSE=true
                ;;
            *)
                echo -e "${RED}Unknown option: $1${RESET}"
                show_help
                exit 1
                ;;
        esac
        shift
    done
}

# Main function to control script execution
main() {
    # Parse command line arguments
    parse_arguments "$@"
    
    # Display welcome message
    if [ "$QUIET" = false ]; then
        clear
        cat << "EOF"
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃                                                                             ┃
┃   ██╗   ██╗██╗  ████████╗██╗███╗   ███╗ █████╗ ████████╗███████╗            ┃
┃   ██║   ██║██║  ╚══██╔══╝██║████╗ ████║██╔══██╗╚══██╔══╝██╔════╝            ┃
┃   ██║   ██║██║     ██║   ██║██╔████╔██║███████║   ██║   █████╗              ┃
┃   ██║   ██║██║     ██║   ██║██║╚██╔╝██║██╔══██║   ██║   ██╔══╝              ┃
┃   ╚██████╔╝███████╗██║   ██║██║ ╚═╝ ██║██║  ██║   ██║   ███████╗            ┃
┃    ╚═════╝ ╚══════╝╚═╝   ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝   ╚═╝   ╚══════╝            ┃
┃                                                                             ┃
┃             ███████╗███████╗██╗  ██╗    ███████╗███████╗████████╗██╗   ██╗  ┃
┃             ╚══███╔╝██╔════╝██║  ██║    ██╔════╝██╔════╝╚══██╔══╝██║   ██║  ┃
┃               ███╔╝ ███████╗███████║    ███████╗█████╗     ██║   ██║   ██║  ┃
┃              ███╔╝  ╚════██║██╔══██║    ╚════██║██╔══╝     ██║   ██║   ██║  ┃
┃             ███████╗███████║██║  ██║    ███████║███████╗   ██║   ╚██████╔╝  ┃
┃             ╚══════╝╚══════╝╚═╝  ╚═╝    ╚══════╝╚══════╝   ╚═╝    ╚═════╝   ┃
┃                                                                             ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
EOF

        echo -e "${PURPLE}This script will set up an awesome ZSH environment with:${RESET}"
        echo -e " ${YELLOW}•${RESET} ZSH as your default shell"
        echo -e " ${YELLOW}•${RESET} Oh My ZSH framework"
        echo -e " ${YELLOW}•${RESET} Powerlevel10k theme"
        echo -e " ${YELLOW}•${RESET} Syntax highlighting"
        echo -e " ${YELLOW}•${RESET} Auto-suggestions"
        echo -e " ${YELLOW}•${RESET} History improvements"
        echo -e " ${YELLOW}•${RESET} Additional useful plugins"
        echo -e "\n${PURPLE}Let's get started!${RESET}"
        
        sleep 2
    fi
    
    # Confirm installation if in interactive mode
    if ! confirm_action "Do you want to proceed with the ZSH setup?" "y"; then
        echo -e "${YELLOW}Setup cancelled by user.${RESET}"
        exit 0
    fi
    
    # Check for root permissions
    print_header "Checking Prerequisites"
    if [ "$EUID" -ne 0 ] && ! command_exists sudo; then
        print_error "This script requires either sudo privileges or to be run as root"
        exit 1
    fi

# Install dependencies
print_header "Installing Dependencies"
if command_exists apt; then
    print_info "Detected apt package manager (Debian/Ubuntu based)"
    print_info "Updating package lists..."
    sudo apt update -q
    print_info "Installing ZSH and other required packages..."
    sudo apt install -y zsh curl git wget fonts-powerline zsh-doc
    print_success "Dependencies installed successfully"
elif command_exists dnf; then
    print_info "Detected dnf package manager (Fedora/RHEL based)"
    print_info "Updating package lists..."
    sudo dnf check-update -q
    print_info "Installing ZSH and other required packages..."
    sudo dnf install -y zsh curl git wget powerline-fonts zsh-syntax-highlighting
    print_success "Dependencies installed successfully"
elif command_exists yum; then
    print_info "Detected yum package manager (CentOS/RHEL based)"
    print_info "Updating package lists..."
    sudo yum check-update -q
    print_info "Installing ZSH and other required packages..."
    sudo yum install -y zsh curl git wget
    print_success "Dependencies installed successfully"
elif command_exists pacman; then
    print_info "Detected pacman package manager (Arch based)"
    print_info "Updating package lists..."
    sudo pacman -Sy
    print_info "Installing ZSH and other required packages..."
    sudo pacman -S --noconfirm zsh curl git wget powerline-fonts zsh-syntax-highlighting
    print_success "Dependencies installed successfully"
elif command_exists brew; then
    print_info "Detected Homebrew package manager (macOS)"
    print_info "Installing ZSH and other required packages..."
    brew install zsh curl git wget
    brew tap homebrew/cask-fonts
    brew install --cask font-powerline-symbols
    print_success "Dependencies installed successfully"
else
    print_error "Unsupported package manager. Please install ZSH, curl, and git manually."
    exit 1
fi

# Verify installed versions
print_info "Verifying installed versions..."
if ! command_exists zsh; then
    print_error "ZSH installation failed"
    exit 1
fi
zsh --version
curl --version
git --version
wget --version

# Set ZSH as default shell
print_header "Setting ZSH as Default Shell"
ZSH_PATH=$(which zsh)
if [ "$SHELL" != "$ZSH_PATH" ]; then
    print_info "Changing default shell to ZSH..."
    sudo chsh -s "$ZSH_PATH" $USER
    print_success "Default shell changed to ZSH"
else
    print_info "ZSH is already your default shell"
fi

# Install Oh My ZSH
print_header "Installing Oh My ZSH"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_info "Installing Oh My ZSH framework..."
    export RUNZSH=no
    export KEEP_ZSHRC=yes
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    print_success "Oh My ZSH installed successfully"
else
    print_info "Oh My ZSH is already installed"
fi

# Set ZSH_CUSTOM if not already set
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

# Install Powerlevel10k theme
print_header "Installing Powerlevel10k Theme"
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    print_info "Cloning Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
    print_success "Powerlevel10k theme installed successfully"
else
    print_info "Powerlevel10k theme is already installed"
    print_info "Updating Powerlevel10k theme..."
    cd "$ZSH_CUSTOM/themes/powerlevel10k" && git pull
    print_success "Powerlevel10k theme updated successfully"
fi

# Install plugins
print_header "Installing Essential ZSH Plugins"

# Install zsh-autosuggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    print_info "Installing zsh-autosuggestions..."
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    print_success "zsh-autosuggestions installed successfully"
else
    print_info "zsh-autosuggestions is already installed"
    print_info "Updating zsh-autosuggestions..."
    cd "$ZSH_CUSTOM/plugins/zsh-autosuggestions" && git pull
    print_success "zsh-autosuggestions updated successfully"
fi

# Install zsh-syntax-highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    print_info "Installing zsh-syntax-highlighting..."
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    print_success "zsh-syntax-highlighting installed successfully"
else
    print_info "zsh-syntax-highlighting is already installed"
    print_info "Updating zsh-syntax-highlighting..."
    cd "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" && git pull
    print_success "zsh-syntax-highlighting updated successfully"
fi

# Install zsh-completions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-completions" ]; then
    print_info "Installing zsh-completions..."
    git clone --depth=1 https://github.com/zsh-users/zsh-completions.git "$ZSH_CUSTOM/plugins/zsh-completions"
    print_success "zsh-completions installed successfully"
else
    print_info "zsh-completions is already installed"
    print_info "Updating zsh-completions..."
    cd "$ZSH_CUSTOM/plugins/zsh-completions" && git pull
    print_success "zsh-completions updated successfully"
fi

# Install fzf
if [ ! -d "$HOME/.fzf" ]; then
    print_info "Installing fzf (fuzzy finder)..."
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
    "$HOME/.fzf/install" --all --no-update-rc
    print_success "fzf installed successfully"
else
    print_info "fzf is already installed"
    print_info "Updating fzf..."
    cd "$HOME/.fzf" && git pull && ./install --all --no-update-rc
    print_success "fzf updated successfully"
fi

# Update .zshrc configuration
print_header "Configuring ZSH"
backup_file "$HOME/.zshrc"

# Get current .zshrc content
zshrc_content=$(cat "$HOME/.zshrc")

# Update ZSH theme
print_info "Setting Powerlevel10k as the theme..."
zshrc_content=$(echo "$zshrc_content" | sed 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/')

# Update plugins list
print_info "Configuring plugins..."
plugins_line="plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-completions fzf history colored-man-pages command-not-found sudo copypath docker)"
zshrc_content=$(echo "$zshrc_content" | sed 's/^plugins=(.*/'"$plugins_line"'/')

# Add some useful ZSH settings
print_info "Adding custom ZSH settings..."
custom_settings=$(cat << 'EOF'

# Custom ZSH settings
# -------------------

# History settings
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_ALL_DUPS  # Don't save duplicates
setopt HIST_FIND_NO_DUPS     # Don't display duplicates when searching
setopt HIST_IGNORE_SPACE     # Don't save commands starting with space
setopt SHARE_HISTORY         # Share history between sessions
setopt EXTENDED_HISTORY      # Save timestamp and duration

# Directory navigation
setopt AUTO_CD               # Auto cd if command is just a path
setopt AUTO_PUSHD            # Make cd push the old directory onto the stack
setopt PUSHD_IGNORE_DUPS     # Don't push duplicates onto the stack
setopt PUSHD_MINUS           # Swap +/- operators for cd -X

# Completion system
zstyle ':completion:*' menu select                  # Menu-driven completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Case insensitive completion
zstyle ':completion:*' special-dirs true            # Complete . and .. directories
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" # Colored completion

# FZF integration
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Useful aliases
alias ls='ls --color=auto'
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias md='mkdir -p'
alias rd='rmdir'
alias h='history'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'

# Function to extract any archive
extract() {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1     ;;
      *.tar.gz)    tar xzf $1     ;;
      *.bz2)       bunzip2 $1     ;;
      *.rar)       unrar e $1     ;;
      *.gz)        gunzip $1      ;;
      *.tar)       tar xf $1      ;;
      *.tbz2)      tar xjf $1     ;;
      *.tgz)       tar xzf $1     ;;
      *.zip)       unzip $1       ;;
      *.Z)         uncompress $1  ;;
      *.7z)        7z x $1        ;;
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Create a directory and cd into it
mcd() {
  mkdir -p "$1" && cd "$1"
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

EOF
)

# Ensure Oh My ZSH is sourced
if ! echo "$zshrc_content" | grep -q "source \$ZSH/oh-my-zsh.sh"; then
    zshrc_content="${zshrc_content}\nsource \$ZSH/oh-my-zsh.sh"
fi

# Add custom settings
if ! echo "$zshrc_content" | grep -q "Custom ZSH settings"; then
    zshrc_content="${zshrc_content}\n${custom_settings}"
fi

# Save the updated .zshrc
echo -e "$zshrc_content" > "$HOME/.zshrc"
print_success ".zshrc configuration updated successfully"

# Final Setup & Instructions
print_header "Setup Complete!"
echo -e "${GREEN}Your ultimate ZSH environment has been successfully set up!${RESET}"
echo -e "\n${YELLOW}What's next?${RESET}"
echo -e " ${BLUE}•${RESET} Restart your terminal or run: ${GREEN}exec zsh${RESET}"
echo -e " ${BLUE}•${RESET} The first time you start ZSH, you'll be prompted to configure Powerlevel10k"
echo -e " ${BLUE}•${RESET} To reconfigure the theme anytime, run: ${GREEN}p10k configure${RESET}"
echo -e " ${BLUE}•${RESET} Explore your new plugins and settings by checking your ~/.zshrc file"

echo -e "\n${PURPLE}Happy coding!${RESET} 🚀\n"
}

# Call the main function with all arguments
main "$@"

# Exit with success
exit 0
