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

USER_HOME=$(eval echo "~$SUDO_USER")

# -------------------------------
# Functions for each component
# -------------------------------

install_fonts() {
  echo "Installing Inter font..."
  mkdir -p "$USER_HOME/.fonts"
  cd "$USER_HOME/.fonts"
  wget -q https://github.com/rsms/inter/releases/download/v3.21/Inter-3.21.zip -O inter.zip
  unzip -qq inter.zip
  rm inter.zip
}

install_gtk_theme() {
  THEME_NAME="$1"
  echo "Installing GTK theme: $THEME_NAME..."
  mkdir -p "$USER_HOME/.themes"
  cd "$USER_HOME/.themes"

  case $THEME_NAME in
    1) # WhiteSur
      git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git
      cd WhiteSur-gtk-theme
      ./install.sh -d dark -c blue -y
      ;;
    2) # McMojave
      git clone https://github.com/vinceliuice/McMojave-gtk-theme.git
      cd McMojave-gtk-theme
      ./install.sh -d dark -y
      ;;
    0) echo "Skipping GTK theme"; return ;;
    *) echo "Invalid option"; return ;;
  esac
  cd "$USER_HOME"
}

install_icon_theme() {
  ICON_NAME="$1"
  echo "Installing icon theme: $ICON_NAME..."
  mkdir -p "$USER_HOME/.icons"
  cd "$USER_HOME/.icons"

  case $ICON_NAME in
    1) # WhiteSur
      git clone https://github.com/vinceliuice/WhiteSur-icon-theme.git
      cd WhiteSur-icon-theme
      ./install.sh
      ;;
    2) # McMojave
      git clone https://github.com/vinceliuice/McMojave-circle-icon-theme.git
      cd McMojave-circle-icon-theme
      ./install.sh
      ;;
    0) echo "Skipping icon theme"; return ;;
    *) echo "Invalid option"; return ;;
  esac
  cd "$USER_HOME"
}

install_cursor_theme() {
  CURSOR_NAME="$1"
  echo "Installing cursor theme: $CURSOR_NAME..."
  mkdir -p "$USER_HOME/.icons"
  cd "$USER_HOME/.icons"

  case $CURSOR_NAME in
    1) # WhiteSur
      git clone https://github.com/vinceliuice/WhiteSur-cursors.git
      cd WhiteSur-cursors
      ./install.sh
      ;;
    0) echo "Skipping cursor theme"; return ;;
    *) echo "Invalid option"; return ;;
  esac
  cd "$USER_HOME"
}

install_wallpaper() {
  WALLPAPER_NAME="$1"
  mkdir -p "$USER_HOME/Pictures/Wallpapers"
  cd "$USER_HOME/Pictures/Wallpapers"

  case $WALLPAPER_NAME in
    1) wget -q https://wallpapers.apple.com/wallpaper/Big-Sur-4k.jpg -O big-sur.jpg
       sudo -u $SUDO_USER gsettings set org.gnome.desktop.background picture-uri "file://$USER_HOME/Pictures/Wallpapers/big-sur.jpg"
       ;;
    2) wget -q https://wallpapers.apple.com/wallpaper/macOS-Ventura-4k.jpg -O ventura.jpg
       sudo -u $SUDO_USER gsettings set org.gnome.desktop.background picture-uri "file://$USER_HOME/Pictures/Wallpapers/ventura.jpg"
       ;;
    0) echo "Skipping wallpaper"; return ;;
    *) echo "Invalid option"; return ;;
  esac
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
  chown -R $SUDO_USER:$SUDO_USER "$USER_HOME/.config"
}

apply_settings() {
  sudo -u $SUDO_USER gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME"
  sudo -u $SUDO_USER gsettings set org.gnome.desktop.interface icon-theme "$ICON_THEME"
  sudo -u $SUDO_USER gsettings set org.gnome.desktop.interface cursor-theme "$CURSOR_THEME"
  sudo -u $SUDO_USER gsettings set org.gnome.desktop.interface enable-animations true
  sudo -u $SUDO_USER gsettings set org.gnome.mutter experimental-features "['rounded-corners']"
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

  # Apply chosen settings
  GTK_THEME="WhiteSur-dark"
  ICON_THEME="WhiteSur"
  CURSOR_THEME="WhiteSur-cursors"
  [[ "$GTK_CHOICE" == "2" ]] && GTK_THEME="McMojave-dark"
  [[ "$ICON_CHOICE" == "2" ]] && ICON_THEME="McMojave-circle"
  [[ "$CURSOR_CHOICE" == "0" ]] && CURSOR_THEME=""
  apply_settings
fi

echo "Installation complete! Log out and back in to see full effect."
