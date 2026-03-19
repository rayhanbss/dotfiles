#!/bin/bash

# Input parameters
INPUT="$1"

# Directories
CONFIG_DIR="$HOME/.config"
DOTFILES_DIR="$HOME/dotfiles"

# .config list
DOT_CONFIGS=(
    "elephant"
    "swayosd"
    "dunst"
    "zsh"
    "walker"
    "ironbar"
    "zed"
    "vibepanel"
    "kitty"
    "alacritty"
    "fastfetch"
    "mako"
    "niri"
    "rofi"
    "waybar"
)

HOME_CONFIGS=(
    "zsh"
)

# Function to create symlink for .config directory
create_config_symlink() {
    local config="$1"
    local source="$DOTFILES_DIR/$config"
    local dest="$CONFIG_DIR/$config"

    if [ ! -e "$source" ]; then
        echo "Warning: $source does not exist, skipping..."
        return 1
    fi

    # Remove existing symlink or directory
    if [ -L "$dest" ]; then
        rm "$dest"
    elif [ -e "$dest" ]; then
        echo "Warning: $dest exists and is not a symlink. Backing up to ${dest}.backup"
        mv "$dest" "${dest}.backup"
    fi

    ln -sf "$source" "$dest"
    echo "✓ Created symlink: $dest -> $source"
}

# Function to create symlinks for home directory files
create_home_symlink() {
    local config="$1"
    local source_dir="$DOTFILES_DIR/$config"

    if [ ! -d "$source_dir" ]; then
        echo "Warning: $source_dir does not exist, skipping..."
        return 1
    fi

    # Link all files in the directory to home
    for file in "$source_dir"/*; do
        if [ -f "$file" ] || [ -d "$file" ]; then
            local basename=$(basename "$file")
            local dest="$HOME/.$basename"

            if [ -L "$dest" ]; then
                rm "$dest"
            elif [ -e "$dest" ]; then
                echo "Warning: $dest exists. Backing up to ${dest}.backup"
                mv "$dest" "${dest}.backup"
            fi

            ln -sf "$file" "$dest"
            echo "✓ Created symlink: $dest -> $file"
        fi
    done
}

# Function to add new config to the script
add_config() {
    local new_config="$1"
    local config_type="$2"  # "dot" or "home"

    if [ "$config_type" = "dot" ]; then
        # Check if already exists
        for config in "${DOT_CONFIGS[@]}"; do
            if [ "$config" = "$new_config" ]; then
                echo "Config '$new_config' already exists in DOT_CONFIGS"
                return 1
            fi
        done

        # Add to this script file
        sed -i "/DOT_CONFIGS=(/a\\    \"$new_config\"" "$0"
    "elephant"
        echo "✓ Added '$new_config' to DOT_CONFIGS. Restart script to use."

    elif [ "$config_type" = "home" ]; then
        # Check if already exists
        for config in "${HOME_CONFIGS[@]}"; do
            if [ "$config" = "$new_config" ]; then
                echo "Config '$new_config' already exists in HOME_CONFIGS"
                return 1
            fi
        done

        # Add to this script file
        sed -i "/HOME_CONFIGS=(/a\\    \"$new_config\"" "$0"
        echo "✓ Added '$new_config' to HOME_CONFIGS. Restart script to use."
    fi
}

# Show usage
show_usage() {
    echo "Usage: $0 [OPTION]"
    echo ""
    echo "Options:"
    echo "  init              Create symlinks for all configs"
    echo "  <config_name>     Create symlink for specific config (e.g., alacritty, zsh)"
    echo "  add <name> <type> Add new config to list (type: dot or home)"
    echo " edit               Edit config"
    echo "  list              List all available configs"
    echo "  help              Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 init           # Link all configs"
    echo "  $0 alacritty      # Link only alacritty"
    echo "  $0 add nvim dot   # Add nvim to DOT_CONFIGS list"
    echo "  $0 add bash home  # Add bash to HOME_CONFIGS list"
}

# Main logic
case "$INPUT" in
    init)
        echo "Creating symlinks for all configs..."
        echo ""
        echo "=== .config directories ==="
        for config in "${DOT_CONFIGS[@]}"; do
            create_config_symlink "$config"
        done

        echo ""
        echo "=== Home directory files ==="
        for config in "${HOME_CONFIGS[@]}"; do
            create_home_symlink "$config"
        done
        echo ""
        echo "Done!"
        ;;

    add)
        if [ -z "$2" ] || [ -z "$3" ]; then
            echo "Error: add requires config name and type (dot/home)"
            echo "Usage: $0 add <config_name> <dot|home>"
            exit 1
        fi
        add_config "$2" "$3"
        ;;

    list)
        echo "[.config configs]"
        printf '• %s\n' "${DOT_CONFIGS[@]}"
        echo ""
        echo "[home configs]"
        printf '• %s\n' "${HOME_CONFIGS[@]}"
        ;;

    help|--help|-h|"")
        show_usage
        ;;

    edit)
        zed ~/dotfiles
        ;;

    *)
        # Check if input matches a config name
        found=false

        # Check in DOT_CONFIGS
        for config in "${DOT_CONFIGS[@]}"; do
            if [ "$config" = "$INPUT" ]; then
                create_config_symlink "$config"
                found=true
                break
            fi
        done

        # Check in HOME_CONFIGS
        if [ "$found" = false ]; then
            for config in "${HOME_CONFIGS[@]}"; do
                if [ "$config" = "$INPUT" ]; then
                    create_home_symlink "$config"
                    found=true
                    break
                fi
            done
        fi

        if [ "$found" = false ]; then
            echo "Error: Unknown config '$INPUT'"
            echo ""
            show_usage
            exit 1
        fi
        ;;
esac
