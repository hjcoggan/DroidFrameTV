# Interaction behaviour

## Home

- List (default): Up/Down scrolls the apps without wrapping, and Left/Right do the same (Left goes up, Right goes down). The list fades at both ends as it scrolls. The clock is at the top right and, when the photo has a location, it is shown at the bottom right.
- Dock: Left/Right scrolls the apps without wrapping. The clock is at the top left.
- The last four entries are fixed and not part of Apps on Home: **Play Store**, **Settings**, **Input** and **All apps**. Input opens the same Inputs picker as the remote's Input button.
- OK opens the selected item. Focus alone never launches an app.
- Icons-only apps reveal their names when focused.
- Back on Home stays on Home; DroidFrameTV is the launcher.
- A panel keeps focus within its own controls. Back closes one panel at a time.
- Returning to the running launcher keeps the selected app or panel item. There is no auto-return timer. Held OK and Back keys act once until the key is released.

## Settings and appearance

Settings opens a grouped overview: Background, Layout, Typography, Focus, Apps on Home and TV settings. OK opens a group. Appearance groups use a two-pane screen with visible choices on the left and the committed Home preview on the right.

| Group | Choices |
| --- | --- |
| Background | Photo, Light, Dark; Wallpaper and Rotation when Photo is active |
| Layout | List or Dock; Text, Icons or Both for the apps |
| Typography | Manrope, Geist and Newsreader |
| Focus | Type, Glass or Solid. Glass: Soft, Frost or Clear tint material. Solid: a highlight colour (including From wallpaper), a text colour for From wallpaper, and Transparency from 0 to 100% |
| Apps on Home | Membership and arrangement editor |
| TV settings | Android TV settings and Wi-Fi |

Up/Down moves between rows. Left/Right moves between choices in a horizontal row. Focus alone changes neither the preview nor saved preferences in these appearance groups. Wallpaper has its own temporary photo preview, described below. OK applies the focused value. A checkmark identifies the applied value; the filled plate identifies remote focus. Applying the current value does not write again.

Material applies to a photographic Dock, or Glass focus on a photographic List. Inactive material choices remain visible with an explanation and are skipped during navigation. Their stored value is retained. Wallpaper and rotation are also inactive on flat backgrounds.

A font or photo change applies only after its resources are ready and storage succeeds. A load or storage failure keeps the previous appearance and checkmark, with a Try again action. Back cancels a pending change, leaves the group and keeps completed changes. Late load callbacks cannot apply a cancelled choice. There is no Save button. Returning to a group restores its last choice focus; returning to Settings restores its category focus. Rotation is nested within Background, and Back returns to its Rotation row.

The selected font applies to Home app names and the clock. Settings, All apps, the Home editor and status text retain Manrope. The preview shows the committed Home appearance and its clock continues to update.

## Apps

Any installed app can be added to Home. Launching uses the app's Android package name; missing, disabled or blocked apps produce a real error. Known streaming apps get their usual position in the defaults, but every app shows its own launcher icon cropped to a circle.

## All apps

The panel lists every app the TV can launch (leanback or launcher activities), alphabetically, except DroidFrameTV itself and disabled apps.

The five-column grid scrolls with remote focus. OK launches an app; its On Home badge shows membership. Up from the first row reaches Apps on Home, which opens the editor. A failure shows a retry and keeps saved Home choices. Browser previews report that app discovery needs the TV.

## Apps on Home

Open the editor from Settings or All apps. On Home shows the current order on the left. Not on Home shows Recently removed first, followed by other installed apps on the right. Home holds one or more apps, with no upper limit.

- Reorder: OK on an app name picks it up. Up/Down moves it. OK places it and saves the order. Back puts an unplaced app back without saving that move.
- Remove: Right from an app name reaches Remove from Home. OK saves the removal and moves focus to the same app in Recently removed. The app stays installed.
- Add: OK on an app in Not on Home adds it and saves. A recently removed app returns to its previous position within the editing session; another app is added at the end. Focus follows the app to its Remove from Home control, so another OK can reverse the addition.
- Undo reverses a completed addition, removal or reorder from the current editing session. Done or Back closes the editor and keeps completed changes. Undo history ends when the editor closes.

Removing the last Home app is prevented. A failed storage write keeps the committed choices and order, with a retry message. Saved native app IDs and names survive a restart or a failed catalogue refresh.

## Focus colours

Solid focus paints the selection as a plain colour in Home, All apps and the Apps on Home editor. Text turns white on dark colours and black on light ones. From wallpaper uses a vivid colour computed from the photo when the wallpaper set is generated (`avg` in the catalog), so it follows every wallpaper change at no runtime cost; its text colour comes from the picker. On the plain Black and White backgrounds there is no photo, so From wallpaper becomes the inverse of the background (a light highlight with dark text on Black, a dark one with light text on White).

## TV screens

Settings > TV settings opens Android's settings and Wi-Fi opens its network screen. Back on Home does nothing, since this app is the launcher. All calls have bounded response handling, and a failure leaves Home usable.

## Preferences and wallpaper

The launcher stores appearance, Home order, recently removed apps, the last launched Home app, wallpaper and rotation locally. List and Dock share these preferences. The existing `cleanframe.home.v1` key is retained, with a fallback read from `cleanframe.shore.v1`. Legacy List maps to Dark + List + Type; Glass Dock and Glass Grid map to Photo + Dock + Glass. App order, wallpaper, rotation and the last Home app are preserved.

The gallery lists the bundled wallpaper plus any local ones. Settings → Background → Wallpaper keeps the two-pane Settings frame. Up/Down browses a vertical thumbnail list without wrapping; the right-hand Home preview shows the candidate while the surrounding Settings backdrop stays on the applied photo. OK applies the focused photo and stays in Wallpaper. The tick marks the applied photo and preview status distinguishes unsaved browsing. Back restores the latest applied photo, cancels pending loading and returns to Background’s Wallpaper row. Photo and material assets change as one complete bundle; a failed load restores the applied preview and offers retry. Preview loading waits briefly for remote focus to settle. OK during loading queues application for that photo; another browse move or Back cancels it. Browsing never saves, and repeated OK on the applied photo does not write again.

Settings → Background → Rotation offers Fixed, Each time the TV wakes, Every 5 minutes, Every 15 minutes and Every hour. Each time the TV wakes (the default) changes the wallpaper the moment the TV is told to sleep, or the screensaver starts, so the frame the panel holds through the next wake is already the new photo. The launcher itself does not change it at start-up. Timed rotation counts only visible Photo Home time in either List or Dock. Panels, flat backgrounds and time spent in other apps pause the cycle. Changing the photo or rotation mode starts a new interval.

Runtime photos, materials and available fonts are local assets; they do not need a network download.



## Clock and rendering

Both layouts show the TV's local time in 12-hour format with lowercase am or pm, and no seconds. It updates at the minute boundary and on return to the launcher. No date or clock panel is shown.

Photographic materials and blurred panel backgrounds are generated before packaging and stay aligned with the full-screen image. Photo colour and contrast metadata are also prepared offline. Navigation does not sample image pixels, run an optics engine or apply live backdrop blur. Flat backgrounds use matching light or dark panel colours. Focus feedback uses transforms and opacity; reduced motion removes animated scaling and movement while retaining opacity feedback.
