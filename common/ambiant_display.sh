#!/system/bin/sh

download_size "$AmbientDisplay_download" file_size

if [ -f "$AmbientDisplay_location" ] &&
  selector "Install the Pixel Ambient Display ?" "$useRecommendedSettings" ||
  selector "Download the Pixel Ambient Display ? ($file_size)" "$useRecommendedSettings"; then
  [ -f "$AmbientDisplay_location" ] && ui_print ' [+] Installing...' || ui_print ' [⭳] Downloading...'

  # Warn the user if the device has not installed Android System Intelligence
  if ! has_package "com.google.intelligence.sense"; then
    ui_print " [!] Pixel Ambient Services is not installed"
    ui_print ' [?] After installation please get the app "Pixel Ambient Services" from the Play Store'
    ui_print ' [?>] "https://play.google.com/store/apps/details?id=com.google.intelligence.sense"'
  fi

  # Download
  [ -f "$AmbientDisplay_location" ] || wget -O "$AmbientDisplay_location" "$AmbientDisplay_download"

  # Install
  tar -xf "$AmbientDisplay_location" -C "$MODPATH"/system/product/etc/
  rm "$AmbientDisplay_location"

  # Done
  ui_print " [✓] Installed"
  ui_print ''
else
  ui_print " [-] Removing from module"
  ui_print ''
  rm -rf "$MODPATH"/system/product/etc/ambient*
fi
