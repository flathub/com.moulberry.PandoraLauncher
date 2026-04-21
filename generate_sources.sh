#!/bin/bash
set -x

temporary_file=$(mktemp)
# shellcheck disable=SC2064
# temporary_file never changes
trap "rm -f $temporary_file" EXIT
tail -n 5 com.moulberry.PandoraLauncher.yaml >> "$temporary_file"
repo=$(grep -o 'url: .*' "$temporary_file" | sed 's/url: //')
#branch=$(grep -o 'branch: .*' "$temporary_file" | sed 's/branch: //')
version_sha=$(grep -o 'commit: .*' "$temporary_file" | sed 's/commit: //')
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
    git clone "$repo" --depth=1 pandora
  fi
  cd pandora || exit
  git pull
  git reset --hard "$version_sha"
#  assets_ver=$(grep -o 'gpui-component.git?rev=[a-zA-Z0-9]*' Cargo.lock | head -n1 | sed 's/gpui-component.git?rev=//')
  cargo add gpui-component-assets --git=https://github.com/longbridge/gpui-component.git --rename=assets #--rev="$assets_ver"
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
