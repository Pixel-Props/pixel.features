# Export variables for default paths & download links
export_location() {
  export "$1_download"="https://github.com/Pixel-Props/pixel.features/raw/main$2"
  export "$1_location"="$MODPATH$2"
}
