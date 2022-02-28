#!/system/bin/sh

if [ "$API" -ge 31 ]; then
  download_size "$NgaResources_download" file_size
  packageName="com.google.android.googlequicksearchbox.nga_resources"

  if has_package "com.google.android.as"; then
    ui_print " [?] NgaResources is already installed on this device."
    ui_print ''
  else
    ui_print " [?] NgaResources is not installed on this device."
  fi

  if ! has_package "com.google.android.as"; then
    if [ -f "$Audio_location" ] && selector "Install NgaResources ? (Next Generation Assistant)" "$useRecommendedSettings" || selector "Download NgaResources ? ($file_size) (Next Generation Assistant)" "$useRecommendedSettings"; then
      [ -f "$NgaResources_location" ] && ui_print ' [+] Installing...' || ui_print ' [⭳] Downloading...'

      # Download
      [ -f "$NgaResources_location" ] || wget -O "$NgaResources_location" "$NgaResources_download"

      # Install
      tar -xf "$NgaResources_location" -C "$MODPATH"/system/product/app/
      install_package "$packageName" "$NgaResources_location"
      rm "$NgaResources_location"

      # Done
      ui_print " [✓] Installed"
      ui_print ''
    else
      ui_print " [-] Removing from module"
      ui_print ''
      rm -rf "$MODPATH"/system/product/app/NgaResources*
    fi
  fi
fi
