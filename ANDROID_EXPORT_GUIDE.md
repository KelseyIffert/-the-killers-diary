# Killer’s Diary — Android APK first

This package is the existing Godot 4 2D Build 2 project with Android export preparation. It is **not** an APK. No Android SDK, Godot executable, export templates, or signing tools were available to create/test an APK here.

## On your Android phone
1. Extract this ZIP into a folder you can access from the Godot Android editor.
2. Open/import `project.godot` in Godot 4 Android editor and verify the project runs.
3. If your editor version offers **Project > Export**, install the matching export templates and open the `Android` preset. Try **Export Project** to `KillersDiary.apk`. Some Android editor versions do not support Android APK exporting; if that option is unavailable, use a desktop for the export.
4. On desktop Godot 4, install matching **export templates**, a compatible **JDK**, **Android SDK** (including platform/build tools), and configure their paths under **Editor > Editor Settings > Export > Android**.
5. Open **Project > Export > Android**, verify package identifier `com.inkplaystudios.killersdiary`, select a debug export for testing, then export `KillersDiary.apk`.
6. Transfer the APK to your phone, install it (allow installs from your file manager when prompted), and test startup, touchscreen interactions, save/load, pause/resume, and orientation.

## Current project
- Android preset included in `export_presets.cfg`.
- Landscape orientation, GL Compatibility renderer, touch-friendly buttons and save/load logic are present.
- Preserve this source folder and original HTML version as backups.
- No signed release APK is included. Release distribution requires a private signing key and on-device testing.

## Status
- **Confirmed by user:** project opens and runs inside Godot Android editor; touchscreen location/inventory/diary interaction works.
- **Not tested:** exported APK, offline standalone runtime, background/resume behavior, device compatibility beyond editor, release signing.
