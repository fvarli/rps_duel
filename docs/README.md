# `docs/` — design + product handoff

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
