#!/system/bin/sh

# Running addons
if [ "$(ls -A "$MODPATH"/common/addon/*/install.sh 2>/dev/null)" ]; then
  ui_print "- Running Addons"
  for addon in "$MODPATH"/common/addon/*/install.sh; do
    # ui_print "- Running addon: $(echo $i | cut -d/ -f4)"
    . "$addon"
  done
fi

# Export file/download location
export_location BootAnimation '/system/product/media/bootanimation.tar.gz'
export_location AmbientDisplay '/system/product/etc/ambient.tar.gz'
export_location MusicDetector '/system/product/etc/firmware.tar.gz'
export_location NgaResources '/system/product/app/NgaResources.tar.gz'
export_location DevicePersonalization '/system/product/priv-app/DevicePersonalizationPrebuiltPixel2021.tar.gz'
export_location PixelWallpapers2021 '/system/product/app/PixelWallpapers2021.tar.gz'
export_location Audio '/system/product/media/audio.tar.gz'
export_location Fonts '/system/product/fonts.tar.gz'
export_location PixelProps '/system/system.prop.tar.gz'

# Should we skip all and use default settings?
export useRecommendedSettings=null
if selector "Automatically install recommended settings ?"; then
  useRecommendedSettings=1
fi

# Make sure has enough memory for the following
if [ "$(grep MemTotal /proc/meminfo | tr -dc '0-9')" -le "6000000" ]; then
  ui_print ''
  ui_print "[!] Not enough memory (6GB)"
  ui_print "[!] Removing GoogleCamera_6gb_or_more_ram.xml"
  ui_print ''
  rm -rf "$MODPATH/system/product/etc/sysconfig/*6gb*.xml"
fi

# Crashing on boot
if [ "$API" -lt 31 ]; then
  ui_print " [!] (SDK) Safely removing privapp permissions xml..."
  ui_print ''
  rm -rf "$MODPATH"/system/product/etc/permissions/privapp-permissions-google-p.xml
fi

# Running installer addins
for addin in "$MODPATH"/common/*.sh; do
  if [ "$addin" != "$MODPATH"/common/install.sh ]; then
    # ui_print "- Running addin: $(echo $i | cut -d/ -f4 | cut -d. -f1)"
    . "$addin"
  fi
done
