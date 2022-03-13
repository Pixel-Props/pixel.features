#!/system/bin/sh

if selector "Enable Pixel GBoard Features ?" "$useRecommendedSettings" "Enable" "Disable"; then
  ui_print ' [+] Flags kept...'
  ui_print ''
else
  ui_print " [~] Flags removed from module..."
  ui_print ''
  rm -rf "$MODPATH"/device_prefs/*/gboard.ini
fi
