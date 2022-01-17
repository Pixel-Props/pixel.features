# Running installer
[ -f "$MODPATH/common/install.sh" ] && . $MODPATH/common/install.sh

# Cleanup
[ -d "$MODPATH/common" ] && rm -rf $MODPATH/common

# Fixing permission
chmod 0644 $MODPATH/system/product/app/*/*.apk

# Remove comments from files and place them, add blank line to end if not already present
for i in $(find $MODPATH -type f -name "*.sh" -o -name "*.prop" -o -name "*.rule"); do
  [ -f $i ] && { sed -i -e "/^#/d" -e "/^ *$/d" $i; [ "$(tail -1 $i)" ] && echo "" >> $i; } || continue
done

# Finish
ui_print "- By Tesla, Telegram: @T3SL4"
ui_print "  https://t.me/PixelProps"
ui_print "  https://github.com/Pixel-Props"
