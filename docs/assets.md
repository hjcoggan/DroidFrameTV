# Assets

## Bundled wallpaper

The repo ships one photograph, "Misty coast" (credit in `app/assets/PHOTO-CREDIT.md`). Each wallpaper needs:

- `app/assets/wallpapers/<id>.jpg` (1920 x 1080), `<id>-thumb.jpg` (512 x 288) and `<id>-panel.jpg`
- four glass materials in `app/assets/materials/`: `<id>-field-blur.jpg`, `-field-frost.jpg`, `-field-clear.jpg`, `-study-soft.jpg`
- an entry in `app/assets/wallpapers/catalog.js` with its tone and control colours

The glass is rendered ahead of time so the TV only shows finished images; the app never blurs or reads photo pixels at runtime.

## Material recipes

`node scripts/build-materials.mjs <id>[,<id>]` renders the four materials for photos listed in `app/assets/wallpapers/SOURCES.json` (needs `npm ci` and `npx playwright install chromium`). Output goes to `.local/materials/builder/`.

- `field-blur`: 28px blur, saturation .92, mirrored edge padding, highlights softly clipped.
- `field-frost`: the same with a 42px blur. The panel backdrop is a small copy of it.
- `field-clear`: 2px blur, saturation 1.06.
- `study-soft`: lower scrim, 14px blur and a bounded tint chosen from the dock band.

## Local wallpapers

Your own photos stay out of git. Put them in `wallpapers/` (ignored) with a `catalog.json`:

```json
[{"file": "my-photo.jpg", "id": "my-photo", "name": "My photo", "place": "Brisbane, Queensland, Australia"}]
```

`file`, `id` and `name` are required. `place` is optional free text shown at the bottom right of Home, in line with the clock, for as long as that photo is on screen. Use it for the location or for a photo credit (for example `"Photo: Jane Doe on Unsplash"`). Leave it out, or use an empty string, to show nothing. It is plain text, so you supply it yourself; the app does not look anything up. A fuller example is in [`wallpapers-catalog.example.json`](wallpapers-catalog.example.json).

Then run `python3 scripts/local-wallpapers.py` (needs Pillow, Node, and Playwright's Chromium). Each photo is centre-cropped to fill 1920 x 1080 without stretching, and its materials are built. Output is `local-*` files in `app/assets/` plus `local-catalog.js`, all ignored by git. When `local-catalog.js` exists it replaces the bundled wallpaper list, so a build made from your working copy uses your photos and a build from a clean checkout uses only the bundled one.

Tone (`light` or `dark`) and the control colours are guessed from image brightness. Check List and Dock on the TV and edit the generated `local-catalog.js` if text is hard to read.
