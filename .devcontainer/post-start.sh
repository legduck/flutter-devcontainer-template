#!/bin/bash
set -e

# Run lightweight setup after container starts, without grabbing an interactive terminal
flutter pub get || true

# Prevent Git noise with mounted volumes
git config --global core.filemode false || true
git config --global core.autocrlf true || true
if [ -n "$WORKSPACE_FOLDER" ] && [ -d "$WORKSPACE_FOLDER" ]; then
	git config --global --add safe.directory "$WORKSPACE_FOLDER" || true
else
	git config --global --add safe.directory "/workspaces/$(basename "$(pwd)")" || true
fi
