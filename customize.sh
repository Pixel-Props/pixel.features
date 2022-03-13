#!/system/bin/sh

# Running installer
[ -f "$MODPATH/common/install.sh" ] && . "$MODPATH"/common/install.sh

# Cleanup common install files
[ -d "$MODPATH/common" ] && rm -rf "$MODPATH"/common/*.sh

# Fixing permission
chmod 0644 "$MODPATH/system/product/app/*/*.apk"

# Remove comments from files and place them, add blank line to end if not already present
for file in $(find "$MODPATH" -type f -name "*.sh" -o -name "*.prop" -o -name "*.rule"); do
  [ -f "$file" ] && {
    sed -i -e "/^[[:blank:]]*#/d" -e "/^ *$/d" "$file"
    [ "$(tail -1 "$file")" ] && echo "" >>"$file"
  }
done

# Delete empty directory
find "$MODPATH" -empty -type d -delete

# Cleaning up
[ -e /data/system/package_cache ] && rm -rf /data/system/package_cache/*

# Finish
ui_print "- By Tesla, Telegram: @T3SL4"
ui_print "  https://t.me/PixelProps"
ui_print "  https://github.com/Pixel-Props"
