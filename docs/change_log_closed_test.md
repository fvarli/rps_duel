# Closed-test change log

> Tracks what shipped to the Play Console closed-test track and why. Distinct from `release_notes.md` (which is user-facing) — this log is for the production-access narrative and ties every change to a source (operator-initiated vs. tester-driven) and a commit.

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
