#!/system/bin/sh

ui_print "[?+] Keeping *breaks* Unlimited GPhoto."
ui_print "[?-] Removing *removes* some new features."
if selector "Keep 2020 and later sysconfigs ?" null "Keep" "Remove"; then
  ui_print " [+] Keeping 2020 and later pixel experience xml"
  ui_print ''
else
  ui_print " [-] Removing sysconfigs from module and device"
  ui_print ''

  rm -rf "$MODPATH"/system/product/etc/sysconfig/pixel_experience_202*.xml
  rm -rf /system/product/etc/sysconfig/pixel_experience_202*.xml

  # Pixel Props
  ui_print "[?+] Installing Pixel Props might help getting Unlimited GPhoto at Original Quality."
  ui_print "[??] Google Dialer might be reporting false information about not being supported for your device."
  download_size "$PixelProps_download" file_size
  if [ -f "$PixelProps_location" ] && selector "Install Pixel Props (sailfish) " || selector "Download Pixel Props (sailfish) ? ($file_size)"; then
    [ -f "$PixelProps_location" ] && ui_print ' [+] Installing...' || ui_print ' [⭳] Downloading...'
    ui_print " [?] Make sure you have no other module that changes your system props."
    ui_print " [?>] https://t.me/PixelProps/105"

    # Download
    [ -f "$PixelProps_location" ] || wget -O "$PixelProps_location" "$PixelProps_download"

    # Install
    tar -xf "$PixelProps_location" -C "$MODPATH/"
    rm -rf "$PixelProps_location"

    # Done
    ui_print "[✓] Installed"
    ui_print ''
  else
    ui_print "[-] Removing from module"
    ui_print ''
    rm -rf "$PixelProps_location"
  fi
fi
