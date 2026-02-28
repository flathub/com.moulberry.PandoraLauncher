#!/bin/env sh
# just to script to help me not have to ctrl + r the command lol
set -x
FPBUILD=
FLATPAK_MANIFEST_NAME=com.moulberry.PandoraLauncher.yaml
if command -v flatpak-builder; then
  FPBUILD=$(command -v flatpak-builder)
else
  FPBUILD="flatpak run org.flatpak.Builder"
fi

$FPBUILD --force-clean build --repo=repo "$FLATPAK_MANIFEST_NAME" --user --mirror-screenshots-url=https://dl.flathub.org/media --ccache || exit
# uncomment to build bundle
# flatpak build-bundle repo release.flatpak "$FLATPAK_MANIFEST_NAME"
flatpak run --command=flatpak-builder-lint org.flatpak.Builder --exceptions --debug repo repo
