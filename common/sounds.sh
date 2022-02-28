#!/system/bin/sh

ownload_size "$Audio_download" file_size

if [ -f "$Audio_location" ] && selector "Install Default Pixel Audio/Sounds ?" || selector "Download Default Pixel Audio/Sounds ? ($file_size)"; then
  [ -f "$Audio_location" ] && ui_print ' [+] Installing...' || ui_print ' [⭳] Downloading...'

  # Download
  [ -f "$Audio_location" ] || wget -O "$Audio_location" "$Audio_download"

  # Install
  tar -xf "$Audio_location" -C "$MODPATH"/system/product/media/
  rm "$Audio_location"

  # Done
  ui_print " [✓] Installed"
  ui_print ''
else
  ui_print " [-] Removing from module"
  ui_print ''
  rm -rf "$Audio_location"
fi
