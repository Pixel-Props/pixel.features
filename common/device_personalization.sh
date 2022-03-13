#!/system/bin/sh

if [ "$API" -ge 31 ]; then
  download_size "$DevicePersonalization_download" file_size
  packageName="com.google.android.as"

  if has_package "$packageName"; then
    ui_print " [?] Android System Intelligence is already installed on this device."
    ui_print ''
    rm -rf "$MODPATH"/system/product/priv-app/DevicePersonalization*
  else
    ui_print " [?] Android System Intelligence is not installed on this device."
  fi

  if ! has_package "$packageName"; then
    if [ -f "$DevicePersonalization_location" ] &&
      selector "Install Android System Intelligence ?" "$useRecommendedSettings" ||
      selector "Download Android System Intelligence ? ($file_size)" "$useRecommendedSettings"; then
      [ -f "$DevicePersonalization_location" ] && ui_print ' [+] Installing...' || ui_print ' [⭳] Downloading...'

      # Download
      [ -f "$DevicePersonalization_location" ] || wget -O "$DevicePersonalization_location" "$DevicePersonalization_download"

      # Install
      tar -xf "$DevicePersonalization_location" -C "$MODPATH"/system/product/priv-app/
      install_package "$packageName" "$DevicePersonalization_location"
      rm "$DevicePersonalization_location"

      # Done
      ui_print " [✓] Installed"
      ui_print ''
    else
      ui_print " [-] Removing from module"
      ui_print ''
      rm -rf "$MODPATH"/system/product/priv-app/DevicePersonalization*
    fi
  fi
fi
