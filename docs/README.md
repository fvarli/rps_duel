# `docs/`

## Operational guides (current)

Live developer/operator documentation. These describe how the project actually works today.

| File | Role |
|---|---|
| [`android-device-workflow.md`](android-device-workflow.md) | Running on a physical Android device over Wireless Debugging, and the `.dev` side-by-side install that keeps the Google Play build safe. |
| [`release_android.md`](release_android.md) | Keystore setup, signed AAB build, and the per-release Play Console workflow. |
| [`release_notes.md`](release_notes.md) | User-facing release notes, newest first. Maps to the Play Console "What's new" field. |
| [`privacy_policy.md`](privacy_policy.md) | Repository copy of the published privacy policy. Keep in sync with the live page. |

The remaining markdown files (`product_audit.md`, `play_store_launch.md`, `play_store_closed_test_plan.md`, `closed_test_feedback_backlog.md`, `change_log_closed_test.md`, `production_access_answers_draft.md`) are the historical launch and closed-test pack, kept for the production-access narrative. They describe the v1.0.x launch window, not the current state.

---

## Design + product handoff

These files are **historical design input**, not the current source of truth. They were authored before the Flutter project was bootstrapped, and the implementation has deliberately diverged from them. **The repository is authoritative.**

Known divergences — do not "fix" the code to match these documents:

| Document says | Reality |
|---|---|
| App is called "Roshambo Duel" (`handoff.html`) | It is **RPS Duel** |
| Isar persistence (`handoff.html` Phase 2) | Eight `shared_preferences` classes with tested v1→v2 migrations |
| Ads & IAP hooks (`handoff.html` Phase 10) | Explicitly rejected — the live store listing promises no ads and no IAP |
| Analytics events + ad placement strategy (`spec.html`) | No analytics of any kind; contradicted by the published privacy policy |
| Phase 0–12 numbering | Abandoned after Phase 21; the project uses Conventional Commits |

They remain useful for the visual language and the FSM, which the implementation did follow. Read them for intent, not for instructions.

| File | Role |
|---|---|
| `html/handoff.html` | Highest-priority engineering source of truth. Phase-by-phase implementation plan, dependency list, file layout, acceptance criteria. |
| `html/spec.html` | Product and architecture source of truth. MVP scope, deferred roadmap, FSM, theme system, monetization, motion/audio tokens. |
| `html/index.html` | Visual reference. Reference rendering of the design system. |
| `components/design-canvas.jsx` | Supporting design canvas (not a build input). |
| `concepts/*.jsx` | Supporting concept explorations (not a build input). |

For project setup, run/test commands, and current MVP status, see the project root [`README.md`](../README.md).
