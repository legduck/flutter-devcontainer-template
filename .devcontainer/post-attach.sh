#!/bin/bash
set -e

flutter pub get

# Prevent Git from reporting false changes due to permission bits or line endings when mounted from Windows.
git config --global core.filemode false || true
git config --global core.autocrlf true || true
# Mark the workspace as safe in case ownership differs inside the container.
if [ -n "$WORKSPACE_FOLDER" ] && [ -d "$WORKSPACE_FOLDER" ]; then
	git config --global --add safe.directory "$WORKSPACE_FOLDER" || true
else
	# Fallback to the default devcontainer workspace path if env var is missing
	git config --global --add safe.directory "/workspaces/$(basename "$(pwd)")" || true
fi
