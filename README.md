# RPS Duel

> RPS Duel: Rock Paper Scissors — a pocketable 30-second duel. The player picks, the CPU picks back, the result lands instantly, wrapped in a runtime-swappable theme engine.

- **App display name:** RPS Duel
- **Package id:** `com.lunexa.games.rpsduel`
- **Platforms:** Android · iOS
- **Status:** Phase 0 (bootstrap shell only — no gameplay yet)

---

## Source-of-truth docs

Everything in this project follows the design documents under `docs/`. **Do not modify them; the implementation is downstream of the docs, not the other way around.**

| File | Role |
|---|---|
| `docs/html/handoff.html` | **Engineering source of truth.** Phase-by-phase implementation plan, dependency list, file layout, acceptance criteria. Always check this first when starting a phase. |
| `docs/html/spec.html` | **Product and architecture source of truth.** MVP scope, deferred roadmap, FSM, theme system, monetization, motion/audio tokens. |
| `docs/html/index.html` | **Visual reference source of truth.** Reference rendering of the design system. |
| `docs/components/design-canvas.jsx` | Supporting design artifact (not a build input). |
| `docs/concepts/*.jsx` | Supporting concept explorations (not a build input). |

---

## Build & run

```bash
flutter pub get                # install deps
flutter gen-l10n               # generate AppLocalizations from lib/l10n/*.arb
flutter pub run build_runner build --delete-conflicting-outputs
                               # generate freezed / json / riverpod sources (no-op at Phase 0)
flutter analyze                # must report zero issues
flutter test                   # smoke test must pass
flutter run                    # launch on a connected device or emulator
```

Phase 0 acceptance: `flutter analyze && flutter test` is clean and `flutter run` shows the placeholder home screen.

---

## Phase-based workflow

Per `docs/html/handoff.html`, the project ships in 13 phases. Each phase is small, buildable, testable, and merge-ready on its own. **Do not jump phases.**

| Phase | Scope |
|---|---|
| **0 — Bootstrap** ✅ | Flutter project skeleton, dep wiring, strict analyzer, l10n pipeline, placeholder shell. |
| 1 — Domain models & engine | Pure-Dart `RpsEngine`, FSM, models. Zero Flutter imports. |
| 2 — Local persistence (Isar) | Settings, round history (cap 100), theme entitlements. |
| 3 — Theme engine | `ThemePack` abstract + first two MVP packs (Tactile Premium, Premium Minimal). |
| 4 — Screens shell | Splash → Onboarding → Home → Mode → Play → History → Settings → Themes → Store routing. |
| 5 — Localization | en/tr/es ARBs filled in; **after this phase, no raw strings allowed in UI code.** |
| 6 — Audio & haptics | `audioplayers`, per-theme SFX packs, haptic profiles. |
| 7 — Animations | Motion tokens, per-theme overrides, reduce-motion path. |
| 8 — Onboarding & polish | Final pre-monetization UX pass. |
| 9 — Ads | `google_mobile_ads`, interstitial cadence, rewarded for theme unlocks. |
| 10 — IAP | `in_app_purchase`, remove-ads SKU, premium theme SKU. |
| 11 — Telemetry | `firebase_core` + `firebase_analytics` + crash reporting. |
| 12 — Store readiness | Icons, screenshots, ASO assets, signing, store listings. |

**Hard guardrails for every phase:**
- The game engine stays pure Dart. No Flutter imports under `lib/domain/`.
- Themes are runtime-swappable. No theme branching outside `ThemePack`.
- After Phase 5, no raw user-facing strings — everything routes through `AppLocalizations`.
- Design tokens (spacing, radius, motion, typography) live in the design system, not in feature widgets.
- Each phase must keep `flutter analyze` clean and `flutter test` green.
- Commits stay small and focused; one phase ≠ one giant commit.

**Explicitly NOT in MVP** (per `docs/html/spec.html`, "Roadmap"): backend, login/auth, realtime multiplayer, leaderboards, ranked mode, cloud sync. Those land in Phase 2/3 of the post-MVP roadmap, not in this codebase yet.

---

## Phase 0 dependency snapshot

Phase 0 only wires the deps the placeholder shell actually needs. Heavier packages are deferred to the phase that integrates them, so this skeleton stays compile-clean without platform config (no `google-services.json`, no AdMob App ID, no native Isar libs).

**Active in Phase 0:**
- `flutter_riverpod`, `riverpod_annotation` — state mgmt; `ProviderScope` is wired but no providers yet
- `go_router` — routing; one placeholder home route
- `freezed_annotation`, `json_annotation` — data class & union annotations (codegen lands in Phase 1)
- `flutter_svg` — vector assets (used heavily in Phase 3 themes)
- `flutter_localizations`, `intl` — l10n pipeline wired; translations land in Phase 5
- `connectivity_plus` — offline detection (used by system screens in Phase 4+)
- `cupertino_icons` — iOS icon set
- dev: `build_runner`, `freezed`, `json_serializable`, `riverpod_generator`, `custom_lint`, `riverpod_lint`, `flutter_lints`

**Deferred (added in the phase that needs them):**

| Package | Lands in phase | Why deferred |
|---|---|---|
| `isar`, `isar_flutter_libs` | 2 | Native libs + codegen; nothing to persist yet |
| `audioplayers` | 6 | No audio surface in skeleton |
| `google_mobile_ads` | 9 | Needs AdMob App ID in `AndroidManifest`; would crash the app on launch otherwise |
| `in_app_purchase` | 10 | Needs Play Console / App Store Connect SKU setup |
| `firebase_core`, `firebase_analytics` | 11 | Needs `flutterfire configure` + `google-services.json` / `GoogleService-Info.plist` |

---

## Project layout (Phase 0)

```
lib/
├── main.dart                    # ProviderScope + MaterialApp.router
├── app/
│   ├── router.dart              # GoRouter config (1 route today)
│   └── home_placeholder.dart    # Phase 0 placeholder screen
├── l10n/
│   ├── app_en.arb               # en starter (1 key)
│   ├── app_tr.arb               # tr starter
│   └── app_es.arb               # es starter
└── generated/l10n/              # AppLocalizations (gitignored, regenerated)
test/
└── widget_test.dart             # smoke test for the bootstrap shell
```

Phase 1+ will introduce `lib/domain/`, `lib/core/`, `lib/ui/` etc. per the structure in `docs/html/spec.html` §04.
