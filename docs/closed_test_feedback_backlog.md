# Closed-test feedback backlog

> Living document. Operator updates as tester feedback arrives during the Play Console closed-test window.

## How feedback flows in

| Source | Channel | Cadence |
|---|---|---|
| Play Console internal feedback | Tester app → "Send feedback" link surfaced in the testing track page | As tester submits |
| Direct messages from invited testers | Operator's preferred channel (email, Slack, etc.) | Ad hoc |
| Play Console pre-launch report | Auto-generated after AAB upload | One-shot per upload |
| Vitals / crashes | Play Console → Quality → Android vitals | Hourly aggregation |

Each new item gets a row in the relevant table below. Severity scale:

| Severity | Meaning |
|---|---|
| Blocking | Cannot graduate to production |
| Major | Should fix before production |
| Minor | Track and consider; ship-after acceptable |
| Nice-to-have | Backlog only |

---

## Open items — usability

| id | reporter | summary | severity | status | linked commit |
|---|---|---|---|---|---|
| _none yet_ | | | | | |

## Open items — performance

| id | reporter | summary | severity | status | linked commit |
|---|---|---|---|---|---|
| _none yet_ | | | | | |

## Open items — compatibility (device / API / locale)

| id | reporter | summary | severity | status | linked commit |
|---|---|---|---|---|---|
| _none yet_ | | | | | |

## Open items — gameplay polish

| id | reporter | summary | severity | status | linked commit |
|---|---|---|---|---|---|
| _none yet_ | | | | | |

---

## Resolved in 1.0.2 (operator-initiated polish, pre-tester-feedback)

These items were identified by the internal audit (`product_audit.md`) before tester feedback arrived. They are listed here for completeness so the production-access narrative is honest about which changes were tester-driven vs. operator-driven.

| id | summary | severity | status | linked commit |
|---|---|---|---|---|
| OP-1 | Add haptic feedback on move tap + result reveal (F1) | Minor | Resolved | _set after commit_ |
| OP-2 | Remove ~56 px vertical jump under "Next Round" button on reveal/idle (F4) | Minor | Resolved | _set after commit_ |

---

## Triage rules

- **Blocking** items must be resolved (or formally accepted with a documented mitigation) before applying for production access.
- **Major** items should be triaged within 48 h: either fix in the next closed-test build, or convert to an explicit "ship-after-production" item in `release_notes.md`.
- **Minor** items can ship in any future patch; tracked but not blocking.
- **Nice-to-have** items go to the README roadmap, not into a closed-test build.

Every resolved item links to a commit SHA so `production_access_answers_draft.md` can cite changes by reference, not by memory.
