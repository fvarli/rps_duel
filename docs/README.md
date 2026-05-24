# `docs/` — design + product handoff

These files are the **source of truth** for the product/architecture/visual decisions behind RPS Duel. They were authored before the Flutter project was bootstrapped and the implementation is downstream of them — **do not modify casually**.

| File | Role |
|---|---|
| `html/handoff.html` | Highest-priority engineering source of truth. Phase-by-phase implementation plan, dependency list, file layout, acceptance criteria. |
| `html/spec.html` | Product and architecture source of truth. MVP scope, deferred roadmap, FSM, theme system, monetization, motion/audio tokens. |
| `html/index.html` | Visual reference. Reference rendering of the design system. |
| `components/design-canvas.jsx` | Supporting design canvas (not a build input). |
| `concepts/*.jsx` | Supporting concept explorations (not a build input). |

For project setup, run/test commands, and current MVP status, see the project root [`README.md`](../README.md).
