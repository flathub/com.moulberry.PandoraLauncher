#!/bin/bash
set -x
zed_override=7ce845210d3af82a57a7518e0abe8c167d60cc6a
sha_to_override=e1a09e290c48fc02d07aaf2150856d77996414df
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
  sed -i "s/$sha_to_override/$zed_override/g" generated/.temp/pandora/Cargo.lock
  "$cargo_gen_override" -o generated/rust-sources.yaml --yaml generated/.temp/pandora/Cargo.lock
}

work_dir=$(pwd)
mkdir -p generated/.temp
cd generated || exit
git_routine
cd "$work_dir" || exit
cargo_gen
