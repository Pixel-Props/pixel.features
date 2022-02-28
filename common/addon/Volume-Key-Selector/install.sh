#!/system/bin/sh

# External Tools
[ "$IS64BIT" ] && ARCH32='arm' || ARCH32='x86'
chmod -R 0755 "$MODPATH"/common/addon/Volume-Key-Selector/tools
export PATH="$MODPATH"/common/addon/Volume-Key-Selector/tools/"$ARCH32":"$PATH"

# Default keys
export selectorValidationKey=42
export selectorDenyKey=41

selector() {
  [ "$1" ] && inselector_message=$1 || inselector_message="Hello World"
  [ "$2" ] && force_ret=$2 || force_ret=null
  [ "$3" ] && vol_up=$3 || vol_up="Yes"
  [ "$4" ] && vol_down=$4 || vol_down="No"
  [ "$5" ] && delay=$5 || delay=5
  [ "$6" ] && max_retry_count=$6 || max_retry_count=3

  ui_print "- $inselector_message"

  # If force ret was set, we don't need to check for the key
  if [ "$force_ret" != null ]; then
    return 0
  fi

  ui_print "   Vol Up += $vol_up"
  ui_print "   Vol Down += $vol_down"

  retry_count=0
  while [ $retry_count -lt $max_retry_count ]; do
    timeout 0 keycheck
    timeout $delay keycheck
    SEL=$?
    if [ $SEL -eq $selectorValidationKey ]; then
      return 0
    elif [ $SEL -eq $selectorDenyKey ]; then
      return 1
    else
      retry_count=$((retry_count + 1))
      retry_left=$((max_retry_count - retry_count + 1))
      ui_print "  Volume key not detected, Retry left: $retry_left"
    fi
  done

  # So that we can start our loop
  selectorValidationKey=$selectorDenyKey

  # Loop until validation key and deny key are pressed and are not the same
  while [ $selectorValidationKey -eq $selectorDenyKey ]; do
    ui_print ''
    ui_print "[!] Failed to identify your Volume keys"
    ui_print "[!] Setting up new Volume keys..."
    ui_print ''

    ui_print "- Press a key to change the default key"
    ui_print "   Press UP"
    timeout 0 keycheck
    timeout 10 keycheck
    selectorValidationKey=$?
    ui_print "   Set to: $selectorValidationKey"

    ui_print "   Press DOWN"
    timeout 0 keycheck
    timeout 10 keycheck
    selectorDenyKey=$?
    ui_print "   Set to: $selectorDenyKey"
  done

  ui_print ''

  # Execute the function again
  selector "$inselector_message" "$force_ret" "$vol_up" "$vol_down" "$delay" "$max_retry_count"
}
