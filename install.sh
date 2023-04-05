#!/bin/bash

# Update the system and install zsh
sudo dnf update -y
sudo dnf install -y zsh

# Set zsh as the default shell
chsh -s $(which zsh)

# Set default response in terminal to yes
echo "alias dnf='dnf --assumeyes'" >> ~/.zshrc

# Set dnf max parallel downloads to 6
sudo sed -i 's/^#max_parallel_downloads=3/max_parallel_downloads=6/' /etc/dnf/dnf.conf

# Install Gnome Tweaks and enable fractional scaling for Wayland and X11
sudo dnf install -y gnome-tweaks
gsettings set org.gnome.mutter experimental-features "['x11-randr-fractional-scaling', 'scale-monitor-framebuffer']"

# Enable RPM Fusion repositories (free and non-free)
sudo dnf install -y \
  "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
  "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

# Enable COPR plugin
sudo dnf install -y dnf-plugins-core

# Install flatpak
sudo dnf install -y flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Update system and install required fonts
sudo dnf update -y
sudo dnf install -y tex-gyre-fonts otf-libertinus noto-fonts-emoji

# Create a new font configuration file
FONT_CONFIG_DIR="${HOME}/.config/fontconfig"
FONT_CONFIG_FILE="${FONT_CONFIG_DIR}/fonts.conf"

mkdir -p "$FONT_CONFIG_DIR"
touch "$FONT_CONFIG_FILE"

# Append the provided XML content to the font configuration file
cat << 'EOF' > "$FONT_CONFIG_FILE"
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

echo "System tweaks, packages and font rendering improvements applied. You may need to restart your applications or log out and log back in for changes to take effect."
