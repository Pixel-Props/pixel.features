#!/data/adb/magisk/busybox sh
# shellcheck shell=sh

##
# Script environment
##

export MODDIR="${0%/*}"
export MODPATH="$MODDIR"
export TMPDIR="$MODDIR"/tmp
export LOGPATH="$MODDIR"/service.log

log_service() {
  # If the log path is bigger than 5MB, delete the oldest log
  if [ -f "$LOGPATH" ] && [ "$(wc -c <"$LOGPATH")" -gt 5000000 ]; then
    rm -f "$LOGPATH"
  fi

  # Write log to file
  echo "[$(date)] $*" >>"$LOGPATH"
}

ui_print() {
  log_service "$*"
}

abort() {
  log_service "$*"
  exit 1
}

wait_until_boot_complete() {
  loop_count=0
  until [ "$(getprop init.svc.bootanim)" = "stopped" ] && [ "$(getprop sys.boot_completed)" = "1" ] && [ -d /sdcard ]; do
    # CHECK
    if [ "$loop_count" -gt 10 ]; then
      log_service "Exceeded the maximum number of retries for loading the service."
      abort "Boot Animation: $(getprop init.svc.bootanim) | Boot Complete: $(getprop sys.boot_completed) | /sdcard: $(if [ -d /sdcard ]; then echo "Exists"; else echo "Does not exist"; fi)"
    fi

    # WAIT
    sleep 3
    loop_count=$((loop_count + 1))
  done
}

export_IS64BIT() {
  abi_prop=$(getprop ro.product.cpu.abi)
  IS64BIT=false

  if [ "${abi_prop%64}" != "$abi_prop" ]; then
    IS64BIT=true
  fi
  export IS64BIT
}

##
# End of Script environment
##

##
##

##
# Begin patching device_prefs
##

export_prop_prefs() {
  propPath="$1"
  shift

  for propName in "$@"; do
    pref_prop="$(grep_prop "$propName" "$propPath")"

    # Remove quotes from the filepath
    PREF_FILEPATH="${pref_prop%\"}"
    PREF_FILEPATH="${PREF_FILEPATH#\"}"

    export "$propName"="$PREF_FILEPATH"
  done
}

str_replace() {
  search="$(echo "$1" | sed -e 's/[]\/$*.^|[]/\\&/g')"
  replace="$(echo "$2" | sed -e 's/[]\/$*.^|[]/\\&/g')"
  subject="$(echo "$3" | sed -e 's/[]\/$*.^|[]/\\&/g')"
  file="$4"

  # Logging
  log_service "str_replace: $search -> $replace in $subject"

  # Replace subject with a parsed version of itself
  subject=$(grep "$subject" "$file" | xargs | sed -e 's/>.</>\n</g')

  # Escape the subject
  subject=$(echo "$subject" | sed -e 's/[]\/$*.^|[]/\\&/g')

  # Save subject to a temp file
  TMPDIR_FILE="$TMPDIR/$(xxd -l 5 -c 5 -p </dev/random)"
  touch "$TMPDIR_FILE"
  echo "$subject" >"$TMPDIR_FILE"

  # Loop true subject new lines
  while read -r line; do
    # Grep the line from the subject and replace it
    replaced_subject=$(grep "$line" "$file" | sed "s/$search/$replace/g" | xargs)

    # Escape the subject
    escaped_replaced_subject=$(echo "$replaced_subject" | sed -e 's/[]\/$*.^|[]/\\&/g')

    # Logging
    log_service "str_replace: $line -> $replaced_subject"

    # Replace the subject with the replaced subject in the file
    sed -i "s/$subject/$escaped_replaced_subject/g" "$file"
  done <"$TMPDIR_FILE"

  # Remove the temp file
  rm -f "$TMPDIR_FILE"
}

bool_patch_false() {
  str_replace true false "$1" "$xml_pref_path"
}

bool_patch() {
  str_replace false true "$1" "$xml_pref_path"
}

value_patch() {
  # Replace subject with a parsed version of itself
  subject=$(grep "$1" "$xml_pref_path" | xargs | sed 's/> </>\n</g')

  # Save subject to a temp file
  TMPDIR_FILE="$TMPDIR/$(xxd -l 5 -c 5 -p </dev/random)"
  touch "$TMPDIR_FILE"
  echo "$subject" >"$TMPDIR_FILE"

  while read -r line; do
    # If the string has a closing tag use the value inside it
    if [[ "$line" == *"</"* ]]; then
      str_replace "$(echo "$line" | cut -d'>' -f2 | cut -d'<' -f1)" "$2" "$1" "$xml_pref_path"
    else
      str_replace "$(echo "$line" | sed -rn 's/.*value="(.*)".*/\1/p')" "$2" "$1" "$xml_pref_path"
    fi
  done <"$TMPDIR_FILE"

  # Remove the temp file
  rm -f "$TMPDIR_FILE"
}

set_prefs() {
  log_service "Setting prefs..."

  for file in "$MODDIR"/device_prefs/*/*.ini; do
    # Get folder base name
    folder_path=${file%/*}         # Remove last /
    folder_name=${folder_path##*/} # Remove path before folder name

    if [ -f "$file" ]; then
      file_name=${file##*/}
      file_name_no_ext=${file_name%.*}
      log_service "Patching \"$folder_name\" on \"$file_name_no_ext\""

      # Export prefs
      export_prop_prefs "$file" "db_pref_packageName" "db_pref_path" "xml_pref_path"

      # Create temp file
      TMPDIR_FILE="$TMPDIR/$(xxd -l 5 -c 5 -p </dev/random)"
      touch "$TMPDIR_FILE"

      # Go true file lines
      while read -r line; do
        # Remove new line from line
        line=${line%$'\r'}

        # Ignore comments, empty lines and script specific lines
        if [[ -n "$line" ]] && [[ "$line" != "#"* ]] && [[ "$line" != *"_pref_"* ]]; then
          # Save line to a temp file
          echo "$line" >"$TMPDIR_FILE"

          # Explode the key and value based on the equal sign
          IFS='=' read -r key value <"$TMPDIR_FILE"

          # Remove the quotes sign between the value
          value=${value#\"}
          value=${value%\"}

          log_service "Patching \"$key\" -> \"$value\""

          # Patch XML values
          value_patch "$key" "$value"

          # Switch the type of patch value based on folder name
          case "$folder_name" in
          "boolean")
            insert_gms_features "FlagOverrides" "$db_pref_packageName" 0 null "$value" null null 1 "$key"
            ;;
          "integer")
            insert_gms_features "FlagOverrides" "$db_pref_packageName" 0 "$value" null null null 1 "$key"
            ;;
          "string")
            insert_gms_features "FlagOverrides" "$db_pref_packageName" 0 null null null "$value" 1 "$key"
            ;;
          *)
            ui_print "Unknown folder name: $folder_name"
            ;;
          esac

        fi
      done <"$file"

      # Remove temp file
      rm -f "$TMPDIR_FILE"
    fi
  done
}

##
# End patching device_prefs
##

##
##

##
# Begin patching device_config
##

dc_set_service() {
  export SERVICE_NAME="$1"
}

dc_put() {
  { [ "$SERVICE_NAME" ] && [ "$1" ] && [ "$2" ]; } && device_config put "$SERVICE_NAME" "$1" "$2"
}

set_flags() {
  log_service "Setting flags..."
  for file in "$MODDIR"/device_config/*.ini; do
    if [ -f "$file" ]; then
      file_name=${file##*/}
      file_name_no_ext=${file_name%.*}
      log_service "Patching \"$file_name_no_ext\""

      # Set service name
      dc_set_service "$file_name_no_ext"

      # Create temp file
      TMPDIR_FILE="$TMPDIR/$(xxd -l 5 -c 5 -p </dev/random)"
      touch "$TMPDIR_FILE"

      # Go true file lines
      while read -r line; do
        # Save line to a temp file
        echo "$subject" >"$TMPDIR_FILE"

        # Explode the key and value based on the equal sign
        IFS='=' read -r key value <"$TMPDIR_FILE"
        dc_put "$key" "$value"
      done <"$file"

      # Remove temp file
      rm -f "$TMPDIR_FILE"
    fi
  done
}

##
# End patching device_config
##

##
##

##
# Script start
##

log_service "Service started."
log_service "MODDIR: $MODDIR"
wait_until_boot_complete
export_IS64BIT
mkdir "$TMPDIR"
log_service "System fully started. Beginning to patch..."

# Run utils
[ -f "$MODDIR/common/addon/Utils/install.sh" ] && . "$MODDIR/common/addon/Utils/install.sh"

# Run SQLite3
[ -f "$MODDIR/common/addon/SQLite3/install.sh" ] && . "$MODDIR/common/addon/SQLite3/install.sh"

# Start patching
set_flags
set_prefs

# Clean temp files
rm -rf "$TMPDIR"

# Finish
log_service "Service finished."

##
# Script end
##
