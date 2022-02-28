#!/system/bin/sh

if [ "$API" -ge 31 ]; then
  download_size "$PixelWallpapers2021_download" file_size
  packageName="com.google.android.apps.wallpaper.pixel"

  if has_package "com.google.android.as"; then
    ui_print " [?] PixelWallpapers2021 is already installed on this device."
    ui_print ''
  else
    ui_print " [?] PixelWallpapers2021 is not installed on this device."
  fi

  if [ -f "$PixelWallpapers2021_location" ] && selector "Install PixelWallpapers2021 ?" || selector "Download PixelWallpapers2021 ? ($file_size)"; then
    [ -f "$PixelWallpapers2021_location" ] && ui_print ' [+] Installing...' || ui_print ' [⭳] Downloading...'

    # Download
    [ -f "$PixelWallpapers2021_location" ] || wget -O "$PixelWallpapers2021_location" "$PixelWallpapers2021_download"

    # Install
    tar -xf "$PixelWallpapers2021_location" -C "$MODPATH/system/product/app/"
    install_package "$packageName" "$NgaResources_location"
    rm "$PixelWallpapers2021_location"

    # Done
    ui_print " [✓] Installed"
    ui_print ''
  else
    ui_print " [-] Removing from module"
    ui_print ''
    rm -rf "$MODPATH"/system/product/app/PixelWallpapers2021*
  fi
fi
