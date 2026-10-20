#!/bin/sh
# Free memory on the TV and make DroidFrameTV the only home screen.
#
#   scripts/tv-setup.sh <tv-ip> status     show what is enabled / which home handlers exist
#   scripts/tv-setup.sh <tv-ip> apply      disable the stock launcher + optional bloat, make CleanFrame the default home
#   scripts/tv-setup.sh <tv-ip> restore    undo everything this script did (re-enables every package below)
#
# Everything uses `pm disable-user --user 0`: nothing is uninstalled, and `restore` brings it all back.
# After a TV software update, just run `apply` again (it is safe to repeat): updates normally keep these
# settings, but Sony can re-enable packages and reset the default home.
#
# Deliberately NOT touched (needed by the apps/features in use): Google Play services and Play Store, Gboard,
# the voice assistant (katniss), Chromecast (mediashell), AirPlay, HomeKit, Sony system/tuner/TV input services,
# Settings (com.android.tv.settings, also the fallback home), SystemUI (the Inputs picker the Source entry opens).

set -eu
ADB="${ADB:-adb}"
TV="${1:?usage: tv-setup.sh <tv-ip> status|apply|restore}"
CMD="${2:?usage: tv-setup.sh <tv-ip> status|apply|restore}"
ME=app.cleanframe.tv

# Replaced by CleanFrame (the stock launcher and its recommendation rows).
LAUNCHER="com.google.android.tvlauncher com.google.android.tvrecommendations"
# Optional bloat: promos, store fronts, setup/hotel/serial-port helpers, help, Living Decor, smart speaker setup.
BLOAT="com.sony.dtv.sonyselect com.sony.dtv.promos com.sony.dtv.livingfit com.sony.dtv.seeds.iot
com.sony.dtv.b2b.hotelmode com.sony.dtv.b2b.rs232csupport com.sony.dtv.broadcastservicesetup
com.sony.dtv.smarthelp com.sony.dtv.helpguidecontents com.sony.dtv.sonybugreportsys"

a() { "$ADB" -s "$TV:5555" "$@"; }
installed() { a shell pm list packages "$1" | grep -qx "package:$1"; }

"$ADB" connect "$TV:5555" >/dev/null

case "$CMD" in
status)
  a shell cmd package query-activities --brief -a android.intent.action.MAIN -c android.intent.category.HOME
  for p in $LAUNCHER $BLOAT; do
    installed "$p" && printf '%-48s %s\n' "$p" "$(a shell pm list packages -d "$p" | grep -qx "package:$p" && echo disabled || echo enabled)"
  done ;;
apply)
  installed "$ME" || { echo "DroidFrameTV ($ME) is not installed on the TV. Install it first."; exit 1; }
  a shell cmd package query-activities --brief -a android.intent.action.MAIN -c android.intent.category.HOME | grep -q "$ME" \
    || { echo "DroidFrameTV is not registered as a home screen. Aborting before touching anything."; exit 1; }
  a shell cmd package set-home-activity "$ME/.MainActivity"
  for p in $LAUNCHER $BLOAT; do
    if installed "$p"; then a shell pm disable-user --user 0 "$p" >/dev/null && echo "disabled $p"; fi
  done
  a shell input keyevent KEYCODE_HOME
  echo "Done. Press Home on the remote: it should open DroidFrameTV." ;;
restore)
  for p in $LAUNCHER $BLOAT; do
    if installed "$p"; then a shell pm enable "$p" >/dev/null && echo "enabled $p"; fi
  done
  echo "Restored. If Home still opens CleanFrame, choose a different default in Settings > Apps > Default apps (or reinstall)." ;;
*) echo "unknown command: $CMD"; exit 1 ;;
esac
