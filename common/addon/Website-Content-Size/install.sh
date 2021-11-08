download_size() {
  [ "$1" ] && local url=$1 || local url="https://example.com"
  [ "$2" ] || abort "Please specify a return variable name to be set"
  local log_path="$MODPATH/common/addon/Website-Content-Size/$(xxd -l 5 -c 5 -p </dev/random).log"

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
    abort "! Unable to calculate estimated content size. '$url'"
  fi
}
