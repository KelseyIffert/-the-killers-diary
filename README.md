# The Killer's Diary — Godot 4 2D Multiplatform Build 2

This continues the original Build 1 without overwriting it. The original artwork, evidence collection, diary, dialogue encounters, 13 locations, and save/load remain.

## Open and play
1. Extract this ZIP into its own folder.
2. Open the folder in VS Code and Godot 4.x (`project.godot`).
3. Press F5 in Godot to launch the main scene.
4. Click/tap a location, clue, person, diary, or inventory item.

## Added in Build 2
- Godot 4 Compatibility renderer (existing Build 1 setting) retained for Web/Android/Windows.
- Fullscreen button and keyboard shortcut (F11).
- Pause/menu and Esc/back handling.
- Unstuck button that returns to current location without deleting evidence.
- Larger touch targets on narrow screens; viewport responsive resizing.
- Basic keyboard shortcuts (D diary, F5 save) and focusable buttons for gamepad navigation.
- Three export presets and platform instructions.

## Controls
- Mouse/touch: select locations, inspect evidence, talk, use inventory.
- Keyboard: Tab/arrows navigate focused buttons; Enter/Space activate; Esc opens/closes menu; D diary; F5 save; F11 fullscreen.
- Controller: basic Godot UI focus navigation; needs real-device testing and polish.
- Virtual joystick is deliberately not used: this is a point-and-click investigation build, not free movement.

## Export
Requires Godot 4.x editor, matching export templates, and for Android an Android SDK/JDK and signing setup. Export presets are starting configurations and may need adjustment to match your installed Godot version.

Web: Project > Export > Web > Export Project to `exports/web/index.html`. For Cloudflare Pages copy **all** exported files together into `games/killers-diary/play/`. Do not publish a Play Online button until the export has been tested in desktop and Android browsers. Web persistence uses Godot `user://` browser storage and depends on browser policies.

Windows: Project > Export > Windows Desktop > Export Project. Keep executable and any .pck sidecar together.

Android: Configure Editor Settings > Export > Android SDK/JDK and signing, then Project > Export > Android. Test on an Android device. No signing secrets are included.

## Known limitations
- Godot executable/export templates are not installed in the authoring environment; runtime, browser, Android and Windows testing have NOT been performed.
- No Web export, APK or Windows executable is included; the presets alone do not produce builds.
- Build 1 itself is a scene-based investigation prototype, not a complete port of the HTML game's branching mystery. Some dialogue remains provisional.
- Gamepad and small-screen usability still need device testing.
- Original illustrated locations are scene backgrounds, not walkable top-down maps.

## GitHub coding agent continuation
Open the extracted folder in VS Code. Ask the agent to run the project in Godot, fix any parser or layout issues, test touch/controller focus, then port the canonical story and choices from the preserved HTML Build 9 reference without inventing lore. Keep source and exported binaries in separate folders.
