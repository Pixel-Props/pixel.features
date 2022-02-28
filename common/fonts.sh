#!/system/bin/sh

download_size "$Fonts_download" file_size

if [ -f "$Fonts_location" ] && selector "Install Default Pixel Fonts ?" || selector "Download Default Pixel Fonts ? ($file_size)"; then
  [ -f "$Fonts_location" ] && ui_print ' [+] Installing...' || ui_print ' [⭳] Downloading...'

  # Download
  [ -f "$Fonts_location" ] || wget -O "$Fonts_location" "$Fonts_download"

  # Install
  tar -xf "$Fonts_location" -C "$MODPATH"/system/product/
  rm "$Fonts_location"

  # Done
  ui_print " [✓] Installed"
  ui_print ''
else
  ui_print " [-] Removing from module"
  ui_print ''
  rm -rf "$Fonts_location"
fi
