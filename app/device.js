/* Android TV bridge (window.AndroidTV, see android/.../MainActivity.java). Browser preview has none. */
(function () {
  'use strict';
  var native = window.AndroidTV;
  function fail(done) {
    var detail = '';
    try { detail = native && native.getLastError() || ''; } catch (e) {}
    done({ message: 'The TV could not open this screen.', detail: detail || 'Try again, or press the remote’s Home button to return to CleanFrame.' });
  }
  function invoke(method, done, arg) {
    if (!native) { done({ message: 'Open CleanFrame on the TV to use this control.', detail: 'The web preview cannot control the TV.' }); return; }
    try { if (arg === undefined ? native[method]() : native[method](arg)) done(null); else fail(done); }
    catch (e) { fail(done); }
  }
  window.FrameDevice = {
    launchApp: function (id, done) { invoke('launchApp', done, id); },
    settings: function (done) { invoke('openSettings', done); },
    wifi: function (done) { invoke('openWifi', done); },
    home: function (done) { invoke('openStockHome', done); },
    art: function (done) { done({ message: 'Art Mode is built into Home on Android.' }); },
    apps: function (done) {
      if (!native) { done({ message: 'Open CleanFrame on the TV to use this control.', detail: 'The web preview cannot control the TV.' }); return; }
      try {
        var list = JSON.parse(native.getApps());
        done(null, list.filter(function (a) { return a && a.appId && a.name; }));
      } catch (e) { done({ message: 'Could not read installed apps.' }); }
    }
  };
}());
