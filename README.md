# DroidFrameTV

A quieter home screen for Android TV: your apps, a photograph and the time, built for the TV remote.

![DroidFrameTV home screen](docs/images/cleanframe-dock.jpg)

## Credit

DroidFrameTV is an Android TV port of **[CleanFrame](https://github.com/nthnclrk/CleanFrame) by [Nathan Clark](https://github.com/nthnclrk)**, which he built for Samsung The Frame. The interface, layouts, pre-rendered glass materials, remote navigation and the idea are his; this project keeps them as close to 1:1 as Android allows and only replaces the Samsung/Tizen parts. Please star and credit the original.

The Android launcher shell borrows its approach from [qingyun7/CleanFrame-Android](https://github.com/qingyun7/CleanFrame-Android), an earlier independent Android port (MIT).

This is an independent project with no affiliation to Nathan Clark, Samsung, Google, Sony or any streaming service.

## What it does

- Home as a **List** or a **Dock**, with icons, names or both, over a photograph, or a plain light or dark background.
- Shows each app's own launcher icon, cropped to a circle. Any number of apps on Home; add, remove and reorder them.
- **All apps** lists everything installed on the TV. **Settings** opens Android's TV settings and Wi-Fi.
- Wallpaper can change each time the TV goes to sleep, so the new one is already there when it wakes (Settings > Background > Rotation).
- Runs offline. No network, storage or accessibility permissions.

Differences from the original: no Art Mode (the button shows the bare photo), Back on Home stays on Home, and the Samsung Home/TV settings entries open the TV's launcher and Android settings.

## Install

Download `DroidFrameTV.apk` from [Releases](../../releases), then with the TV's network debugging on:

```sh
adb connect <tv-ip>:5555
adb install -r DroidFrameTV.apk
adb shell am start -n app.cleanframe.tv/.MainActivity
```

It also appears in the TV's app row, so you can try it before making it your Home. To use it as Home, press the remote's Home button and pick DroidFrameTV when asked, or set the default launcher in Android settings. Whether the default can change depends on the TV's firmware. To go back, clear the default under Settings > Apps > DroidFrameTV or uninstall it.

Requires Android 8.0 (API 26) or newer. Developed on a Sony BRAVIA running Android 10; the target is Android 9 TVs. Other TVs are untested.

## Build

You need JDK 17 to 21 and the Android SDK (platform 35 and build-tools).

```sh
export ANDROID_HOME=/path/to/android-sdk
echo "sdk.dir=$ANDROID_HOME" > android/local.properties
cd android && ./gradlew assembleRelease
```

The APK is `android/app/build/outputs/apk/release/app-release.apk`. It is signed with the Android debug key, so it installs for sideloading; use your own keystore for anything you distribute. The wrapper pins Gradle 8.13 (newer Gradle releases are not yet compatible with the Android plugin used here).

The web UI in `app/` is bundled into the APK unchanged. See [development](docs/development.md) for the browser preview and how the bridge works.

## Your own wallpapers

The repo ships one wallpaper. To use your own without committing them, put photos in `wallpapers/` with a `catalog.json`, then run `python3 scripts/local-wallpapers.py`. They are cropped to fill the screen and kept out of git. See [assets](docs/assets.md).

## Layout

| Path | Purpose |
| --- | --- |
| `app/` | The UI: HTML, CSS and ES5 JavaScript. `device.js` is the platform bridge |
| `android/` | Gradle project: the launcher activity and WebView host |
| `scripts/` | Browser preview, glass material builder, local wallpaper generator |
| `docs/` | [Development](docs/development.md), [assets](docs/assets.md), [interaction behaviour](docs/interaction-behaviour.md) |

## Licence

MIT, covering both CleanFrame (Nathan Clark) and this port. See [LICENSE](LICENSE). Fonts and the bundled photograph keep their own terms: [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).
