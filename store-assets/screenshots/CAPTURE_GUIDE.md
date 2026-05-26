# Screenshot capture guide — Play Store listing

Operator step. Capture 8 phone screenshots of RPS Duel for the Google Play Console listing. Each frame is documented below with the exact pre-state, the tap sequence to reach it, and which capture-script call writes the PNG.

## Prerequisites

- An Android device with **USB debugging enabled** (Settings → Developer options → USB debugging), or a running Android emulator.
- `adb` available on PATH (ships with Android SDK platform-tools — already installed if you use `flutter run` against Android).
- The RPS Duel app installed on the device. Two paths:
  - **Release build (recommended for the final listing).** AABs aren't directly sideloadable, so build an APK from the same `1.0.0+1` source:
    ```bash
    flutter build apk --release
    adb install build/app/outputs/flutter-apk/app-release.apk
    ```
  - **Debug build via `flutter run`** — fine for dry runs, but the "DEBUG" banner may appear in the top-right corner. Use a release/profile build for the actual store screenshots.

## Verify your device is connected

```bash
adb devices
# Should list at least one device, e.g.:
#   emulator-5554       device
#   RZ8X1234567         device
```

If empty: plug in the device + tap "Allow USB debugging" on the device prompt, or start an emulator with `flutter emulators --launch <id>`.

## Recommended capture resolution

- 1080×1920 (16:9) or 1080×2400 (modern phones). Play Console accepts both.
- Portrait orientation only for v1.0.0.
- Avoid ultrawide (>16:9) — Play Console crops them.

## Capture script

`capture.sh <N>` writes `screenshot_<N>.png` next to itself. Run from this directory:

```bash
cd store-assets/screenshots
./capture.sh 1     # writes screenshot_1.png
./capture.sh 2     # writes screenshot_2.png
# ...
./capture.sh 8     # writes screenshot_8.png
```

If `./capture.sh` is not executable: `chmod +x capture.sh`.

## The 8 frames

### 1. Home / game idle

**Pre-state:** Fresh install OR Settings → Reset data; locale = English.

**Action:**
1. Launch the app.
2. Land on the game screen. Score 0-0-0; three RPS buttons visible.

**Capture:**
```bash
./capture.sh 1
```

### 2. CPU choosing (`cpuThinking` phase)

**Pre-state:** Fresh state.

**Action:**
1. Tap any of the three move buttons.
2. The CPU enters its ~500 ms thinking beat — the CPU side shows the thinking indicator.

**Capture (timing-sensitive — you may need 2–3 tries):**
```bash
./capture.sh 2
```
The window is roughly half a second. If you miss it, tap "Next round" / "Reset" and try again.

### 3. Reveal / player win

**Pre-state:** Settings → Difficulty → **Easy**. Easy biases the CPU toward losing (`lib/domain/rps_engine.dart`), so you don't have to fight RNG to land a player win.

**Action:**
1. Close the settings sheet.
2. Tap **Scissors**.
3. Wait for the reveal — score updates, "You win!" copy appears.

**Capture:**
```bash
./capture.sh 3
```

### 4. Settings sheet

**Pre-state:** Any state.

**Action:**
1. Tap the gear / cog button.
2. Let the bottom sheet finish settling.

**Capture:** All four rows visible — Difficulty, Language, Reset data, About.
```bash
./capture.sh 4
```

### 5. Difficulty picker

**Pre-state:** Settings sheet open (from frame #4).

**Action:**
1. Tap the **Difficulty** row.
2. The difficulty picker sheet pushes in showing Easy / Normal / Hard.

**Capture:**
```bash
./capture.sh 5
```

### 6. Daily Challenge + Achievements visible

**Pre-state:** Fresh state (Reset data if needed). On a phone in portrait, both cards fit on one screen below the game area.

**Action:**
1. Land on the game screen.
2. If both cards aren't visible at once, scroll the screen until they align.

**Capture:**
```bash
./capture.sh 6
```

### 7. Turkish UI

**Pre-state:** Settings → Language → **Türkçe** → close sheet.

**Action:**
- Capture the game screen with Turkish copy throughout. Mirror frame #1's framing (idle game state, score 0-0-0) for visual rhythm across the listing.

**Capture:**
```bash
./capture.sh 7
```

### 8. Spanish UI

**Pre-state:** Settings → Language → **Español** → close sheet.

**Action:**
- Capture the game screen with Spanish copy throughout. Mirror frame #1's framing.

**Capture:**
```bash
./capture.sh 8
```

## Post-capture

1. **Sanity-check** each PNG opens correctly and shows the expected state.
2. Optionally batch-rename if you want a different ordering on Play Console.
3. `git add store-assets/screenshots/*.png` and commit. Remove the `.gitkeep` placeholder when you do.
4. Upload to Play Console → Main store listing → Screenshots → Phone.

## Alternative: `flutter screenshot`

If `adb` doesn't suit you, `flutter screenshot` works when the app is running under `flutter run`:

```bash
flutter screenshot --out store-assets/screenshots/screenshot_1.png
```

That requires an active `flutter run` session. The `adb` route works whether the app was launched via Flutter or installed as a release build, which is why `capture.sh` uses it by default.
