#!/system/bin/sh
export MODDIR="${0%/*}"

log_service() {
  echo "[$(date)] $*" >>"$MODDIR"/service.log
}

wait_until_boot_complete() {
  loop_count=0
  until [ "$(getprop init.svc.bootanim)" = "stopped" ] && [ "$(getprop sys.boot_completed)" = "1" ] && [ -d /sdcard ]; do
    # CHECK
    if [ "$loop_count" -gt 10 ]; then
      log_service "Exceeded the maximum number of retries for loading the service."
      log_service "Boot Animation: $(getprop init.svc.bootanim) | Boot Complete: $(getprop sys.boot_completed) | /sdcard: $(if [ -d /sdcard ]; then echo "Exists"; else echo "Does not exist"; fi)"
      exit 0
    fi

    # WAIT
    sleep 3
    loop_count=$((loop_count + 1))
  done
}

##
# Begin patching config files
##

set_patch_filepath() {
  export PATCH_FILEPATH="$1"
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
  done <<<"$subject"
}

bool_patch_false() {
  str_replace true false "$1" "$PATCH_FILEPATH"
}

bool_patch() {
  str_replace false true "$1" "$PATCH_FILEPATH"
}

value_patch() {
  # Replace subject with a parsed version of itself
  subject=$(grep "$1" "$PATCH_FILEPATH" | xargs | sed 's/> </>\n</g')

  while read -r line; do
    #If the string has a closing tag use the value inside it
    if [[ "$line" == *"</"* ]]; then
      str_replace "$(echo "$line" | cut -d'>' -f2 | cut -d'<' -f1)" "$2" "$1" "$PATCH_FILEPATH"
    else
      str_replace "$(echo "$line" | sed -rn 's/.*value="(.*)".*/\1/p')" "$2" "$1" "$PATCH_FILEPATH"
    fi
  done <<<"$subject"
}

set_prefs() {
  iso_lang_code="af,af-ZA,ar,ar-AE,ar-BH,ar-DZ,ar-EG,ar-IQ,ar-JO,ar-KW,ar-LB,ar-LY,ar-MA,ar-OM,ar-QA,ar-SA,ar-SY,ar-TN,ar-YE,az,az-AZ,az-AZ,be,be-BY,bg,bg-BG,bs-BA,ca,ca-ES,cs,cs-CZ,cy,cy-GB,da,da-DK,de,de-AT,de-CH,de-DE,de-LI,de-LU,dv,dv-MV,el,el-GR,en,en-AU,en-BZ,en-CA,en-CB,en-GB,en-IE,en-JM,en-NZ,en-PH,en-TT,en-US,en-ZA,en-ZW,eo,es,es-AR,es-BO,es-CL,es-CO,es-CR,es-DO,es-EC,es-ES,es-ES,es-GT,es-HN,es-MX,es-NI,es-PA,es-PE,es-PR,es-PY,es-SV,es-UY,es-VE,et,et-EE,eu,eu-ES,fa,fa-IR,fi,fi-FI,fo,fo-FO,fr,fr-BE,fr-CA,fr-CH,fr-FR,fr-LU,fr-MC,gl,gl-ES,gu,gu-IN,he,he-IL,hi,hi-IN,hr,hr-BA,hr-HR,hu,hu-HU,hy,hy-AM,id,id-ID,is,is-IS,it,it-CH,it-IT,ja,ja-JP,ka,ka-GE,kk,kk-KZ,kn,kn-IN,ko,ko-KR,kok,kok-IN,ky,ky-KG,lt,lt-LT,lv,lv-LV,mi,mi-NZ,mk,mk-MK,mn,mn-MN,mr,mr-IN,ms,ms-BN,ms-MY,mt,mt-MT,nb,nb-NO,nl,nl-BE,nl-NL,nn-NO,ns,ns-ZA,pa,pa-IN,pl,pl-PL,ps,ps-AR,pt,pt-BR,pt-PT,qu,qu-BO,qu-EC,qu-PE,ro,ro-RO,ru,ru-RU,sa,sa-IN,se,se-FI,se-FI,se-FI,se-NO,se-NO,se-NO,se-SE,se-SE,se-SE,sk,sk-SK,sl,sl-SI,sq,sq-AL,sr-BA,sr-BA,sr-SP,sr-SP,sv,sv-FI,sv-SE,sw,sw-KE,syr,syr-SY,ta,ta-IN,te,te-IN,th,th-TH,tl,tl-PH,tn,tn-ZA,tr,tr-TR,tt,tt-RU,ts,uk,uk-UA,ur,ur-PK,uz,uz-UZ,uz-UZ,vi,vi-VN,xh,xh-ZA,zh,zh-CN,zh-HK,zh-MO,zh-SG,zh-TW,zu,zu-ZA"

  # Turbo
  set_patch_filepath "/data/data/com.google.android.apps.turbo/shared_prefs/phenotypeFlags.xml"
  bool_patch AdaptiveCharging__enabled
  bool_patch AdaptiveCharging__v1_enabled

  # Call Screening
  set_patch_filepath "/data/data/com.google.android.dialer/shared_prefs/dialer_phenotype_flags.xml"
  bool_patch speak_easy
  bool_patch speakeasy
  bool_patch call_screen
  bool_patch revelio
  bool_patch record
  bool_patch atlas

  # GBoard
  set_patch_filepath "/data/data/com.google.android.inputmethod.latin/shared_prefs/flag_value.xml"
  bool_patch lm
  bool_patch nga
  bool_patch silk
  bool_patch lens
  bool_patch agsa
  bool_patch tflite
  bool_patch tiresias
  bool_patch redesign
  bool_patch floating
  bool_patch translate
  bool_patch multiword
  bool_patch generation
  bool_patch voice_promo
  bool_patch dynamic_art
  bool_patch multilingual
  bool_patch enable_voice
  bool_patch feature_cards
  bool_patch log_auto_space
  bool_patch pill_shaped_key
  bool_patch personalization
  bool_patch fast_access_bar
  bool_patch material3_theme
  bool_patch translate_new_ui
  bool_patch keyboard_redesign
  bool_patch offline_translate
  bool_patch enable_dynamic_trainer
  bool_patch enable_preemptive_decode
  bool_patch enable_trainer_manager_v2
  bool_patch enable_matrializer_manager
  bool_patch enable_multiword_predictions
  bool_patch enable_email_provider_completion
  bool_patch use_scrollable_candidate_for_voice
  bool_patch enable_inline_suggestions_on_client_side
  bool_patch enable_training_cache_metrics_processors
  bool_patch enable_inline_suggestions_on_decoder_side
  bool_patch show_voice_reconversion_suggestion_as_chip
  bool_patch enable_show_inline_suggestions_in_popup_view
  bool_patch show_suggestions_for_selected_text_while_dictating
  bool_patch enable_core_typing_experience_indicator_on_candidates
  bool_patch enable_core_typing_experience_indicator_on_composing_text
  bool_patch_false personalization
  bool_patch_false show_branding_on_space
  value_patch enable_magic_g_locales ""
  value_patch crank_min_char_num_limit 5
  value_patch crank_max_char_num_limit 100
  value_patch branding_fadeout_delay_ms 900
  value_patch user_history_learning_strategies 1
  value_patch inline_suggestion_experiment_version 4
  value_patch show_branding_interval_seconds 86400000
  value_patch speech_ondevice_locales "$iso_lang_code"
  value_patch mutex_profiler_inverse_stack_trace_freq 4096
  value_patch key_locale_cutout_switches_lm "$iso_lang_code"
  value_patch max_chars_to_read_before_and_after_cursor 1024
  value_patch enable_dynamic_art_language_tags "$iso_lang_code"
  value_patch multiword_candidate_language_tags "$iso_lang_code"
  value_patch crank_inline_suggestion_language_tags "$iso_lang_code"
  value_patch enable_expression_moment_language_tags "$iso_lang_code"
  value_patch enable_autocorrection_adaptation_locales "$iso_lang_code"
}

##
# End patching xml files
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

      # Go true file lines
      while read -r line; do
        IFS='=' read -r key value <<<"$line"
        dc_put "$key" "$value"
      done <<<"$(cat "$file")"
    fi
  done
}

##
# End patching device_config
##

# Starting...
log_service "Service started."
log_service "MODDIR: $MODDIR"
wait_until_boot_complete
log_service "System fully started. Beginning to patch..."

# Start patching
set_flags
set_prefs
