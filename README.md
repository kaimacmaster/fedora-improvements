# Fedora Workstation Setup Script

This Bash script automates the setup of a Fedora workstation by updating the system, installing necessary packages, and applying various tweaks for improved performance and user experience.

## Features

- Updates the system and installs required packages
  - Visual Studio Code repository
  - RPM Fusion repositories
  - zsh
  - util-linux-user
  - gnome-tweaks
  - dnf-plugins-core
  - texlive-scheme-basic
  - texlive-tex-gyre
  - google-noto-emoji-fonts
  - flatpak
  - gnome-extensions-app
  - gnome-shell-extension-user-theme
  - gnome-shell-extension-caffeine
- Installs Oh My Zsh
- Configures DNF
- Enables fractional scaling for Wayland
- Sets up font configurations
- Fixes blurry UI on fractional Wayland Visual Studio Code
- Updates the font cache

## Usage

1. Download the script and save it as `install.sh`.
2. Open a terminal and navigate to the directory where the script is located.
3. Give the script executable permissions:

```bash
chmod +x install.sh
```

1. Run the script:

```bash
./install.sh
```

Please note that you might need to enter your sudo password during the execution of the script. After the script finishes, restart your applications or log out and log back in for the changes to take effect.

## License

This script is provided "as-is" and can be used, modified, and shared freely.
