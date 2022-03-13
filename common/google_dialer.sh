#!/system/bin/sh

if selector "Enable Pixel Google Dialer Features ?" "$useRecommendedSettings" "Enable" "Disable"; then
  ui_print ' [+] Flags kept...'
  ui_print ''
else
  ui_print " [~] Flags removed from module..."
  ui_print ''
  rm -rf "$MODPATH"/device_prefs/*/google_dialer.ini
fi
