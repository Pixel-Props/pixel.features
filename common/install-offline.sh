# Run Addons
if [ "$(ls -A $MODPATH/common/addon/*/install.sh 2>/dev/null)" ]; then
  ui_print "- Running Addons"
  for i in $MODPATH/common/addon/*/install.sh; do
    # ui_print "  Running $(echo $i | sed -r "s|$MODPATH/common/addon/(.*)/install.sh|\1|")"
    . $i
  done
fi

# Boot Animation
if selector "Do you want to install Pixel Boot Animation ?"; then
  ui_print ""
  # Black or White
  if selector "Animation Theme" "Black" "White"; then
    ui_print "[+] Installing [Black] Pixel Boot Animation"
    ui_print ""
    rm -rf $MODPATH/system/product/media/bootanimation.zip
    mv $MODPATH/system/product/media/bootanimation-dark.zip $MODPATH/system/product/media/bootanimation.zip
  else
    ui_print "[+] Installing [White] Pixel Boot Animation"
    ui_print ""
    rm -rf $MODPATH/system/product/media/bootanimation-dark.zip
  fi
else
  ui_print "[-] Removing Pixel Boot Animation"
  ui_print ""
  rm -rf $MODPATH/system/product/media/bootanimation*.zip
fi

# Unlimited GPhoto
ui_print "[?+] Keeping 2020 and later pixel experience xml *breaks* Unlimited GPhoto."
ui_print "[?-] Removing 2020 and later pixel experience xml *removes* some new features."
if selector "Do you want to keep 2020 and later XML's ?" "Keep" "Remove"; then
  ui_print "[+] Keeping 2020 and later pixel experience xml"
  ui_print ""
else
  ui_print "[-] Removing 2020 and later pixel experience xml"
  ui_print ""
  rm -rf $MODPATH/system/product/etc/sysconfig/pixel_experience_202*.xml
  rm -rf /system/product/etc/sysconfig/pixel_experience_202*.xml
fi

# NgaResources
if selector "Do you want to install NgaResources ? (Next Generation Assistant)"; then
    ui_print "[+] Keeping NgaResources"
    ui_print ""
else
	ui_print "[-] Removing NgaResources"
  ui_print ""
	rm -rf $MODPATH/system/product/app/NgaResources
fi

# PixelWallpapers2021
if selector "Do you want to install PixelWallpapers2021 ?"; then
    ui_print "[+] Keeping PixelWallpapers2021"
    ui_print ""
else
	ui_print "[-] Removing PixelWallpapers2021"
  ui_print ""
	rm -rf $MODPATH/system/product/app/PixelWallpapers2021
fi