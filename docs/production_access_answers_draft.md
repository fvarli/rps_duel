# Production-access answers — draft

> **Do not submit any claim from this draft that isn't true at submission time.** Every fact below must be verifiable against the repo, the Play Console, or tester records. If a question can't be answered honestly when you submit, fix the underlying gap first — don't paper over it.

This draft tracks the three questions Google Play asks when applying for production access, with structured slots the operator fills in once the closed-test window is complete. Pre-filled content cites only what is implemented in code and verifiable in the Play Console.

---

## Q1. What feedback did testers provide?

> **Operator fills this in at the end of the 14-day window.** Until real feedback arrives, the section below is intentionally empty — do not invent themes.

Structure to use when filling in:

### Themes observed

| Theme | Frequency (count of testers) | Severity (max across reports) | Example quote / paraphrase | Tracked in backlog |
|---|---|---|---|---|
| _e.g. "haptic on win feels too strong"_ | _e.g. 2 of 12_ | Minor | _operator paraphrase_ | Yes (id #) |

### Quantitative summary

- Testers opted in: _N_
- Testers who completed Scripts A-D from `play_store_closed_test_plan.md`: _N_
- Crashes reported in Play Console Vitals during the window: _N_
- ANRs reported: _N_
- Pre-launch-report compatibility flags: _N_

If no themes emerged because feedback was sparse, say so: "We received feedback from N of 12 testers; the remaining did not respond after the test window. Among responders, themes were…" Do not fabricate themes to fill space.

---

## Q2. What changes were made in response?

Tracked changes pulled directly from `change_log_closed_test.md`. Each row must link to a real git commit SHA.

### Operator-initiated polish (pre-tester-feedback, 1.0.2)

These were made before tester feedback arrived, based on the internal product audit (`product_audit.md`). Flag them as such — Google Play does not penalize self-driven polish, but mislabeling them as "in response to tester feedback" would be false.

| Change | Commit | Notes |
|---|---|---|
| Haptic feedback on move tap + result reveal | _set on commit_ | F1 from audit |
| Removed layout shift under "Next Round" button | _set on commit_ | F4 from audit |

### Tester-driven changes

> Filled in as the closed-test window progresses.

| Tester feedback | Resolution | Commit | Build that shipped the fix |
|---|---|---|---|
| _none yet_ | | | |

If no tester-driven changes were needed (i.e., the operator-initiated polish was sufficient and testers reported no blockers), say so explicitly: "All blocking and major feedback was addressed; no additional builds were required during the window."

---

## Q3. Why is the app ready for production?

Use the bullets below only after confirming each is true at the moment of submission.

- **Functional completeness.** All advertised gameplay is implemented: rock-paper-scissors with three CPU difficulty levels, persistent scores and history, daily challenge, four local achievements, in-app language switcher (English / Turkish / Spanish), settings sheet with reset.
- **Quality bar.** `flutter analyze` reports 0 issues. `flutter test` passes 73 / 73 tests (54 unit + 19 widget) covering the domain layer, persistence, and full game-screen widget flow including locale switching and data reset.
- **Stability under tester traffic.** Across the closed-test window (N days, M testers), Play Console Vitals reported X crashes and Y ANRs; all root-caused and resolved.
- **Localization.** Three locales (en, tr, es) are fully wired with translated UI strings, including the in-app language switcher.
- **Privacy.** App stores only local on-device preferences via `shared_preferences`. No data leaves the device. Privacy policy is hosted at `<URL>` and matches the Data Safety form.
- **Signing.** Release builds are signed with the upload keystore documented in `release_android.md`; the keystore lives outside the repository.
- **Listing.** Store listing copy is finalized for en / tr / es in `play_store_launch.md`. Screenshots and feature graphic in `assets/store-final/` are uploaded.

Do not include any claim that is not currently true. If `<URL>` isn't hosted yet at submission time, fix that first.

---

## Submission checklist

Before pasting any of these answers into the Play Console:

- [ ] Closed-test window complete (>= 14 days, >= 12 testers).
- [ ] Backlog cleaned: 0 Blocking, 0 Major.
- [ ] Q1 themes section filled with real responses (or honest "no responses").
- [ ] Q2 commit SHAs and build versions filled in.
- [ ] Q3 facts re-verified against current repo + console state.
- [ ] No `<URL>`, `_set on commit_`, `_none yet_`, or other placeholder text remains in the answers you paste.
