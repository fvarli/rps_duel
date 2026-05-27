# Release notes

> Chronological, newest first. Each entry is short enough to map to a Play Console "What's new" field (max 500 chars).

## 1.0.2+3 — Polish (closed test)

- Haptic feedback added on move tap (light) and result reveal (medium on win, click on loss / tie).
- Removed a small vertical jump under the "Next Round" button when transitioning between idle and reveal states.
- 73 / 73 tests pass; signed AAB built.

No gameplay, persistence, or signing changes. Same package id, same upload key.

---

## 1.0.1+2 — Closed-testing release

- First release uploaded to the Play Console closed-testing track.
- No app changes vs. 1.0.0+1; versionCode bumped to satisfy the Play Console strictly-increasing requirement.

---

## 1.0.0+1 — Initial launch package

- Pure-Dart rock-paper-scissors engine with full 9-case truth table.
- CPU thinking beat (~500 ms) before reveal; race-safe reset mid-thinking.
- Three CPU difficulty tiers (Easy / Normal / Hard).
- Local persistence: game state, locale, difficulty, daily challenge, achievements (each `.v1`-tagged in `shared_preferences`).
- Daily Challenge — "Win 3 with Scissors today."
- Four local achievements (First Win, Streak 3, Scissors Specialist, 10 Rounds).
- In-app settings: difficulty picker, language switcher (en / tr / es), reset data, about.
- Material 3 throughout. Mobile-responsive max-width 460 column.
- Tactile Premium theme (cream / sage / clay / ink).
- Signed release AAB, upload key gitignored.
