#!/system/bin/sh

packageName="com.google.android.inputmethod.latin#com.google.android.inputmethod.latin"

if selector "Enable Pixel GBoard Features ?" "$useRecommendedSettings" "Enable" "Disable"; then
  ui_print ' [+] Adding flags...'
  insert_gms_features "FlagOverrides" $packageName 0 null 1 null null 1 "crank_trigger_decoder_inline_completion_first" "crank_trigger_decoder_inline_prediction_first" "enable_core_typing_experience_indicator_on_candidates" "enable_core_typing_experience_indicator_on_composing_text" "enable_email_provider_completion" "enable_floating_keyboard_v2" "enable_inline_suggestions_on_client_side" "enable_inline_suggestions_on_decoder_side" "enable_inline_suggestions_space_tooltip" "enable_inline_suggestions_tooltip_v2" "enable_matched_predictions_as_inline_from_crank_cifg" "enable_multiword_predictions_as_inline_from_crank_cifg" "enable_multiword_predictions_from_user_history" "enable_multiword_suggestions_as_inline_from_crank_cifg" "enable_next_generation_hwr_support" "enable_nga" "enable_single_word_predictions_as_inline_from_crank_cifg" "enable_single_word_suggestions_as_inline_from_crank_cifg" "enable_user_history_predictions_as_inline_from_crank_cifg" "nga_enable_mic_button_when_dictation_eligible" "nga_enable_mic_onboarding_animation" "nga_enable_spoken_emoji_sticky_variant" "nga_enable_sticky_mic" "nga_enable_undo_delete" "silk_on_all_devices" "silk_on_all_pixel"
  insert_gms_features "FlagOverrides" $packageName 0 4 null null null 1 "inline_suggestion_experiment_version"
  insert_gms_features "FlagOverrides" $packageName 0 1 null null null 1 "user_history_learning_strategies"

  # Done
  ui_print " [✓] Installed"
  ui_print ''
else
  ui_print " [~] Ignoring"
  ui_print ''
fi
