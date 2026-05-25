# Android release — operator guide

This is the one-time setup + per-release workflow for shipping RPS Duel to the Google Play Console. Nothing here lives in the repo — every step involves files that are gitignored or that you keep on your own machine.

- **Package id:** `com.lunexa.games.rpsduel`
- **App name:** `RPS Duel`
- **Store title:** `RPS Duel: Rock Paper Scissors`

---

## 1. Generate an upload keystore (one-time)

Keep this OFFLINE the entire life of the app. If you lose it, you cannot push updates under the same package id — you have to enroll in Play App Signing key-reset, which is non-trivial.

```bash
mkdir -p ~/upload-keystores
keytool -genkey -v \
  -keystore ~/upload-keystores/rps_duel_upload.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias rps_duel_upload
```

You'll be prompted for:
- a keystore password (remember it)
- a key password (use the same as the keystore password for simplicity)
- a distinguished name (org / city / country)

Back up `~/upload-keystores/rps_duel_upload.jks` somewhere safe (1Password attachment, encrypted external drive, etc.). **Do not put it in the repo.**

---

## 2. Wire `android/key.properties` (one-time)

In the project root:

```bash
cp android/key.properties.example android/key.properties
```

Edit `android/key.properties` and fill in the four values:

```properties
storePassword=<your keystore password>
keyPassword=<your key password>
keyAlias=rps_duel_upload
storeFile=/Users/you/upload-keystores/rps_duel_upload.jks
```

`storeFile` should be an **absolute path** to the keystore on your machine. `android/key.properties` is gitignored — verify with:

```bash
git status                     # should not list android/key.properties
git check-ignore android/key.properties
# -> expected output: android/key.properties
```

---

## 3. Build a release app bundle

From the project root:

```bash
flutter pub get
flutter gen-l10n
flutter build appbundle --release
```

Output artifact (the file you upload to Play Console):

```
build/app/outputs/bundle/release/app-release.aab
```

Verify the bundle was signed with your upload keystore (not the debug key):

```bash
# Quick sanity check — should NOT mention "Android Debug" or "androiddebugkey"
unzip -p build/app/outputs/bundle/release/app-release.aab \
    META-INF/UPLOAD.SF | head -1
```

---

## 4. Upload to Play Console

1. Play Console -> your app -> **Production** -> **Create new release**.
2. Drag in `app-release.aab`.
3. Fill in the release notes per the localizations you support (`en`, `tr`, `es`).
4. Save -> review -> roll out.

First-time apps need Play Console setup that's outside this repo's scope: content rating, target audience, store listing screenshots in en/tr/es, privacy policy URL, data-safety form, etc. See the release readiness checklist in the main `README.md`.

---

## 5. Version bumps

Single source of truth: `pubspec.yaml` `version: <name>+<code>`.

| Field | Maps to | Rules |
|---|---|---|
| `<name>` | Android `versionName` (display) | semver-style, e.g. `0.1.0`, `0.2.0`, `1.0.0`. Bump on every Play release. |
| `<code>` | Android `versionCode` (integer) | **Must strictly increase** every uploaded release, even for hotfixes. Play rejects duplicates. |

Current version: **`1.0.0+1`** (versionName `1.0.0`, versionCode `1`).

Worked examples for the next two releases:

```yaml
# pubspec.yaml — next bugfix release
version: 1.0.1+2
```

```yaml
# pubspec.yaml — next feature release
version: 1.1.0+3
```

Then rebuild and re-upload. **`versionCode` must strictly increase every uploaded release**, even for hotfixes — Play Console rejects duplicates.

---

## 6. Security reminders

- **Never commit** `android/key.properties` or `*.jks` / `*.keystore` files. Both are covered by `.gitignore` and `android/.gitignore`, but always verify with `git status` before pushing.
- Keep the keystore + passwords in a password manager (1Password, etc.).
- If the keystore is lost or compromised, contact Play Console support about a signing-key reset before pushing another release.
- iOS release setup (provisioning profiles, App Store Connect) is **not** covered here — separate phase.
