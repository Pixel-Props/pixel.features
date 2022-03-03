#!/system/bin/sh

packageName="com.google.android.dialer"

if selector "Enable Pixel Google Dialer Features ?" "$useRecommendedSettings" "Enable" "Disable"; then
  ui_print ' [+] Adding flags...'
  insert_gms_features "FlagOverrides" $packageName 0 null 1 null null 1 "CallLogInformationArchitecture__enable_call_log_information_architecture" "CallRecording__enable_call_recording_for_fi" "G__always_enable_new_call_log_framework_and_fragment" "G__answer_false_touch_detection_enabled" "G__are_embeddings_jobs_enabled" "G__bypass_revelio_roaming_check" "G__call_screen_audio_listener_enabled" "G__config_caller_id_enabled" "G__enable_after_call_spam_blocking_promo" "G__enable_atlas" "G__enable_call_recording" "G__enable_call_screen_audio_stitching" "G__enable_call_screen_data_in_call_log" "G__enable_call_screen_saving_audio" "G__enable_duplicates_promo_v2_ui" "G__enable_embedding_spam_revelio" "G__enable_embedding_spam_revelio" "G__enable_new_voicemail_tab" "G__enable_patronus_spam" "G__enable_pendingcall" "G__enable_phone_number_classification_spam" "G__enable_reject_embedding_spam_calls" "G__enable_revelio" "G__enable_revelio_on_bluetooth" "G__enable_revelio_on_wired_headset" "G__enable_revelio_r_api" "G__enable_rtt_visibility_setting_part2" "G__enable_spam_blocking_promo" "G__enable_speak_easy_is_spam_survey" "G__enable_speakeasy_details" "G__enable_video_share" "G__enable_wifi_calling_icons_all_carriers" "G__force_disable_enriched_call" "G__force_within_call_recording_geofence_value" "G__force_within_crosby_geofence_value" "G__is_call_log_item_anim_null" "G__new_call_log_fragment_enabled" "G__new_voicemail_fragment_enabled" "G__show_call_screen_recording_player_in_call_log" "G__speak_easy_bypass_locale_check" "G__speak_easy_enable_listen_in_button" "G__speak_easy_enabled" "G__speak_easy_use_soda_asr" "G__use_call_recording_geofence_overrides" "G__voicemail_change_greeting_enabled" "G_answer_proximity_sensor_enabled" "G_call_screen_audio_listener_enabled" "Scooby__are_spam_jobs_enabled" "Scooby__enable_same_prefix_logging" "atlas_use_soda_for_transcription" "enable_android_s_notifications" "enable_atlas_on_tidepods_voice_screen" "enable_dialer_hold_handling" "enable_dialpad_v2_ux" "enable_hold_detection" "enable_precall_dialpad_v2" "enable_revelio_transcript" "enable_smart_reply" "enable_stir_shaken_call_log" "enable_theme_pushing" "enable_video_call_landscape" "enable_video_handover_dialog" "enable_voice_autofill" "enable_xatu" "enable_xatu_music_detection" "force_flip_to_silence" "show_atlas_hold_for_me_confirmation_dialog"
  insert_gms_features "FlagOverrides" $packageName 0 null 0 null null 1 "G__enable_pride_month_celebration" "G__enable_primes" "G__enable_primes_crash_metric" "G__enable_primes_timer_metric" "G__enable_tidepods_video" "enable_profile_photo_for_on_hold_video_call"
  insert_gms_features "FlagOverrides" $packageName 0 null null null "" 1 "CallRecording__call_recording_countries" "CallRecording__call_recording_countries_with_built_in_audio_file" "CallRecording__call_recording_force_enable_built_in_audio_file_countries" "CallRecording__call_recording_force_enable_tts_countries" "CallRecording__crosby_countries" "G__assisted_dialing_csv_country_codes"

  # Done
  ui_print " [✓] Installed"
  ui_print ''
else
  ui_print " [~] Removing from module"
  ui_print ''
fi
