#!/bin/bash

##################################### Global variables #####################################
# Project information
PROJECT_NAME="Kubectl-Plus"
PROJECT_URL="https://github.com/perfumescent/Kubectl-Plus"
AUTHOR="perfumescent"
VERSION="1.0.0"

# Subcommands
SUBCOMMANDS=("l" "f" "i" "g")
SUBCOMMAND_NAMES=(
    "l:log (View and search logs)"
    "f:find (Search logs across multiple pods)"
    "i:into (Enter pod by bash)"
    "g:get (View resources in wide format)"
)

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# File locations
BIN_DIR="/usr/local/bin"
if [ ! -w "$BIN_DIR" ]; then
    BIN_DIR="$HOME/.local/bin"
    mkdir -p "$BIN_DIR"
fi

TEMP_DIR=""
BACKUP_DIR=""
INSTALLED_FILES=()

# Installation mode
INSTALL_MODE=""

# Version file location
VERSION_FILE="$HOME/.kubectl-plus/version"

##################################### Specification #####################################
# Installation Process Overview:
# 1. Pre-installation
#    - Check system requirements (kubectl, curl)
#    - Verify kubectl cluster connectivity
#    - Create temporary directories for installation
#
# 2. Installation Mode Detection
#    - Check for local files (cmd/kp, cmd/l, cmd/f, cmd/i, cmd/g, cmd/autocomplete)
#    - Determine mode: local, online, upgrade, downgrade, or reinstall
#    - For upgrades: backup existing installation
#
# 3. File Preparation
#    - Local mode: Copy files from cmd/ directory
#    - Online mode: Download files from GitHub
#    - Convert Windows line endings to Unix format
#
# 4. Installation Steps
#    - Install main command (kp) to BIN_DIR
#    - Install subcommands with kubectl-style naming (kp-l, kp-f, kp-i, kp-g)
#    - Install shell completion
#    - Configure default namespace
#    - Save version information
#
# Key Features:
# - Supports multiple installation modes (local/online/upgrade)
# - Automatic backup and rollback capability
# - Shell completion for bash/zsh
# - Configurable default namespace
# - Version management
#
# Important Notes:
# 1. BIN_DIR fallback: Uses ~/.local/bin if /usr/local/bin is not writable
# 2. Subcommands follow kubectl plugin naming convention (kp-*)
# 3. All operations are atomic with rollback support
# 4. Shell completion requires restart or source after installation
# 5. Version information is stored in ~/.kubectl-plus/version

##################################### Functions #####################################

# Create temporary directory
setup_temp_dir() {
    TEMP_DIR=$(mktemp -d)
    BACKUP_DIR="$TEMP_DIR/backup"
    mkdir -p "$BACKUP_DIR"
    echo "Created temporary directory: $TEMP_DIR"
}

# Clean up temporary files
cleanup() {
    if [ -d "$TEMP_DIR" ]; then
        rm -rf "$TEMP_DIR"
        echo "Cleaned up temporary directory"
    fi
}

# Rollback changes in case of failure
rollback() {
    echo -e "${RED}Installation failed! Rolling back changes...${NC}"
    
    # Restore backed up files
    if [ -d "$BACKUP_DIR" ]; then
        for file in "$BACKUP_DIR"/*; do
            if [ -f "$file" ]; then
                base_name=$(basename "$file")
                if [ -f "$BIN_DIR/$base_name" ]; then
                    mv "$file" "$BIN_DIR/$base_name"
                    echo "Restored: $base_name"
                fi
            fi
        done
    fi
    
    # Remove installed files
    for file in "${INSTALLED_FILES[@]}"; do
        if [ -f "$file" ] && [ ! -f "$BACKUP_DIR/$(basename "$file")" ]; then
            rm -f "$file"
            echo "Removed: $file"
        fi
    done
    
    # Clean up
    cleanup
    
    echo -e "${RED}Rollback complete. Please check your system.${NC}"
    exit 1
}

# Logo
print_logo() {
    echo -e "${BLUE}  _  __     _               _   _        _____  _           ${NC}"
    echo -e "${BLUE} | |/ /    | |             | | | |      |  __ \| |          ${NC}"
    echo -e "${BLUE} | ' /_   _| |__   ___  ___| |_| |______| |__) | |_   _ ___ ${NC}"
    echo -e "${BLUE} |  <| | | | '_ \ / _ \/ __| __| |______|  ___/| | | | / __| ${NC}"
    echo -e "${BLUE} | . \ |_| | |_) |  __/ (__| |_| |      | |    | | |_| \__ \ ${NC}"
    echo -e "${BLUE} |_|\_\__,_|_.__/ \___|\___|\__|_|      |_|    |_|\__,_|___/ ${NC}"

    echo -e "${BLUE}🚀 Easy Kubernetes CLI Management: \033[1;36mSimplified Commands, \033[1;35mSmart Completion!${NC}"
    echo -e "${BLUE}Version: $VERSION${NC}"
    echo -e "${BLUE}Author:  $AUTHOR${NC}"
    echo -e "${BLUE}GitHub:  $PROJECT_URL${NC}"
    echo
}

# Download command scripts for online installation
download_commands() {
    echo -e "${BLUE}Downloading kubectl-plus commands...${NC}"
    
    local base_url="$PROJECT_URL/raw/main"
    
    # Create subdirectories
    mkdir -p "$TEMP_DIR/subcmd"
    
    # Download main command
    if ! curl -fsSL "$base_url/cmd/kp" -o "$TEMP_DIR/kp"; then
        echo -e "${RED}Failed to download main command${NC}"
        return 1
    fi
    chmod +x "$TEMP_DIR/kp"
    echo -e "${GREEN}✓ Downloaded: kp${NC}"
    
    # Download subcommands
    for cmd in "${SUBCOMMANDS[@]}"; do
        if ! curl -fsSL "$base_url/cmd/$cmd" -o "$TEMP_DIR/subcmd/$cmd"; then
            echo -e "${RED}Failed to download $cmd${NC}"
            return 1
        fi
        chmod +x "$TEMP_DIR/subcmd/$cmd"
        echo -e "${GREEN}✓ Downloaded: $cmd${NC}"
    done
    
    # Download autocomplete
    if ! curl -fsSL "$base_url/cmd/autocomplete" -o "$TEMP_DIR/autocomplete"; then
        echo -e "${RED}Failed to download autocomplete${NC}"
        return 1
    fi
    echo -e "${GREEN}✓ Downloaded: autocomplete${NC}"
    
    return 0
}

# Check system requirements
check_requirements() {
    echo -e "${BLUE}Checking system requirements...${NC}"
    
    # Check curl for online installation
    if ! command -v curl &> /dev/null; then
        echo -e "${RED}Error: curl is not installed${NC}"
        echo -e "Please install curl first"
        exit 1
    fi
    
    # Check kubectl
    if ! command -v kubectl &> /dev/null; then
        echo -e "${RED}Error: kubectl is not installed${NC}"
        echo -e "Please install kubectl first: ${YELLOW}https://kubernetes.io/docs/tasks/tools/${NC}"
        exit 1
    fi
    
    # Check if kubectl can connect to cluster
    if ! kubectl get nodes &> /dev/null; then
        echo -e "${RED}Error: kubectl cannot connect to cluster${NC}"
        echo -e "Please check your kubeconfig configuration"
        exit 1
    fi
    
    echo -e "${GREEN}✓ System requirements met${NC}"
}

# Get default namespace
get_default_namespace() {
    local default_ns=$(kubectl config view --minify --output 'jsonpath={..namespace}')
    if [ -z "$default_ns" ]; then
        echo "dev"
    else
        echo "$default_ns"
    fi
}

# Install completion for current shell
install_completion() {
    local shell_type=$(basename "$SHELL")
    echo -e "${BLUE}Installing completion for ${shell_type}...${NC}"
    
    # Backup existing completion file
    if [ -f ~/.kubectl-plus-completion ]; then
        cp ~/.kubectl-plus-completion "$BACKUP_DIR/"
    fi
    
    case "$shell_type" in
        "bash")
            cp "$TEMP_DIR/autocomplete" ~/.kubectl-plus-completion
            echo "source ~/.kubectl-plus-completion" >> ~/.bashrc
            source ~/.bashrc
            ;;
        "zsh")
            cp "$TEMP_DIR/autocomplete" ~/.kubectl-plus-completion
            echo "source ~/.kubectl-plus-completion" >> ~/.zshrc
            source ~/.zshrc
            ;;
        *)
            echo -e "${YELLOW}Warning: Unsupported shell ${shell_type}, completion not installed${NC}"
            return
            ;;
    esac
    
    INSTALLED_FILES+=("$HOME/.kubectl-plus-completion")
    echo -e "${GREEN}✓ Completion installed${NC}"
}

# Convert Windows line endings to Unix
convert_line_endings() {
    local file="$1"
    if [ -f "$file" ]; then
        # Remove carriage returns
        sed -i 's/\r$//' "$file"
    fi
}

# Install binaries
install_binaries() {
    echo -e "${BLUE}Installing kubectl-plus commands...${NC}"
    
    # Install main command
    if [ -f "$BIN_DIR/kp" ]; then
        cp "$BIN_DIR/kp" "$BACKUP_DIR/"
    fi
    cp "$TEMP_DIR/kp" "$BIN_DIR/"
    chmod 755 "$BIN_DIR/kp"
    INSTALLED_FILES+=("$BIN_DIR/kp")
    
    # Install subcommands with kubectl style naming
    for cmd in "${SUBCOMMANDS[@]}"; do
        local target="$BIN_DIR/kp-$cmd"
        if [ -f "$target" ]; then
            cp "$target" "$BACKUP_DIR/"
        fi
        cp "$TEMP_DIR/subcmd/$cmd" "$target"
        chmod 755 "$target"
        INSTALLED_FILES+=("$target")
    done
    
    # Add bin directory to PATH if needed
    if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
        echo "export PATH=\$PATH:$BIN_DIR" >> ~/.bashrc
        export PATH=$PATH:$BIN_DIR
    fi
    
    echo -e "${GREEN}✓ Commands installed${NC}"
}

# Configure namespace
configure_namespace() {
    local default_ns=$(get_default_namespace)
    local namespace=${1:-$default_ns}
    
    echo -e "${BLUE}Configuring namespace...${NC}"
    echo -e "Using namespace: ${YELLOW}${namespace}${NC}"
    
    # Update namespace in command files
    for cmd in "${SUBCOMMANDS[@]}"; do
        local cmd_file="$BIN_DIR/kp-$cmd"
        if [ -f "$cmd_file" ]; then
            sed -i "s/^namespace=\"[^\"]*\"$/namespace=\"${namespace}\"/" "$cmd_file"
        else
            echo -e "${YELLOW}Warning: Command file $cmd not found in $BIN_DIR/kp-$cmd${NC}"
        fi
    done
    
    echo -e "${GREEN}✓ Namespace configured${NC}"
}

# Print help information
print_help() {
    echo -e "${BLUE}Kubectl Plus Installer${NC}"
    echo
    echo "Usage:"
    echo "  ./install.sh [options]"
    echo
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  -n NAMESPACE   Set default namespace"
    echo "  --no-color     Disable color output"
    echo
    echo "For more information, visit: $PROJECT_URL"
}

# Check if local files exist
check_local_files() {
    echo -e "${BLUE}Checking local files...${NC}"
    local all_files_exist=true
    local missing_files=()
    
    # Check all files in cmd directory
    for cmd in "${SUBCOMMANDS[@]}"; do
        if [ ! -f "cmd/$cmd" ]; then
            all_files_exist=false
            missing_files+=("cmd/$cmd")
        fi
    done
    
    if [ "$all_files_exist" = true ]; then
        echo -e "${GREEN}✓ All required files found locally${NC}"
        return 0
    else
        echo -e "${YELLOW}Missing files:${NC}"
        for file in "${missing_files[@]}"; do
            echo -e "  - $file"
        done
        return 1
    fi
}

# Determine installation mode
determine_install_mode() {
    if check_local_files; then
        echo -e "\nLocal installation files detected."
        read -p "Do you want to proceed with local installation? [Y/n] " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Nn]$ ]]; then
            INSTALL_MODE="local"
            return 0
        fi
    fi
    
    echo -e "\nWould you like to download files from the internet? [Y/n] " 
    read -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        INSTALL_MODE="online"
        return 0
    fi
    
    echo -e "${RED}No installation mode selected. Exiting...${NC}"
    exit 1
}

# Copy local files to temp directory
copy_local_files() {
    echo -e "${BLUE}Copying local files...${NC}"
    local copy_failed=false
    
    # Create subdirectories
    mkdir -p "$TEMP_DIR/subcmd"
    
    # Copy main command
    if [ -f "cmd/kp" ]; then
        cp "cmd/kp" "$TEMP_DIR/" || copy_failed=true
        chmod +x "$TEMP_DIR/kp"
    else
        echo -e "${YELLOW}Warning: Main command 'cmd/kp' not found${NC}"
        copy_failed=true
    fi
    
    # Copy subcommands
    for cmd in "${SUBCOMMANDS[@]}"; do
        if [ -f "cmd/$cmd" ]; then
            cp "cmd/$cmd" "$TEMP_DIR/subcmd/" || copy_failed=true
            chmod +x "$TEMP_DIR/subcmd/$cmd"
        else
            echo -e "${YELLOW}Warning: Subcommand 'cmd/$cmd' not found${NC}"
            copy_failed=true
        fi
    done
    
    # Copy autocomplete
    if [ -f "cmd/autocomplete" ]; then
        cp "cmd/autocomplete" "$TEMP_DIR/" || copy_failed=true
    else
        echo -e "${YELLOW}Warning: Autocomplete file not found${NC}"
        copy_failed=true
    fi
    
    if [ "$copy_failed" = true ]; then
        case $INSTALL_MODE in
            "upgrade"|"downgrade"|"reinstall")
                echo -e "${RED}Error: Some local files are missing. Cannot proceed with ${INSTALL_MODE}.${NC}"
                echo -e "${YELLOW}Tip: Please make sure all required files are present in the correct locations:${NC}"
                echo -e "  - cmd/kp"
                echo -e "  - cmd/{${SUBCOMMANDS[*]}}"
                echo -e "  - cmd/autocomplete"
                return 1
                ;;
            "local")
                echo -e "${RED}Error: Some local files are missing. Cannot proceed with local installation.${NC}"
                return 1
                ;;
            "online")
                echo -e "${YELLOW}Warning: Some local files are missing. Attempting online download...${NC}"
                return 0
                ;;
        esac
    fi
    
    echo -e "${GREEN}✓ Local files copied${NC}"
    return 0
}

# Get installed version
get_installed_version() {
    if [ -f "$VERSION_FILE" ]; then
        cat "$VERSION_FILE"
    else
        echo "0.0.0"
    fi
}

# Compare versions
# Returns 1 if version1 > version2
# Returns 0 if version1 = version2
# Returns -1 if version1 < version2
compare_versions() {
    if [[ $1 == $2 ]]; then
        echo 0
        return
    fi
    local IFS=.
    local i ver1=($1) ver2=($2)
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++)); do
        ver1[i]=0
    done
    for ((i=0; i<${#ver1[@]}; i++)); do
        if [[ -z ${ver2[i]} ]]; then
            ver2[i]=0
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]})); then
            echo 1
            return
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]})); then
            echo -1
            return
        fi
    done
    echo 0
}

# Check if upgrade is needed
check_upgrade() {
    local installed_version=$(get_installed_version)
    local version_compare=$(compare_versions "$VERSION" "$installed_version")
    
    if [ "$version_compare" -eq 0 ]; then
        echo -e "${GREEN}You are already running the latest version ($VERSION)${NC}"
        read -p "Do you want to reinstall? [y/N] " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 0
        fi
        INSTALL_MODE="reinstall"
    elif [ "$version_compare" -eq 1 ]; then
        echo -e "${YELLOW}A new version is available:${NC}"
        echo -e "Installed version: ${RED}$installed_version${NC}"
        echo -e "Latest version: ${GREEN}$VERSION${NC}"
        echo
        read -p "Do you want to upgrade? [Y/n] " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Nn]$ ]]; then
            INSTALL_MODE="upgrade"
        else
            exit 0
        fi
    else
        echo -e "${RED}Warning: Installed version ($installed_version) is newer than this installer ($VERSION)${NC}"
        read -p "Do you want to downgrade? [y/N] " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 0
        fi
        INSTALL_MODE="downgrade"
    fi
}

# Save version information
save_version_info() {
    mkdir -p "$(dirname "$VERSION_FILE")"
    echo "$VERSION" > "$VERSION_FILE"
    echo -e "${GREEN}Version information saved${NC}"
}

# Backup existing installation
backup_existing_installation() {
    echo -e "${BLUE}Backing up existing installation...${NC}"
    
    # Create backup directory with timestamp
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_root="$HOME/.kubectl-plus/backups"
    BACKUP_DIR="$backup_root/$timestamp"
    mkdir -p "$BACKUP_DIR"
    
    # Backup version file
    if [ -f "$VERSION_FILE" ]; then
        cp "$VERSION_FILE" "$BACKUP_DIR/"
    fi
    
    # Backup command files
    for cmd in "${SUBCOMMANDS[@]}"; do
        if [ -f "$BIN_DIR/$cmd" ]; then
            cp "$BIN_DIR/$cmd" "$BACKUP_DIR/"
        fi
    done
    
    # Backup completion file
    if [ -f "$HOME/.kubectl-plus-completion" ]; then
        cp "$HOME/.kubectl-plus-completion" "$BACKUP_DIR/"
    fi
    
    echo -e "${GREEN}✓ Backup completed: $BACKUP_DIR${NC}"
}

# Restore from backup
restore_from_backup() {
    local backup_dir="$1"
    echo -e "${YELLOW}Restoring from backup: $backup_dir${NC}"
    
    # Restore version file
    if [ -f "$backup_dir/version" ]; then
        cp "$backup_dir/version" "$VERSION_FILE"
    fi
    
    # Restore command files
    for cmd in "${SUBCOMMANDS[@]}"; do
        if [ -f "$backup_dir/$cmd" ]; then
            cp "$backup_dir/$cmd" "$BIN_DIR/"
            chmod 755 "$BIN_DIR/$cmd"
        fi
    done
    
    # Restore completion file
    if [ -f "$backup_dir/kubectl-plus-completion" ]; then
        cp "$backup_dir/kubectl-plus-completion" "$HOME/.kubectl-plus-completion"
    fi
    
    echo -e "${GREEN}✓ Restore completed${NC}"
}

# Enhanced rollback for upgrades
enhanced_rollback() {
    echo -e "${RED}Installation failed during ${INSTALL_MODE}! Rolling back...${NC}"
    
    case $INSTALL_MODE in
        "upgrade"|"downgrade"|"reinstall")
            if [ -d "$BACKUP_DIR" ]; then
                restore_from_backup "$BACKUP_DIR"
            else
                rollback
            fi
            ;;
        *)
            rollback
            ;;
    esac
    
    cleanup
    echo -e "${RED}Rollback complete. Please check your system.${NC}"
    exit 1
}

# Main installation process
main() {
    # Set up error handling
    trap enhanced_rollback ERR
    trap cleanup EXIT
    
    # Create temporary directory
    setup_temp_dir
    
    print_logo
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                print_help
                exit 0
                ;;
            -n)
                NAMESPACE="$2"
                shift 2
                ;;
            --no-color)
                RED=''
                GREEN=''
                YELLOW=''
                BLUE=''
                NC=''
                shift
                ;;
            *)
                echo -e "${RED}Unknown option: $1${NC}"
                print_help
                exit 1
                ;;
        esac
    done
    
    # Welcome message
    echo -e "${BLUE}Welcome to kubectl-plus installer!${NC}"
    echo -e "This will install kubectl-plus commands and shell completion."
    echo
    
    # Check requirements first
    check_requirements
    
    # Check for existing installation and handle upgrade
    if [ -f "$VERSION_FILE" ] || [ -f "$BIN_DIR/l" ]; then
        check_upgrade
        backup_existing_installation
    fi
    
    # If not upgrading, determine installation mode
    if [ -z "$INSTALL_MODE" ]; then
        determine_install_mode
    fi
    
    # Get files based on installation mode
    case $INSTALL_MODE in
        "local"|"upgrade"|"downgrade"|"reinstall")
            if ! copy_local_files; then
                echo -e "${RED}Installation failed: Unable to copy required files${NC}"
                exit 1
            fi
            ;;
        "online")
            if ! download_commands; then
                echo -e "${RED}Installation failed: Unable to download required files${NC}"
                exit 1
            fi
            ;;
        *)
            echo -e "${RED}Invalid installation mode${NC}"
            exit 1
            ;;
    esac
    
    install_binaries
    install_completion
    
    # Configure namespace
    if [ -z "$NAMESPACE" ]; then
        echo
        echo -e "Please enter your default namespace [${YELLOW}$(get_default_namespace)${NC}]:"
        read NAMESPACE
    fi
    configure_namespace "${NAMESPACE}"
    
    # Save version information
    save_version_info
    
    # Final message with version information
    echo
    echo -e "${GREEN}✓ kubectl-plus has been successfully ${INSTALL_MODE}ed!${NC}"
    echo -e "Version: ${YELLOW}$VERSION${NC}"
    if [ "$INSTALL_MODE" = "upgrade" ]; then
        echo -e "Upgraded from: ${YELLOW}$(get_installed_version)${NC}"
    fi
    echo -e "Please restart your shell or run: ${YELLOW}source ~/.bashrc${NC} or ${YELLOW}source ~/.zshrc${NC}"
}

# Run main installation
main "$@"
