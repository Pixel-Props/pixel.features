# Running installer
[ -f "$MODPATH/common/install.sh" ] && . $MODPATH/common/install.sh

# Cleanup
[ -d "$MODPATH/common" ] && rm -rf $MODPATH/common

# Finish
ui_print "- By Tesla, Telegram: @T3SL4"
ui_print "  https://t.me/PixelProps"
ui_print "  https://github.com/Pixel-Props"
