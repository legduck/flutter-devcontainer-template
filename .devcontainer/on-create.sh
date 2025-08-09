#!/bin/bash
set -e

# Ensure scripts are LF-terminated even if edited on Windows hosts (best-effort)
command -v dos2unix >/dev/null 2>&1 && dos2unix "$0" || true

dart --disable-analytics
flutter --disable-analytics
flutter config --no-enable-web
flutter config --no-enable-linux-desktop
flutter doctor

echo '' >> $HOME/.bashrc
echo 'eval -- "$(/usr/local/bin/starship init bash --print-full-init)"' >> $HOME/.bashrc
echo '' >> $HOME/.bashrc
echo 'source ~/.bashrc.1' >> $HOME/.bashrc

export TERM=xterm-256color
task onboarding | while IFS= read -r line; do
  # Loop over each character in the current line.
  for (( i=0; i<${#line}; i++ )); do
    echo -n "${line:$i:1}"
    sleep 0.003
  done
  # Print a newline after finishing the line.
  echo
done
