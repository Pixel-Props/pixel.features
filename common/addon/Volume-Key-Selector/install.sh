# External Tools
chmod -R 0755 $MODPATH/common/addon/Volume-Key-Selector/tools
export PATH=$MODPATH/common/addon/Volume-Key-Selector/tools/$ARCH32:$PATH

selector() {
  [ "$1" ] && local inselector_message=$1 || local inselector_message="Hello World"
  [ "$2" ] && local vol_up=$2 || local vol_up="Yes"
  [ "$3" ] && local vol_down=$3 || local vol_down="No"
  [ "$4" ] && local delay=$4 || local delay=5
  [ "$5" ] && local max_retry_count=$5 || local max_retry_count=3

  ui_print "- $inselector_message"
  ui_print "   Vol Up += $vol_up"
  ui_print "   Vol Down += $vol_down"

  retry_count=0
  while [ $retry_count -lt $max_retry_count ]; do
    timeout 0 keycheck
    timeout $delay keycheck
    local SEL=$?
    if [ $SEL -eq 42 ]; then
      return 0
    elif [ $SEL -eq 41 ]; then
      return 1
    else
      retry_count=$((retry_count + 1))
      retry_left=$(($max_retry_count - $retry_count + 1))
      ui_print "  Volume key not detected, Retry left: $retry_left"
    fi
  done

  abort "! Volume key timeout..."
}
