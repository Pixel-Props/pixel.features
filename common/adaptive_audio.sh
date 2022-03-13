#!/system/bin/sh

download_size "$MusicDetector_download" file_size

if [ -f "$MusicDetector_location" ] &&
  selector "Install the Pixel Adaptive Audio Firmware ?" "$useRecommendedSettings" ||
  selector "Download the Pixel Adaptive Audio Firmware ? ($file_size)" "$useRecommendedSettings"; then
  [ -f "$MusicDetector_location" ] && ui_print ' [+] Installing...' || ui_print ' [⭳] Downloading...'

  # Download
  [ -f "$MusicDetector_location" ] || wget -O "$MusicDetector_location" "$MusicDetector_download"

  # Install
  tar -xf "$MusicDetector_location" -C "$MODPATH/system/product/etc/"
  rm "$MusicDetector_location"

  # Done
  ui_print " [✓] Installed"
  ui_print ''
else
  ui_print " [-] Removing from module"
  ui_print ''
  rm -rf "$MODPATH"/system/product/etc/firmware*
fi
