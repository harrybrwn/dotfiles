#!/usr/bin/env bash

set -euo pipefail

readonly URL="$(
  curl -sL \
    -H "Accept: application/vnd.github+json" \
    'https://api.github.com/repos/wez/wezterm/releases/latest' \
    | jq -r '.assets[] | select(.name|endswith("Ubuntu20.04.deb")) | .browser_download_url')"

echo "Downloading \"$URL\""
wget "$URL"

echo '$ sudo apt update'
sudo apt update

echo "\$ sudo apt install -f ./$(basename $URL)"
sudo apt install -f "./$(basename "$URL")"
