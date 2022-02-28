#!/system/bin/sh

packageName="com.google.android.platform.device_personalization_services"
download_size "$MusicDetector_download" file_size

if [ -f "$MusicDetector_location" ] &&
  selector "Install the Pixel Adaptive Audio Firmware ?" "$useRecommendedSettings" ||
  selector "Download the Pixel Adaptive Audio Firmware ? ($file_size)" "$useRecommendedSettings"; then
  [ -f "$MusicDetector_location" ] && ui_print ' [+] Installing...' || ui_print ' [⭳] Downloading...'

  # Download
  [ -f "$MusicDetector_location" ] || wget -O "$MusicDetector_location" "$MusicDetector_download"

  # Install
  tar -xf "$MusicDetector_location" -C "$MODPATH/system/product/etc/"
  rm "$MusicDetector_location"

  # Adding flags
  ui_print ' [+] Adding flags...'
  insert_gms_features "FlagOverrides" $packageName 0 null 1 null null 0 "Echo__enable_headphones_suggestions_from_agsa" "Echo__smartspace_enable_doorbell" "Echo__smartspace_enable_earthquake_alert_predictor" "Echo__smartspace_enable_echo_settings" "Echo__smartspace_enable_light_predictor" "Echo__smartspace_enable_paired_device_predictor" "Echo__smartspace_enable_safety_check_predictor" "NowPlaying__ambient_music_on_demand_enabled" "NowPlaying__cloud_api_allowed" "NowPlaying__enable_usage_fa" "NowPlaying__favorites_enabled" "NowPlaying__handle_ambient_music_results_with_history" "NowPlaying__youtube_export_enabled" "Overview__enable_lens_r_overview_long_press" "Overview__enable_lens_r_overview_select_mode" "Overview__enable_lens_r_overview_translate_action"

  # Done
  ui_print " [✓] Installed"
  ui_print ''
else
  ui_print " [-] Removing from module"
  ui_print ''
  rm -rf "$MODPATH"/system/product/etc/firmware*
fi
