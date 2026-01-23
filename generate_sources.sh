#!/bin/bash
set -x
repo=$(grep -o 'url: .*' com.moulberry.PandoraLauncher.yaml | sed 's/url: //')
branch=$(grep -o 'branch: .*' com.moulberry.PandoraLauncher.yaml | sed 's/branch: //')
version_sha=$(grep -o 'commit: .*' com.moulberry.PandoraLauncher.yaml | sed 's/commit: //')
cargo_gen_override=

if [ -z "$cargo_gen_override" ]; then
  if ! command -v flatpak-cargo-generator &> /dev/null; then
    echo "Please install flatpak-cargo-generator from https://github.com/flatpak/flatpak-builder-tools into path"
    echo "Or override cargo-gen-override"
  fi
  cargo_gen_override=$(command -v flatpak-cargo-generator)
fi

git_routine() {
  cd generated/.temp || exit
  if [ ! -d pandora/.git ]; then
    git clone "$repo" --depth=1 -b "$branch" pandora
  fi
  cd pandora || exit
  git pull
  git checkout "$version_sha"
}

cargo_gen() {
#  cd "$work_dir"/generated/.temp/pandora || exit
#  rm Cargo.lock; cargo generate-lockfile;
  cd "$work_dir" || exit
#  "$cargo_gen_override" update gpui-component
  "$cargo_gen_override" -o generated/cargo-sources.yaml --yaml generated/.temp/pandora/Cargo.lock
}

work_dir=$(pwd)
mkdir -p generated/.temp
git_routine
cargo_gen
