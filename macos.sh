#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-or-later
#
# iLinux - macOS-inspired Linux installer
# Copyright (C) 2025 SalsaCat
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

set -e

# -------------------------------
# Guards
# -------------------------------

if [[ -z "$SUDO_USER" ]]; then
  echo "Please run with sudo: sudo ./macos.sh"
  exit 1
fi

USER_HOME=$(eval echo "~$SUDO_USER")

# -------------------------------
# Helper: fetch latest GitHub release download URL
# Usage: gh_latest_asset <owner/repo> <pattern>
# -------------------------------

gh_latest_asset() {
  local repo="$1"
  local pattern="$2"
  curl -s "https://api.github.com/repos/$repo/releases/latest" \
    | grep "browser_download_url" \
    | grep "$pattern" \
    | cut -d '"' -f 4 \
    | head -1
}

# Helper: clone or pull a repo (skips re-cloning if already present)
gh_clone() {
  local url="$1"
  local dir="$2"
  if [[ -d "$dir" ]]; then
    echo "  Already cloned, pulling latest..."
    git -C "$dir" pull --ff-only
  else
    git clone "$url" "$dir"
  fi
}

# -------------------------------
# Functions for each component
# -------------------------------

install_fonts() {
  echo "Installing Inter font..."
  mkdir -p "$USER_HOME/.fonts"
  cd "$USER_HOME/.fonts"

  echo "  Fetching latest Inter release..."
  INTER_URL=$(gh_latest_asset "rsms/inter" "\.zip")
  if [[ -z "$INTER_URL" ]]; then
    echo "  ERROR: Could not fetch Inter download URL. Check your internet connection."
    exit 1
  fi
  echo "  Downloading $INTER_URL..."
  wget "$INTER_URL" -O inter.zip
  unzip -qq -o inter.zip "*.ttf" 2>/dev/null || unzip -qq -o inter.zip
  rm inter.zip
  fc-cache -fv
  echo "  Inter font installed."
}

install_gtk_theme() {
  local THEME_NAME="$1"
  mkdir -p "$USER_HOME/.themes"

  case $THEME_NAME in
    1) # WhiteSur
      echo "Installing GTK theme: WhiteSur..."
      gh_clone "https://github.com/vinceliuice/WhiteSur-gtk-theme.git" "$USER_HOME/.themes/WhiteSur-gtk-theme"
      cd "$USER_HOME/.themes/WhiteSur-gtk-theme"
      ./install.sh -c dark --silent-mode
      ;;
    2) # McMojave
      echo "Installing GTK theme: McMojave..."
      gh_clone "https://github.com/vinceliuice/McMojave-gtk-theme.git" "$USER_HOME/.themes/McMojave-gtk-theme"
      cd "$USER_HOME/.themes/McMojave-gtk-theme"
      ./install.sh -d dark -y
      ;;
    0) echo "Skipping GTK theme."; return ;;
    *) echo "Invalid option, skipping GTK theme."; return ;;
  esac
  cd "$USER_HOME"
}

install_icon_theme() {
  local ICON_NAME="$1"
  mkdir -p "$USER_HOME/.icons"

  case $ICON_NAME in
    1) # WhiteSur
      echo "Installing icon theme: WhiteSur..."
      gh_clone "https://github.com/vinceliuice/WhiteSur-icon-theme.git" "$USER_HOME/.icons/WhiteSur-icon-theme"
      cd "$USER_HOME/.icons/WhiteSur-icon-theme"
      ./install.sh
      ;;
    2) # McMojave
      echo "Installing icon theme: McMojave-circle..."
      gh_clone "https://github.com/vinceliuice/McMojave-circle-icon-theme.git" "$USER_HOME/.icons/McMojave-circle-icon-theme"
      cd "$USER_HOME/.icons/McMojave-circle-icon-theme"
      ./install.sh
      ;;
    0) echo "Skipping icon theme."; return ;;
    *) echo "Invalid option, skipping icon theme."; return ;;
  esac
  cd "$USER_HOME"
}

install_cursor_theme() {
  local CURSOR_NAME="$1"
  mkdir -p "$USER_HOME/.icons"

  case $CURSOR_NAME in
    1) # WhiteSur
      echo "Installing cursor theme: WhiteSur..."
      gh_clone "https://github.com/vinceliuice/WhiteSur-cursors.git" "$USER_HOME/.icons/WhiteSur-cursors"
      cd "$USER_HOME/.icons/WhiteSur-cursors"
      ./install.sh
      ;;
    0) echo "Skipping cursor theme."; return ;;
    *) echo "Invalid option, skipping cursor theme."; return ;;
  esac
  cd "$USER_HOME"
}

install_wallpaper() {
  local WALLPAPER_NAME="$1"
  local WALLPAPER_FILE=""
  mkdir -p "$USER_HOME/Pictures/Wallpapers"

  # Base URL for WhiteSur wallpapers (always pulls from main branch = latest)
  local BASE="https://raw.githubusercontent.com/vinceliuice/WhiteSur-wallpapers/main/src/4k"

  case $WALLPAPER_NAME in
    1)
      echo "Downloading Big Sur wallpaper..."
      WALLPAPER_FILE="$USER_HOME/Pictures/Wallpapers/big-sur.jpg"
      wget "$BASE/monterey/monterey-light.jpg" -O "$WALLPAPER_FILE" || {
        echo "  ERROR: Could not download wallpaper."
        return
      }
      ;;
    2)
      echo "Downloading Ventura wallpaper..."
      WALLPAPER_FILE="$USER_HOME/Pictures/Wallpapers/ventura.jpg"
      wget "$BASE/ventura/ventura-light.jpg" -O "$WALLPAPER_FILE" || {
        echo "  ERROR: Could not download wallpaper."
        return
      }
      ;;
    0) echo "Skipping wallpaper."; return ;;
    *) echo "Invalid option, skipping wallpaper."; return ;;
  esac

  if [[ -n "$WALLPAPER_FILE" ]]; then
    sudo -u "$SUDO_USER" gsettings set org.gnome.desktop.background picture-uri "file://$WALLPAPER_FILE"
    sudo -u "$SUDO_USER" gsettings set org.gnome.desktop.background picture-uri-dark "file://$WALLPAPER_FILE"
  fi
  cd "$USER_HOME"
}

install_dock() {
  echo "Installing Plank dock..."
  apt install -y plank
  mkdir -p "$USER_HOME/.config/plank/dock1"
  cat > "$USER_HOME/.config/plank/dock1/settings" <<EOL
[PlankDockPreferences]
Alignment=Center
DockItems=['/usr/share/applications/firefox.desktop','/usr/share/applications/nautilus.desktop','/usr/share/applications/gnome-terminal.desktop']
EOL
  chown -R "$SUDO_USER:$SUDO_USER" "$USER_HOME/.config"
}

apply_settings() {
  sudo -u "$SUDO_USER" gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME"
  sudo -u "$SUDO_USER" gsettings set org.gnome.desktop.interface icon-theme "$ICON_THEME"
  [[ -n "$CURSOR_THEME" ]] && sudo -u "$SUDO_USER" gsettings set org.gnome.desktop.interface cursor-theme "$CURSOR_THEME"
  sudo -u "$SUDO_USER" gsettings set org.gnome.desktop.interface enable-animations true
  sudo -u "$SUDO_USER" gsettings set org.gnome.mutter experimental-features "['rounded-corners']"
}

# -------------------------------
# Interactive choice
# -------------------------------
echo "Choose installation type:"
echo "<R> Recommended"
echo "<C> Custom"
read -n1 -p "Enter choice: " INSTALL_TYPE
echo

if [[ "$INSTALL_TYPE" == "R" || "$INSTALL_TYPE" == "r" ]]; then
  echo "Proceeding with Recommended installation..."
  install_fonts
  install_gtk_theme 1
  install_icon_theme 1
  install_cursor_theme 1
  install_dock
  install_wallpaper 1
  GTK_THEME="WhiteSur-dark"
  ICON_THEME="WhiteSur"
  CURSOR_THEME="WhiteSur-cursors"
  apply_settings
else
  echo "Custom installation selected..."

  install_fonts

  echo "Choose GTK theme:"
  echo "1) WhiteSur"
  echo "2) McMojave"
  echo "0) Skip"
  read -n1 -p "Enter choice: " GTK_CHOICE
  echo
  install_gtk_theme "$GTK_CHOICE"

  echo "Choose Icon theme:"
  echo "1) WhiteSur"
  echo "2) McMojave-circle"
  echo "0) Skip"
  read -n1 -p "Enter choice: " ICON_CHOICE
  echo
  install_icon_theme "$ICON_CHOICE"

  echo "Choose Cursor theme:"
  echo "1) WhiteSur"
  echo "0) Skip"
  read -n1 -p "Enter choice: " CURSOR_CHOICE
  echo
  install_cursor_theme "$CURSOR_CHOICE"

  echo "Choose Wallpaper:"
  echo "1) Big Sur"
  echo "2) Ventura"
  echo "0) Skip"
  read -n1 -p "Enter choice: " WALLPAPER_CHOICE
  echo
  install_wallpaper "$WALLPAPER_CHOICE"

  install_dock

  # Resolve theme names from choices
  GTK_THEME="WhiteSur-dark"
  ICON_THEME="WhiteSur"
  CURSOR_THEME="WhiteSur-cursors"
  [[ "$GTK_CHOICE" == "2" ]] && GTK_THEME="McMojave-dark"
  [[ "$ICON_CHOICE" == "2" ]] && ICON_THEME="McMojave-circle"
  [[ "$CURSOR_CHOICE" == "0" ]] && CURSOR_THEME=""
  apply_settings
fi

echo "Installation complete! Log out and back in to see full effect."
