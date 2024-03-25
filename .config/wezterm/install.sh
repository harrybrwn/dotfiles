#!/usr/bin/env bash

set -euo pipefail

font_install() {
  local name="$1"
  wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/${name}.zip"
  unzip -o -d ~/.local/share/fonts/ "${name}.zip"
  rm -f \
    ~/.local/share/fonts/LICENSE     \
    ~/.local/share/fonts/LICENSE.txt \
    ~/.local/share/fonts/README      \
    ~/.local/share/fonts/README.md
  fc-cache
  rm "${name}.zip"
}

wezterm_deb_url() {
  curl -sL \
    -H "Accept: application/vnd.github+json" \
    'https://api.github.com/repos/wez/wezterm/releases/latest' \
    | jq -r '.assets[] | select(.name|endswith("Ubuntu20.04.deb")) | .browser_download_url'
}

# Download and install my fonts
font_install "RobotoMono"
font_install "LiberationMono"
font_install "FiraMono"
font_install "SourceCodePro"
exit 0

readonly URL="$(wezterm_deb_url)"
echo "Downloading \"$URL\""
wget "$URL"

echo '$ sudo apt update'
sudo apt update

echo "\$ sudo apt install -f ./$(basename $URL)"
sudo apt install -f "./$(basename "$URL")"
rm "$(basename "$URL")"
