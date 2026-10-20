# Development

## Browser preview

```sh
npm run dev
```

Opens http://localhost:4795/home/ on this computer. Arrow keys, Enter and Escape mirror the remote. App discovery and launching need the TV and report that in the preview.

## How it fits together

- `app/index.html`, `main.js`, `style.css` are the UI, written as plain ES5 so old WebViews run it. The logical stage is 1920 x 1080, scaled to the viewport; glass geometry and the pre-rendered materials must stay aligned.
- `app/device.js` is the only platform seam. It wraps the `AndroidTV` object that `android/.../MainActivity.java` exposes to the page: `getApps`, `launchApp`, `openSettings`, `openWifi`, `openStockHome`.
- `MainActivity` loads the bundled `app/` from a virtual `https://appassets.androidplatform.net/` origin (a `file://` origin blocks the UI's image probes), blocks all other requests, and maps the remote's keys to the key codes the UI expects.
- Preferences live in `localStorage` under `cleanframe.home.v1`.
- Wake rotation: `MainActivity` listens for screen-off and screensaver start and calls `window.onWake`, which swaps to a different wallpaper without a fade (unless the rotation mode is Fixed). The page keeps running while asleep so the image is loaded before the screen comes back.
- `window.onHomeIntent` resets Home when the Home button is pressed while it is open.

## Platform notes

- Android reports `innerWidth` in device pixels while laying out in dp, so `fit()` uses `clientWidth/clientHeight`.
- Old WebViews (Android 9) lack `inset` and flex `gap`; `style.css` has fallbacks.
- App icons come from the TV (`PackageManager`), drawn to a 128px bitmap with banner icons letterboxed on their own edge colour, then cropped to circles in CSS.
- `BRANDS` in `MainActivity.java` maps known package names to Home's default apps. Unknown packages still appear under All apps.

## Checks

`npm run check` parses the JavaScript and verifies every referenced file exists. There is no automated UI test suite; check List, Dock, Settings and the apps editor by hand on the TV.
