#!/bin/bash
# This script updates the system, installs required packages, configures DNF, sets up font rendering, and applies various system tweaks.

# Introductory message
echo "Installing required packages..."

# Update the system and install required packages
sudo dnf update -y -q

# Install Visual Studio Code repository
if [ ! -f "/etc/yum.repos.d/vscode.repo" ]; then
  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
  sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
  sudo dnf check-update
fi

sudo dnf install -y -q \
  "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
  "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm" \
  "zsh" \
  "util-linux-user" \
  "gnome-tweaks" \
  "dnf-plugins-core" \
  "texlive-scheme-basic" \
  "texlive-tex-gyre" \
  "google-noto-emoji-fonts" \
  "flatpak" \
  "code" \
  "gnome-extensions-app" \
  "gnome-shell-extension-user-theme" \
  "gnome-shell-extension-caffeine"

# Add flathub repository
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install Oh My Zsh
if [ ! -d "${HOME}/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended
fi

# Configure DNF
declare -A config_flags
config_flags=(["defaultyes"]="True" ["fastestmirror"]="True" ["max_parallel_downloads"]="10")

for key in "${!config_flags[@]}"; do
  if grep -q "^$key=" /etc/dnf/dnf.conf; then
    sudo sed -i "s/^$key=.*/$key=${config_flags[$key]}/" /etc/dnf/dnf.conf
  else
    echo "$key=${config_flags[$key]}" | sudo tee -a /etc/dnf/dnf.conf
  fi
done

# Enable fractional scaling for Wayland
gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"

# Fix blurry UI on fractional wayland visual studio code
if ! grep -q -- '--ozone-platform-hint=auto' /usr/share/applications/code.desktop; then
  sudo cp /usr/share/applications/code.desktop /usr/share/applications/code.desktop.bak
  sudo sed -i -e 's/Exec=\/usr\/share\/code\/code --unity-launch %F/Exec=\/usr\/share\/code\/code --unity-launch --ozone-platform-hint=auto %F/' -e 's/Exec=\/usr\/share\/code\/code --new-window %F/Exec=\/usr\/share\/code\/code --new-window --ozone-platform-hint=auto %F/' /usr/share/applications/code.desktop
fi

# Check if Git username and email are set
if [[ -z "$(git config --global user.name)" ]] || [[ -z "$(git config --global user.email)" ]]; then
  # Prompt the user for their Git username and email
  read -p "Enter your Git username: " git_username
  read -p "Enter your Git email: " git_email

  # Set Git username and email
  git config --global user.name "$git_username"
  git config --global user.email "$git_email"
fi

# Return a newline then echo a message
echo ""
echo "Done! Reboot to apply changes."
