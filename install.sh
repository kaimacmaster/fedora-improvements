#!/bin/bash
# This script updates the system, installs required packages, configures DNF, sets up font rendering, and applies various system tweaks.

# Introductory message
echo "Installing required packages..."

# Create a loading spinner
spinner() {
  local pid=$1
  local delay=0.5
  local spinstr='|/-\'
  while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
    local temp=${spinstr#?}
    printf " [%c]  " "$spinstr"
    local spinstr=$temp${spinstr%"$temp"}
    sleep $delay
    printf "\b\b\b\b\b\b"
  done
  printf "    \b\b\b\b"
}

# Run the spinner in the background
spinner $$ &
spinner_pid=$!

# Stop the spinner before prompting the user
stop_spinner() {
  kill -TERM "$spinner_pid" 2>/dev/null
}

# Register the stop_spinner function to be called on exit or interruption
trap stop_spinner EXIT

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

# Create a new font configuration file
FONT_CONFIG_DIR="${HOME}/.config/fontconfig"
FONT_CONFIG_FILE="${FONT_CONFIG_DIR}/fonts.conf"
LIBERTINUS_DIR="$HOME/.local/share/fonts/otf"

if [ ! -e "$FONT_CONFIG_DIR" ]; then
  mkdir -p "$FONT_CONFIG_DIR"
fi

# Install otf-libertinus fonts
if [ ! -f "$LIBERTINUS_DIR/LibertinusSerif-Regular.otf" ]; then
  # Download the latest release
  LATEST_TAG=$(curl -s https://api.github.com/repos/alerque/libertinus/releases/latest | grep 'tag_name' | cut -d '"' -f 4)
  wget -q https://github.com/alerque/libertinus/releases/download/${LATEST_TAG}/Libertinus-${LATEST_TAG#v}.tar.xz -O libertinus.tar.xz

  # Extract the fonts
  mkdir -p libertinus-source
  tar -xJf libertinus.tar.xz -C libertinus-source

  # Install the fonts
  mkdir -p "$LIBERTINUS_DIR"
  cp libertinus-source/Libertinus-*/static/OTF/*.otf "$LIBERTINUS_DIR"

  # Cleanup
  rm libertinus.tar.xz
  rm -rf libertinus-source
fi

if [ ! -e "$FONT_CONFIG_FILE" ]; then
  touch "$FONT_CONFIG_FILE"

  # Append the provided XML content to the font configuration file
  cat <<'EOF' >"$FONT_CONFIG_FILE"
  <?xml version='1.0'?>
  <!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
  <fontconfig>

    <match target="font">
      <edit name="autohint" mode="assign">
        <bool>true</bool>
      </edit>
      <edit name="hinting" mode="assign">
        <bool>true</bool>
      </edit>
      <edit mode="assign" name="hintstyle">
        <const>hintslight</const>
      </edit>
      <edit mode="assign" name="lcdfilter">
        <const>lcddefault</const>
      </edit>
    </match>

    <!-- Default sans-serif font -->
    <match target="pattern">
      <test qual="any" name="family"><string>-apple-system</string></test>
      <!--<test qual="any" name="lang"><string>ja</string></test>-->
      <edit name="family" mode="prepend" binding="same"><string>Tex Gyre Heros</string></edit>
    </match>
    <match target="pattern">
      <test qual="any" name="family"><string>Helvetica Neue</string></test>
      <!--<test qual="any" name="lang"><string>ja</string></test>-->
      <edit name="family" mode="prepend" binding="same"><string>Tex Gyre Heros</string></edit>
    </match>
    <match target="pattern">
      <test qual="any" name="family"><string>Helvetica</string></test>
      <!--<test qual="any" name="lang"><string>ja</string></test>-->
      <edit name="family" mode="prepend" binding="same"><string>Tex Gyre Heros</string></edit>
    </match>
    <match target="pattern">
      <test qual="any" name="family"><string>arial</string></test>
      <!--<test qual="any" name="lang"><string>ja</string></test>-->
      <edit name="family" mode="prepend" binding="same"><string>Tex Gyre Heros</string></edit>
    </match>
    <match target="pattern">
      <test qual="any" name="family"><string>sans-serif</string></test>
      <!--<test qual="any" name="lang"><string>ja</string></test>-->
      <edit name="family" mode="prepend" binding="same"><string>Tex Gyre Heros</string></edit>
    </match>

    <!-- Default serif fonts -->
    <match target="pattern">
      <test qual="any" name="family"><string>serif</string></test>
      <edit name="family" mode="prepend" binding="same"><string>Libertinus Serif</string></edit>
      <edit name="family" mode="prepend" binding="same"><string>Noto Serif</string></edit>
      <edit name="family" mode="prepend" binding="same"><string>Noto Color Emoji</string></edit>
      <edit name="family" mode="append" binding="same"><string>IPAPMincho</string></edit>
      <edit name="family" mode="append" binding="same"><string>HanaMinA</string></edit>
    </match>

    <!-- Default monospace fonts -->
    <match target="pattern">
      <test qual="any" name="family"><string>SFMono-Regular</string></test>
      <edit name="family" mode="prepend" binding="same"><string>DM Mono</string></edit>
      <edit name="family" mode="prepend" binding="same"><string>Space Mono</string></edit>
      <edit name="family" mode="append" binding="same"><string>Inconsolatazi4</string></edit>
      <edit name="family" mode="append" binding="same"><string>IPAGothic</string></edit>
    </match>
    <match target="pattern">
      <test qual="any" name="family"><string>Menlo</string></test>
      <edit name="family" mode="prepend" binding="same"><string>DM Mono</string></edit>
      <edit name="family" mode="prepend" binding="same"><string>Space Mono</string></edit>
      <edit name="family" mode="append" binding="same"><string>Inconsolatazi4</string></edit>
      <edit name="family" mode="append" binding="same"><string>IPAGothic</string></edit>
    </match>
    <match target="pattern">
      <test qual="any" name="family"><string>monospace</string></test>
      <edit name="family" mode="prepend" binding="same"><string>DM Mono</string></edit>
      <edit name="family" mode="prepend" binding="same"><string>Space Mono</string></edit>
      <edit name="family" mode="append" binding="same"><string>Inconsolatazi4</string></edit>
      <edit name="family" mode="append" binding="same"><string>IPAGothic</string></edit>
    </match>

    <!-- Fallback fonts preference order -->
    <alias>
      <family>sans-serif</family>
      <prefer>
        <family>Noto Sans</family>
        <family>Noto Color Emoji</family>
        <family>Noto Emoji</family>
        <family>Open Sans</family>
        <family>Droid Sans</family>
        <family>Ubuntu</family>
        <family>Roboto</family>
        <family>NotoSansCJK</family>
        <family>Source Han Sans JP</family>
        <family>IPAPGothic</family>
        <family>VL PGothic</family>
        <family>Koruri</family>
      </prefer>
    </alias>
    <alias>
      <family>serif</family>
      <prefer>
        <family>Noto Serif</family>
        <family>Noto Color Emoji</family>
        <family>Noto Emoji</family>
        <family>Droid Serif</family>
        <family>Roboto Slab</family>
        <family>IPAPMincho</family>
      </prefer>
    </alias>
    <alias>
      <family>monospace</family>
      <prefer>
        <family>Noto Sans Mono</family>
        <family>Noto Color Emoji</family>
        <family>Noto Emoji</family>
        <family>Inconsolatazi4</family>
        <family>Ubuntu Mono</family>
        <family>Droid Sans Mono</family>
        <family>Roboto Mono</family>
        <family>IPAGothic</family>
      </prefer>
    </alias>
  </fontconfig>
EOF
fi

# Fix blurry UI on fractional wayland visual studio code
if ! grep -q -- '--ozone-platform-hint=auto' /usr/share/applications/code.desktop; then
  sudo cp /usr/share/applications/code.desktop /usr/share/applications/code.desktop.bak
  sudo sed -i -e 's/Exec=\/usr\/share\/code\/code --unity-launch %F/Exec=\/usr\/share\/code\/code --unity-launch --ozone-platform-hint=auto %F/' -e 's/Exec=\/usr\/share\/code\/code --new-window %F/Exec=\/usr\/share\/code\/code --new-window --ozone-platform-hint=auto %F/' /usr/share/applications/code.desktop
fi

# Update the font cache
fc-cache -f -v >/dev/null 2>&1

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
