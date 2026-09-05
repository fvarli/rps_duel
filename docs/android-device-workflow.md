# Android physical-device workflow — developer guide

How to run RPS Duel on a physical Android phone over Wireless Debugging **without disturbing the Google Play production install** that may already be on it.

This is a local development and testing convention. It is not product architecture: nothing here affects the shipped app.

---

## 1. Application identities

| Variant | Application ID | Launcher label |
|---|---|---|
| **release** (Google Play) | `com.lunexa.games.rpsduel` | **RPS Duel** |
| **debug** | `com.lunexa.games.rpsduel.dev` | **RPS Duel Dev** |
| **profile** | `com.lunexa.games.rpsduel.dev` | **RPS Duel Dev** |

- Debug and profile **deliberately share one isolated development package**, so there is exactly one development install to reason about.
- The release identity is unchanged. Play update compatibility, signing and version semantics are untouched.
- The Google Play install and **RPS Duel Dev** coexist on the same device. Two launcher entries, distinct names.
- The `.dev` package has its **own empty data sandbox** at `/data/user/0/com.lunexa.games.rpsduel.dev`. Storage key names are identical, but the two apps share nothing.

Configured by `applicationIdSuffix = ".dev"` on the debug and profile build types in `android/app/build.gradle.kts`, plus a label override in the `src/debug` and `src/profile` manifest overlays. `namespace` is unchanged, so `.MainActivity` and all resources still resolve.

---

## 2. Why the separation is mandatory

The Google Play build and the local debug build are signed with **different identities** — Play App Signing versus the local debug keystore.

If a debug build claims the same application ID, installing it over the Play build fails on a signature mismatch. Flutter's tooling does not stop there: on install failure it checks whether the package is present and, if so, prints `Uninstalling old version...` and runs `adb uninstall` before retrying. That deletes the package-scoped data directory.

The cost is real user data — unlocked achievements, collected narrative moments, lifetime totals, Daily Challenge progress — and there is no confirmation prompt.

**Development must never target the production package identity.**

---

## 3. Connecting the device

Use **Android 11+ native Wireless debugging** (Developer Options → Wireless debugging) with paired ADB. Do **not** use legacy `adb tcpip 5555`.

Discover the current transport:

```bash
adb devices -l
```

`adb mdns services` may also be used for discovery. An **empty mDNS list alongside a working transport is not an error** — direct connections and some network setups (a laptop hotspot, for example) simply do not advertise.

Pairing, when required, is run by the developer in their own terminal:

```bash
adb pair <host>:<pairing-port>
```

The temporary pairing code is typed interactively. **Never** copy pairing codes into chat, logs, issues or repository files.

**Never hardcode or commit** IP addresses, ports, device serials, pairing codes or any transient ADB state. The wireless endpoint is not stable — see §7.

---

## 4. Daily workflow

Always target the intended device explicitly; the default target is ambiguous as soon as more than one transport exists.

```bash
flutter run -d <wireless-device>
```

Then iterate in the running session:

- `r` — **hot reload**
- `R` — **hot restart**

Do not rebuild and hand-install an APK for ordinary UI or code changes.

For performance and device-behaviour work, where debug-mode jank would distort judgement:

```bash
flutter run --profile -d <wireless-device>
```

Profile mode is safe here because it is isolated under the same development identity, `com.lunexa.games.rpsduel.dev`.

---

## 5. Safety rules

- **Never** uninstall, clear, downgrade, replace or otherwise disturb `com.lunexa.games.rpsduel` in order to enable local development.
- Never work around a signature mismatch by uninstalling the Play version.
- Never change the production application ID or the release signing configuration for development convenience.
- If `flutter run` ever prints:

  ```
  Uninstalling old version...
  ```

  **stop immediately** and verify the target package identity. That line means the build is claiming the production package, and the development suffix is not in effect.

---

## 6. What to test where

**RPS Duel Dev is for iteration. The Google Play RPS Duel install is the production/reference environment.** Do not confuse the two.

### Appropriate for wireless debug/profile iteration

Records screen · Collection screen · the Records app-bar affordance · the Recent rounds / Records row · achievements UI · narrative-moment UI · Daily Challenge card presentation · game layout · EN/TR/ES copy · audio and haptic iteration · animations · CPU interaction feel · accessibility and `Semantics` work.

### Use hot restart (not hot reload) when changes affect

App bootstrap · route initialization · locale bootstrap · `_GameScreenState.initState` · storage and controller initialization.

### Never substitute hot reload or hot restart for

- **Daily Challenge midnight rollover** — it is driven by a real `resumed` lifecycle callback, and a hot restart re-runs `initState`, which masks the behaviour being tested
- true background → foreground lifecycle transitions
- process death
- cold start
- persistence migrations
- anything involving existing production-user data
- Play upgrades
- release signing
- final release permissions
- clean install
- AAB verification

These require the real lifecycle and, where relevant, the real production identity and a release artifact. The `.dev` install starts empty and cannot exercise migrations or upgrade behaviour.

---

## 7. When the connection drops

Treat wireless ADB failures as **environment/tooling issues first**, never as an application defect without evidence.

Check, in order:

1. The device is still on the same network.
2. Wireless debugging is still enabled in Developer Options.
3. `adb devices -l`
4. `adb mdns services`
5. Whether the advertised connect port changed, then reconnect with `adb connect <host>:<connect-port>`.

The native wireless IP and port **change** when the network changes, the phone reconnects or reboots, or Wireless debugging is toggled. Always re-discover; never reuse a remembered address.

---

## 8. Networking

RPS Duel is **fully offline**. It has no backend, makes no network requests, and the release build declares no permissions.

No `adb reverse`, tunnel, port forwarding or localhost mapping is needed for this project. Do not add one.

The `INTERNET` permission exists **only** in the debug and profile manifest overlays, where the Flutter tool requires it for hot reload and the VM Service. It is not present in the release manifest.
