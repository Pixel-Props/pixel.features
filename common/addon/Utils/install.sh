#!/system/bin/sh

# Export variables for default paths & download links
export_location() {
  export "$1_download"="https://github.com/Pixel-Props/pixel.features/raw/main$2"
  export "$1_location"="$MODPATH$2"
}

has_command() {
  [ "$1" ] || abort "[✗] Please specify a command name in has_command()"
  [ -z $(command -v "$1") ] && return 1 || return 0
}

# Use pm path to make sure the package is existing
has_package() {
  [ "$1" ] || abort "[✗] Please specify a package in has_package()"
  [ -z $(pm path "$1") ] && return 1 || return 0
}

install_package() {
  [ "$1" ] || abort "[✗] Please specify a package in install_package()"
  [ "$2" ] || abort "[✗] Please specify a location in install_package()"

  # Save running users on system
  running_users=$(pm list users | grep running)
  running_uname=$(echo "$running_users" | head -n 1 | cut -d: -f2)
  cuid=$(am get-current-user)

  # Make sure there are running users on the system
  [ -z "$running_users" ] && abort "[✗] No running users found on the system. ERR: install_package()"

  # If package exists uninstall it
  if has_package "$1"; then
    ui_print " [!] Package already installed: $1"
    ui_print " [!] Uninstalling..."
    pm uninstall --user "$cuid" "$1"
  fi

  # Install the package
  ui_print " [+] Installing $1 on $cuid ($running_uname)..."
  chmod 0777 "$2"
  pm install --user "$cuid" "$2"

  # Clean up
  rm -rf "$2"
}

grep_prop() {
  REGEX="s/^$1=//p"
  shift
  FILES=$*
  [ -z "$FILES" ] && FILES='/system/build.prop'
  cat $FILES 2>/dev/null | dos2unix | sed -n "$REGEX" | head -n 1
}

# Get the download size of a website using wget
download_size() {
  [ "$1" ] && url=$1 || url="https://example.com"
  [ "$2" ] || abort "[✗] Please specify a return variable name to be set in download_size()"
  log_path="$TMPDIR/$(xxd -l 5 -c 5 -p </dev/random).log"

  # Make request
  wget --spider --server-response --output-file="$log_path" "$url"

  # Check if prepared logfile is used
  if [ -f "$log_path" ]; then
    # Calculate and print estimated website size
    eval "$2='$(
      grep -e "Length" "$log_path" |
        awk '{sum+=$2} END {printf("%.1f", sum / 1024 / 1024)}'
    ) Mb'"

    # Delete wget log file
    rm "$log_path"
  else
    abort "[✗] Unable to calculate estimated content size. '$url'"
  fi
}
