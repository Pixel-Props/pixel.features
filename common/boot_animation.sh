#!/system/bin/sh

download_size "$BootAnimation_download" file_size

if [ -f "$BootAnimation_location" ] &&
  selector "Install the Pixel Boot Animation ?" "$useRecommendedSettings" ||
  selector "Download the Pixel Boot Animation ? ($file_size)" "$useRecommendedSettings"; then
  [ -f "$BootAnimation_location" ] && ui_print ' [+] Installing...' || ui_print ' [⭳] Downloading...'

  # Download
  [ -f "$BootAnimation_location" ] || wget -O "$BootAnimation_location" "$BootAnimation_download"

  # Install
  tar -xf "$BootAnimation_location" -C "$MODPATH/system/product/media/"
  rm "$BootAnimation_location"

  # Black or White
  if selector "Animation Theme" null "Black/Monet" "White"; then
    ui_print " [+] Installing Black/Monet version..."

    # Install Monet
    mv "$MODPATH/system/product/media/bootanimation-monet.zip" "$MODPATH/system/product/media/bootanimation.zip"

    # Use Dark version if the system does not support monet bootanimation
    if ! has_command themed_bootanimation; then
      ui_print " [!] Monet Boot Animation is not supported by this device"
      ui_print " [!] Using Dark version instead"
      mv "$MODPATH"/system/product/media/bootanimation-dark.zip "$MODPATH"/system/product/media/bootanimation.zip
    fi

    # Done
    ui_print " [✓] Installed"
    ui_print ''
  else
    ui_print " [+] Installing White version..."
    rm -rf "$MODPATH"/system/product/media/bootanimation-*.zip

    # Done
    ui_print " [✓] Installed"
    ui_print ''
  fi
else
  ui_print " [-] Removing from module"
  ui_print ''
  rm -rf "$MODPATH"/system/product/media/bootanimation*.zip
fi
