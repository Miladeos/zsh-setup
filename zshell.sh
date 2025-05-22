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
# Author: The Project Contributors
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

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Script Configuration Variables ---
INTERACTIVE=true # Controls whether to prompt user for confirmation (default: true)
QUIET=false      # Controls verbosity of output (default: false, show all messages)
VERBOSE=false    # Controls detailed output for debugging (default: false)

# --- Color Codes for Output ---
GREEN='[0;32m'
BLUE='[0;34m'
YELLOW='[1;33m'
RED='[0;31m'
PURPLE='[0;35m'
RESET='[0m' # Resets text color to default

# --- Helper Functions ---

# Function to print a formatted section header.
# Arguments:
#   $1: The text to display in the header.
print_header() {
    local text="$1"
    local length=${#text}
    local line
    line=$(printf '%*s' "$length" | tr ' ' '=') # Create a line of '=' characters
    echo -e "
${BLUE}$line${RESET}"
    echo -e "${BLUE}$text${RESET}"
    echo -e "${BLUE}$line${RESET}
"
}

# Function to print a success message.
# Arguments:
#   $1: The message to display.
print_success() {
    if [ "$QUIET" = false ]; then
        echo -e "${GREEN}✓ $1${RESET}"
    fi
}

# Function to print an informational message.
# Arguments:
#   $1: The message to display.
print_info() {
    if [ "$QUIET" = false ] && [ "$VERBOSE" = true ]; then # Only show if not quiet and verbose is enabled
        echo -e "${YELLOW}➜ $1${RESET}"
    elif [ "$QUIET" = false ]; then # Default info message
        echo -e "${YELLOW}➜ $1${RESET}"
    fi
}

# Function to print an error message.
# Arguments:
#   $1: The message to display.
print_error() {
    echo -e "${RED}✗ $1${RESET}" >&2 # Errors should go to stderr
}

# Function to check if a command exists on the system.
# Arguments:
#   $1: The command name to check.
# Returns:
#   0 if the command exists, 1 otherwise.
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to back up a file if it exists.
# Creates a backup with a timestamp.
# Arguments:
#   $1: The path to the file to back up.
backup_file() {
    if [ -f "$1" ]; then
        local backup_filename="$1.backup.$(date +%Y%m%d%H%M%S)"
        print_info "Backing up $1 to $backup_filename"
        if cp "$1" "$backup_filename"; then
            print_success "Backup of $1 created at $backup_filename"
        else
            print_error "Failed to create backup for $1"
        fi
    fi
}

# Function to display the help message for the script.
show_help() {
    cat << EOF
Usage: $0 [options]

This script automates the installation and configuration of a powerful ZSH environment.

Options:
  -h, --help     Display this help message.
  -y, --yes      Skip all confirmation prompts and run in non-interactive mode.
                 Useful for automated setups.
  -q, --quiet    Minimal output. Only essential error messages and a final
                 success or failure message will be displayed.
  -v, --verbose  Show detailed output of all operations being performed.
                 This is useful for debugging issues with the script.
EOF
}

# Function to confirm an action with the user.
# Only prompts if INTERACTIVE mode is true.
# Arguments:
#   $1: The message/question to display to the user.
#   $2: The default answer ("y" or "n").
# Returns:
#   0 if the user confirms (yes), 1 if the user denies (no).
confirm_action() {
    local message="$1"
    local default_answer="$2" # Renamed for clarity
    
    if [ "$INTERACTIVE" = false ]; then
        # If not interactive, assume "yes" for all confirmations
        return 0
    fi
    
    local prompt_indicator # Renamed for clarity
    if [ "$default_answer" = "y" ]; then
        prompt_indicator="[Y/n]"
    else
        prompt_indicator="[y/N]"
    fi
    
    # Loop until a valid response is given
    while true; do
        echo -e "
${YELLOW}$message $prompt_indicator${RESET}"
        read -r user_response # Renamed for clarity
        
        case "$user_response" in
            [yY][eE][sS]|[yY])
                return 0 # User answered yes
                ;;
            [nN][oO]|[nN])
                return 1 # User answered no
                ;;
            "") # Empty response, use default
                if [ "$default_answer" = "y" ]; then
                    return 0
                else
                    return 1
                fi
                ;;
            *)
                print_error "Invalid response. Please answer 'yes' or 'no'."
                # Loop will continue, prompting again
                ;;
        esac
    done
}

# Function to parse command-line arguments.
# Updates global configuration variables based on flags.
parse_arguments() {
    while [ $# -gt 0 ]; do
        case "$1" in
            -h|--help)
                show_help
                exit 0
                ;;
            -y|--yes)
                INTERACTIVE=false
                print_info "Non-interactive mode enabled."
                ;;
            -q|--quiet)
                QUIET=true
                # No message for quiet mode itself
                ;;
            -v|--verbose)
                VERBOSE=true
                print_info "Verbose mode enabled." # Info shown if not quiet
                ;;
            *)
                print_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
        shift # Move to the next argument
    done
}

# --- Main Script Logic ---
main() {
    # Parse command line arguments first
    parse_arguments "$@"
    
    # Display welcome message (unless in quiet mode)
    if [ "$QUIET" = false ]; then
        clear # Clear the terminal for a cleaner look
        # ASCII Art Welcome Banner
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
┃             ███████╗███████║██║  ██║    ███████╗███████╗   ██║   ╚██████╔╝  ┃
┃             ╚══════╝╚══════╝╚═╝  ╚═╝    ╚══════╝╚══════╝   ╚═╝    ╚═════╝   ┃
┃                                                                             ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
EOF
        # Introduction to the script's purpose
        echo -e "${PURPLE}This script will set up an awesome ZSH environment with:${RESET}"
        echo -e " ${YELLOW}•${RESET} ZSH as your default shell"
        echo -e " ${YELLOW}•${RESET} Oh My ZSH framework"
        echo -e " ${YELLOW}•${RESET} Powerlevel10k theme"
        echo -e " ${YELLOW}•${RESET} Syntax highlighting (zsh-syntax-highlighting)"
        echo -e " ${YELLOW}•${RESET} Auto-suggestions (zsh-autosuggestions)"
        echo -e " ${YELLOW}•${RESET} Enhanced completions (zsh-completions)"
        echo -e " ${YELLOW}•${RESET} Fuzzy finder (fzf)"
        echo -e " ${YELLOW}•${RESET} Useful plugins: history, colored-man-pages, command-not-found, sudo, copypath, docker"
        echo -e "
${PURPLE}Let's get started!${RESET}"
        
        sleep 2 # Brief pause for the user to read
    fi
    
    # Confirm installation if in interactive mode
    if ! confirm_action "Do you want to proceed with the ZSH setup?" "y"; then
        echo -e "${YELLOW}Setup cancelled by user.${RESET}"
        exit 0
    fi
    
    # --- Step 1: Prerequisites Check ---
    print_header "Checking Prerequisites"
    # Check for root/sudo privileges if not already root
    if [ "$EUID" -ne 0 ] && ! command_exists sudo; then
        print_error "This script requires either sudo privileges or to be run as root."
        print_error "Please run with sudo or as the root user."
        exit 1
    fi
    print_success "Privilege check passed."

    # --- Step 2: Install Dependencies ---
    print_header "Installing Dependencies"
    local packages_to_install="zsh curl git wget" # Common packages
    local package_manager_detected=false

    if command_exists apt; then
        package_manager_detected=true
        print_info "Detected apt package manager (Debian/Ubuntu based)."
        print_info "Updating package lists (sudo apt update)..."
        sudo apt update -q
        print_info "Installing ZSH and other required packages: $packages_to_install fonts-powerline zsh-doc"
        sudo apt install -y $packages_to_install fonts-powerline zsh-doc
    elif command_exists dnf; then
        package_manager_detected=true
        print_info "Detected dnf package manager (Fedora/RHEL based)."
        print_info "Checking for updates (sudo dnf check-update)..." # dnf doesn't have a direct quiet update for lists only
        sudo dnf check-update -q || true # Allow to proceed even if check-update has non-zero exit for no updates
        print_info "Installing ZSH and other required packages: $packages_to_install powerline-fonts zsh-syntax-highlighting"
        sudo dnf install -y $packages_to_install powerline-fonts zsh-syntax-highlighting # zsh-syntax-highlighting might be available as a system package
    elif command_exists yum; then # Older RHEL/CentOS
        package_manager_detected=true
        print_info "Detected yum package manager (CentOS/RHEL based)."
        print_info "Checking for updates (sudo yum check-update)..."
        sudo yum check-update -q || true
        print_info "Installing ZSH and other required packages: $packages_to_install"
        # powerline-fonts might need EPEL or manual install on older systems
        sudo yum install -y $packages_to_install
    elif command_exists pacman; then
        package_manager_detected=true
        print_info "Detected pacman package manager (Arch Linux based)."
        print_info "Synchronizing package databases (sudo pacman -Sy)..."
        sudo pacman -Sy --noconfirm
        print_info "Installing ZSH and other required packages: $packages_to_install powerline-fonts zsh-syntax-highlighting"
        sudo pacman -S --noconfirm $packages_to_install powerline-fonts zsh-syntax-highlighting
    elif command_exists brew; then
        package_manager_detected=true
        print_info "Detected Homebrew package manager (macOS)."
        print_info "Installing ZSH and other required packages: $packages_to_install"
        brew install $packages_to_install
        print_info "Installing Powerline fonts via Homebrew Cask..."
        brew tap homebrew/cask-fonts
        brew install --cask font-powerline-symbols # Common Powerline font package
    else
        print_error "Unsupported package manager. Could not detect apt, dnf, yum, pacman, or brew."
        print_error "Please install ZSH, curl, git, and wget manually, then re-run this script."
        exit 1
    fi

    if [ "$package_manager_detected" = true ]; then
        print_success "Core dependencies installed successfully."
    fi

    # Verify installed versions (optional, but good for debugging)
    if [ "$VERBOSE" = true ]; then
        print_info "Verifying installed versions..."
        command_exists zsh && zsh --version || print_error "ZSH not found or version check failed."
        command_exists curl && curl --version || print_error "Curl not found or version check failed."
        command_exists git && git --version || print_error "Git not found or version check failed."
        command_exists wget && wget --version || print_error "Wget not found or version check failed."
    fi

    # --- Step 3: Set ZSH as Default Shell ---
    print_header "Setting ZSH as Default Shell"
    local zsh_path # Renamed for clarity
    zsh_path=$(which zsh) # Find the path to the ZSH executable

    if [ -z "$zsh_path" ]; then
        print_error "ZSH installation could not be verified (zsh executable not found in PATH)."
        exit 1
    fi

    if [ "$SHELL" != "$zsh_path" ]; then
        if confirm_action "Change default shell to ZSH ($zsh_path) for user $USER?" "y"; then
            print_info "Changing default shell to ZSH for user $USER..."
            # Using sudo chsh, as chsh usually requires root for other users or system-wide changes.
            # Some systems might not require sudo if only changing for the current user.
            if sudo chsh -s "$zsh_path" "$USER"; then
                print_success "Default shell changed to ZSH. Please log out and log back in, or restart your terminal for changes to take effect."
            else
                print_error "Failed to change default shell. You may need to do this manually."
                print_info "Manual command: chsh -s $zsh_path $USER"
            fi
        else
            print_info "Skipping change of default shell."
        fi
    else
        print_info "ZSH is already your default shell ($SHELL)."
    fi

    # --- Step 4: Install Oh My ZSH ---
    print_header "Installing Oh My ZSH"
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        print_info "Installing Oh My ZSH framework..."
        # Set environment variables for non-interactive Oh My ZSH installation
        export RUNZSH=no      # Do not start ZSH after installation
        export KEEP_ZSHRC=yes # Do not overwrite existing .zshrc if it exists (we'll manage it)
        # Execute Oh My ZSH installation script
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        print_success "Oh My ZSH installed successfully."
    else
        print_info "Oh My ZSH is already installed. Checking for updates..."
        # Navigate to Oh My ZSH directory and update if INTERACTIVE or VERBOSE
        if [ "$INTERACTIVE" = true ] || [ "$VERBOSE" = true ]; then
          (cd "$HOME/.oh-my-zsh" && git pull)
          print_success "Oh My ZSH updated."
        else
          print_info "Skipping Oh My ZSH update in non-interactive/non-verbose mode."
        fi
    fi

    # Define ZSH_CUSTOM path (Oh My ZSH standard)
    ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    mkdir -p "$ZSH_CUSTOM/plugins"
    mkdir -p "$ZSH_CUSTOM/themes"


    # --- Step 5: Install Powerlevel10k Theme ---
    print_header "Installing Powerlevel10k Theme"
    local p10k_theme_path="$ZSH_CUSTOM/themes/powerlevel10k" # Renamed for clarity
    if [ ! -d "$p10k_theme_path" ]; then
        print_info "Cloning Powerlevel10k theme into $p10k_theme_path..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$p10k_theme_path"
        print_success "Powerlevel10k theme installed successfully."
    else
        print_info "Powerlevel10k theme is already installed in $p10k_theme_path."
        if confirm_action "Update Powerlevel10k theme?" "y"; then
            print_info "Updating Powerlevel10k theme..."
            (cd "$p10k_theme_path" && git pull) # Run in a subshell to avoid cd side effects
            print_success "Powerlevel10k theme updated successfully."
        else
            print_info "Skipping Powerlevel10k update."
        fi
    fi

    # --- Step 6: Install ZSH Plugins ---
    print_header "Installing Essential ZSH Plugins"
    
    # Helper function to install/update a ZSH plugin
    install_or_update_plugin() {
        local plugin_name="$1"
        local plugin_repo_url="$2"
        local plugin_path="$ZSH_CUSTOM/plugins/$plugin_name"

        if [ ! -d "$plugin_path" ]; then
            print_info "Installing $plugin_name from $plugin_repo_url..."
            git clone --depth=1 "$plugin_repo_url" "$plugin_path"
            print_success "$plugin_name installed successfully."
        else
            print_info "$plugin_name is already installed."
            if confirm_action "Update $plugin_name plugin?" "y"; then
                print_info "Updating $plugin_name..."
                (cd "$plugin_path" && git pull)
                print_success "$plugin_name updated successfully."
            else
                print_info "Skipping $plugin_name update."
            fi
        fi
    }

    install_or_update_plugin "zsh-autosuggestions" "https://github.com/zsh-users/zsh-autosuggestions.git"
    install_or_update_plugin "zsh-syntax-highlighting" "https://github.com/zsh-users/zsh-syntax-highlighting.git"
    install_or_update_plugin "zsh-completions" "https://github.com/zsh-users/zsh-completions.git"

    # Install fzf (fuzzy finder)
    print_info "Checking fzf (fuzzy finder)..."
    if [ ! -d "$HOME/.fzf" ]; then
        if confirm_action "Install fzf (fuzzy finder)?" "y"; then
            print_info "Installing fzf..."
            git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
            # The --all flag enables key bindings and completion
            # --no-update-rc prevents fzf from modifying shell rc files directly; we'll do it.
            "$HOME/.fzf/install" --all --no-update-rc
            print_success "fzf installed successfully."
        else
            print_info "Skipping fzf installation."
        fi
    else
        print_info "fzf is already installed."
        if confirm_action "Update fzf?" "y"; then
            print_info "Updating fzf..."
            (cd "$HOME/.fzf" && git pull && ./install --all --no-update-rc)
            print_success "fzf updated successfully."
        else
            print_info "Skipping fzf update."
        fi
    fi

    # --- Step 7: Configure .zshrc ---
    print_header "Configuring .zshrc"
    local zshrc_file="$HOME/.zshrc" # Renamed for clarity
    backup_file "$zshrc_file" # Backup existing .zshrc

    # Read current .zshrc content or create a placeholder if it doesn't exist
    local current_zshrc_content="" # Renamed for clarity
    if [ -f "$zshrc_file" ]; then
        current_zshrc_content=$(cat "$zshrc_file")
    else
        print_info "$zshrc_file not found. A new one will be created."
        # Basic Oh My ZSH bootstrap if no .zshrc exists
        current_zshrc_content="export ZSH=\"$HOME/.oh-my-zsh\" 
ZSH_THEME=\"robbyrussell\"
plugins=(git)
source \$ZSH/oh-my-zsh.sh"
    fi

    # Set ZSH_THEME to Powerlevel10k
    print_info "Setting Powerlevel10k as the ZSH theme..."
    # Use sed to replace or add ZSH_THEME
    if grep -q "^ZSH_THEME=" "$zshrc_file" 2>/dev/null; then
        current_zshrc_content=$(echo "$current_zshrc_content" | sed 's|^ZSH_THEME=.*|ZSH_THEME="powerlevel10k/powerlevel10k"|')
    else
        current_zshrc_content="ZSH_THEME=\"powerlevel10k/powerlevel10k\"
${current_zshrc_content}"
    fi

    # Define the list of plugins to enable
    local plugins_to_enable="git zsh-autosuggestions zsh-syntax-highlighting zsh-completions fzf history colored-man-pages command-not-found sudo copypath docker"
    print_info "Configuring plugins: $plugins_to_enable"
    local plugins_line="plugins=($plugins_to_enable)"
    # Use sed to replace or add the plugins line
    if grep -q "^plugins=(" "$zshrc_file" 2>/dev/null; then
        current_zshrc_content=$(echo "$current_zshrc_content" | sed "s|^plugins=(.*|$plugins_line|")
    else
        # Add plugins line, trying to place it after ZSH_THEME if possible
        if grep -q "^ZSH_THEME=" "$zshrc_file" 2>/dev/null; then
             current_zshrc_content=$(echo "$current_zshrc_content" | sed "/^ZSH_THEME=.*/a $plugins_line")
        else
            current_zshrc_content="$plugins_line
${current_zshrc_content}"
        fi
    fi
    
    # Add custom ZSH settings, aliases, and functions
    print_info "Adding custom ZSH settings, aliases, and functions..."
    # Using a heredoc for cleaner multi-line string
    # Check if the custom settings block already exists to avoid duplication
    if ! grep -q "# Custom ZSH settings" <<< "$current_zshrc_content"; then
        local custom_zsh_config # Renamed for clarity
        custom_zsh_config=$(cat << 'EOF'

# Custom ZSH settings
# -------------------

# History configuration
HISTSIZE=50000             # Number of lines of history to keep in memory
SAVEHIST=50000             # Number of lines of history to save to file
HISTFILE=~/.zsh_history    # Path to history file
setopt HIST_IGNORE_ALL_DUPS  # Remove older duplicate entries from history
setopt HIST_FIND_NO_DUPS     # Do not display duplicates when searching history
setopt HIST_IGNORE_SPACE     # Commands starting with a space are not saved to history
setopt SHARE_HISTORY         # Share history between all active ZSH sessions
setopt EXTENDED_HISTORY      # Save timestamp and duration for each command

# Directory navigation enhancements
setopt AUTO_CD               # Automatically 'cd' if a command is just a directory path
setopt AUTO_PUSHD            # Make 'cd' push the old directory onto the directory stack
setopt PUSHD_IGNORE_DUPS     # Don't push duplicate directories onto the stack
setopt PUSHD_MINUS           # Allows using `cd -<NUM>` to navigate the directory stack

# Completion system tuning
zstyle ':completion:*' menu select                  # Enable menu selection for completions
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Case-insensitive completion
zstyle ':completion:*' special-dirs true            # Allow completion of '.' and '..'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" # Use LS_COLORS for completion highlighting

# FZF (fuzzy finder) integration
# This ensures that fzf's keybindings and completions are loaded.
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Useful Aliases
# --------------
alias ls='ls --color=auto'   # Always use color for ls
alias ll='ls -lah'           # Long format, all files, human-readable sizes
alias la='ls -A'             # List all entries except . and ..
alias l='ls -CF'             # List entries by columns, with type indicators
alias grep='grep --color=auto' # Always use color for grep
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias md='mkdir -p'          # Create parent directories as needed
alias rd='rmdir'             # Remove directory (safer than rm -rf)
alias h='history 1'          # Show history starting from the first entry

# Git Aliases
# -----------
alias gs='git status'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit -m'
alias gca='git commit -am'
alias gp='git push'
alias gpl='git pull' # Changed from 'gl' to avoid conflict with 'gl' often being 'git log'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'
alias glg='git log --graph --oneline --decorate --all' # A more useful git log

# Function to extract various archive types
# Usage: extract <filename>
extract() {
  if [ -f "$1" ] ; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"     ;;
      *.tar.gz)    tar xzf "$1"     ;;
      *.bz2)       bunzip2 "$1"     ;;
      *.rar)       unrar e "$1"     ;; # Requires 'unrar' or 'rar' command
      *.gz)        gunzip "$1"      ;;
      *.tar)       tar xf "$1"      ;;
      *.tbz2)      tar xjf "$1"     ;;
      *.tgz)       tar xzf "$1"     ;;
      *.zip)       unzip "$1"       ;; # Requires 'unzip' command
      *.Z)         uncompress "$1"  ;;
      *.7z)        7z x "$1"        ;; # Requires 'p7zip' or '7z' command
      *)           echo "'$1' cannot be extracted via extract(). Unknown extension." ;;
    esac
  else
    echo "'$1' is not a valid file."
  fi
}

# Function to create a directory and change into it
# Usage: mcd <directory_name>
mcd() {
  mkdir -p "$1" && cd "$1" || return # Added || return for safety
}

# Powerlevel10k configuration:
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Enable Powerlevel10k instant prompt.
# This significantly speeds up ZSH startup time.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
EOF
)
        # Append the custom configuration to the .zshrc content
        current_zshrc_content="${current_zshrc_content}
${custom_zsh_config}"
    else
        print_info "Custom ZSH settings block already found in .zshrc. Skipping addition."
    fi
    
    # Ensure Oh My ZSH is sourced at the end of .zshrc
    # This is crucial for Oh My ZSH to function correctly.
    if ! grep -q "source \$ZSH/oh-my-zsh.sh" <<< "$current_zshrc_content"; then
        print_info "Adding Oh My ZSH source line to .zshrc."
        current_zshrc_content="${current_zshrc_content}

# Source Oh My ZSH
source \$ZSH/oh-my-zsh.sh"
    fi

    # Save the final .zshrc content
    echo -e "$current_zshrc_content" > "$zshrc_file"
    print_success ".zshrc configuration updated successfully at $zshrc_file"

    # --- Final Setup Instructions ---
    print_header "🎉 Setup Complete! 🎉"
    if [ "$QUIET" = false ]; then
        echo -e "${GREEN}Your ultimate ZSH environment has been successfully set up!${RESET}"
        echo -e "
${YELLOW}What's next?${RESET}"
        echo -e " ${BLUE}•${RESET} For the changes to take full effect, you need to start a new ZSH session."
        echo -e "   You can do this by: ${GREEN}closing and reopening your terminal${RESET}, or running: ${GREEN}exec zsh${RESET}"
        echo -e " ${BLUE}•${RESET} The first time you start ZSH with Powerlevel10k, you might be guided through its configuration wizard (${GREEN}p10k configure${RESET})."
        echo -e "   Follow the prompts to customize your shell's appearance."
        echo -e " ${BLUE}•${RESET} To reconfigure the Powerlevel10k theme at any time, run: ${GREEN}p10k configure${RESET}"
        echo -e " ${BLUE}•${RESET} Explore your new plugins and settings. Your ZSH configuration file is located at: ${GREEN}~/.zshrc${RESET}"
        echo -e "
${PURPLE}Happy ZSHelling!${RESET} 🚀
"
    else
        print_success "ZSH setup complete. Please start a new ZSH session (e.g., exec zsh or restart terminal)."
    fi
}

# --- Script Entry Point ---
# Call the main function, passing all script arguments to it.
main "$@"

# Exit with success status (0)
exit 0
