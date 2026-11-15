# Pandora Launcher on Flathub

Flatpak packaging for [Pandora Launcher](https://github.com/Moulberry/PandoraLauncher), a Minecraft launcher.

- Flatpak app ID: `com.moulberry.PandoraLauncher`
- Main manifest: `com.moulberry.PandoraLauncher.yaml`
- Built from upstream source using the Freedesktop SDK and Rust SDK extension.

## Local build

Install Flatpak Builder from Flathub:

```sh
flatpak install flathub org.flatpak.Builder
```

Build and validate:

```sh
./build.sh
```

Launch the result with the native builder, if installed:

```sh
flatpak-builder --run build com.moulberry.PandoraLauncher.yaml pandora_launcher
```

Or use the Flatpak Builder installed above:

```sh
flatpak run --command=flatpak-builder org.flatpak.Builder --run build com.moulberry.PandoraLauncher.yaml pandora_launcher
```

Launching uses the application's normal user data. For a packaging-only check, stop after `./build.sh`; it builds and validates without installing or launching Pandora.

## Updating the release

1. Locate the latest **stable** upstream tag.
2. Update `tag`, the matching full Git commit hash, and `PANDORA_RELEASE_VERSION` (without the leading `v`) in the main manifest.
3. Update `appstream-release.patch` with the release version and official publication date. Drop the patch when upstream metadata is current. Check whether the upstream build process or dependencies have changed.
4. Build locally, launch the app, and verify Minecraft instances and their Java runtimes.
5. Open a pull request to this Flathub repository.

`xrandr.yml` is kept because it is part of the current working packaging.
Rust dependencies are supplied by the upstream source tree and compiled offline.

The v6.0.0 upstream tag still declares Cargo workspace version `5.3.1` and AppStream release `v2.5.0`. The packaging sets `PANDORA_RELEASE_VERSION` for the version displayed in the UI and patches AppStream with the [official release date](https://github.com/Moulberry/PandoraLauncher/releases/tag/v6.0.0), preserving the older entry. Cargo package versions remain as provided upstream.
