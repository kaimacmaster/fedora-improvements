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

# Update the font cache
fc-cache -f -v >/dev/null 2>&1

echo "Font configuration complete."
