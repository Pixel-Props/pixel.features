# Run Addons
if [ "$(ls -A $MODPATH/common/addon/*/install.sh 2>/dev/null)" ]; then
  ui_print "- Running Addons"
  for i in $MODPATH/common/addon/*/install.sh; do
    # ui_print "  Running $(echo $i | sed -r "s|$MODPATH/common/addon/(.*)/install.sh|\1|")"
    . $i
  done
fi

# Set file/download location
set_location BootAnimation '/system/product/media/bootanimation.tar.gz'
set_location AmbiantDisplay '/system/product/etc/ambient.tar.gz'
set_location MusicDetector '/system/product/etc/firmware.tar.gz'
set_location NgaResources '/system/product/app/NgaResources.tar.gz'
set_location PixelWallpapers2021 '/system/product/app/PixelWallpapers2021.tar.gz'
set_location Audio '/system/product/media/audio.tar.gz'
set_location Fonts '/system/product/fonts.tar.gz'

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
  if selector "Animation Theme" "Black" "White"; then
    ui_print "[+] Installing [Black] Pixel Boot Animation"
    ui_print ''
    rm -rf "$MODPATH/system/product/media/bootanimation.zip"
    mv "$MODPATH/system/product/media/bootanimation-dark.zip" "$MODPATH/system/product/media/bootanimation.zip"
  else
    ui_print "[+] Installing [White] Pixel Boot Animation"
    ui_print ''
    rm -rf "$MODPATH/system/product/media/bootanimation-dark.zip"
  fi
else
  ui_print "[-] Removing Pixel Boot Animation"
  ui_print ''
  rm -rf $MODPATH/system/product/media/bootanimation*.zip
fi

# Ambiant Display
download_size "$AmbiantDisplay_download" file_size
if [ -f "$AmbiantDisplay_location" ] && selector 'Do you want to install the Pixel Ambiant Display ?' || selector "Do you want to download the Pixel Ambiant Display ? ($file_size)"; then
  ui_print ' After installation please get the app "Pixel Ambient Services" from the Play Store'
  ui_print ' > "https://play.google.com/store/apps/details?id=com.google.intelligence.sense"'
  [ -f "$AmbiantDisplay_location" ] && ui_print ' Installing...' || ui_print ' Downloading...'
  ui_print ''

  # Download file
  [ -f "$AmbiantDisplay_location" ] || wget -O "$AmbiantDisplay_location" "$AmbiantDisplay_download"

  # Extract archive
  tar -xf "$AmbiantDisplay_location" -C "$MODPATH/system/product/etc/"

  # Remove archive
  rm "$AmbiantDisplay_location"
else
  ui_print "[-] Removing Pixel Ambiant Display"
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
  ui_print "[-] Removing Pixel Adaptive Audio Firmware"
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
  ui_print "[-] Removing NgaResources"
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
  ui_print "[-] Removing PixelWallpapers2021"
  ui_print ''
  rm -rf "$MODPATH/system/product/app/PixelWallpapers2021"
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
  ui_print "[-] Removing Default Pixel Audio/Sounds"
  ui_print ''
  rm -rf "$MODPATH/system/product/media/audio.tar.gz"
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
  ui_print "[-] Removing Default Pixel Fonts"
  ui_print ''
  rm -rf "$MODPATH/system/product/fonts.tar.gz"
fi

# Unlimited GPhoto
ui_print "[?+] Keeping 2020 and later pixel experience xml *breaks* Unlimited GPhoto."
ui_print "[?-] Removing 2020 and later pixel experience xml *removes* some new features."
if selector "Do you want to keep 2020 and later XML's ?" "Keep" "Remove"; then
  ui_print "[+] Keeping 2020 and later pixel experience xml"
  ui_print ''
else
  ui_print "[-] Removing 2020 and later pixel experience xml"
  ui_print ''
  rm -rf $MODPATH/system/product/etc/sysconfig/pixel_experience_202*.xml
  rm -rf /system/product/etc/sysconfig/pixel_experience_202*.xml
fi
