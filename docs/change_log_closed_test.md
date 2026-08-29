# Closed-test change log

> Tracks what shipped to the Play Console closed-test track and why. Distinct from `release_notes.md` (which is user-facing) — this log is for the production-access narrative and ties every change to a source (operator-initiated vs. tester-driven) and a commit.

> **Note:** this log covers the Play Console *closed-test* window, which is complete — the app is now live on the Production track. It is kept for the production-access narrative. Ongoing user-facing changes are recorded in `release_notes.md`.

## 1.0.4+5 — post-launch correctness pass

- **Date:** 2026-08-29
- **Source:** Internal re-entry audit after ~7.5 weeks dormant. No tester feedback drove this build.
- **Tests passing:** 155 / 155 (`flutter analyze` clean).

| Change | Files | Commit |
|---|---|---|
| Daily Challenge now rolls over at midnight on resume (`WidgetsBindingObserver`) | `lib/ui/game/game_screen.dart`, `test/ui/game/daily_challenge_rollover_test.dart` | _set after commit_ |
| "Scissors Specialist" → "Challenge Met" copy fix (enum name deliberately unchanged) | `lib/domain/achievement.dart`, 3 ARB files, `achievements_card.dart`, `achievements_screen.dart` | _set after commit_ |
| Labelled Records affordance in the history header | `lib/ui/game/game_screen.dart`, `test/ui/game/records_navigation_test.dart` | _set after commit_ |
| Drop `connectivity_plus` + `flutter_svg`; removes `ACCESS_NETWORK_STATE` from the release manifest | `pubspec.yaml` | _set after commit_ |
| ARB-parity guard test | `test/l10n/arb_parity_test.dart` | _set after commit_ |
| Docs truth-up (release notes, privacy policy, README, docs/README) + version bump | `docs/`, `README.md`, `pubspec.yaml` | _set after commit_ |

---

## 1.0.3+4 — retention wave (shipped without a log entry)

- **Date:** 2026-06-21 → 2026-07-07
- **Source:** Operator. Recorded retroactively during the 2026-08-29 re-entry audit — this build went out without a row here, in violation of the append rule below.
- **Tests passing at the time:** 150 / 150.

| Change | Commit |
|---|---|
| Achievement unlock toast + Collection screen (achievements storage v1→v2) | `04981b8` |
| Daily Challenge rotation, 7 kinds (challenge storage v1→v2) | `9509d62` |
| Records screen + 7 narrative moments | `a61db04` |
| Lifetime stats + 500-round history soft cap | `da99575` |
| Locale-aware lifetime number formatting | `fc2bedc` |
| Tactile interaction sound layer + sound toggle | `f6abde9` |
| Version bump 1.0.2+3 → 1.0.3+4 | `20f4e76` |

---

## 1.0.2+3 — operator-initiated polish (this iteration)

- **Date:** 2026-05-27
- **Source:** Internal product audit (`product_audit.md`). No tester feedback drove this build — pre-feedback polish only.
- **Tests still passing:** 73 / 73 (`flutter analyze` clean).
- **AAB path:** `build/app/outputs/bundle/release/app-release.aab` (built locally; upload by operator).

| Change | Files | Commit |
|---|---|---|
| Add `Haptics` wrapper + fire haptics on move tap and reveal entry | `lib/ui/haptics.dart` (new), `lib/ui/game/move_button.dart`, `lib/ui/game/game_screen.dart` | _set after commit_ |
| Reserve constant vertical slot for "Next Round" button so Reset Game does not jump | `lib/ui/game/game_screen.dart` | _set after commit_ |
| Add product audit + closed-test doc pack | `docs/product_audit.md`, `docs/closed_test_feedback_backlog.md`, `docs/play_store_closed_test_plan.md`, `docs/production_access_answers_draft.md`, `docs/release_notes.md`, `docs/change_log_closed_test.md` | _set after commit_ |
| Bump version 1.0.1+2 → 1.0.2+3 | `pubspec.yaml` | _set after commit_ |

---

## 1.0.1+2 — first closed-test build

- **Date:** 2026-05-27 (same operator session — versionCode bump after internal-test consumed 1)
- **Source:** Operator. Play Console required a strictly increasing `versionCode` to upload a new build to the closed track after internal testing already consumed versionCode 1.
- **Tests still passing:** 73 / 73.
- **AAB path:** `build/app/outputs/bundle/release/app-release.aab` (uploaded to closed track).

| Change | Files | Commit |
|---|---|---|
| Bump version 1.0.0+1 → 1.0.1+2 | `pubspec.yaml` | b7316ea |

No app code changes in this build. Only the version bump.

---

## Append rule

Every new build for the closed-test track gets a section here **before** it's uploaded. If the build was driven by tester feedback, the **Source** line names the backlog id(s) (`FB-#`) from `closed_test_feedback_backlog.md`. If operator-initiated, the **Source** line says so. No build goes to the track without a row in this log.
