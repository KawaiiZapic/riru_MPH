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
rm "$TARGET_DIR"/*
for package in "$ORIG_DIR"/*
do
  rename="$(echo "$package" | sed -e 's/^[0-9]\+.//g')"
  cp "$ORIG_DIR/$package" "$TARGET_DIR/$rename"
done
set_perm_recursive "$TARGET_DIR" 0 0 0755 0644
chcon -R u:object_r:magisk_file:s0 "$TARGET_DIR"
