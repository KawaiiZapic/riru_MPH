#!/system/bin/sh
MODDIR=${0%/*}

# Remove this part if this module support Riru v24+ only

if [ -f "$MODDIR"/../riru-core/util_functions.sh ]; then
  # Riru v24
  # If this module is installed before Riru is updated to v24, we have to manually move the files to the new location
  [ -d "$MODDIR"/system ] && mv "$MODDIR"/system "$MODDIR"/riru
else
  # Riru pre-v24
  # In case user downgrade Riru to pre-v24
  [ -d "$MODDIR"/riru ] && mv "$MODDIR"/riru "$MODDIR"/system
fi

ORIG_DIR=/data/misc/riru/modules/mipush_fake/packages
TARGET_DIR=/data/misc/mph/config/packages
PREFER_SYSTEM=0
if [ -d "$ORIG_DIR" ] && [ -d "$TARGET_DIR" ];
then
  if [ -f "$TARGET_DIR"/prefer_system ];
  then
    PREFER_SYSTEM=1
  fi
  rm "$TARGET_DIR"/* 2> /dev/null
  for package in "$ORIG_DIR"/*
  do
    rename="$(echo $(basename "$package") | sed -E "s/^[0-9]+.//g")"
    cp $package "$TARGET_DIR"/$rename
  done
  if [ PREFER_SYSTEM -eq 1];
  then
    touch "$TARGET_DIR"/prefer_system
  fi
  rm "$ORIG_DIR"/prefer_system 2> /dev/null
  set_perm_recursive "$TARGET_DIR" 0 0 0755 0644
  chcon -R u:object_r:magisk_file:s0 "$TARGET_DIR"
fi
