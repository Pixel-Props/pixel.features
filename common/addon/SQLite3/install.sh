#!/system/bin/sh

# External Tools
[ "$IS64BIT" ] && ARCH32='arm' || ARCH32='x86'
chmod -R 0755 "$MODPATH"/common/addon/SQLite3/tools
export PATH="$MODPATH"/common/addon/SQLite3/tools/"$ARCH32":"$PATH"

# SQLite3 binary
export SQLite3="$MODPATH"/common/addon/SQLite3/tools/"$ARCH32"/sqlite3

# SQLite3 databases
export gsv=/data/data/com.google.android.gsf/databases/gservices.db
export gms=/data/user/0/com.google.android.gms/databases/phenotype.db
export gah=/data/user/0/com.google.android.gms/databases/google_account_history.db

# Save Google accounts for later use
google_accounts="$("$SQLite3" "$gah" "SELECT account_name FROM AccountHistory;")"
export google_accounts

insert_gms_features() {
  [ "$1" ] && tableName="$1" || abort "[✗] Please specify a tableName in insert_gms_features()"
  shift # Remove tableName argument
  [ "$1" ] && packageName="$1" || abort "[✗] Please specify a packageName in insert_gms_features()"
  shift # Remove packageName argument
  [ "$1" ] && flagType=$1 || flagType=null
  shift # Remove flagType argument
  [ "$1" ] && intVal=$1 || intVal=null
  shift # Remove intVal argument
  [ "$1" ] && boolVal=$1 || boolVal=null
  shift # Remove boolVal argument
  [ "$1" ] && floatVal=$1 || floatVal=null
  shift # Remove floatVal argument
  [ "$1" ] && stringVal=$1 || stringVal=null
  shift # Remove stringVal argument
  [ "$1" ] && committed=$1 || committed=0
  shift # Remove committed argument

  # Make sure database is open
  if [ ! -f "$gms" ]; then
    abort "[✗] Database not found: $gms"
  fi

  # Make sure table exists
  if ! $SQLite3 "$gms" "SELECT name FROM sqlite_master WHERE type='table' AND name='$tableName';" | grep -q "$tableName"; then
    abort " [✗] Table not found: $tableName"
  fi

  # Loop true featureNames
  for featureName in "$@"; do
    # ui_print "  [+] Enabling $tableName.$packageName.$featureName"

    # Delete existing featureNames
    $SQLite3 $gms "DELETE FROM $tableName WHERE packageName='$packageName' AND name='$featureName';"

    # Enable feature for system
    $SQLite3 "$gms" "INSERT INTO $tableName (packageName, flagType, user, name, intVal, boolVal, committed) VALUES ('$packageName', '$flagType', '', '$featureName', '$intVal', '$boolVal', '$committed');"

    # Enable feature per account
    for user in $google_accounts; do
      $SQLite3 "$gms" "INSERT INTO $tableName (packageName, flagType, user, name, intVal, boolVal, committed) VALUES ('$packageName', '$flagType', '$user', '$featureName', '$intVal', '$boolVal', '$committed');"
    done
  done
}
