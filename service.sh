#!/system/bin/sh
MODDIR=${0%/*}

log_service() {
  echo "[$(date)] $*" >>"$MODDIR"/service.log
}

# Starting...
log_service "Service started."
log_service "MODDIR: $MODDIR"

# Start script once bootanimation has done loading and sdcard mounted
until [ "$(getprop init.svc.bootanim)" = "stopped" ] && [ -d /sdcard ]; do
  sleep 3
done

log_service "Boot animation finished. And sdcard mounted."

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
  bool_patch agsa
  bool_patch dynamic_art
  bool_patch enable_core_typing_experience_indicator_on_candidates
  bool_patch enable_core_typing_experience_indicator_on_composing_text
  bool_patch enable_email_provider_completion
  bool_patch enable_inline_suggestions_on_client_side
  bool_patch enable_inline_suggestions_on_decoder_side
  bool_patch enable_multiword_predictions
  bool_patch enable_preemptive_decode
  bool_patch enable_show_inline_suggestions_in_popup_view
  bool_patch enable_voice
  bool_patch fast_access_bar
  bool_patch feature_cards
  bool_patch floating
  bool_patch generation
  bool_patch lens
  bool_patch lm
  bool_patch multilingual
  bool_patch multiword
  bool_patch nga
  bool_patch personalization
  bool_patch redesign
  bool_patch show_suggestions_for_selected_text_while_dictating
  bool_patch silk
  bool_patch tflite
  bool_patch tiresias
  bool_patch translate
  bool_patch voice_promo
  value_patch crank_inline_suggestion_language_tags "ar,de,en,en-US,es,fr,fr-FR,hi-IN,hi-Latn,id,it,ja,ko,nl,pl,pt,ru,th,tr,zh-CN,zh-HK,zh-TW"
  value_patch crank_max_char_num_limit 100
  value_patch crank_min_char_num_limit 5
  value_patch inline_suggestion_experiment_version 4
  value_patch keyboard_redesign 1
  value_patch user_history_learning_strategies 1
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

# Start patching
set_flags
set_prefs
