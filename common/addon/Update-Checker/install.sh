#!/system/bin/sh

ui_print "- Checking for script updates"

# Compare module.prop to online version
if [ -f "$MODPATH/module.prop" ]; then
  local_version=$(grep_prop versionCode "$MODPATH/module.prop")
  online_version=$(wget -qO- https://raw.githubusercontent.com/Pixel-Props/pixel.features/main/module.prop | grep versionCode | cut -d= -f2)

  if [ "$local_version" -lt "$online_version" ]; then
    ui_print "[!] This module version is outdated"
    ui_print "[!] Download the newest release at https://github.com/Pixel-Props/pixel.features/releases"
    ui_print ''
  fi
fi
