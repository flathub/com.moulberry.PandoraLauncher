#!/bin/env sh
# just to script to help me not have to ctrl + r the command lol
set -x
FPBUILD=
if command -v flatpak-builder; then
  FPBUILD=$(command -v flatpak-builder)
else
  FPBUILD="flatpak run org.flatpak.Builder"
fi

$FPBUILD --force-clean build --repo=repo com.moulberry.PandoraLauncher.yaml --user --mirror-screenshots-url=https://dl.flathub.org/media --install --ccache
