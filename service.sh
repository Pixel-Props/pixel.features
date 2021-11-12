#!/system/bin/sh

MODDIR=${0%/*}

sleep 150

# Adaptive Sound
device_config put device_personalization_services AdaptiveAudio__enable_adaptive_audio true
device_config put device_personalization_services AdaptiveAudio__show_promo_notification true
