# Run Addons
if [ "$(ls -A $MODPATH/common/addon/*/install.sh 2>/dev/null)" ]; then
  ui_print "- Running Addons"
  for i in $MODPATH/common/addon/*/install.sh; do
    # ui_print "  Running $(echo $i | sed -r "s|$MODPATH/common/addon/(.*)/install.sh|\1|")"
    . $i
  done
fi

# Download url
local BootAnimation_download='https://github.com/Pixel-Props/pixel.features/raw/main/system/product/media/bootanimation.tar.gz'
local NgaResources_download='https://github.com/Pixel-Props/pixel.features/raw/main/system/product/app/NgaResources.tar.gz'
local PixelWallpapers2021_download='https://github.com/Pixel-Props/pixel.features/raw/main/system/product/app/PixelWallpapers2021.tar.gz'

# Local files
local BootAnimation_location="$MODPATH/system/product/media/bootanimation.tar.gz"
local NgaResources_location="$MODPATH/system/product/app/NgaResources.tar.gz"
local PixelWallpapers2021_location="$MODPATH/system/product/app/PixelWallpapers2021.tar.gz"

# Boot Animation
download_size "$BootAnimation_download" file_size
if [ -f "$BootAnimation_location" ] && selector 'Do you want to install the Pixel Boot Animation ?' || selector "Do you want to download the Pixel Boot Animation ? ($file_size)"; then
  [ -f "$BootAnimation_location" ] && ui_print ' Installing...' || ui_print ' Downloading...'
  ui_print ''

  # Download file
  [ -f "$BootAnimation_location" ] || wget -O "$BootAnimation_location" "$BootAnimation_download"

  # Extract archive
  tar -xf "$BootAnimation_location"

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
  rm -rf "$MODPATH/system/product/media/bootanimation*.zip"
fi

# NgaResources
download_size "$NgaResources_download" file_size
if [ -f "$NgaResources_location" ] && selector 'Do you want to install NgaResources ? (Next Generation Assistant)' || selector "Do you want to download NgaResources ? ($file_size) (Next Generation Assistant)"; then
  [ -f "$NgaResources_location" ] && ui_print ' Installing...' || ui_print ' Downloading...'
  ui_print ''

  # Download file
  [ -f "$NgaResources_location" ] || wget -O "$NgaResources_location" "$NgaResources_download"

  # Extract archive
  tar -xf "$NgaResources_location"

  # Remove archive
  rm "$NgaResources_location"
else
  ui_print "[-] Removing NgaResources"
  ui_print ''
  rm -rf "$MODPATH/system/product/app/NgaResources*"
fi

# PixelWallpapers2021
download_size "$PixelWallpapers2021_download" file_size
if [ -f "$PixelWallpapers2021_location" ] && selector 'Do you want to install PixelWallpapers2021 ?' || selector "Do you want to download PixelWallpapers2021 ? ($file_size)"; then
  [ -f "$PixelWallpapers2021_location" ] && ui_print ' Installing...' || ui_print ' Downloading...'
  ui_print ''

  # Download file
  [ -f "$PixelWallpapers2021_location" ] || wget -O "$PixelWallpapers2021_location" "$PixelWallpapers2021_download"

  # Extract archive
  tar -xf "$PixelWallpapers2021_location"

  # Remove archive
  rm "$PixelWallpapers2021_location"
else
  ui_print "[-] Removing PixelWallpapers2021"
  ui_print ''
  rm -rf "$MODPATH/system/product/app/PixelWallpapers2021"
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
  rm -rf "$MODPATH/system/product/etc/sysconfig/pixel_experience_202*.xml"
  rm -rf "/system/product/etc/sysconfig/pixel_experience_202*.xml"
fi
