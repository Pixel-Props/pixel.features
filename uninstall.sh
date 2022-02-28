#!/system/bin/sh
gms=/data/user/0/com.google.android.gms/databases/phenotype.db

rm -rf /data/data/com.google.android.apps.fitness/shared_prefs/growthkit_phenotype_prefs.xml
rm -rf /data/data/com.google.android.apps.turbo/shared_prefs/phenotypeFlags.xml
rm -rf /data/data/com.google.android.dialer/shared_prefs/dialer_phenotype_flags.xml
rm -rf /data/data/com.google.android.googlequicksearchbox/shared_prefs/GEL.GSAPrefs.xml
rm -rf /data/data/com.google.android.inputmethod.latin/shared_prefs/flag_value.xml

sqlite3 $gms "DELETE FROM FlagOverrides;"

[ -e "/data/system/package_cache" ] && rm -rf /data/system/package_cache/*
