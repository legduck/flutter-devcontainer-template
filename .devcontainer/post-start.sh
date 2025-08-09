#!/bin/bash
set -e

# Run lightweight setup after container starts, without grabbing an interactive terminal
flutter pub get || true

# Prevent Git noise with mounted volumes
git config --global core.filemode false || true
git config --global core.autocrlf true || true
git config --global --add safe.directory /workspaces/flutter-devcontainer-template || true
