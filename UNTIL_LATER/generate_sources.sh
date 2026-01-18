#!/bin/bash
set -x
pandora_version=v2.5.0
cargo_gen_override=

if [ -z "$cargo_gen_override" ]; then
  if ! command -v flatpak-cargo-generator &> /dev/null; then
    echo "Please install flatpak-cargo-generator from https://github.com/flatpak/flatpak-builder-tools into path"
    echo "Or override cargo-gen-override"
  fi
  cargo_gen_override=$(command -v flatpak-cargo-generator)
fi

git_routine() {
  cd .temp || exit
  if [ ! -d pandora/.git ]; then
    git clone https://github.com/Moulberry/PandoraLauncher --depth=1 -b "$pandora_version" pandora
  else
    cd pandora || exit
    git pull
  fi
}

cargo_gen() {
  "$cargo_gen_override" -o generated/rust-sources.yaml --yaml generated/.temp/pandora/Cargo.lock
}

work_dir=$(pwd)
mkdir -p generated/.temp
cd generated || exit
git_routine
cd "$work_dir" || exit
cargo_gen
