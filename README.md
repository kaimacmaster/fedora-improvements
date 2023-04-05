# Fedora Workstation Setup Script

This Bash script automates the setup of a Fedora workstation by updating the system, installing necessary packages, and applying various tweaks for improved performance and user experience.

## Features

1. Updates the system and installs Zsh, setting it as the default shell.
2. Modifies dnf configurations for faster package downloads and automatic "yes" response.
3. Installs Gnome Tweaks and enables fractional scaling for Wayland and X11.
4. Enables RPM Fusion repositories (free and non-free) and the COPR plugin.
5. Installs Flatpak and adds the Flathub repository.
6. Installs required fonts and improves font rendering.
7. Creates a new font configuration file with customized settings.

## Usage

1. Download the script and save it as `fedora_setup.sh`.
2. Open a terminal and navigate to the directory where the script is located.
3. Give the script executable permissions:
```bash
chmod +x fedora_setup.sh
```
4. Run the script:
```bash
./fedora_setup.sh
```

Please note that you might need to enter your sudo password during the execution of the script. After the script finishes, restart your applications or log out and log back in for the changes to take effect.

## License

This script is provided "as-is" and can be used, modified, and shared freely.
