# Run Addons
if [ "$(ls -A $MODPATH/common/addon/*/install.sh 2>/dev/null)" ]; then
  ui_print "- Running Addons"
  for i in $MODPATH/common/addon/*/install.sh; do
    # ui_print "  Running $(echo $i | sed -r "s|$MODPATH/common/addon/(.*)/install.sh|\1|")"
    . $i
  done
fi

# Export file/download location
export_location BootAnimation '/system/product/media/bootanimation.tar.gz'
export_location AmbientDisplay '/system/product/etc/ambient.tar.gz'
export_location MusicDetector '/system/product/etc/firmware.tar.gz'
export_location NgaResources '/system/product/app/NgaResources.tar.gz'
export_location PixelWallpapers2021 '/system/product/app/PixelWallpapers2021.tar.gz'
export_location Audio '/system/product/media/audio.tar.gz'
export_location Fonts '/system/product/fonts.tar.gz'
export_location PixelProps '/system/system.prop.tar.gz'

# Boot Animation
download_size "$BootAnimation_download" file_size
if [ -f "$BootAnimation_location" ] && selector 'Do you want to install the Pixel Boot Animation ?' || selector "Do you want to download the Pixel Boot Animation ? ($file_size)"; then
  [ -f "$BootAnimation_location" ] && ui_print ' Installing...' || ui_print ' Downloading...'
  ui_print ''

  # Download file
  [ -f "$BootAnimation_location" ] || wget -O "$BootAnimation_location" "$BootAnimation_download"

  # Extract archive
  tar -xf "$BootAnimation_location" -C "$MODPATH/system/product/media/"

  # Remove archive
  rm "$BootAnimation_location"

  # Black or White
  if selector "Animation Theme" "Black/Monet" "White"; then
    ui_print " [+] Installing [Black/Monet] Pixel Boot Animation"
    ui_print ''

    rm -rf "$MODPATH/system/product/media/bootanimation.zip"
    mv "$MODPATH/system/product/media/bootanimation-dark.zip" "$MODPATH/system/product/media/bootanimation.zip"
  else
    ui_print " [+] Installing [White] Pixel Boot Animation"
    ui_print ''
    rm -rf "$MODPATH/system/product/media/bootanimation-dark.zip"
  fi
else
  ui_print " [-] Removing Pixel Boot Animation"
  ui_print ''
  rm -rf $MODPATH/system/product/media/bootanimation*.zip
fi

# Ambient Display
download_size "$AmbientDisplay_download" file_size
if [ -f "$AmbientDisplay_location" ] && selector 'Do you want to install the Pixel Ambient Display ?' || selector "Do you want to download the Pixel Ambient Display ? ($file_size)"; then
  ui_print ' [?] After installation please get the app "Pixel Ambient Services" from the Play Store'
  ui_print ' [?>] "https://play.google.com/store/apps/details?id=com.google.intelligence.sense"'

  [ -f "$AmbientDisplay_location" ] && ui_print ' Installing...' || ui_print ' Downloading...'
  ui_print ''

  # Download file
  [ -f "$AmbientDisplay_location" ] || wget -O "$AmbientDisplay_location" "$AmbientDisplay_download"

  # Extract archive
  tar -xf "$AmbientDisplay_location" -C "$MODPATH/system/product/etc/"

  # Remove archive
  rm "$AmbientDisplay_location"
else
  ui_print " [-] Removing Pixel Ambient Display"
  ui_print ''
  rm -rf $MODPATH/system/product/etc/ambient*
fi

# Adaptive Audio Firmware
download_size "$MusicDetector_download" file_size
if [ -f "$MusicDetector_location" ] && selector 'Do you want to install the Pixel Adaptive Audio Firmware ?' || selector "Do you want to download the Pixel Adaptive Audio Firmware ? ($file_size)"; then
  [ -f "$MusicDetector_location" ] && ui_print ' Installing...' || ui_print ' Downloading...'
  ui_print ''

  # Download file
  [ -f "$MusicDetector_location" ] || wget -O "$MusicDetector_location" "$MusicDetector_download"

  # Extract archive
  tar -xf "$MusicDetector_location" -C "$MODPATH/system/product/etc/"

  # Remove archive
  rm "$MusicDetector_location"
else
  ui_print " [-] Removing Pixel Adaptive Audio Firmware"
  ui_print ''
  rm -rf $MODPATH/system/product/etc/firmware*
  rm -rf $MODPATH/service.sh
fi

# NgaResources
download_size "$NgaResources_download" file_size
if [ -f "$NgaResources_location" ] && selector 'Do you want to install NgaResources ? (Next Generation Assistant)' || selector "Do you want to download NgaResources ? ($file_size) (Next Generation Assistant)"; then
  [ -f "$NgaResources_location" ] && ui_print ' Installing...' || ui_print ' Downloading...'
  ui_print ''

  # Download file
  [ -f "$NgaResources_location" ] || wget -O "$NgaResources_location" "$NgaResources_download"

  # Extract archive
  tar -xf "$NgaResources_location" -C "$MODPATH/system/product/app/"

  # Remove archive
  rm "$NgaResources_location"
else
  ui_print " [-] Removing NgaResources"
  ui_print ''
  rm -rf $MODPATH/system/product/app/NgaResources*
fi

# PixelWallpapers2021
download_size "$PixelWallpapers2021_download" file_size
if [ -f "$PixelWallpapers2021_location" ] && selector 'Do you want to install PixelWallpapers2021 ?' || selector "Do you want to download PixelWallpapers2021 ? ($file_size)"; then
  [ -f "$PixelWallpapers2021_location" ] && ui_print ' Installing...' || ui_print ' Downloading...'
  ui_print ''

  # Download file
  [ -f "$PixelWallpapers2021_location" ] || wget -O "$PixelWallpapers2021_location" "$PixelWallpapers2021_download"

  # Extract archive
  tar -xf "$PixelWallpapers2021_location" -C "$MODPATH/system/product/app/"

  # Remove archive
  rm "$PixelWallpapers2021_location"
else
  ui_print " [-] Removing PixelWallpapers2021"
  ui_print ''
  rm -rf $MODPATH/system/product/app/PixelWallpapers2021*
fi

# Audio/Sounds
download_size "$Audio_download" file_size
if [ -f "$Audio_location" ] && selector 'Do you want to install Default Pixel Audio/Sounds ?' || selector "Do you want to download Default Pixel Audio/Sounds ? ($file_size)"; then
  [ -f "$Audio_location" ] && ui_print ' Installing...' || ui_print ' Downloading...'
  ui_print ''

  # Download file
  [ -f "$Audio_location" ] || wget -O "$Audio_location" "$Audio_download"

  # Extract archive
  tar -xf "$Audio_location" -C "$MODPATH/system/product/media/"

  # Remove archive
  rm "$Audio_location"
else
  ui_print " [-] Removing Default Pixel Audio/Sounds"
  ui_print ''
  rm -rf "$Audio_location"
fi

# Fonts
download_size "$Fonts_download" file_size
if [ -f "$Fonts_location" ] && selector 'Do you want to install Default Pixel Fonts ?' || selector "Do you want to download Default Pixel Fonts ? ($file_size)"; then
  [ -f "$Fonts_location" ] && ui_print ' Installing...' || ui_print ' Downloading...'
  ui_print ''

  # Download file
  [ -f "$Fonts_location" ] || wget -O "$Fonts_location" "$Fonts_download"

  # Extract archive
  tar -xf "$Fonts_location" -C "$MODPATH/system/product/"

  # Remove archive
  rm "$Fonts_location"
else
  ui_print " [-] Removing Default Pixel Fonts"
  ui_print ''
  rm -rf "$Fonts_location"
fi

# Unlimited GPhoto
ui_print "[?+] Keeping 2020 and later pixel experience xml *breaks* Unlimited GPhoto."
ui_print "[?-] Removing 2020 and later pixel experience xml *removes* some new features."
if selector "Do you want to keep 2020 and later XML's ?" "Keep" "Remove"; then
  ui_print " [+] Keeping 2020 and later pixel experience xml"
  ui_print ''
else
  ui_print " [-] Removing 2020 and later pixel experience xml"
  ui_print ''

  rm -rf $MODPATH/system/product/etc/sysconfig/pixel_experience_202*.xml
  rm -rf /system/product/etc/sysconfig/pixel_experience_202*.xml

  # Pixel Props
  ui_print "[?+] Installing Pixel Props might help getting Unlimited GPhoto at Original Quality."
  download_size "$PixelProps_download" file_size
  if [ -f "$PixelProps_location" ] && selector 'Do you want to install Pixel Props (sailfish) as well?' || selector "Do you want to download Pixel Props (sailfish) as well? ($file_size)"; then
    [ -f "$PixelProps_location" ] && ui_print ' Installing...' || ui_print ' Downloading...'
    ui_print " [?] Make sure you have no other module that changes your system props."
    ui_print " [?>] https://t.me/PixelProps/105"
    ui_print ''

    # Download file
    [ -f "$PixelProps_location" ] || wget -O "$PixelProps_location" "$PixelProps_download"

    # Extract archive
    tar -xf "$PixelProps_location" -C "$MODPATH/"

    # Remove archive
    rm "$PixelProps_location"
  else
    ui_print " [-] Removing Pixel Props"
    ui_print ''
    rm -rf "$PixelProps_location"
  fi
fi
