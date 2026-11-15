#!/bin/sh
set -eu

MANIFEST="com.moulberry.PandoraLauncher.yaml"
BUILD_DIR="build"
REPO_DIR="repo"

# Select Flatpak Builder
if command -v flatpak-builder >/dev/null 2>&1; then
    set -- flatpak-builder
else
    set -- flatpak run --command=flatpak-builder org.flatpak.Builder
fi

# Build and export
"$@" \
    --force-clean \
    --ccache \
    --install-deps-from=flathub \
    --repo="$REPO_DIR" \
    --compose-url-policy=full \
    --mirror-screenshots-url=https://dl.flathub.org/media \
    "$BUILD_DIR" \
    "$MANIFEST"

# Validate manifest
flatpak run --command=flatpak-builder-lint \
    org.flatpak.Builder manifest "$MANIFEST"

# Validate build
flatpak run --command=flatpak-builder-lint \
    org.flatpak.Builder builddir "$BUILD_DIR"

# Validate repository
flatpak run --command=flatpak-builder-lint \
    org.flatpak.Builder repo "$REPO_DIR"

echo "Build and validation completed successfully."
