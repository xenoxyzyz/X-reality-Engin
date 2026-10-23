# Display Engine (X-Reality) port — LineageOS 24 / marble

Ported from **Evolution X (cnb, Android 17)** official source on 2026-10-20.
Verified against LineageOS `lineage-24.0` sources: both patches apply cleanly
(zero fuzz/rejects, dry-run tested), XMLs are well-formed, all APIs used
(`ColorDisplayManager.isColorTransformAccelerated`, `RadioButtonPickerFragment.updateCandidates`)
exist in LOS 24.

## What it adds
Settings → Display → Colours page gets a **"Display engine"** section with
**Reality display engine** modes: Default / X-Reality / Vivid / Triluminous /
Natural / Cinema / Comfort (Reading). Software color-matrix presets applied by
system_server via `Settings.Secure.display_engine_mode`.

## Contents
- `frameworks_base.patch` — Settings.java (new `DISPLAY_ENGINE_MODE` key) +
  ColorDisplayService.java (controller registration, observer, handler).
  Only Display-Engine hunks; EvoX's unrelated inversion changes excluded.
- `packages_apps_Settings.patch` — ColorModePreferenceFragment: import,
  `updateCandidates()` inflation hook, search indexing.
- `files/` — new files at target paths:
  - `DisplayEngineController.java` (EvoX/crDroid version, 6 presets)
  - `res/xml/display_engine_settings.xml`
  - `res/values/display_engine_strings.xml`, `display_engine_arrays.xml`
  - `src/org/lineageos/settings/preferences/SecureSettingListPreference.java`
    (written for LOS — EvoX's `org.evolution...` class isn't in their Settings
    repo; this is the standard equivalent)

## Apply
From the top of the LOS tree (after sync, before lunch/brunch):
```bash
bash /path/to/marble-los-displayengine/apply-display-engine.sh
```
Idempotent — safe to re-run; can be called from LOSFIX.sh after the clones.
Note: script expects to sit next to its `files/` dir and patch files.

## Not yet build-verified
Patches were dry-run verified against the exact LOS 24 file versions, but a
full compile hasn't run yet — the first green build will confirm.
