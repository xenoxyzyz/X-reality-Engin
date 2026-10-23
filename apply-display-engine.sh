#!/bin/bash
# Display Engine (X-Reality) port for LineageOS 24 — apply script
# Usage: run from the TOP of the LOS source tree (after repo sync):
#     bash /path/to/apply-display-engine.sh
# or pass the tree path:  bash apply-display-engine.sh /path/to/los-tree
# Idempotent: safe to re-run.
set -e
PKG="$(cd "$(dirname "$0")" && pwd)"
TREE="${1:-$PWD}"
cd "$TREE"

echo ">>> Tree: $TREE"
echo ">>> [1/4] frameworks/base: new DisplayEngineController.java"
cp -f "$PKG/files/frameworks/base/services/core/java/com/android/server/display/color/DisplayEngineController.java" \
      frameworks/base/services/core/java/com/android/server/display/color/

echo ">>> [2/4] frameworks/base: patch Settings.java + ColorDisplayService.java"
if grep -q "DISPLAY_ENGINE_MODE" frameworks/base/services/core/java/com/android/server/display/color/ColorDisplayService.java; then
    echo "    already patched, skipping"
else
    (cd frameworks/base && patch -p1 --forward < "$PKG/frameworks_base.patch")
fi

echo ">>> [3/4] packages/apps/Settings: new files"
mkdir -p packages/apps/Settings/res/xml packages/apps/Settings/res/values \
         packages/apps/Settings/src/org/lineageos/settings/preferences
cp -f "$PKG/files/packages/apps/Settings/res/xml/display_engine_settings.xml" \
      packages/apps/Settings/res/xml/
cp -f "$PKG/files/packages/apps/Settings/res/values/display_engine_strings.xml" \
      "$PKG/files/packages/apps/Settings/res/values/display_engine_arrays.xml" \
      packages/apps/Settings/res/values/
cp -f "$PKG/files/packages/apps/Settings/src/org/lineageos/settings/preferences/SecureSettingListPreference.java" \
      packages/apps/Settings/src/org/lineageos/settings/preferences/

echo ">>> [4/4] packages/apps/Settings: patch ColorModePreferenceFragment.java"
if grep -q "display_engine_settings" packages/apps/Settings/src/com/android/settings/display/ColorModePreferenceFragment.java; then
    echo "    already patched, skipping"
else
    (cd packages/apps/Settings && patch -p1 --forward < "$PKG/packages_apps_Settings.patch")
fi

echo ">>> Display Engine port applied. Verify:"
grep -c "DISPLAY_ENGINE_MODE" frameworks/base/core/java/android/provider/Settings.java \
    frameworks/base/services/core/java/com/android/server/display/color/ColorDisplayService.java
ls frameworks/base/services/core/java/com/android/server/display/color/DisplayEngineController.java \
   packages/apps/Settings/res/xml/display_engine_settings.xml
